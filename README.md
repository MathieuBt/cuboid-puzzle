Summary
-------

Quick'n dirty code to solve a friend's 3D wood puzzle.

The puzzle consists in building a 3 * 4 * 5 rectangular cuboid based on the chunks below.


Compilation
-----------

Requires Ocaml (and some Unix-like shell).

You may compile with

    make

and then launch with

    ./chunks


Chunks
------

The crosses represent small 1*1*1 cubes glued together.

#1:
<pre>
XXX
X  
X  
</pre>

#2:
<pre>
XXXXX
</pre>

#3:
<pre>
X  
XX 
 XX
</pre>

#4:
<pre>
XXX 
  XX
</pre>

#5:
<pre>
 X 
XXX
 X 
</pre>

#6:
<pre>
XX 
 X 
 XX
</pre>

#7:
<pre>
XXXX
X   
</pre>

#8:
<pre>
XXX
 X 
 X 
</pre>

#9:
<pre>
XXXX
  X 
</pre>

#10:
<pre>
X  
XXX
 X 
</pre>

#11:
<pre>
XXX
X X
</pre>

#12:
<pre>
XXX
XX 
</pre>



Results
-------

Here are a few solutions quickly found by the program:

<pre>
 2  2  2  2  2 
 5  1  3 10  6 
11  1  3  3  6 
11  1 12  3  3 

 5  7  7  7  7 
 5  1 10 10 10 
 5  4  4  4  6 
11 12 12  4  4 

 9  9  9  9  7 
 5  1  9  8 10 
11  8  8  8  6 
11 12 12  8  6 
</pre>

<pre>
 2  2  2  2  2 
 5  1  3 12 12 
11  1  3  3  8 
11  1 10  3  3 

 5  7  7  7  7 
 5  1 12 12 12 
 5  4  4  4  8 
11 10 10  4  4 

 9  9  9  9  7 
 5  1  9  6  8 
11  6  6  6  8 
11  6 10 10  8 
</pre>

<pre>
 2  2  2  2  2 
 5  1  3  3  6 
11  1 12 12  6 
11  1 12 12 12 

 5  7  7  7  7 
 5  1 10  3  3 
 5 10 10 10  6 
11 10  4  4  4 

 9  9  9  9  7 
 5  1  9  8  3 
11  8  8  8  6 
11  4  4  8  6 
</pre>

<pre>
 2  2  2  2  2 
 5  1  1  1  3 
11  1 10  3  3 
11  1  3  3  7 

 5  4  8  8  8 
 5  4 10  8 12 
 5  4 10  8 12 
11  7  7  7  7 

 9  9  9  9 12 
 5  9  6  6 12 
11  4 10  6 12 
11  4 10  6  6 
</pre>

<pre>
 2  2  2  2  2 
 5  1  1  1  3 
11  1 10  3  3 
11  1  3  3  7 

 5  8  4  4 12 
 5  8  8  8 12 
 5  8 10 10 10 
11  7  7  7  7 

 4  4  4  6 12 
 5  6  6  6 12 
11  6  9 10 12 
11  9  9  9  9
</pre>