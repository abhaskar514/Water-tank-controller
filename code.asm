org 00h
rs equ p1.0; //register select pin
rw equ p1.1; //read/write pin
en equ p1.2; //enable pin
quat equ p3.0; //pin connected to quater level of tank
half equ p3.1; //pin connected to half level of tank
quat_3 equ p3.2; //pin connected to three -fourth level of tank
full equ p3.3; //pin connected to full level of tank
spkr_on equ p3.5 ; //pin to on motor
spkr_off equ p3.4; // pin to off motor

      SETB spkr_off
      SETB full
      SETB quat_3
      SETB half
      SETB quat
      clr spkr_off
      clr full
      clr quat_3
      clr half
      clr quat
      SETB spkr_on
      acall display

start:JB quat,next
      JB half,next
      JB quat_3,next
      JB full,next
      JB spkr_off,next
      acall display
      acall EMPTY
      sjmp start
      
next: JNB quat,next2
      JB half,next2
      JB quat_3,next2
      JB full,next2
      JB spkr_off,next2
      acall display
      acall MOTOR_ON
      sjmp next

next2:JNB quat,next3
      JNB half,next3
      JB quat_3,next3
      JB full,next3
      JB spkr_off,next3
      acall display
      acall quarter
      sjmp next2

next3:JNB quat,next4
      JNB half,next4
      JNB quat_3,next4
      JB full,next4
      JB spkr_off,next4
      acall display
      acall half_fill
      sjmp next3

next4:JNB quat,next5
      JNB half,next5
      JNB quat_3,next5
      JNB full,next5
      JB spkr_off,next5
      acall display
      acall three_four_full
      sjmp next4

next5:JNB quat,next6
      JNB half,next6
      JNB quat_3,next6
      JNB full,next6
      JNB spkr_off,next6
      acall display
      acall full_fill
      setb spkr_on
      sjmp next5

next6:JB quat,l2
      LJMP start
      l2:JB half,l3
      LJMP start
      l3:JB quat_3,l4
      LJMP start
      l4:JB full,l5
      LJMP start
      l5:JB spkr_off,l6
      LJMP start
      l6:JB spkr_on,l7
      LJMP start
      l7: clr spkr_on
      sjmp next6

EMPTY: mov dptr,#m1
v1:   clr a
      movc a,@a+dptr
      acall data1
      acall delay
      inc dptr
      jz v2
      sjmp v1    
v2:   ret

MOTOR_ON: mov dptr,#m6
fs1: clr a
      movc a,@a+dptr
      acall data1
      acall delay
      inc dptr
      jz fs2
      sjmp fs1
fs2:  ret

quarter: mov dptr,#m2
 q1: clr a
      movc a,@a+dptr
      acall data1
      acall delay
      inc dptr
      jz q2
      sjmp q1
q2:   ret

half_fill: mov dptr,#m3
h1: clr a
      movc a,@a+dptr
      acall data1
      acall delay
      inc dptr
      jz h2
      sjmp h1
h2:   ret

three_four_full: mov dptr,#m4
aa1: clr a
      movc a,@a+dptr
      acall data1
      acall delay
      inc dptr
      jz tf2
      sjmp aa1
tf2:  ret

full_fill: mov dptr,#m5
f1:   clr a
      movc a,@a+dptr
      acall data1
      acall delay
      inc dptr
      jz f2
      sjmp f1
f2:   ret

delay: mov r0,#0ffh
d1: mov r1,#08h
d2: djnz r1,d2
    djnz r0,d1
    ret
    
display: mov a,#80h
	 acall cmd
	 mov a,#38h
	 acall cmd
	 mov a,#0eh
	 acall cmd
	 mov a,#01h
	 acall cmd
ret

cmd:  acall delay
	mov p2,a
	clr rs
	clr rw
	setb en
	acall delay
	clr en
ret

data1: acall delay
      mov p2,a
      setb rs
      clr rw
      setb en
      acall delay
      clr en
ret

org 400h
m1: db "TANK EMPTY",0
m2: db "25%FILLED",0
m3: db "50%FILLED",0
m4: db "75%FILLED",0
m5: db "100% FILLED",0
m6: db "0% FILLED",0
end