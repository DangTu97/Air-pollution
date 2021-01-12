/***
* Name: NguyenVanCu5PM
* Author: dang tu
* Description: simulation at 5pm on Nguyen Van Cu road with data information:
* traffic flow: 2.25 vehicle/s
* 68.5 % motorbike, 27% car 1.5% bus, 3% truck 
* Tags: air pollution simulation
***/

model NguyenVanCu5PM
import "../models/traffic.gaml"

/* Insert your model definition here */
global {
	graph road_network;
	geometry shape <- envelope(shape_file_buildings) + 10;
	float step <- STEP;
	int every_cycle <- 9; // indicates traffic volume
	
	init {
		create building from: shape_file_buildings;
		create boundary from: shape_file_boundary;
		create road from: shape_file_roads {
			width <- is_twoway ? 2.0 : 5.0; 
			geom_display <- shape + width;
		}
		road_network <- as_edge_graph(road);
		loop vertex over: road_network.vertices {
			create roadNode { location <- vertex; }
		}
		
		create Sensor number: 1 {
			location <- building(10).location - {10,13};
		}
	}
	
	reflex init_traffic when: mod(cycle,every_cycle) = 0 {
		create vehicle number: 1 {
			int k <- rnd(1,100);
			type <- (k < 67.5) ? 'MOTORBIKE': ((k < 93.5) ? 'CAR': one_of(['TRUCK', 'TRUCK', 'BUS']));
			source_node <- roadNode(12).location;
			final_node <- roadNode(15).location;
			do set_type;
		}
		
		create vehicle number:1 {
			int k <- rnd(1,100);
			type <- (k < 68.5) ? 'MOTORBIKE': ((k < 95.5) ? 'CAR': one_of(['TRUCK', 'TRUCK', 'BUS']));
			source_node <- roadNode(14).location;
			final_node <- roadNode(13).location;
			do set_type;
		}
	}
}

experiment my_experiment {
	float minimum_cycle_duration <- TIME_STEP;
	output {
		display my_display background: #black {
			species boundary aspect: default;
			species road aspect:base;
			species vehicle aspect:base;
			species building aspect: base;
			species Emis aspect:default;
			species Sensor aspect:default;
		}
		
		display chart refresh: every(20#cycle) {
			chart "Number of pollutants" type:series {
				data "Pollutants" value: length(Emis);
			}
		}
		
		monitor "CO AQI_h: " value: Sensor(0).CO_aqi;
		monitor "NOx AQI_h: " value: Sensor(0).NOx_aqi;
		monitor "SO2 AQI_h: " value: Sensor(0).SO2_aqi;
	}
}
