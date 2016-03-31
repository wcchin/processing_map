// the junctions of streets
class Junction {
  int id;
  PVector jpt;
  float xx;
  float yy;
  Junction[] outsegments;
  int neighborno;
  
  Junction(int idd, float x, float y) {
    id = idd;
    outsegments = new Junction[20];
    neighborno = 0;
    jpt = new PVector(x, -y);
    xx = x;
    yy = -y;
  }
  
  void display() {
    fill(150);
    ellipse(xx,yy,50,50);
  }
  
  void addneighbor(Junction nid) {
    outsegments[neighborno] = nid;
    neighborno++;
    
    if(neighborno >= 20){
      int len = outsegments.length;
      //Junction[] temp = Arrays.copyOf(outsegments, len);
      Junction[] temp = new Junction[len];
      for(int j=0;j<outsegments.length;j++) {
        temp[j] = outsegments[j];
      }
      outsegments = new Junction[len+20];
      //outsegments = Arrays.copyOf(temp, len);
      for(int j=0;j<temp.length;j++) {
        outsegments[j] = temp[j];
      }
      //println(len);
    }
  }
  void finalize_neighborlist(){
    //Junction[] temp = Arrays.copyOf(outsegments, neighborno);
    Junction[] temp = new Junction[neighborno];
    for(int j=0;j<neighborno;j++) {
      temp[j] = outsegments[j];
    }
    outsegments = temp;
  }
  
  Junction turning(Junction from) {
    Junction target = from;
    while(target==from) {
      int tar = int(random(neighborno));//(int)(Math.random()*neighborno);
      target = outsegments[tar];
      break;
    }
    return(target);
  }
}

// the segments between junctions
class Segment {
  String id;
  int dirtype;
  Junction node1;
  Junction node2;
  float direction; // in radian form
  float distance;
  float speed = gmspeed*1000/3600; // m/s
  //float needtime;
  float dx;
  float dy;
  
  Segment(String idd, int dt, Junction n1, Junction n2) {
    id = idd;
    dirtype = dt;
    node1 = n1;
    node2 = n2;
    node1.addneighbor(node2);
    PVector temp = new PVector(node2.xx-node1.xx, node2.yy-node1.yy);
    direction = temp.heading();
    distance = sqrt(pow((node2.xx-node1.xx),2)+pow((node2.yy-node1.yy),2));
    dx = cos(direction);
    dy = sin(direction);
  }
  
  void display() {
    stroke(150);
    float xx1 = node1.xx;
    float yy1 = node1.yy;
    float xx2 = node2.xx;
    float yy2 = node2.yy;
    line(xx1, yy1, xx2, yy2);
  }
}

// the moving cars
class Car {
  int id;
  PVector carpt;
  float loc_x;
  float loc_y;
  Grids backgroundgrids;
  Grid on_grid;
  Segment moving_on;
  boolean isgrided;
  
  Car(int idd, Junction initpos, Grids bgrids) {
    id = idd;
    loc_x = initpos.xx;
    loc_y = initpos.yy;
    backgroundgrids = bgrids;
    int tar = int(random(initpos.neighborno));//(int)(Math.random()*initpos.neighborno);
    Junction next_tar = initpos.outsegments[tar];
    Segment next_seg = ODtable[initpos.id][next_tar.id];
    moving_on = next_seg;
    if(bgrids == null) {
      isgrided = false;
    } else {
      isgrided = true;
      on_grid = checkgrid();
    }
  }
  
  void drive() {
    //Segment location = moving_on;
    float move_dist = moving_on.speed*1; // 1 s moving distancve
    float distto_target = sqrt(pow((loc_x-moving_on.node2.xx),2)+pow((loc_y-moving_on.node2.yy),2));
    float left_dist = move_dist - distto_target;
    Junction next_tar = moving_on.node2;
    if (left_dist >= 0) {
      next_tar = moving_on.node2.turning(moving_on.node1);
      Segment next_seg = ODtable[moving_on.node2.id][next_tar.id];
      moving_on = next_seg;
      loc_x = next_seg.node1.xx;
      loc_y = next_seg.node1.yy;
    } else {
      left_dist = move_dist;
    }
    loc_x = loc_x + moving_on.dx*left_dist;
    loc_y = loc_y + moving_on.dy*left_dist;
    
    if(isgrided) {
      Grid next_g = checkgrid();
      if(on_grid != null && next_g != null) {
        on_grid.reduce(1);
        next_g.plus(1);
        on_grid = next_g;
      }
    }
  }
  
  Grid checkgrid() {
    float westest = backgroundgrids.lowerleft.x;
    float southest = backgroundgrids.lowerleft.y + backgroundgrids.size_h;
    int g_col = (int)(floor((loc_x - westest)/backgroundgrids.size_w));
    int g_row = (int)(floor(-(loc_y - southest)/backgroundgrids.size_h));
    //println(g_col);
    //println(g_row);
    if(g_col>0 && g_row>0) {
      return(backgroundgrids.get_grid(g_col,g_row));
    } else {
      return(null);
    }
  }
  
  void display() {
    stroke(150);
    fill(200);
    rectMode(CENTER);
    rect(loc_x,loc_y,20,20);
  }
}

class Grids {
  int row_no;
  int col_no;
  Grid[][] thisgrids;
  PVector lowerleft;
  float size_w;
  float size_h;
  float[] cuts;
  
  Grids(float gx, float gy, float gw, float gh, float esw, float esh) {
    size_w = esw;
    size_h = esh;
    lowerleft = new PVector(gx-25*esw,gy+25*esh);
    col_no = (int)(ceil(gw/esw))+50;
    row_no = (int)(ceil(gh/esh))+51;
    //println(col_no);
    //println(row_no);
    
    thisgrids = new Grid[col_no][row_no];
    for(int rr=0;rr<row_no;rr++){
      float yy = -rr*esh+gy+25*esh;
      for(int cc=0;cc<col_no;cc++){
        float xx = cc*esw+gx-25*esw;
        thisgrids[cc][rr] = new Grid(esw,esh,cc,rr,xx,yy);
      }
    }
  }
  
  // use 5 number in the array to store a cuts of 4 group [start_no | 1 | second_no | 2 |third_no | 3 | fourth_no | 4 | end_no]
  // this implementation use start, end, and the number of group, and calculate the "adapted" step
  void setCuts(float start, float end, int group_no) {
    float step = (end-start)/group_no;
    cuts = new float[group_no+1];
    float this_ceil = start;
    for(int i=0;i < group_no+1;i++) {
      cuts[i] = this_ceil;
      this_ceil = this_ceil + step;
    }
  }
  
  void display(int alpha) {
    for(int rr=0;rr<row_no;rr++){
      for(int cc=0;cc<col_no;cc++){
        thisgrids[cc][rr].display(colors, cuts, alpha);
      }
    }
  }
  
  Grid get_grid(int cc, int rr) {
    if(cc<col_no && rr<row_no) {
      return thisgrids[cc][rr];
    } else {
      return(null);
    }
  }
}

class Grid {
  PVector topleft;
  float size_w;
  float size_h;
  int loc_row;
  int loc_col;
  int count_cars;
  
  
  Grid(float w, float h, int c, int r, float xx, float yy) {
    size_w = w;
    size_h = h;
    loc_row = r;
    loc_col = c;
    topleft = new PVector(xx,yy);
    count_cars = 0;
  }
  
  void reduce(int cc) {
    count_cars = count_cars - cc;
  }
  
  void plus(int cc) {
    count_cars = count_cars + cc;
  }

  void display(color[] colorlist, float[] cuts, int alpha) {
    int gind = -99;
    int checknow = 0;
    while(gind==-99) {
      if(int(count_cars) <= int(cuts[checknow])) {
        gind = checknow -1;
        //println(count_cars);
        //println(checknow);
      } else {
        checknow = checknow + 1;
        if(checknow >= cuts.length){
          gind = checknow -1 ;
        }
      }
    }
    color c = color(0, 255);
    if(gind == -1) {
      c = color(50, 255);
    } else {
      if(gind<(cuts.length-1)) {
        c = colorlist[gind];
      }
    }
    //color c = color(50,0,255,55);
    noStroke();
    //stroke(50,50,255);
    fill(c);
    rectMode(CORNER);
    rect(topleft.x,topleft.y,size_w,size_h);
  }
  
}