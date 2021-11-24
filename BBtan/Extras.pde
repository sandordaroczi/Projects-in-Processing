float q = 5/4;

class Plus {
  
  int x;
  int y;
  float a;
  float b;
  int radius;
  boolean offscreen = false;
  
  
  Plus(int X, int Y, int R) {
    x = X; y = Y; radius = R;
    a = x*w+w/2;
    b = y*w+w/2+3*w;
  }
  
  void shift() {
    y++;
    if (y>6) {
      offscreen = true;
    }
  }
  
  void show() {
    a = x*w+w/2;
    b = y*w+w/2+3*w;
    noFill();
    strokeWeight(2);
    stroke(255,255,0);
    ellipse(a,b,radius,radius);
    line(a-radius/4, b, a+radius/4, b);
    line(a, b-radius/4, a, b+radius/4);
  }
  
}


class Laser {
  
  int x; int y; int radius;
  float a;
  float b;
  boolean offscreen = false;
  boolean used = false;
  int type;
  
  Laser(int X, int Y, int R, int Type) {
    x = X; y = Y; radius = R;
    a = x*w+w/2;
    b = y*w+w/2+3*w;
    type = Type;
  }
  
  void shift() {
    y++;
    if (y>6) {
      offscreen = true;
    }
  }
  
  void fire() {
    used = true;
    if (type == 0) {
      for (int i = tiles.size()-1; i>=0; i--) {
        Tile t = tiles.get(i);
        if (t.x == x) {
          if (t.value>1) {
            t.value = t.value-1;
          } else {
            tiles.remove(i);
          }
        }
      }
    } else {
      for (int i = tiles.size()-1; i>=0; i--) {
        Tile t = tiles.get(i);
        if (t.y == y) {
          if (t.value>1) {
            t.value = t.value-1;
          } else {
            tiles.remove(i);
          }
        }
      }
    }
    
    strokeWeight(4);
    if (type == 0) {
      stroke(10,255,150);
      line(a, 2*w, a, height-w);
    } else {
      stroke(0,50,255);
      line(0, b, width, b);
    }
    
  }
  
  void show() {
    a = x*w+w/2;
    b = y*w+w/2+3*w;
    noFill();
    strokeWeight(2);
    if (type == 0) {
      stroke(10,255,150);
      ellipse(a,b,radius,radius);
      line(a, b-radius/4, a, b+radius/4);
    } else {
      stroke(0,50,255);
      ellipse(a,b,radius,radius);
      line(a-radius/4, b, a+radius/4, b);
    }
  }
  
}


class Cannon {
  
  int x; int y; int radius;
  float a;
  float b;
  boolean offscreen = false;
  boolean used = false;
  
  Cannon(int X, int Y, int R) {
    x = X; y = Y; radius = R;
    a = x*w+w/2;
    b = y*w+w/2+3*w;
  }
  
  void shift() {
    y++;
    if (y>6) {
      offscreen = true;
    }
  }
  
  void fire(Ball b) {
    used = true;
    
    float angle = random(0,PI);
    b.vel_x = b.speed*cos(angle);
    b.vel_y = -b.speed*sin(angle);
    
  }
  
  void show() {
    a = x*w+w/2;
    b = y*w+w/2+3*w;
    noFill();
    strokeWeight(4);
    stroke(200,0,150);
    ellipse(a,b,radius,radius);
  }
  
}
