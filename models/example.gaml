/***
* Name: example
* Author: dang tu
* Description: study case of Nguyen Van Cu traffic road coupled with emission model
* Tags: Tag1, Tag2, TagN
***/

model example
import "traffic.gaml"
/* Insert your model definition here */

global {
	file shape_file_roads <- file("../includes/roads.shp");
	file shape_file_buildings <- file("../includes/buildings.shp");
	file shape_file_boundary <- file("../includes/boundary.shp");
	graph road_network;
	geometry shape <- envelope(shape_file_roads) + 50;
	float step <- STEP;
	
	init {
		create building from: shape_file_buildings;
		create boundary from: shape_file_boundary;
		create road from: shape_file_roads {
			width <- is_twoway ? 2.0 : 5.0; 
			geom_display <- shape + width;
		}
		road_network <- as_edge_graph(road);
		loop vertex over: road_network.vertices {
			create roadNode {
				location <- vertex;
			}
		}
		
		create Sensor number: 1 {
			location <- one_of(road_network.vertices);
		}
	}
	
	reflex init_traffic when: mod(cycle,10) = 0 {
		create vehicle number: 1 {
			type <- flip(0.3) ? one_of(['CAR', 'CAR', 'CAR', 'CAR', 'TRUCK', 'TRUCK', 'BUS']) : 'MOTORBIKE';
			source_node <- roadNode(12).location;
			final_node <- roadNode(15).location;
			do set_type;
		}
		
		create vehicle number:1 {
			type <- flip(0.3) ? one_of(['CAR', 'CAR', 'CAR', 'CAR', 'TRUCK', 'TRUCK', 'BUS']) : 'MOTORBIKE';
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
			chart "Number of vehicles" type:series {
				data "Vehicles" value: length(Emis);
			}
		}
//		monitor "Number of Emis:" value: length(Emis);
//		monitor "Number of Vehicles:" value: length(vehicle);
	}
}