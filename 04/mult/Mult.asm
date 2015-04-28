// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

// Put your code here.
  @sum 
  M=0 
  @R0
  D=M
  @i
  M=D
  @R1
  D=M
  @j
  M=D

(LOOP)
  @j
  D=M-1
  @END
  D;JLT
  @j
  M=D
  @R0
  D=M
  @sum
  M=M+D
  @LOOP
  0;JMP
(END)
  @sum
  D=M
  @R2
  M=D
  @END
  0;JMP


