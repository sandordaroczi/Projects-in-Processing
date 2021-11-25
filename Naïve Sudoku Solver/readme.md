## Project description

This is an implementation of a naïve sudoku solver algorithm.

During each round, the program makes a list of the allowed numbers at each square by taking the list _[1,2,...,9]_ and excluding the numbers that are either in the corresponding row, column, or 3x3 subgrid.

If only one number is allowed, this number gets written in that square, the allowed numbers of the other squares get updated, and the algorithm continues with the next round.

If no square has a list of allowed numbers with length one, we are either finished, or the program is stuck.

## Controls

Tune the _frame_rate_ parameter to change the frame rate of the sudoku solver.

The value of the variable _easy_hard_or_invalid_ determines which of the three pre-built sudoku boards we would like to solve. A value of _1_, _2_ and _3_ means that the program will solve an easy, a hard or an invalid sudoku problem, respectively.


