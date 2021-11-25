int n = 40;
int radius = floor(n/6);
float wall_prob = 0.45;
int frame_rate = 50;

int w;
int startFrame;
int counter = 0;
int limit = 6;
boolean mazeSolver;
boolean alt_pressed;
boolean starting_screen;
boolean[][] horizontalWalls;
boolean[][] verticalWalls;

PVector[] position;
PVector[] path;
PVector[] junction;
PVector[] shortestPath;

MazeSolver m;

PVector zero = new PVector(0,0);



void setup() {
  frameRate(frame_rate);
  size(601,601);
  w = floor(width/n);
  mazeSolver = false;
  alt_pressed = false;
  starting_screen = true;
  /*for (int i = 0; i < cycle; i++) {
    mazeSolver[i] = false;
    win[i] = false;
  }*/
  horizontalWalls = new boolean[n+1][n+1];
  verticalWalls = new boolean[n+1][n+1];
  
  shortestPath = new PVector[1];
  shortestPath[0] = new PVector(0,0);

  
  for (int i=0; i<=n; i++) {
    for (int j=0; j<=n; j++) {
      if (j == 0 || j == n) {
        horizontalWalls[i][j] = true;
      } else {
        float r = random(120);
        if (r < wall_prob*120) {
          horizontalWalls[i][j] = true;
        } else {
          horizontalWalls[i][j] = false;
        }
      }
      if (i == 0 || i == n) {
        verticalWalls[i][j] = true;
      } else {
        float r = random(120);
        if (r < wall_prob*120) {
          verticalWalls[i][j] = true;
        } else {
          verticalWalls[i][j] = false;
        }
      }
      if ((j<radius && i<radius ) || (j>n-radius && i>n-radius)) {
        horizontalWalls[i][j] = false;
        verticalWalls[i][j] = false;
      }
    }
  }
  
}


void draw() {
  
  background(50);
  drawSquares();
  
  if (starting_screen) {
    textAlign(CENTER);
    textSize(60);
    fill(0,0,100);
    text("Press Alt to begin",width/2,2*height/5);
    textSize(50);
    text("Click on a wall to create \n or dismiss it",width/2,11*height/20);
  }
  
  if (mazeSolver && !m.win) {
    m.show();
    m.solveMaze();
  }
  
  if (counter <= limit && mazeSolver && m.win) {
    /*finalPaths[0] = path[0];
    for (int i = 0; i<path.length; i++) {
      
    }*/
    m.show();
    m.showPath();
  }
  
  
  if (counter > limit) {
    showShortestPath();
  }
  
  
  fill(100,100,255);
  rect(0,0,w,w);
  rect((n-1)*w, (n-1)*w, w, w);
  
  drawWalls();
  
}


void showShortestPath() {
  
  
  for (int i = 1; i < shortestPath.length; i++) {
    float x = shortestPath[i].x;
    float y = shortestPath[i].y;
    fill(0,255,255);
    rect(w*x, w*y, w, w);
  }
  
}


void drawSquares() {
  for (int i=0; i<n; i++) {
    for (int j=0; j<n; j++) {
      fill(200);
      noStroke();
      rect(i*w, j*w, w, w);
    }
  }
}

void drawWalls() {
  for (int i=0; i<=n; i++) {
    for (int j=0; j<=n; j++) {
      strokeWeight(2);
      if (horizontalWalls[i][j]) {
        stroke(0);
        line(i*w, j*w, (i+1)*w, j*w);
      }
      if (verticalWalls[i][j]) {
        stroke(0);
        line(i*w, j*w, i*w, (j+1)*w);
      }
    }
  }
}




void mouseClicked() {
  starting_screen = false;
  for (int i=0; i<n; i++) {
    for (int j=1; j<n; j++) {
      if (dist(mouseX, mouseY, i*w+w/2, j*w) < w/3) {
        horizontalWalls[i][j] = !horizontalWalls[i][j];
      }
    }
  }
  for (int j=0; j<n; j++) {
    for (int i=1; i<n; i++) {
      if (dist(mouseX, mouseY, i*w, j*w+w/2) < w/3) {
        verticalWalls[i][j] = !verticalWalls[i][j];
      }
    }
  }
}

void keyReleased() {
  if (key == CODED && keyCode == ALT) {
    starting_screen = false;
    if (counter < limit) {
      mazeSolver = true;
      alt_pressed = true;
      m = new MazeSolver(zero);
    }
    counter++;
  }
}
