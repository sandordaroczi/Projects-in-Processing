## Project description

This program can be used to create mazes of arbitrary size and let the computer solve them using weighted DFS.

Here, weighted DFS means that the solving algorithm prefers moves going right or down, hence in the direction of the goal. If both cells to the right and bottom are available, the algorithm will choose one of the two randomly.

## Design

Firstly, the walls of the maze are generated randomly, the probability of setting up a wall determined by the variable _wall_prob_.

After that, we are allowed to customize the wall structure even more: we can create a wall in place an empty edge by clicking the mouse button at the center of the edge, or, we can dismiss an existing wall by clicking on the middle of it. This customizability is also a good way to ensure that the start and goal squares are not completely locked in due to a continuous line of walls around them.

Finally, pressing the Alt button will launch the maze solver. The green colored squares represent the squares which were visited by the solver. If no path to the goal was found, the program terminates; if, on the other hand, the solver managed to find a path, the squares of the path will be cyan colored.

After finding a path, it is also possible to relaunch the solver by pressing the Alt button once again.


