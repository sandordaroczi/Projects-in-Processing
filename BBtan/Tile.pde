class Tile {
  
  int x;
  int y;
  float a;
  float b;
  int value;
  float green;
  int type;
  
  Tile(int X, int Y, int Value, int Type) {
    x = X; y = Y; value = Value; type = Type;
    a = x*w;
    b = y*w+3*w;
    green = 255-map(value, 0, 20, 0, 255);
  }
  
  
  
  void show() {
    a = x*w;
    b = y*w+3*w;
    stroke(255,green,0);
    strokeWeight(4);
    int correction = 1;
    textSize(18);
    noFill();
    if (type == 0) {
      rect(a+1, b+1, w-2, w-2);
      fill(255,green,0);
      text(value, a+w/2, b+w/2+8);
    } else if (type == 1) {
      triangle(a+correction, b+correction, a+w-correction, b+correction, a+correction, b+w-correction);
      fill(255,green,0);
      text(value, a+w/2-w/4, b+w/2+8-w/4);
    } else if (type == 2) {
      triangle(a+correction, b+correction, a+w-correction, b+correction, a+w-correction, b+w-correction);
      fill(255,green,0);
      text(value, a+w/2+w/4, b+w/2+8-w/4);
    } else if (type == 3) {
      triangle(a+w-correction, b+correction, a+w-correction, b+w-correction, a+correction, b+w-correction);
      fill(255,green,0);
      text(value, a+w/2+w/4, b+w/2+8+w/4);
    } else if (type == 4) {
      triangle(a+w-correction, b+w-correction, a+w-correction, b+correction, a+correction, b+correction);
      fill(255,green,0);
      text(value, a+w/2-w/4, b+w/2+8+w/4);
    }
  }
  
  
  void shift() {
    y++;
    if (y>6) {
      lose = true;
    }
  }
  
  float distance(Ball ball) {
    return dist(a+w/2, b+w/2, ball.x, ball.y);
  }
  
  
}
