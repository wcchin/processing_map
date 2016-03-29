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
    xx = x;//(x - minx)*zoom-positioning_x - width*(1-pan_x);
    //float ya1 = (y - miny)*zoom-positioning_y;
    yy = -y;//(y - miny)*zoom-positioning_y - height*(1-pan_y);// -(ya1-height*pan_y);
  }
  
  void display() {
    fill(150);
    //point(xx,yy);
    ellipse(xx,yy,50,50);
    //line(xx1, yy1, xx2, yy2);
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
      //println(tar);
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
    //direction = atan((node2.yy-node1.yy)/(node2.xx-node1.xx));
    //direction = PVector.angleBetween(node2.jpt,node1.jpt);
    PVector temp = new PVector(node2.xx-node1.xx, node2.yy-node1.yy);
    direction = temp.heading();
    distance = sqrt(pow((node2.xx-node1.xx),2)+pow((node2.yy-node1.yy),2));
    //needtime = distance/speed;
    //println(direction);
    dx = cos(direction);//*distance/needtime;//*speed*1;
    dy = sin(direction);//*distance/needtime;//*speed*1;
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
  Segment moving_on;
  
  Car(int idd, Junction initpos) {
    id = idd;
    loc_x = initpos.xx;
    loc_y = initpos.yy;
    int tar = int(random(initpos.neighborno));//(int)(Math.random()*initpos.neighborno);
    Junction next_tar = initpos.outsegments[tar];
    Segment next_seg = ODtable[initpos.id][next_tar.id];
    moving_on = next_seg;
    moving_on.node2.display();
  }
  
  void drive() {
    //Segment location = moving_on;
    float move_dist = moving_on.speed*1; // 1 s moving distancve
    float distto_target = sqrt(pow((loc_x-moving_on.node2.xx),2)+pow((loc_y-moving_on.node2.yy),2));
    float left_dist = move_dist - distto_target;
    Junction next_tar = moving_on.node2;
    if (left_dist >= 0) {
      //println("haha");
      next_tar = moving_on.node2.turning(moving_on.node1);
      //println(moving_on.id);
      Segment next_seg = ODtable[moving_on.node2.id][next_tar.id];
      moving_on = next_seg;
      //moving_on.node2.display();
      //println(moving_on.id);
      loc_x = next_seg.node1.xx;
      loc_y = next_seg.node1.yy;
    } else {
      left_dist = move_dist;
    }
    loc_x = loc_x + moving_on.dx*left_dist;
    loc_y = loc_y + moving_on.dy*left_dist;
  }
  
  void display() {
    //point(loc_x, loc_y);
    stroke(150);
    //fill(255,0,255);
    fill(200);
    rectMode(CENTER);
    rect(loc_x,loc_y,20,20);
    //ellipse(loc_x,loc_y,20,20);
    /*
    if (loc_x > width || loc_x < 0 || loc_y > height || loc_y < 0) {
      point(loc_x, loc_y);
    } else {
      point(loc_x, loc_y);
    }
    */
  }
}