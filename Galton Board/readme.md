## Project description

This is an implementation of the Galton board which can be used to experimentally approximate the values of binomial coefficients.

## The original Galton board

The original [Galton board](https://en.wikipedia.org/wiki/Galton_board), invented by Sir Francis Galton, consists of a vertical board with interleaved rows of pegs. Beads are dropped from the top and, when the device is level, bounce either left or right as they hit the pegs. Eventually they are collected into bins at the bottom, where the height of bead columns accumulated in the bins approximate a bell curve.

This device was to demonstrate the central limit theorem, which says that the binomial distribution with sufficient sample size approximates a normal distribution.

## The theory behind

If the number of rows is _n_, and the probability of bouncing to the right is assumed to be _p_ at each peg, then the probability that a bead will land in the _k_-th bin is

![equation](https://i.ibb.co/ry9QDbR/equation-3.png)

This is the probability density function of the Binomial Distribution with parameter _p_.

In case of a symmetric Galton board (with _p_ equal to _0.5_) the probabilities are directly proportional to the binomial coefficients. Therefore the binomial coefficients can be approximated by calculating the ratio of beads ending up in the _k_-th bin and multiplying the result with ![equation](https://i.ibb.co/wMJq5g7/equation-2.png).

## Design of the program

Instead of actual beads and pegs, my implementation uses green light beams which bounce off of gates with equal probability to the left and to the right. The gates are arranged into the shape of the Pascal triangle, therefore the construction exactly simulates the behaviour of the Galton board. For each box on the bottom of the pyramid the number of beams landing in that box is calculated, and then the scaled value is compared to the corresponding binomial coefficient.
