/**
* Name: emission
* Based on the internal empty template. 
* Author: dongh
* Tags: 
*/


model emission
import "global_variables.gaml"
import "traffic.gaml"
/* Insert your model definition here */

global {
	species boundary{
		aspect default {
			draw shape color: #yellow border:#grey;
		}
	}
}

species Emis skills: [moving]{
	string type <- 'CO'; // can add NOx, SO2 and PTM
	map<string, rgb> col <- ['CO'::#red, 'NOx'::#blue, 'SO2'::#orange, 'PTM'::#gray];
	vehicle root;
	float power <- 1.0;
	float back_coeff <- 1.0;
	float diff_speed <- 20#m/#s;
	float starting_speed <- 10#m/#s;
	float starting_heading;
	float wind_speed <- 5.0#m/#s;
	float wind_dir <- 90.0;
	
	reflex move{
		// moving by affect of engine
		do move heading: starting_heading speed: starting_speed * back_coeff * step;
		// moving by diffusion
		do wander amplitude: 360.0 speed: diff_speed * step;
		// moving by affect of wind
		do move heading: wind_dir speed: wind_speed * step;
	}
	
	reflex dec_power{
//		power <- max(0.0, power - step * DEPOWER_FACTOR[self.type]);
		back_coeff <- max(0.0, back_coeff - step * 0.25);
	}
	
	//
	reflex disappear when: (power <= 0) or ((self overlaps boundary(0).shape) = false) {
		do die;
	}
	
	aspect default{
		draw circle(0.2#m) color: col[self.type];
	}	
}

species Sensor {
	map<string, float> allowed_amount <- ['CO'::150.0 * DISTANCE_RANGE, 
	'NOx'::3.85*DISTANCE_RANGE, 'SO2'::2.63*DISTANCE_RANGE, 'PTM'::0.6*DISTANCE_RANGE]; // mg/(DISTANCE_RANGE m3)
	map<string, float> pollution_value <- ['CO'::0.0, 'NOx'::0.0, 'SO2'::0.0, 'PTM'::0.0];
	float density <- 0.0;
	rgb color <- rgb(150, 0, 0) update: rgb(150, 0, 125*density);
	list<Emis> Emis_surrounding;
	
	// hourly AQI index
	int CO_aqi;
	int SO2_aqi;
	int NOx_aqi;
	int PTM_aqi;
	
	// average AQI
	int CO_average <- 0;
	int NOx_average <- 0;
	int SO2_average <- 0;
	int count <- 0;
	
	int compute_index (float value, list<float> BP) {
		int index;
		loop i from: 0 to: length(BP) - 2 {
			if value >= BP[i] and value <= BP[i + 1] {index <- i;}
			if value > BP[length(BP) - 1] {index <- length(BP) - 1;}
		}
		return index;
	}
	
	reflex sensing when: mod(cycle, 20) = 0{
		pollution_value <- ['CO'::0.0, 'NOx'::0.0, 'SO2'::0.0, 'PTM'::0.0];
		Emis_surrounding <- (Emis where (distance_to(each.location, self.location) < DISTANCE_RANGE));
		loop emis over: Emis_surrounding {
			write Emis_surrounding;
			write emis.power;
			pollution_value[emis.type] <- pollution_value[emis.type] + emis.power;
		}
		
		density <- (min(1, pollution_value['CO'] / allowed_amount['CO']) + min(1, pollution_value['NOx'] / allowed_amount["NOx"]) + 
				min(1, pollution_value['SO2'] / allowed_amount["SO2"]) + min(1, pollution_value['PTM'] / allowed_amount["PTM"])) / 4;
		
		// update aqi
		// convert amount of pollutants at DISTANCE_RANGE m3 to m3;
		float standard_CO <- pollution_value['CO']/(3.142*DISTANCE_RANGE^3)*(4/3); 
		float standard_NOx <- pollution_value['NOx']/(3.142*DISTANCE_RANGE^3)*(4/3); 
		float standard_SO2 <- pollution_value['SO2']/(3.142*DISTANCE_RANGE^3)*(4/3); 
		
		int CO_index <- compute_index(standard_CO, CO_BP);
		int NOx_index <- compute_index(standard_NOx, NOx_BP);
		int SO2_index <- compute_index(standard_SO2, SO2_BP);
		
		CO_aqi <- CO_index = length(CO_BP) - 1 ? 500 : (I[CO_index + 1] - I[CO_index])*
			(standard_CO - CO_BP[CO_index])/(CO_BP[CO_index + 1] - CO_BP[CO_index]) + I[CO_index] as int;
		NOx_aqi <- NOx_index = length(NOx_BP) - 1 ? 500 : (I[NOx_index + 1] - I[NOx_index])*
			(standard_NOx - NOx_BP[NOx_index])/(NOx_BP[NOx_index + 1] - NOx_BP[NOx_index]) + I[NOx_index] as int;
		SO2_aqi <- SO2_index = length(SO2_BP) - 1 ? 500 : (I[SO2_index + 1] - I[SO2_index])*
			(standard_SO2 - SO2_BP[SO2_index])/(SO2_BP[SO2_index + 1] - SO2_BP[SO2_index]) + I[SO2_index] as int;
		
		count <- count + 1;
		CO_average <- ((count - 1)*CO_average + CO_aqi)/count as int;
		NOx_average <- ((count - 1)*NOx_average + NOx_aqi)/count as int;
		SO2_average <- ((count - 1)*SO2_average + SO2_aqi)/count as int;
	}
	
	aspect default{
		draw circle(DISTANCE_RANGE#m) color: color;
	}
}

