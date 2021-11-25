float w;

int I = 0; int J = 1; int L = 2; int O = 3; int S = 4; int T = 5; int Z = 6;
int delay = 30;
int startFrame;
int score;
int next;

boolean moved;
boolean lose;
boolean startFrameSet;
boolean readyToClick;
boolean[][] occupied = new boolean[21][10];

Piece current;

void setup() {
  size(480,600);
  w = height/20;
  textAlign(CENTER);
  textSize(40);
  initialize();
}


void draw() {
  if (!keyPressed) {
    moved = false;
  }
  
  background(20);
  
  if (frameCount % delay == 0 && frameCount > 0 && !lose) {
    checkLose();
    if (current.collides()) {
      current.freeze();
      current = new Piece(4,0,next);
      next = floor(random(7));
      int[] array = checkRows();
      if (array.length > 0) {
        for (int r : array) {
          deleteRow(r);
        }
        score += array.length;
      }
    } else {
      current.y += 1;
    }
  }
  if (lose) {
    if (!startFrameSet) {
      startFrame = frameCount;
      startFrameSet = true;
    }
    fill(255);
    if (frameCount-startFrame < 150) {
      text("Game over",width/2,height/2);
    } else if (!mousePressed) {
      text("Click to restart",width/2,height/2);
    } else {
      initialize();
    }
  } else {
    drawGrid();
    drawInfo();
    showFreeze();
    current.show();
  }
}

void initialize() {
  startFrame = 0;
  score = 0;
  moved = false;
  lose = false;
  startFrameSet = false;
  readyToClick = false;
  for (int i = 0; i<20; i++) {
    for (int j = 0; j<10; j++) {
      occupied[i][j] = false;
    }
  }
  for (int j = 0; j<10; j++) {
    occupied[20][j] = true;
  }
  next = floor(random(7));
  current = new Piece(4,0,floor(random(7)));
}

void keyPressed() {
  if (key == CODED && !moved) {
    current.calcEdges();
    moved = true;
    if (keyCode == UP) {
      current.rotation();
    }
    if (keyCode == LEFT) {
      if (current.x_min > 0) current.moveLeft();
    }
    if (keyCode == RIGHT) {
      if (current.x_max < 9) current.moveRight();
    }
    if (keyCode == DOWN) {
      current.moveDown();
      current.freeze();
      current = new Piece(4,0,next);
      next = floor(random(7));
      int[] array = checkRows();
      if (array.length > 0) {
        for (int r : array) {
          deleteRow(r);
        }
        score += array.length;
      }
    }
  }
}

void mousePressed() {
  if (!lose && mouseButton == LEFT && mouseX>350 && mouseX<440 && mouseY>480 && mouseY<570) {
    initialize();
  }
}

void checkLose() {
  for (int i = 0; i<4; i++) {
    for (int j = 0; j<4; j++) {
      if (current.matrix[i][j] && occupied[current.y+i][current.x+j]) {
        lose = true;
      }
    }
  }
  for (int i = 0; i<10; i++) {
    if (occupied[0][i]) {
      lose = true;
    }
  }
}

int[] checkRows() {
  int[] array = new int[0];
  for (int i = 0; i<20; i++) {
    boolean good = true;
    for (int j = 0; j<10; j++) {
      if (!occupied[i][j]) {
        good = false;
      }
    }
    if (good) {
      array = append(array,i);
    }
  }
  return array;
}

void deleteRow(int a) {
  for (int i = a; i>0; i--) {
    for (int j = 0; j<10; j++) {
      occupied[i][j] = occupied[i-1][j];
    }
  }
}

void showFreeze() {
  for (int i = 0; i<20; i++) {
    for (int j = 0; j<10; j++) {
      if (occupied[i][j]) {
        fill(255,255,0);
        stroke(100);
        rect(j*w,i*w,w,w);
      }
    }
  }
}

void drawGrid() {
  stroke(150);
  strokeWeight(1);
  for (int i = 0; i<=10; i++) {
    line(i*w,0,i*w,height);
  }
  for (int j = 0; j<=20; j++) {
    line(0,j*w,300,j*w);
  }
}

void drawInfo() {
  textSize(40);
  fill(255);
  text("Score:",390,60);
  text(score,390,110);
  text("Next:",390,250);
  boolean[][] matrix = setMatrix(next);
  for (int i = 0; i<4; i++) {
    for (int j = 0; j<4; j++) {
      if (matrix[j][i]) {
        fill(255,0,0);
        stroke(100);
        rect(350+i*w,300+j*w,30,30);
      }
    }
  }
  stroke(255);
  noFill();
  rect(350,480,90,90);
  textSize(23);
  fill(255);
  text("Restart",395,530);
}
