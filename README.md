The Reasoned Schemer
====================

Ian Taylor, 2017

[The Reasoned Schemere](https://mitpress.mit.edu/books/reasoned-schemer) is an explanation of the
logic programming language, miniKanren, implemented in Scheme.

This repo is a fork of the original code base for The Reasoned Schemer, and contains my exercise code and helper code (some of which is mine).
I'm implementing all code using [MIT/GNU Scheme](https://www.gnu.org/software/mit-scheme/) on a MacBook Pro.  

====================

Original code from 'The Reasoned Schemer' (MIT Press, 2005) by Daniel P. Friedman, William E. Byrd and Oleg Kiselyov.

This implementation uses an older version of miniKanren. Newer versions of miniKanren have a simpler language, simpler implementation, and improved performance. (For example, ```condi``` has been replaced by an improved version of ```conde``` which performs interleaving.).

The code is divided into four files:

```mk.scm``` contains the miniKanren core forms.

```mkextraforms.scm``` contains ```run*``` and ```project```.

```mkprelude.scm``` contains useful helper relations, including the full arithmetic system from chapters 7 and 8.

```mktests.scm``` contains essentially every piece of code in the book, along with appropriate tests.


To run all the tests, simply load ```mktests.scm``` in an R5RS-compatible Scheme system:

```> (load "mktests.scm")```

To just play around with miniKanren, instead load ```mkprelude.scm```.
