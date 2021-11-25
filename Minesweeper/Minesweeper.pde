int n = 10;
int m = 10;
int numberofmines = 10;

float w;
float resolution;

int screen = 0;

boolean win = false;
boolean lose = false;
boolean[][] revealed;
boolean[][] mine;
boolean[][] foundmine;
int[][] value;


PImage bomb; PImage flag; PImage hidden; PImage unhidden;




void setup() {
  
  frameRate(200);
  textAlign(CENTER);
  bomb = loadImage("bomb0000.png");
  flag = loadImage("flag300000.png");
  hidden = loadImage("hidden10000.png");
  unhidden = loadImage("unhidden0000.png");
  
  w = width/n;
  resolution = 40;
  
  size(400,400);
  
}

void draw() {
  if (screen == 1) {
    background(30);
    show();
    int p = 0;
    for (int i = 0; i<n; i++) {
      for (int j = 0; j<m; j++) {
        if (revealed[i][j]) {
          p++;
          if (value[i][j] == 0) {
            revealNeighbors(i,j);
          }
        }
      }
    }
    if (!lose && p==n*m) {
      win = true;
    }
  } else if (screen == 0) {
    background(0);
    showStartScreen();
  } else {
    background(0);
    textSize(20);
    fill(255,255,255);
    noStroke();
    text("Currently no options available :(", width/2, height/2);
  }
  
}


void initialize() {
  revealed = new boolean[n][m];
  mine = new boolean[n][m];
  foundmine = new boolean[n][m];
  value = new int[n][m];
  
  for (int i = 0; i<n; i++) {
    for (int j = 0; j<m; j++) {
      revealed[i][j] = false;
      foundmine[i][j] = false;
    }
  }
  
  setMines(numberofmines);
  setValues();
}



void setMines(int k) {
  int[] array = new int[k];
  int count = 0;
  int N = n*m;
  while (count < k) {
    int r = floor(random(N));
    boolean good = true;
    for (int a : array) {
      if (a == r) {
        good = false;
      }
    }
    if (good) {
      array[count] = r;
      count++;
    }
  }
  
  for (int a : array) {
    int x = a % n;
    int y = floor(a/m);
    mine[x][y] = true;
  }
  
}



void setValues() {
  
  for (int i = 0; i<n; i++) {
    for (int j = 0; j<m; j++) {
      
      if (mine[i][j]) {
        value[i][j] = -1;
      } else {
        int count = 0;
        
        for (int a = -1; a<2; a++) {
          for (int b = -1; b<2; b++) {
            
            int u = i+a;
            int v = j+b;
            if (0<=u && u<n && 0<=v && v<m) {
              if (mine[u][v]) {
                count++;
              }
            }
            
          }
        }
        
        value[i][j] = count;
        
      }
      
    }
  }
  
}




void show() {
  
  for (int i = 0; i<n; i++) {
    for (int j = 0; j<m; j++) {
      
      image(hidden, i*w, j*w, w, w);
      
      if (revealed[i][j] && !mine[i][j]) {
        int v = value[i][j];
        image(unhidden, i*w, j*w, w, w);
        if (v != 0) {
          textSize(24);
          fill(0);
          noStroke();
          text(v, i*w+w/2, j*w+w/2+7);
        }
      }
      
      if (revealed[i][j] && mine[i][j]) {
        
        if (foundmine[i][j]) {
          image(flag, i*w, j*w, w, w);
        } else {
          image(bomb, i*w, j*w, w, w);
        }
      }
      
    }
  }
  
  if (lose) {
    textSize(40);
    fill(0,0,255);
    noStroke();
    text("Game over", width/2, height/2);
  }
  if (win) {
    textSize(40);
    fill(0,0,255);
    noStroke();
    text("Congratulations!", width/2, 2*height/5);
    text("You won", width/2, 3*height/5);
  }
  
}


void revealNeighbors(int x, int y) {
  
  for (int a = -1; a<2; a++) {
    for (int b = -1; b<2; b++) {
      int u = x+a;
      int v = y+b;
      if (0<=u && u<n && 0<=v && v<m) {
        revealed[u][v] = true;
        if (value[u][v] == 0 && !neighborsRevealed(u,v)) {
          revealNeighbors(u,v);
        }
      }
    }
  }
  
}


boolean neighborsRevealed(int u, int v) {
  int count = 0;
  int count_ = 0;
  for (int a = -1; a<2; a++) {
    for (int b = -1; b<2; b++) {
      int s = u+a;
      int t = v+b;
      if (0<=s && s<n && 0<=t && t<m) {
        if (revealed[u][v]) count++;
        count_++;
      }
    }
  }
  if (count == count_) return true;
  return false;
}

void showStartScreen() {
  textSize(26);
  stroke(255);
  strokeWeight(3);
  noFill();
  rect(130,110,140,40);
  text("START", 200, 140);
  rect(130,170,140,40);
  text("OPTIONS", 200, 200);
  rect(130,230,140,40);
  text("EXIT", 200, 260);
}




void mousePressed() {
  
  //print(" mousepressed ");
  //print(" mouseX: " + mouseX);
  //print(" mouseY: " + mouseY);
  
  if (screen == 1) {
  
  int x = floor(mouseX/w);
  int y = floor(mouseY/w);
  if ((mine[x][y] && mouseButton == LEFT) || (!mine[x][y] && mouseButton == RIGHT)) {
    lose = true;
    for (int i = 0; i<n; i++) {
      for (int j = 0; j<m; j++) {
        revealed[i][j] = true;
      }
    }
  } else if ((!mine[x][y] && mouseButton == LEFT) || (mine[x][y] && mouseButton == RIGHT)) {
    revealed[x][y] = true;
    if (mine[x][y]) {
      foundmine[x][y] = true;
    }
    if (value[x][y] == 0) {
      revealNeighbors(x,y);
    }
  }
  
  } else if (screen == 0) {
    
    //rect(130,110,140,40);
    //text("START", 200, 140);
    //rect(130,170,140,40);
    //text("OPTIONS", 200, 200);
    //rect(130,230,140,40);
    //text("EXIT", 200, 260);
    
    if (mouseX > 130 && mouseX < 270 && mouseY>110 && mouseY<150) {
      screen = 1;
      initialize();
    } else if (mouseX > 130 && mouseX<270 && mouseY>170 && mouseY<210) {
      screen = 2;
    } else if (mouseX > 130 && mouseX<270 && mouseY>230 && mouseY<270) {
      exit();
    }
    
  }
  
}
