//import java.util.Arrays;
//import org.gicentre.utils.move.*;

int sn;
int jn;
//Segment[] segments;
Junction[] junctions;
Segment[][] ODtable;
Car[] cars;
float minx = 295755.004;
float miny = 2762162.8811;
float maxx = 316364.0661;
float maxy = 2787932.3789;
float zoom = 0.2;//0.022328334;
float positioning_y;
float positioning_x;
float pan_x = 4000; // meter
float pan_y = 6000; // meter
PVector lower_left = new PVector(minx+pan_x,-miny-pan_y);
float gmspeed = 40; //km/hr
int ncar = 2;
//ZoomPan zoomer;

void setup() {
  frameRate(36);
  size(1024, 800);
  coordinateTransform();
  //zoomer = new ZoomPan(this);
  //positioning_y = (maxy-miny)/2*zoom-height/2;
  //positioning_x = (maxx-minx)/2*zoom-width/2;
  background(40);
  //stroke(150);
  readfiles();
  create_cars();
  //draw_segments();
  //testcar = new Car(9999,junctions[5916]);
}

void draw() {
  //zoomer.transform();
  coordinateTransform();
  fill(40,50);
  //ellipse(lower_left.x, lower_left.y, 5000, 5000);
  stroke(40);
  rectMode(CORNERS);
  rect(minx-minx,-maxy-maxy,maxx+maxx,-miny+miny);//width/zoom,height/zoom);
  //draw_segments();
  //testcar.drive();
  //testcar.display();
  
  for(Car acar : cars) {
    acar.drive();
    acar.display();
  }
  
}