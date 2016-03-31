//import java.util.Arrays;
//import org.gicentre.utils.move.*;

int sn;
int jn;
//Segment[] segments;
Junction[] junctions;
Segment[][] ODtable;
Car[] cars;
Grids bgrids;
float minx = 295755.004;
float miny = 2762162.8811;
float maxx = 316364.0661;
float maxy = 2787932.3789;
float zoom = 0.05;//0.022328334;
float positioning_y;
float positioning_x;
float pan_x = 1000; // meter
float pan_y = 4000; // meter
PVector lower_left = new PVector(minx+pan_x,-miny-pan_y);
float gmspeed = 40; //km/hr
int ncar = 1;
//ZoomPan zoomer;
color[] colors;
int alpha;

void setup() {
  frameRate(24);
  size(1024, 800);
  background(100);
  coordinateTransform();
  //zoomer = new ZoomPan(this);
  alpha = 50;
  setColors(alpha);
  bgrids = new Grids(minx,-miny,maxx-minx,maxy-miny,200,200);
  bgrids.setCuts(0, 20.0, 5);
  bgrids.display(alpha);
  //positioning_y = (maxy-miny)/2*zoom-height/2;
  //positioning_x = (maxx-minx)/2*zoom-width/2;
  //stroke(150);
  readfiles();
  create_cars(bgrids);
  
  //draw_segments();
  //testcar = new Car(9999,junctions[5916]);
}

void draw() {
  //zoomer.transform();
  coordinateTransform();
  fill(255,alpha);
  //ellipse(lower_left.x, lower_left.y, 5000, 5000);
  noStroke();
  rectMode(CORNERS);
  //rect(minx-minx,-maxy-maxy,maxx+maxx,-miny+miny);//width/zoom,height/zoom);
  //draw_segments();
  //testcar.drive();
  //testcar.display();
  
  for(Car acar : cars) {
    acar.drive();
    acar.display();
  }
  bgrids.display(alpha);
  
}
