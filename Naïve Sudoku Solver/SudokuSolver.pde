/*for (int i = 0; i<9; i++) {
    for (int j = 0; j<9; j++) {
      
    }
  }*/
  
void checkFilled() {
  for (int i = 0; i<9; i++) {
    for (int j = 0; j<9; j++) {
      if (sudoku[i][j] != 0) {
        filled[i][j] = true;
      } else {
        filled[i][j] = false;
      }
    }
  }
}

void checkErrors() {
  for (int i = 0; i<9; i++) {
    for (int j = 0; j<9; j++) {
      if (filled[i][j] == false && options[i][j].length == 0) {
        noLoop();
        print("Error");
      }
    }
  }
}

int[] fillNakedSingles() {
  int[] array = new int[3];
  array[0] = 0; array[1] = 0; array[2] = 0;
  for (int i = 0; i<9; i++) {
    for (int j = 0; j<9; j++) {
      if (options[i][j].length == 1) {
        array[0] = i;
        array[1] = j;
        array[2] = options[i][j][0];
        return array;
      }
    }
  }
  return array;
}

int[] fillHiddenSingles() {
  int[] array = new int[3];
  array[0] = 0; array[1] = 0; array[2] = 0;
  for (int k = 1; k<10; k++) {
    for (int i = 0; i<9; i++) {
      int number = 0;
      int i0 = -1;
      int j0 = -1;
      for (int j = 0; j<9; j++) {
        if (contains(options[i][j], k)) {
          number++;
          i0 = i;
          j0 = j;
        }
      }
      if (number == 1) {
        array[0] = i0; array[1] = j0; array[2] = k;
        return array;
      }
    }
    for (int j = 0; j<9; j++) {
      int number = 0;
      int i0 = -1;
      int j0 = -1;
      for (int i = 0; i<9; i++) {
        if (contains(options[i][j], k)) {
          number++;
          i0 = i;
          j0 = j;
        }
      }
      if (number == 1) {
        array[0] = i0; array[1] = j0; array[2] = k;
        return array;
      }
    }
    for (int a = 0; a<3; a++) {
      for (int b = 0; b<3; b++) {
        int number = 0;
        int i0 = -1;
        int j0 = -1;
        for (int i = 0; i<3; i++) {
          for (int j = 0; j<3; j++) {
            if (contains(options[a*3+i][b*3+j],k)) {
              number++;
              i0 = a*3+i;
              j0 = b*3+j;
            }
          }
        }
        if (number == 1) {
          array[0] = i0; array[1] = j0; array[2] = k;
          return array;
        }
      }
    }
  }
  return array;
}


void checkNakedPairs() {
  
}


boolean contains(int[] array, int k) {
  for (int a : array) {
    if (a == k) return true;
  }
  return false;
}

void setOptions() {
  options = new int[9][9][0];
  for (int i = 0; i<9; i++) {
    for (int j = 0; j<9; j++) {
      if (!filled[i][j]) {
      for (int k = 1; k<10; k++) {
        boolean ok = true;
        for (int l = 0; l<9; l++) {
          if (sudoku[i][l] == k || sudoku[l][j] == k) ok = false;
        }
        int l0 = floor(i/3);
        int m0 = floor(j/3);
        for (int l = 0; l<3; l++) {
          for (int m = 0; m<3; m++) {
            if (sudoku[3*l0+l][3*m0+m] == k) ok = false;
          }
        }
        if (ok) {
          options[i][j] = append(options[i][j],k);
        }
      }
    }
  }
}
}
