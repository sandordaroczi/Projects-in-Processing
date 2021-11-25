class Piece {
  
  int x; int y; int type;
  int x_min = -1; int x_max = -1;
  boolean[][] matrix = new boolean[4][4];
  
  Piece(int X, int Y, int Type) {
    x = X; y = Y; type = Type;
    matrix = setMatrix(Type);
  }
  
  
  void show() {
    fill(255,0,0);
    stroke(100);
    for (int i = 0; i<4; i++) {
      for (int j = 0; j<4; j++) {
        if (matrix[i][j]) {
          rect((x+j)*w,(y+i)*w,w,w);
        }
      }
    }
  }
  
  void calcEdges() {
    x_max = -1;
    x_min = 100;
    for (int i = 0; i<4; i++) {
      for (int j = 0; j<4; j++) {
        if (x_max == -1) x_max = x+j;
        if (x_min == -1) x_min = x+j;
        if (matrix[i][j]) {
          if (x+j > x_max) x_max = x+j;
          if (x+j < x_min) x_min = x+j;
        }
      }
    }
  }
  
  void moveDown() {
    while (!collides()) {
      y++;
    }
  }
  
  void moveLeft() {
    if (!collides_left()) {
      x--;
    }
  }
  
  void moveRight() {
    if (!collides_right()) {
      x++;
    }
  }
  
  void rotation() {
    matrix = rotateMatrix(this);
    boolean[] bools = overlaps();
    
    if (bools[1]) {
      shiftLeft();
    }
    if (bools[2]) {
      shiftRight();
    }
    if (bools[0]) {
      shiftUp();
    }
    
    if (checkEdges(this)) {
      x += 1;
      if (checkEdges(this)) {
        x -= 2;
        if (checkEdges(this)) {
          x += 3;
          if (checkEdges(this)) {
            x -= 4;
          }
        }
      }
    }
  }
  
  void freeze() {
    for (int i = 0; i<4; i++) {
      for (int j = 0; j<4; j++) {
        if (matrix[i][j]) {
          occupied[y+i][x+j] = true;
        }
      }
    }
  }
  
  void shiftUp() {
    while(overlaps()[0] && y>0) {
      y--;
    }
  }
  
  void shiftRight() {
    while(overlaps()[2] && x<9) {
      x++;
    }
  }
  
  void shiftLeft() {
    while(overlaps()[1] && x>0) {
      x--;
    }
  }
  
  boolean checkEdges(Piece p) {
    boolean good = false;
    for (int i = 0; i<4; i++) {
      for (int j = 0; j<4; j++) {
        if (matrix[i][j] && (x+j<0 || x+j>9 || y+i<0 || y+i>19)) {
          good = true;
        }
      }
    }
    return good;
  }
  
  boolean collides() {
    boolean good = false;
    for (int i = 0; i<4; i++) {
      for (int j = 0; j<4; j++) {
        if (matrix[i][j]) {
          if (occupied[y+i+1][x+j]) {
            good = true;
          }
        }
      }
    }
    return good;
  }
  
  boolean collides_right() {
    boolean good = false;
    for (int i = 0; i<4; i++) {
      for (int j = 0; j<4; j++) {
        if (matrix[i][j]) {
          if (x+j+1 > 9 || occupied[y+i][x+j+1]) {
            good = true;
          }
        }
      }
    }
    return good;
  }
  
  boolean collides_left() {
    boolean good = false;
    for (int i = 0; i<4; i++) {
      for (int j = 0; j<4; j++) {
        if (matrix[i][j]) {
          if (x+j-1 < 0 || occupied[y+i][x+j-1]) {
            good = true;
          }
        }
      }
    }
    return good;
  }
  
  boolean[] overlaps() {
    boolean good = false;
    boolean right = false;
    boolean left = false;
    boolean down = false;
    for (int i = 0; i<4; i++) {
      for (int j = 0; j<4; j++) {
        if (matrix[i][j]) {
          if (y+i > 19) {
            down = true;
            good = true;
          }
          if (x+j < 0) {
            left = true;
          }
          if (x+j > 9) {
            right = true;
          }
          if (occupied[y+i][x+j]) {
            good = true;
          }
        }
      }
    }
    boolean[] arr = {good, right, left, down};
    return arr;
  }
  
}

boolean[][] setMatrix(int type) {
  boolean[][] m;
  if (type == I) {
    m = new boolean[][]{{false,true,false,false},{false,true,false,false},{false,true,false,false},{false,true,false,false}};
  } else if (type == J) {
    m = new boolean[][]{{true,true,true,false},{false,false,true,false},{false,false,false,false},{false,false,false,false}};
  } else if (type == L) {
    m = new boolean[][]{{true,true,true,false},{true,false,false,false},{false,false,false,false},{false,false,false,false}};
  } else if (type == O) {
    m = new boolean[][]{{true,true,false,false},{true,true,false,false},{false,false,false,false},{false,false,false,false}};
  } else if (type == S) {
    m = new boolean[][]{{false,true,true,false},{true,true,false,false},{false,false,false,false},{false,false,false,false}};
  } else if (type == T) {
    m = new boolean[][]{{true,true,true,false},{false,true,false,false},{false,false,false,false},{false,false,false,false}};
  } else if (type == Z) {
    m = new boolean[][]{{true,true,false,false},{false,true,true,false},{false,false,false,false},{false,false,false,false}};
  } else {
    m = null;
  }
  return m;
}

boolean[][] rotateMatrix(Piece p) {
  boolean[][] matrix = p.matrix;
  boolean[][] newMatrix = new boolean[4][4];
  if (p.type == I) {
    for (int i = 0; i<4; i++) {
      for (int j = 0; j<4; j++) {
        newMatrix[i][j] = matrix[3-j][i];
      }
    }
  } else if (p.type != O) {
    for (int i = 0; i<4; i++) {
      for (int j = 0; j<4; j++) {
        if (j<3 && i<3) {
          newMatrix[i][j] = matrix[2-j][i];
        } else {
          newMatrix[i][j] = matrix[i][j];
        }
      }
    }
  } else {
    return matrix;
  }
  return newMatrix;
}
