class MazeSolver {

  PVector lastJunction;
  int step;
  int num;
  boolean thereIsLastJunction = false;
  boolean comeback = false;
  boolean win = false;
  PVector current;
  
  PVector[] position;
  PVector[] path;
  PVector[] junction;
  
  MazeSolver(PVector pos) {
    current = pos;
    initialize();
    
  }
  
 
void solveMaze() {
  
  current = position[position.length-1];
  if (frameCount % 1 == 0 && frameCount > 0) {
    update();
  }
  
}


void update() {
  
  if (current.x == n-1 && current.y == n-1 && !win) {
    win = true;
    startFrame = frameCount;
    if (counter > 1) {
    if (path.length - 1 <= shortestPath.length) {
      while (shortestPath.length > 1) {
        shortestPath = (PVector[])shorten(shortestPath);
      }
      for (PVector a : shortestPath) {
           print(a); }
      for (int i = 1; i < path.length-1; i++) {
        shortestPath = (PVector[])append(shortestPath, path[i]);
      }
      for (PVector a : shortestPath) {
           print(a); }
    }
    } else {
      for (int i = 1; i < path.length-1; i++) {
        shortestPath = (PVector[])append(shortestPath, path[i]);
      }
    }
  }
  
  if (!comeback && numberOfDirections(current) > 0 && !win) {
    
    PVector next;
  
    if (checkRightDown(current).length == 2) {
      int r = floor(random(2));
      next = new PVector(getVector(current, checkRightDown(current)[r]).x, getVector(current, checkRightDown(current)[r]).y);
    } else if (checkRightDown(current).length == 1) {
      next = new PVector(getVector(current, checkRightDown(current)[0]).x, getVector(current, checkRightDown(current)[0]).y);
    } else {
      int r = floor(random(numberOfDirections(current)));
      next = new PVector(getVector(current, calculateDirections(current)[r]).x, getVector(current, calculateDirections(current)[r]).y);
    }
  
    position = (PVector[])append(position, next);
    path = (PVector[])append(path, next);
    
    if (numberOfDirections(next) > 1) {
      junction = (PVector[])append(junction, next);
    }
    
  } else if (!comeback && numberOfDirections(current) == 0) {
    
    comeback = true;
    calculateLastJunction();
    
    if (!thereIsLastJunction && !win) {
      textAlign(CENTER);
      textSize(70);
      fill(0,0,100);
      text("Oops",width/2,2*height/5);
      textSize(60);
      text("There is no path \n to the goal :(",width/2,3*height/5);
      noLoop();
    }
    
    step = path.length;
    num = step;
    update(); 
  } else if (comeback && !win) {
    
    calculateLastJunction();
    if (current.x == lastJunction.x && current.y == lastJunction.y) {
      comeback = false;
      
      update();
    } else {
      position = (PVector[])append(position, path[2*step-2-num]);
      path = (PVector[])shorten(path);
      num++;
    }
    
  }
  
}


void initialize() {
  
  position = new PVector[1];
  path = new PVector[1];
  junction = new PVector[1];
  position[0] = new PVector(0,0);
  path[0] = new PVector(0,0);
  junction[0] = new PVector(0,0);
  
}



void calculateLastJunction() {
  
  boolean on = true;
  thereIsLastJunction = false;
  for (int i = junction.length-1; i>=0; i--) {
    if (on && numberOfDirections(junction[i]) > 0) {
      lastJunction = junction[i];
      thereIsLastJunction = true;
      on = false;
    }
  }
}


int[] checkRightDown(PVector pos) {
  
  int[] choices = new int[1];
  choices[0] = 0;
  for (int a : calculateDirections(pos)) {
    if (a == 1 || a == 2) {
      choices = append(choices, a);
    }
  }
  choices = subset(choices, 1);
  return choices;
  
}





PVector getVector(PVector p, int a) {
  PVector v = p;
  if (a == 0) {
    v = new PVector(p.x, p.y-1);
  }
  if (a == 1) {
    v = new PVector(p.x+1, p.y);
  }
  if (a == 2) {
    v = new PVector(p.x, p.y+1);
  }
  if (a == 3) {
    v = new PVector(p.x-1, p.y);
  }
  return v;
}


int numberOfDirections(PVector pos) {
  
  int sum = 0;
  for (boolean b : availableDirections(pos)) {
    if (b) {
      sum++;
    }
  }
  return sum;
  
}

int[] calculateDirections(PVector pos) {
  
  int[] array = new int[numberOfDirections(pos)];
  int index = 0;
  for (int i = 0; i < 4; i++) {
    if (availableDirections(pos)[i]) {
      array[index] = i;
      index++;
    }
  }
  
  return array;
  
}


boolean[] availableDirections(PVector pos) {
  boolean[] array = new boolean[4];
  boolean good = true;
  
  PVector p = neighbors(pos)[0];
  for (PVector v : position) {
    if (p.x==v.x && p.y==v.y) {
      good = false;
    }
  }
  if (good && p.x>=0 && !horizontalWalls[int(pos.x)][int(pos.y)]) {
    array[0] = true;
  } else {
    array[0] = false;
  }
  
  good = true;
  
  p = neighbors(pos)[1];
  for (PVector v : position) {
    if (p.x==v.x && p.y==v.y) {
      good = false;
    }
  }
  if (good && p.x>=0 && !verticalWalls[int(pos.x+1)][int(pos.y)]) {
    array[1] = true;
  } else {
    array[1] = false;
  }
  
  good = true;
  
  p = neighbors(pos)[2];
  for (PVector v : position) {
    if (p.x==v.x && p.y==v.y) {
      good = false;
    }
  }
  if (good && p.x>=0 && !horizontalWalls[int(pos.x)][int(pos.y+1)]) {
    array[2] = true;
  } else {
    array[2] = false;
  }
  
  good = true;
  
  p = neighbors(pos)[3];
  for (PVector v : position) {
    if (p.x==v.x && p.y==v.y) {
      good = false;
    }
  }
  if (good && p.x>=0 && !verticalWalls[int(pos.x)][int(pos.y)]) {
    array[3] = true;
  } else {
    array[3] = false;
  }
  return array;
  
}

PVector[] neighbors(PVector pos) {
  PVector[] array = new PVector[4];
  PVector p = new PVector(pos.x, pos.y-1);
  if (0 <= p.x && p.x < n && 0 <= p.y && p.y < n) {
    array[0] = p;
  } else {
    array[0] = new PVector(-1,-1);
  }
  p = new PVector(pos.x+1, pos.y);
  if (0 <= p.x && p.x < n && 0 <= p.y && p.y < n) {
    array[1] = p;
  } else {
    array[1] = new PVector(-1,-1);
  }
  p = new PVector(pos.x, pos.y+1);
  if (0 <= p.x && p.x < n && 0 <= p.y && p.y < n) {
    array[2] = p;
  } else {
    array[2] = new PVector(-1,-1);
  }
  p = new PVector(pos.x-1, pos.y);
  if (0 <= p.x && p.x < n && 0 <= p.y && p.y < n) {
    array[3] = p;
  } else {
    array[3] = new PVector(-1,-1);
  }
  return array;
}

void show() {
  
  current = position[position.length-1];
  for (PVector p : position) {
    fill(0,140,40);
    noStroke();
    rect(w*p.x, w*p.y, w, w);
  }
  
  fill(255,40,40);
  rect(w*m.current.x, w*current.y, w, w);
  
  
}

void showPath() {
  
  for (int i = 1; i < path.length-1; i++) {
    if (floor((frameCount-startFrame)/1) == i || frameCount-startFrame > path.length) {
      float x = path[i].x;
      float y = path[i].y;
      fill(0,255,255);
      rect(w*x, w*y, w, w);
    }
  }
  
}




}
