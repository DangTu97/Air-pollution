/***
* Name: globalvariables
* Author: dang tu
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model globalvariables

/* Insert your model definition here */

global {
	// global variables
	float STEP <- 0.05 #s;
	float TIME_STEP <- 0.05 #s;
	float EVIRONMENT_SIZE <- 300.0;
	list<image_file> IMAGES <- [image_file("../includes/car.png"), image_file("../includes/motorbike.png"), image_file("../includes/bus.jpg")];
	
	// attributes of road
	float ROAD_WIDTH <- 8.0;
	
	// attributes of traffic light;
	int GREEN_TIME <- 400; // with STEP = 0.05 #s, this means GREEN_TIME = 20s
	int YELLOW_TIME <- 80;
	int RED_TIME <- 480; // RED_TIME = GREEN_TIME + YELLLOW_TIME
	
	
	// attributes of vehicle
	float DISTANCE_CHECHK <- 20.0;
	float MINIMUM_LENGTH_SIZE <- 0.15;
	float WIDTH_SIZE <- 0.5; // for the left and right polygon
	float ACCELERATION_FACTOR <- 0.5;
	float DECELERATION_FACTOR <- 2.0;
	float PROB_PASS_LIGHT <- 0.0;
	
	// CAR
	float CAR_LENGTH <- 3.8 #m;
	float CAR_WIDTH <- 1.5 #m;
	float CAR_DF <- 0.15 #m; //safe distance for vehicle in front
	float CAR_DB <- 0.1 #m; //safe distance for vehicle beside
	float CAR_MAXSPEED <- 14 #m/#s;
	
	// MOTORBIKE
	float MOTORBIKE_LENGTH <- 2.0 #m;
	float MOTORBIKE_WIDTH <- 0.7 #m;
	float MOTORBIKE_DF <- 0.1 #m;  
	float MOTORBIKE_DB <- 0.05 #m; 
	float MOTORBIKE_MAXSPEED <- 11 #m/#s;
	
	// BUS
	float BUS_LENGTH <- 9.45 #m;
	float BUS_WIDTH <- 2.45 #m;
	float BUS_DF <- 0.4 #m; 
	float BUS_DB <- 0.2 #m; 
	float BUS_MAXSPEED <- 16.6 #m/#s;
	
	//TRUCK
	float TRUCK_LENGTH <- 7.0 #m;
	float TRUCK_WIDTH <- 2.25 #m;
	float TRUCK_DF <- 0.4 #m; 
	float TRUCK_DB <- 0.2 #m; 
	float TRUCK_MAXSPEED <- 16.6 #m/#s;
	
	float INIT_SPEED <- 8 #m/#s;
	float PROB_GO_OPPOSITE <- 0.0;
	float PROB_TURN_RIGHT <- 1.0;
	
	// percent of car 
	float CAR_PERCENT <- 0.2;
	
	// diffusion of emission variables
	float wind_speed <- 0.0#m/#s;
	float wind_dir <- 30.0;
	
	int EMIS_DURATION <- 100; //cycle
 
	// emission factor g/km -> mg/m
	map<string, float> EF_CO <- ['CAR' :: 3.62, 'MOTORBIKE' :: 3.62, 'BUS' :: 3.1, 'TRUCK':: 2.75];
	map<string, float> EF_NOx <- ['CAR' :: 1.5, 'MOTORBIKE' :: 0.3, 'BUS' :: 7.6, 'TRUCK':: 11.0];
	map<string, float> EF_SO2 <- ['CAR' :: 0.17, 'MOTORBIKE' :: 0.03, 'BUS' :: 0.64, 'TRUCK':: 0.4];
	map<string, float> EF_PTM <- ['CAR' :: 0.1, 'MOTORBIKE' :: 0.1, 'BUS' :: 1.5, 'TRUCK':: 0.8];
	
	// depower_coeff
//	float depower_coeff <- 0.1;
	map<string, float> DEPOWER_FACTOR <- ['CO'::3, 'NOx'::0.5, 'SO2'::0.1, 'PTM'::0.2];
		
	// parameter
	float CAR_SAFESPEED_MALE <- 11.1 #m/#s;
	float CAR_SAFESPEED_FEMALE <- 10.0 #m/#s;
	float MOTORBIKE_SAFESPEED_MALE <- 8.9 #m/#s;
	float MOTORBIKE_SAFESPEED_FEMALE <- 8.3 #m/#s;
	float PROB_MAXSPEED_SAFESPEED <- 0.5;
}