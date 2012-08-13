
Summary
-------

Quick'n dirty code to solve a friend's 3D wood puzzle.

The puzzle consists in building a 3 * 4 * 5 rectangular cuboid based on the chunks below.


Compilation
-----------

Requires Ocaml (and some shell).

You may compile with the following command:
   ocamlopt.opt chunks.ml -o chunks
and then launch with
   ./chunks

Chunks
------

The crosses represent small 1*1*1 cubes glued together.

#1:
XXX
X  
X  

#2:
XXXXX

#3:
 XX
XX 
X  

#4:
 XXX
XX  

#5:
 X 
XXX
 X 

#6:
XX 
 X 
 XX

#7:
   X
XXXX

#8:
XX

#9:
XXX

#10:
  X 
XXXX

#11:
 X 
XXX
  X

#12:
XXX
X X

#13:
 XX
XXX
