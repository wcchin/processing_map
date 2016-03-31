
void coordinateTransform() {
  translate(0,height);
  scale(zoom);
  translate(-minx,miny);
  translate(-pan_x,pan_y);
}

void draw_segments() {
  for(Junction ajunc:junctions) {
    //println(ajunc.id);
    //println(ajunc.outsegments);
    //ajunc.display();
    for(Junction njunc: ajunc.outsegments){
      //println(njunc.id);
      Segment seg = ODtable[ajunc.id][njunc.id];
      stroke(125);
      seg.display();
    }
  }
}

void readfiles() {
  String[] linesjunctions = loadStrings("data/junctions.txt");
  String[] linesegments = loadStrings("data/segments.txt");
  jn = linesjunctions.length;
  sn = linesegments.length;
  junctions = new Junction[jn];
  //segments = new Segment[2*sn];
  ODtable = new Segment[jn][jn];
  for (int index=0; index < jn; index++) {
    String[] pieces = split(linesjunctions[index], '\t');
    int idd = int(pieces[0]);
    float x1 = float(pieces[1]);
    float y1 = float(pieces[2]);
    junctions[idd] = new Junction(idd,x1,y1);
   }
  for (int index=0; index < sn; index++) {
    String[] pieces = split(linesegments[index], '\t');
    int n1 = int(pieces[0]);
    int n2 = int(pieces[1]);
    Junction node1 = junctions[n1];
    Junction node2 = junctions[n2];
    Segment seg1 = new Segment(str(index), 1, node1, node2);
    //segments[index] = seg1;
    ODtable[n1][n2] = seg1;
    Segment seg2 = new Segment(str(index), 2, node2, node1);
    //segments[index+sn] = seg2;
    ODtable[n2][n1] = seg2;
  }
  for(Junction ajunc : junctions) {
    ajunc.finalize_neighborlist();
  }
  
  //Segment temp = ODtable[0][890];
  //println(temp.id);
}

void create_cars(Grids bgrids) {
  Car[] temp = new Car[junctions.length*ncar];
  int cid = 0;
  for(Junction ajunction : junctions) {
    for (int i=0;i<ncar;i++) {
        if(random(1)<1.0){
        Car acar = new Car(cid, ajunction, bgrids);
        temp[cid] = acar;
        cid++;
      }
    }
  }
  cars = new Car[cid];
  for(int i=0;i<cid;i++) {
    cars[i] = temp[i];
  }
}


// color YlOrBr_Sequential_5
void setColors(int alpha) {
  color[] YlOrBr_Sequential_5_ = new color[5];
  YlOrBr_Sequential_5_[0] = color(255, 255, 212, alpha);
  YlOrBr_Sequential_5_[1] = color(254, 217, 142, alpha);
  YlOrBr_Sequential_5_[2] = color(254, 153, 41, alpha);
  YlOrBr_Sequential_5_[3] = color(217, 95, 14, alpha);
  YlOrBr_Sequential_5_[4] = color(153, 52, 4, alpha);
  colors = YlOrBr_Sequential_5_;
}