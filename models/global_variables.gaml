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
	list<image_file> IMAGES <- [image_file("../includes/car.png"), image_file("../includes/motorbike.png"),
								image_file("../includes/bus.jpg"), image_file("../includes/truck.jpg")];
	
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
 
	// emission factor g/km -> mg/m
	map<string, float> EF_CO <- ['CAR' :: 3.62, 'MOTORBIKE' :: 3.62, 'BUS' :: 3.1, 'TRUCK':: 2.75];
	map<string, float> EF_NOx <- ['CAR' :: 1.5, 'MOTORBIKE' :: 0.3, 'BUS' :: 7.6, 'TRUCK':: 11.0];
	map<string, float> EF_SO2 <- ['CAR' :: 0.17, 'MOTORBIKE' :: 0.03, 'BUS' :: 0.64, 'TRUCK':: 0.4];
	map<string, float> EF_PTM <- ['CAR' :: 0.1, 'MOTORBIKE' :: 0.1, 'BUS' :: 1.5, 'TRUCK':: 0.8];
	
	file shape_file_roads <- file("../includes/roads.shp");
	file shape_file_buildings <- file("../includes/buildings.shp");
	file shape_file_boundary <- file("../includes/boundary2.shp");
	
	// distance to get pollutant
	float DISTANCE_RANGE <- 4.0#m;
	int EMIS_DURATION <- 100; //#cycle, 20#cycle is 1#s
	
	// hourly AQI 
	list<int> I <- [0, 50,100,150,200,300,400,500];
	list<float> CO_BP <- [0, 10.0, 30.0, 45.0, 60.0, 90.0, 120.0, 150.0]; // mg/m3
	list<float> NOx_BP <- [0, 0.1, 0.2, 0.7, 1.2, 2.35, 3.1, 3.85]; // mg/m3
	list<float> SO2_BP <- [0.0, 0.125, 0.35, 0.55, 0.8, 1.6, 2.1, 2.63]; // mg/m3
}