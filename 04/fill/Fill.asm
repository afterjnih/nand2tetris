// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input. 
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel. When no key is pressed, the
// program clears the screen, i.e. writes "white" in every pixel.

// Put your code here.
(INFINITE)
  @0
  M=!M
  D=M
 
  @24576
  D=A
  @mux
  M=D
 
  @SCREEN
  D=A
  @i
  M=D
 
(LOOP)
  @i
  D=M
  @mux
  D=M-D
  @END
  D;JLT
 
  @24576
  D=M
  @WHITE
  D;JEQ
  @BLACK
  0;JMP
 
(BLACK)
  @i
  D=M
  @tmp
  A=D
  D=0
  D=!D
  M=D
  @i
  M=M+1
 
  @24576
  D=A
  @mux
  M=D
  @LOOP
  0;JMP
 
(WHITE)
  @i
  D=M
  @tmp
  A=D
  M=0
  @i
  M=M+1
 
  @24576
  D=A
  @mux
  M=D
  @LOOP
  0;JMP
 
(END)
  @INFINITE
  0;JMP
(INFINITEEND)