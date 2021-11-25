int frame_rate = 50;
int easy_hard_or_invalid = 1;

int[][] easySudoku =
  {{7,4,0,0,3,0,0,1,0},
  {0,1,9,0,6,8,5,0,2},
  {0,0,0,0,0,4,3,0,0},
  {0,5,6,3,7,0,0,0,1},
  {0,0,1,8,0,0,0,9,5},
  {0,9,0,0,2,0,6,0,0},
  {1,0,3,4,0,7,2,0,0},
  {5,0,0,2,0,0,0,0,8},
  {0,8,0,0,0,1,4,7,0}};
  
int[][] hardSudoku =
  {{7,0,8,0,0,0,3,0,0},
  {0,0,0,2,0,1,0,0,0},
  {5,0,0,0,0,0,0,0,0},
  {0,4,0,0,0,0,0,2,6},
  {3,0,0,0,8,0,0,0,0},
  {0,0,0,1,0,0,0,9,0},
  {0,9,0,6,0,0,0,0,4},
  {0,0,0,0,7,0,5,0,0},
  {0,0,0,0,0,0,0,0,0}};
  
int[][] invalidSudoku =
  {{0,0,1,0,0,0,0,0,0},
  {0,0,0,0,0,3,0,8,5},
  {0,0,1,0,2,0,0,0,0},
  {0,0,0,5,0,7,0,0,0},
  {0,0,4,0,0,0,1,0,0},
  {0,9,0,0,0,0,0,0,0},
  {5,0,0,0,0,0,0,7,3},
  {0,0,2,0,1,0,0,0,0},
  {0,0,0,0,4,0,0,0,9}};


int[][] sudoku = new int[9][9];
int[][][] options = new int[9][9][0];
boolean[][] filled = new boolean[9][9];
boolean[][] fix = new boolean[9][9];

int num_of_zeros = 0;
boolean invalid;

void setup() {
  size(400,400);
  textAlign(CENTER);
  for (int i = 0; i<9; i++) {
    for (int j = 0; j<9; j++) {
      switch (easy_hard_or_invalid) {
        case 1:
          sudoku[i][j] = easySudoku[i][j];
          break;
        case 2:
          sudoku[i][j] = hardSudoku[i][j];
          break;
        case 3:
          sudoku[i][j] = invalidSudoku[i][j];
          break;
      }
      if (sudoku[i][j] != 0) {
        fix[i][j] = true;
      } else {
        fix[i][j] = false;
        num_of_zeros += 1;
      }
    }
  }
  setOptions();
  checkFilled();
  invalid = checkInvalid();
}

void draw() {
  background(210);
  
  if (invalid) {
    textSize(50);
    fill(0,0,100);
    noStroke();
    text("Invalid board", width/2, height/2);
    noLoop();
  }
  
  if (frameCount % floor(1000/frame_rate) == 0) {
    checkFilled();
    setOptions();
    int[] array1 = new int[3];
    arrayCopy(fillNakedSingles(),array1);
    if (array1[2] != 0) {
      sudoku[array1[0]][array1[1]] = array1[2];
      num_of_zeros -= 1;
    } else {
      int[] array2 = new int[3];
      arrayCopy(fillHiddenSingles(),array2);
      if (array2[2] != 0) {
        sudoku[array2[0]][array2[1]] = array2[2];
        num_of_zeros -= 1;
      } else if (num_of_zeros > 0) {
        textSize(60);
        fill(0,0,100);
        noStroke();
        text("Stuck", width/2, height/2);
        noLoop();
      } else {
        noLoop();
      }
      
    }
    
    //print(" " + num_of_zeros + " ");
    checkFilled();
    setOptions();
  }
  show();
}


void show() {
  stroke(0);
  for (int i = 0; i<10; i++) {
    if (i%3 == 0) {
      strokeWeight(2);
    } else {
      strokeWeight(1);
    }
    line(0,i*height/9,width,i*height/9);
    line(i*width/9,0,i*width/9,height);
  }
  for (int i = 0; i<9; i++) {
    for (int j = 0; j<9; j++) {
      if (sudoku[i][j] != 0) {
        textSize(30);
        if (fix[i][j]) {
          fill(0);
        } else {
          fill(200,0,0);
        }
        text(sudoku[i][j],(j+0.5)*width/9,(i+0.77)*height/9);
      } else {
        textSize(10);
        fill(0,0,255);
        if (options[i][j].length < 5) {
          for (int l = 0; l<options[i][j].length; l++) {
            int a = options[i][j][l];
            text(a,(j+0.2+floor(l/2)*0.5)*width/9,(i+0.33+(l%2)*0.5)*height/9);
          }
        } else {
          for (int l = 0; l<options[i][j].length; l++) {
            int a = options[i][j][l];
            text(a,(j+0.15+(l%3)*0.3)*width/9,(i+0.3+floor(l/3)*0.3)*height/9);
          }
        }
      }
    }
  }
}
