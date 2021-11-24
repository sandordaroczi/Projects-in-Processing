int gameScreen = 0;
int r = 16;
int startFrame = 0;
int count = 0;
int topLevel = 0;
int delay = 7;
int startingLevel = 0;
int numberofballs = startingLevel+1;
int level = startingLevel;
int extraBalls = 0;
float speed = 3;
int w = 50;

boolean launched = false;
boolean readyToLaunch = false;
boolean levelup = true;
boolean lose = false;
boolean firstClick = true;
boolean currentPointSet = false;
boolean lostFrameSet = false;
boolean[] occupied = new boolean[7];

float direction_x = 0;
float direction_y = 0;
float startingPoint = width/2;
float currentPoint = width/2;

ArrayList<Ball> balls = new ArrayList<Ball>();
ArrayList<Tile> tiles = new ArrayList<Tile>();
ArrayList<Plus> plusBalls = new ArrayList<Plus>();
ArrayList<Laser> lasers = new ArrayList<Laser>();
ArrayList<Cannon> cannons = new ArrayList<Cannon>();

void setup() {
  
  size(400,600);
  textAlign(CENTER);
  startFrame = frameCount;
  frameRate(70);
  
}



void draw() {
  
  background(30);
  
  if (gameScreen == 0) {
    showStartScreen();
  } else if (gameScreen == 1) {
  
  
  display();
  
  if (balls.size() == 0 && levelup) {
    level++;
    numberofballs = numberofballs + extraBalls;
    extraBalls = 0;
    levelup = false;
    startingPoint = currentPoint;
    currentPointSet = false;
    
    for (Tile t : tiles) {
      t.shift();
    }
    
    for (Plus p : plusBalls) {
      p.shift();
    }
    
    for (int i = lasers.size()-1; i>=0; i--) {
      Laser l = lasers.get(i);
      l.shift();
      if (l.used) {
        lasers.remove(i);
      }
    }
    
    for (int i = cannons.size()-1; i>=0; i--) {
      Cannon c = cannons.get(i);
      c.shift();
      if (c.used) {
        cannons.remove(i);
      }
    }
    
    for (int i = 0; i<7; i++) {
      if (random(5) < 2) {
        tiles.add(new Tile(i,0,level,floor(random(2))));
        occupied[i] = true;
      } else if (random(12)<1) {
        tiles.add(new Tile(i,0,2*level,0));
        occupied[i] = true;
      } else if (random(12)<1) {
        lasers.add(new Laser(i,0,16,0));
        occupied[i] = true;
      } else if (random(11)<1) {
        lasers.add(new Laser(i,0,16,1));
        occupied[i] = true;
      } else if (random(9)<1) {
        cannons.add(new Cannon(i,0,16));
        occupied[i] = true;
      } else {
        occupied[i] = false;
      }
    }
    
    addPlusBalls();
    
  }
  
  if (level > topLevel) {
    topLevel = level;
  }
  
  if (!mousePressed) {
    firstClick = false;
  }
  
  if (mousePressed && !launched && balls.size() == 0 && !firstClick) {
    setDirection();
    readyToLaunch = true;
  } else if (!mousePressed && !launched && readyToLaunch) {
    launched = true;
    startFrame = frameCount;
  }
  
  
  if ((frameCount - startFrame) % delay == 0 && launched) {
    if (count < numberofballs) {
      balls.add(new Ball(startingPoint, height-r/2-w, direction_x, direction_y, speed));
      count++;
    } else {
      count = 0;
      launched = false;
      readyToLaunch = false;
      levelup = true;
    }
  }
  
  
  for (int i = balls.size()-1; i>=0; i--) {
    Ball b = balls.get(i);
    if (b.offScreen()) {
      if (!currentPointSet) {
        currentPoint = b.x;
        currentPointSet = true;
      }
      balls.remove(i);
    }
  }
  
  
  for (Ball b : balls) {
    b.update();
    b.show();
  }
  
  for (Tile t : tiles) {
    t.show();
  }
  
  for (int i = lasers.size()-1; i>=0; i--) {
    Laser l = lasers.get(i);
    if (l.offscreen) {
      lasers.remove(i);
    } else {
      l.show();
    }
  }
  
  for (int i = cannons.size()-1; i>=0; i--) {
    Cannon c = cannons.get(i);
    if (c.offscreen) {
      cannons.remove(i);
    } else {
      c.show();
    }
  }
  
  for (int i = plusBalls.size()-1; i>=0; i--) {
    Plus p = plusBalls.get(i);
    if (p.offscreen) {
      plusBalls.remove(i);
    } else {
      p.show();
    }
  }
  
  if (lose) {
    if (!lostFrameSet) {
      startFrame = frameCount;
      lostFrameSet = true;
    }
    if (frameCount-startFrame > 50) {
      gameScreen = 2;
    }
  }
  
  } else if (gameScreen == 2) {
    showRestartScreen();
  }
  
}


void initialize() {
  startFrame = frameCount;
  count = 0;
  numberofballs = startingLevel+1;
  level = startingLevel;

  launched = false;
  readyToLaunch = false;
  levelup = true;
  lose = false;
  firstClick = true;
  currentPointSet = false;
  lostFrameSet = false;

  direction_x = 0;
  direction_y = 0;
  startingPoint = width/2;
  currentPoint = width/2;

  balls = new ArrayList<Ball>();
  tiles = new ArrayList<Tile>();
  plusBalls = new ArrayList<Plus>();
  lasers = new ArrayList<Laser>();
  cannons = new ArrayList<Cannon>();
}


void addPlusBalls() {
  int[] availablePositions = new int[0];
  for (int i = 0; i<7; i++) {
    if (!occupied[i]) {
      availablePositions = append(availablePositions, i);
    }
  }
  if (availablePositions.length > 0) {
    int r = floor(random(availablePositions.length));
    plusBalls.add(new Plus(availablePositions[r],0,16));
  }
}


void setDirection() {
  direction_x = mouseX - startingPoint;
  direction_y = mouseY - height + r/2 + w;
  float mag = sqrt(direction_x*direction_x + direction_y*direction_y);
  direction_x = direction_x / mag;
  direction_y = direction_y / mag;
  stroke(255);
  line(mouseX,mouseY,startingPoint,height-r/2-w);
}


void showStartScreen() {
  textSize(60);
  fill(255);
  text("Click to begin", width/2, height/2);
}

void showRestartScreen() {
  if (frameCount - startFrame > 250) {
    textSize(50);
    fill(255);
    text("Click to restart", width/2, height/2);
  } else {
    textSize(60);
    fill(255);
    text("Game Over", width/2, height/2);
    textSize(50);
    text("Score: " + level, width/2, height/2+100);
  }
}


void mousePressed() {
  if (gameScreen == 0 || gameScreen == 2) {
    gameScreen = 1;
    initialize();
  } else {
    /*rect(20,w/2,80,60);
    if (20<mouseX && mouseX<100 && w/2<mouseY && mouseY<60+w/2) {
      gameScreen = 0;
    }*/
  }
}



void display() {
  
  fill(150, 0, 0);
  noStroke();
  rect(0,0,width,2*w);
  rect(0,height-w,width,w);
  textSize(30);
  fill(255);
  text("Level "+level, width/2, w+10);
  textSize(20);
  text("Top: "+topLevel, width-50, w+10);
  textSize(20);
  text("Balls: "+numberofballs, width-50, height-w/2+10);
  
  fill(255);
  ellipse(currentPoint,height-w-r/2,r,r);
  
  /*noFill();
  stroke(255);
  strokeWeight(3);
  rect(20,w/2,80,60);
  text("Menu", 60, 63);*/
  
  
}
