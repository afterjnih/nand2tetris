@17
D=A
@SP
A=M
M=D
@SP
M=M+1
@17
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M-1
D=M
@SP
A=M-1
A=A-1
D=M-D
@TRUE0
D;JEQ
@FALSE0
0;JMP
(TRUE0)
@SP
M=M-1
A=M-1
M=-1
@END0
0;JMP
(FALSE0)
@SP
M=M-1
A=M-1
M=0
(END0)
@17
D=A
@SP
A=M
M=D
@SP
M=M+1
@16
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M-1
D=M
@SP
A=M-1
A=A-1
D=M-D
@TRUE1
D;JEQ
@FALSE1
0;JMP
(TRUE1)
@SP
M=M-1
A=M-1
M=-1
@END1
0;JMP
(FALSE1)
@SP
M=M-1
A=M-1
M=0
(END1)
@16
D=A
@SP
A=M
M=D
@SP
M=M+1
@17
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M-1
D=M
@SP
A=M-1
A=A-1
D=M-D
@TRUE2
D;JEQ
@FALSE2
0;JMP
(TRUE2)
@SP
M=M-1
A=M-1
M=-1
@END2
0;JMP
(FALSE2)
@SP
M=M-1
A=M-1
M=0
(END2)
@892
D=A
@SP
A=M
M=D
@SP
M=M+1
@891
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M-1
D=M
@SP
A=M-1
A=A-1
D=M-D
@TRUE3
D;JLT
@FALSE3
0;JMP
(TRUE3)
@SP
M=M-1
A=M-1
M=-1
@END3
0;JMP
(FALSE3)
@SP
M=M-1
A=M-1
M=0
(END3)
@891
D=A
@SP
A=M
M=D
@SP
M=M+1
@892
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M-1
D=M
@SP
A=M-1
A=A-1
D=M-D
@TRUE4
D;JLT
@FALSE4
0;JMP
(TRUE4)
@SP
M=M-1
A=M-1
M=-1
@END4
0;JMP
(FALSE4)
@SP
M=M-1
A=M-1
M=0
(END4)
@891
D=A
@SP
A=M
M=D
@SP
M=M+1
@891
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M-1
D=M
@SP
A=M-1
A=A-1
D=M-D
@TRUE5
D;JLT
@FALSE5
0;JMP
(TRUE5)
@SP
M=M-1
A=M-1
M=-1
@END5
0;JMP
(FALSE5)
@SP
M=M-1
A=M-1
M=0
(END5)
@32767
D=A
@SP
A=M
M=D
@SP
M=M+1
@32766
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M-1
D=M
@SP
A=M-1
A=A-1
D=M-D
@TRUE6
D;JGT
@FALSE6
0;JMP
(TRUE6)
@SP
M=M-1
A=M-1
M=-1
@END6
0;JMP
(FALSE6)
@SP
M=M-1
A=M-1
M=0
(END6)
@32766
D=A
@SP
A=M
M=D
@SP
M=M+1
@32767
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M-1
D=M
@SP
A=M-1
A=A-1
D=M-D
@TRUE7
D;JGT
@FALSE7
0;JMP
(TRUE7)
@SP
M=M-1
A=M-1
M=-1
@END7
0;JMP
(FALSE7)
@SP
M=M-1
A=M-1
M=0
(END7)
@32766
D=A
@SP
A=M
M=D
@SP
M=M+1
@32766
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M-1
D=M
@SP
A=M-1
A=A-1
D=M-D
@TRUE8
D;JGT
@FALSE8
0;JMP
(TRUE8)
@SP
M=M-1
A=M-1
M=-1
@END8
0;JMP
(FALSE8)
@SP
M=M-1
A=M-1
M=0
(END8)
@57
D=A
@SP
A=M
M=D
@SP
M=M+1
@31
D=A
@SP
A=M
M=D
@SP
M=M+1
@53
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M-1
D=M
@SP
A=M-1
A=A-1
D=M+D
@SP
M=M-1
A=M-1
M=D
@112
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M-1
D=M
@SP
A=M-1
A=A-1
D=M-D
@SP
M=M-1
A=M-1
M=D
@SP
A=M-1
M=-M
@SP
A=M-1
D=M
@SP
A=M-1
A=A-1
D=M&D
@SP
M=M-1
A=M-1
M=D
@82
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
A=M-1
D=M
@SP
A=M-1
A=A-1
D=M|D
@SP
M=M-1
A=M-1
M=D
@SP
A=M-1
M=!M
