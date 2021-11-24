class Ball {
  
  float x; float y;
  float next_x; float next_y;
  float vel_x; float vel_y;
  float speed;
  boolean laserFired = false;
  boolean cannonFired = false;
  
  Ball(float X, float Y, float v_x, float v_y, float Speed) {
    x = X; y = Y;
    speed = Speed;
    vel_x = v_x * Speed; vel_y = v_y * Speed;
    next_x = X + v_x; next_y = Y + v_y;
  }
  
  void update() {
    next_x = x+vel_x; next_y = y+vel_y;
    checkWalls();
    collision();
    checkPlusBall();
    checkLaser();
    checkCannon();
    x += vel_x;
    y += vel_y;
  }
  
  void checkWalls() {
    if (next_x < r/2 || next_x > width-r/2) {
      vel_x = -vel_x;
    }
    if (next_y < r/2+2*w) {
      vel_y = -vel_y;
    }
  }
  
  void collision() {
    Tile s = closestTile();
    for (int i = tiles.size()-1; i >=0; i--) {
      Tile t = tiles.get(i);
      if (t.type == 0) {
        if (t == s && t.a-r/2 < next_x && next_x < t.a+w+r/2 && t.b-r/2 < next_y && next_y < t.b+w+r/2) {
          changeValue(t,i);
          setVelocity(t);
        }
      } else if (t.type == 1) {
        if (t == s && t.a-r/2 < next_x && next_x < t.a+w+r/2 && t.b-r/2 < next_y && next_y < t.b+w+r/2 && dist(next_x,next_y,t.a-r/2,t.b-r/2)<10+dist(next_x,next_y,t.a+w+r/2,t.b+w+r/2)) {
          changeValue(t,i);
          setVelocity1(t);
        }
      } else if (t.type == 2) {
        
      } else if (t.type == 3) {
        
      } else if (t.type == 4) {
        
      }
    }
  }
  
  void changeValue(Tile t, int i) {
    if (t.value > 1) {
      t.value = t.value-1;
      t.green = 255-map(t.value, 0, 20, 0, 255);
    } else {
      tiles.remove(i);
    }
  }
  
  void setVelocity(Tile t) {
    if (calculateNewDirection(t)) {
      vel_x = -vel_x;
    } else {
      vel_y = -vel_y;
    }
  }
  
  void setVelocity1(Tile t) {
    if (calculateNewDirection1(t) == 0) {
      vel_x = -vel_x;
    } else if (calculateNewDirection1(t) == 1) {
      vel_y = -vel_y;
    } else {
      float temp = vel_x;
      vel_x = -vel_y;
      vel_y = -temp;
    }
  }
  
  void checkPlusBall() {
    for (int i = plusBalls.size()-1; i>=0; i--) {
      Plus p = plusBalls.get(i);
      if (dist(next_x, next_y, p.a, p.b) < q*p.radius) {
        extraBalls++;
        plusBalls.remove(i);
      }
    }
  }
  
  void checkLaser() {
    boolean good = true;
    for (int i = lasers.size()-1; i>=0; i--) {
      Laser l = lasers.get(i);
      if (!laserFired && dist(next_x, next_y, l.a, l.b) < q*l.radius) {
        laserFired = true;
        l.fire();
      }
      if (dist(next_x, next_y, l.a, l.b) < l.radius) {
        good = false;
      }
    }
    if (good) {
      laserFired = false;
    }
  }
  
  void checkCannon() {
    boolean good = true;
    for (int i = cannons.size()-1; i>=0; i--) {
      Cannon c = cannons.get(i);
      if (!cannonFired && dist(next_x, next_y, c.a, c.b) < q*c.radius) {
        cannonFired = true;
        c.fire(this);
      }
      if (dist(next_x, next_y, c.a, c.b) < c.radius) {
        good = false;
      }
    }
    if (good) {
      cannonFired = false;
    }
  }
  
  Tile closestTile() {
    Tile tile = new Tile(-1,-1,-1,0);
    for (Tile t : tiles) {
      if (t.distance(this) < tile.distance(this)) {
        tile = t;
      }
    }
    return tile;
  }
  
  boolean calculateNewDirection(Tile t) {
    if (x > t.a+w+r/2 && y > t.b-r/2 && y < t.b+w+r/2) {
      return true;
    } else if (x < t.a-r/2 && y > t.b-r/2 && y < t.b+w+r/2) {
      return true;
    } else if (x > t.a-r/2 && x < t.a+w+r/2 && y > t.b+w+r/2) {
      return false;
    } else if (x > t.a-r/2 && x < t.a+w+r/2 && y < t.b-r/2) {
      return false;
    } else if (x > t.a+w+r/2 && y < t.b-r/2) {
      if (underVertice(t.a+w+r/2,t.b-r/2)) {
        return true;
      } else {
        return false;
      }
    } else if (x > t.a+w+r/2 && y > t.b+w+r/2) {
      if (underVertice(t.a+w+r/2,t.b+w+r/2)) {
        return false;
      } else {
        return true;
      }
    } else if (x < t.a-r/2 && y > t.b+w+r/2) {
      if (underVertice(t.a-r/2,t.b+w+r/2)) {
        return false;
      } else {
        return true;
      }
    } else if (x < t.a-r/2 && y < t.b-r/2) {
      if (underVertice(t.a-r/2,t.b-r/2)) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
  
  int calculateNewDirection1(Tile t) {
    int a = 2;
    if (x < t.a-r/2 && y > t.b-r/2 && y < t.b+w+r/2) {
      a=0;
    } else if (x > t.a-r/2 && x < t.a+w+r/2 && y < t.b-r/2) {
      a=1;
    } else if (x < t.a-r/2 && y < t.b-r/2) {
      if (underVertice(t.a-r/2,t.b-r/2)) {
        a=0;
      } else {
        a=1;
      }
    } else if (x > t.a+w+r/2 && y < t.b-r/2) {
      if (underVertice(t.a+w+r/2,t.b-r/2)) {
        a=2;
      } else {
        a=1;
      }
    } else if (x < t.a-r/2 && y > t.b+w+r/2) {
      if (underVertice(t.a-r/2,t.b+w+r/2)) {
        a=2;
      } else {
        a=0;
      }
    }
    return a;
  }
  
  boolean underVertice(float u, float v) {
    float q = (u-next_x)/(x-next_x);
    return (q*y+(1-q)*next_y < v);
  }
  
  /*boolean calculateNearestSide(float a, float b, float u, float v, float side) {
    float[] distances = new float[4];
    distances[0] = abs(u-a);
    distances[1] = abs(a+side-u);
    distances[2] = abs(v-b);
    distances[3] = abs(b+side-v);
    int q = -1;
    float m = min(distances);
    for (int i = 0; i<4; i++) {
      if (distances[i] == m) {
        q = i;
      }
    }
    return (q<2);
  }*/
  
  boolean offScreen() {
    return (next_y > height-r/2-w);
  }
  
  void show() {
    fill(255);
    noStroke();
    ellipse(x,y,r,r);
  }
  
  
}
