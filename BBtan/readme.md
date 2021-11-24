## Project description

This project is a reimplementation attempt of the popular mobile phone game BBtan.

## Game objective

You are given a cannon with white bouncing balls, and your goal is to shoot the balls and eliminate the hitpoints of the appearing geometric shapes (boxes and triangles) so that they die before reaching the bottom.

One bounce to a shape results in a one point decrease in its hitpoint count. The number of hitpoints of the shapes are increasing by one per round, and we can also increase the number of available balls by picking up the "+" icons.

There are also special shapes with double hitpoints, as well as special icons: lasers and randomizers. A laser, if passed through, takes away one hitpoint per ball from all the shapes in the corresponding row or column. A randomizer, if touched, sends off the balls in a random upward direction each time.

## Notes to the implementation

- The collision detector is rather primitive as it only allows vertical or horizontal velocity changes around the corners of the boxes. This could definitely be improved to allow a more natural behaviour around the corners.
- Similarly, colliding with triangles can also be weird sometimes.
