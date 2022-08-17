.data
input1: .asciiz "\nNhap tung chu so cua thua so 1: "
input2: .asciiz "\nNhap tung chu so cua thua so 2: "
input3: .asciiz "\nNhap phep tinh (a = cong, b = tru, c = nhan, d = chia): "
input: .asciiz "Ban co muon nhap tiep khong? (neu khong thi nhan 0, muon nhap tiep thi nhan bat ki de tiep tuc):"
output1: .asciiz "Thua so thu nhat cua ban la: "
output2: .asciiz "Thua so thu hai cua ban la: "
output3: .asciiz "Ket qua cua ban la: "
output4: .asciiz "\nNhan f de hien thi ket qua: "
tryagain: .asciiz "Nhap sai roi, hay nhap lai theo dung cu phap"
tryagain1: .asciiz "\nNeu thuc hien phep chia thi thua so thu 2 phai khac 0, hay nhap lai!"
pheptinh: .space 100
.eqv SEVENSEG_LEFT 0xFFFF0011 #Dia chi cua den led 7 doan trai.
.eqv SEVENSEG_RIGHT 0xFFFF0010 #Dia chi cua den led 7 doan phai.
.text
begin: #ban dau cho so bang 00
	li $t2, 63 
	jal SHOW_7SEG_LEFT 
	nop
	li $t8, 63
	jal SHOW_7SEG_RIGHT 
	nop
	addi $t1, $t1, 0 #t1 luu gia tri thua so thu 1
	addi $t4, $t4, 0 #t4 luu gia tri cua thua so thu 2
#thua so thu nhat
main:	
	li $v0, 4 #yeu cau nguoi dung nhap tung chu so cua thua so thu 1
	la $a0, input1
	syscall
	li $v0, 5 #doc gia tri nguoi dung nhap
	syscall
	add $t9, $v0, 0 #t9 = v0 = gia tri cua chu so nguoi dung vua nhap
	add $t7, $t7, 9 #cho t7 = 9
	blt $t7, $t9, again #de kiem tra xem chu so nguoi dung vua nhap co dung khong, neu >9 thi yeu cau nhap lai
	mul $t1, $t1, 10 #t1 = 10*t1 + t9 = gia tri cua thua so thu 1 
	add $t1, $t1, $t9
	j loopright #neu <9 thi nhay toi loopright
again:
	li $v0, 4 #yeu cau nhap lai
	la $a0, tryagain
	syscall
	j main

SHOW_7SEG_LEFT: #bat tat led 7 segment
	li $t0, SEVENSEG_LEFT #load dia chi cua den led 7 doan trai
	sb $t2, 0($t0) #cap nhat gia tri
	nop
	jr $ra #copy nd thanh ghi $ra (dang chua dia chi tro ve) tra lai cho bo dem chuong trinh pc
	nop

SHOW_7SEG_RIGHT: 
	li $t0, SEVENSEG_RIGHT #load dia chi cua den led 7 doan phai
	sb $t8, 0($t0) #cap nhat gia tri
	nop
	jr $ra  #copy nd thanh ghi $ra (dang chua dia chi tro ve) tra lai cho bo dem chuong trinh pc
	nop
 #so sanh t9 voi cac so de hien thi tren led
loopright:
	beq $t9, 0 , caseright_0 #t9 = 0 thi nhay toi case = 0, tuong tu voi nhung cai duoi
	beq $t9, 1 , caseright_1 
	beq $t9, 2 , caseright_2 
	beq $t9, 3 , caseright_3 
	beq $t9, 4 , caseright_4 
	beq $t9, 5 , caseright_5 
	beq $t9, 6 , caseright_6 
	beq $t9, 7 , caseright_7 
	beq $t9, 8 , caseright_8 
	beq $t9, 9 , caseright_9
	j continute
caseright_0: 
	li $t8, 63 # 63 = 0111111 (tuong ung voi • g f e d c b a)
	jal SHOW_7SEG_RIGHT 
	j continute #nhay toi continute de hoi nguoi dung muon nhap chu so tiep theo khong
#nhung truong hop ben duoi tuong tu
caseright_1:
	li $t8, 6 #6 = 0110
	jal SHOW_7SEG_RIGHT 
	j continute
caseright_2:
	li $t8, 91 #91 = 1011011
	jal SHOW_7SEG_RIGHT 
	j continute
caseright_3:
	li $t8, 79 #79 = 10011111
	jal SHOW_7SEG_RIGHT 
	j continute
caseright_4:
	li $t8, 102 #102 = 1100110
	jal SHOW_7SEG_RIGHT 
	j continute
caseright_5:
	li $t8, 109 #109 = 1101101
	jal SHOW_7SEG_RIGHT
	j continute
caseright_6:
	li $t8, 125 #125 = 1111101
	jal SHOW_7SEG_RIGHT 
	j continute
caseright_7:
	li $t8, 7 #7 = 0111
	jal SHOW_7SEG_RIGHT 
	j continute
caseright_8:
	li $t8, 127 #127 = 1111111
	jal SHOW_7SEG_RIGHT 
	j continute
caseright_9:
	li $t8, 111 #1101111
	jal SHOW_7SEG_RIGHT 
	j continute		

continute:
	li $v0, 4
	la $a0, input #hoi nguoi dung co muon nhap tiep khong
	syscall
	li $v0, 12 #doc gia tri nguoi dung nhap
	syscall
	bne $v0, '0', continute1 #neu nguoi dung nhap so 0 thi dung lai, nhap so bat ki thi tiep tuc
	j number1 #in ra thua so thu 1 nguoi dung vua nhap de nguoi dung nho
continute1:
	move $t2, $t9 #copy gia tri hang don vi vua nhap vao hang chuc (t2 luu gia tri hang chuc)
	nop
	li $t8, 63 #0111111
	jal SHOW_7SEG_RIGHT 
loopleft: #so sanh t2 voi cac so
	beq $t2, 0 , caseleft_0
	beq $t2, 1 , caseleft_1	
	beq $t2, 2 , caseleft_2	
	beq $t2, 3 , caseleft_3	
	beq $t2, 4 , caseleft_4
	beq $t2, 5 , caseleft_5	
	beq $t2, 6, caseleft_6	
	beq $t2, 7 , caseleft_7	
	beq $t2, 8 , caseleft_8	
	beq $t2, 9 , caseleft_9	

caseleft_0:
	li $t2, 63 # 63 = 0111111
	jal SHOW_7SEG_LEFT
	j main #nhay toi main de nhap lai so hang don vi
caseleft_1:
	li $t2, 6 #6 = 0110
	jal SHOW_7SEG_LEFT 
	j main
caseleft_2:
	li $t2, 91 #91 = 1011011
	jal SHOW_7SEG_LEFT
	j main
caseleft_3:
	li $t2, 79 #79 = 10011111
	jal SHOW_7SEG_LEFT
	j main
caseleft_4:
	li $t2, 102 #102 = 1100110
	jal SHOW_7SEG_LEFT
	j main
caseleft_5:
	li $t2, 109 #109 = 1101101
	jal SHOW_7SEG_LEFT
	j main
caseleft_6:
	li $t2, 125 #125 = 1111101
	jal SHOW_7SEG_LEFT
	j main
caseleft_7:
	li $t2, 7 #7 = 0111
	jal SHOW_7SEG_LEFT
	j main
caseleft_8:
	li $t2, 127 #127 = 1111111
	jal SHOW_7SEG_LEFT
	j main
caseleft_9:
	li $t2, 111 #1101111
	jal SHOW_7SEG_LEFT
	j main

number1:
	li $v0, 56
	la $a0, output1 #in ra thua so thu 1
	la $a1, ($t1)
	syscall
	li $t2, 63
	jal SHOW_7SEG_LEFT #cap nhat lai den led de chuyen sang nhap thua so thu 2(chuyen ve 00)
	nop
	li $t8, 63
	jal SHOW_7SEG_RIGHT 
	nop


#thua so thu 2 (tuong tu voi thua so 1)
main2:	
	li $v0, 4
	la $a0, input2
	syscall
	li $v0, 5
	syscall
	add $t6, $v0, 0
	li $t7, 9
	blt $t7, $t6, again2 
	mul $t4, $t4, 10
	add $t4, $t4, $t6 
	j loopright2
again2:
	li $v0, 4
	la $a0, tryagain
	syscall
	j main2
	
SHOW_7SEG_LEFT2: 
	li $t0, SEVENSEG_LEFT 
	sb $t3, 0($t0) 
	nop
	jr $ra
	nop

SHOW_7SEG_RIGHT2: 
	li $t0, SEVENSEG_RIGHT 
	sb $t5, 0($t0) 
	nop
	jr $ra 
	nop

loopright2:
	beq $t6, 0 , caseright2_0
	beq $t6, 1 , caseright2_1 
	beq $t6, 2 , caseright2_2 
	beq $t6, 3 , caseright2_3 
	beq $t6, 4 , caseright2_4 
	beq $t6, 5 , caseright2_5 
	beq $t6, 6 , caseright2_6 
	beq $t6, 7 , caseright2_7 
	beq $t6, 8 , caseright2_8 
	beq $t6, 9 , caseright2_9
	j continute
caseright2_0:
	li $t5, 63 # 63 = 0111111
	jal SHOW_7SEG_RIGHT2
	j continute2
caseright2_1:
	li $t5, 6 #6 = 0110
	jal SHOW_7SEG_RIGHT2 
	j continute2
caseright2_2:
	li $t5, 91 #91 = 1011011
	jal SHOW_7SEG_RIGHT2 
	j continute2
caseright2_3:
	li $t5, 79 #79 = 10011111
	jal SHOW_7SEG_RIGHT2 
	j continute2
caseright2_4:
	li $t5, 102 #102 = 1100110
	jal SHOW_7SEG_RIGHT2 
	j continute2
caseright2_5:
	li $t5, 109 #109 = 1101101
	jal SHOW_7SEG_RIGHT2
	j continute2
caseright2_6:
	li $t5, 125 #125 = 1111101
	jal SHOW_7SEG_RIGHT2 
	j continute2
caseright2_7:
	li $t5, 7 #7 = 0111
	jal SHOW_7SEG_RIGHT2
	j continute2
caseright2_8:
	li $t5, 127 #127 = 1111111
	jal SHOW_7SEG_RIGHT2 
	j continute2
caseright2_9:
	li $t5, 111 #1101111
	jal SHOW_7SEG_RIGHT2 
	j continute2		

continute2:
	li $v0, 4
	la $a0, input
	syscall
	li $v0, 12
	syscall
	bne $v0, '0', continute3
	j number2
continute3:
	move $t3, $t6
	nop
	li $t5, 63 #0111111
	jal SHOW_7SEG_RIGHT2
loopleft2: 
	beq $t3, 0 , caseleft2_0
	beq $t3, 1 , caseleft2_1	
	beq $t3, 2 , caseleft2_2	
	beq $t3, 3 , caseleft2_3	
	beq $t3, 4 , caseleft2_4
	beq $t3, 5 , caseleft2_5	
	beq $t3, 6, caseleft2_6	
	beq $t3, 7 , caseleft2_7	
	beq $t3, 8 , caseleft2_8	
	beq $t3, 9 , caseleft2_9	

caseleft2_0:
	li $t3, 63 # 63 = 0111111
	jal SHOW_7SEG_LEFT2
	j main2
caseleft2_1:
	li $t3, 6 #6 = 0110
	jal SHOW_7SEG_LEFT2 
	j main2
caseleft2_2:
	li $t3, 91 #91 = 1011011
	jal SHOW_7SEG_LEFT2
	j main2
caseleft2_3:
	li $t3, 79 #79 = 10011111
	jal SHOW_7SEG_LEFT2
	j main2
caseleft2_4:
	li $t3, 102 #102 = 1100110
	jal SHOW_7SEG_LEFT2
	j main2
caseleft2_5:
	li $t3, 109 #109 = 1101101
	jal SHOW_7SEG_LEFT2
	j main2
caseleft2_6:
	li $t3, 125 #125 = 1111101
	jal SHOW_7SEG_LEFT2
	j main2
caseleft2_7:
	li $t3, 7 #7 = 0111
	jal SHOW_7SEG_LEFT2
	j main2
caseleft2_8:
	li $t3, 127 #127 = 1111111
	jal SHOW_7SEG_LEFT2
	j main2
caseleft2_9:
	li $t3, 111 #1101111
	jal SHOW_7SEG_LEFT2
	j main2

number2:
	li $v0, 56
	la $a0, output2
	la $a1, ($t4)
	syscall

#nhap phep tinh
tinh:
	li $v0, 4
	la $a0, input3 #yeu cau nguoi dung nhap phep tinh ho mong muon
	syscall
	li $v0, 12 #doc ki tu nguoi dung vua nhap
	syscall 
	beq $v0, 'a' , case1 #so sanh voi cac ki tu a, b, c, d roi jump toi case tuong ung
	beq $v0, 'b' , case2
	beq $v0, 'c' , case3
	beq $v0, 'd' , case4
	j again3 #neu nhap sai dinh dang yeu cau nguoi dung nhap lai
again3: 
	li $v0, 4
	la $a0, tryagain 
	syscall
	j tinh
case1:
	add $s2, $t1, $t4 #s2 = t1 + t4
	j tiep #yeu cau nguoi dung nhap f (tuong ung dau '=' de hien thi ket qua)
case2:
	sub $s2, $t1, $t4 #s2 = t1 - t4
	j tiep
case3:
	mul $s2, $t1, $t4 #s2 = t1 * t4
	j tiep
case4:
	beq $t4, $0, again5
	div $s2, $t1, $t4 #s2 = t1/t4
	j tiep
again5:
	li $v0, 4
	la $a0, tryagain1
	syscall
	j main2
tiep:
	li $v0, 4
	la $a0, output4 #nhap f de hien thi ket qua
	syscall
	li $v0, 12 #doc ki tu nguoi dung
	syscall 
	beq $v0, 'f' , case5
	j again4 #neu nhap sai yeu cau nhap lai
again4:
	li $v0, 4
	la $a0, tryagain
	syscall
	j tiep
case5:
	addi $t7, $0, 0
	addi $t7, $t7, 100
	div $s3, $s2, $t7 #chia cho 100 
	mul $s3, $s3, $t7
	sub $s4, $s2, $s3 #2 so cuoi cua so can tim
 	addi $t7, $0, 0
	addi $t7, $t7, 10
	div $s5, $s4, $t7 #chia 10, day la so hang chuc (ben trai)
	mul $s6, $s5, $t7
	sub $s6, $s4, $s6 #so hang don vi cua 2 chu so cuoi can tim
	j right
right:	#so sanh so hang don vi voi cac so
	beq $s6, 0 , case_0
	beq $s6, 1 , case_1 
	beq $s6, 2 , case_2 
	beq $s6, 3 , case_3 
	beq $s6, 4 , case_4 
	beq $s6, 5 , case_5 
	beq $s6, 6 , case_6 
	beq $s6, 7 , case_7 
	beq $s6, 8 , case_8 
	beq $s6, 9 , case_9

case_0:
	li $a0, 63
	jal SHOW_7SEG_RIGHT3 # show
	j left #jump toi left de hien thi so hang chuc
case_1:
	li $a0, 6
	jal SHOW_7SEG_RIGHT3 # show
	j left
case_2:
	li $a0, 91
	jal SHOW_7SEG_RIGHT3 # show
	j left
case_3:
	li $a0, 79
	jal SHOW_7SEG_RIGHT3 # show
	j left
case_4:
	li $a0, 102
	jal SHOW_7SEG_RIGHT3 # show
	j left
case_5:
	li $a0, 109
	jal SHOW_7SEG_RIGHT3 # show
	j left
case_6:
	li $a0, 125
	jal SHOW_7SEG_RIGHT3 # show
	j left
case_7:
	li $a0, 7
	jal SHOW_7SEG_RIGHT3 # show
	j left
case_8:
	li $a0, 127
	jal SHOW_7SEG_RIGHT3 # show
	j left
case_9:
	li $a0, 111
	jal SHOW_7SEG_RIGHT3 # show
	j left
	
left: #so sanh hang chuc 
	beq $s5, 0 , case2_0
	beq $s5, 1 , case2_1 
	beq $s5, 2 , case2_2 
	beq $s5, 3 , case2_3 
	beq $s5, 4 , case2_4 
	beq $s5, 5 , case2_5 
	beq $s5, 6 , case2_6 
	beq $s5, 7 , case2_7 
	beq $s5, 8 , case2_8 
	beq $s5, 9 , case2_9

case2_0:
	li $a0, 63
	jal SHOW_7SEG_LEFT3 
	j exit #exit de in ra ket qua
case2_1:
	li $a0, 6
	jal SHOW_7SEG_LEFT3 
	j exit
case2_2:
	li $a0, 91
	jal SHOW_7SEG_LEFT3 
	j exit
case2_3:
	li $a0, 79
	jal SHOW_7SEG_LEFT3 
	j exit
case2_4:
	li $a0, 102
	jal SHOW_7SEG_LEFT3 
	j exit
case2_5:
	li $a0, 109
	jal SHOW_7SEG_LEFT3
	j exit
case2_6:
	li $a0, 125
	jal SHOW_7SEG_LEFT3 
	j exit
case2_7:
	li $a0, 7
	jal SHOW_7SEG_LEFT3 
	j exit
case2_8:
	li $a0, 127
	jal SHOW_7SEG_LEFT3 
	j exit
case2_9:
	li $a0, 111
	jal SHOW_7SEG_LEFT3 
	j exit

SHOW_7SEG_RIGHT3: 
	li $t0, SEVENSEG_RIGHT 
	sb $a0, 0($t0) 
	nop
	jr $ra 
	nop
SHOW_7SEG_LEFT3: 
	li $t0, SEVENSEG_LEFT 
	sb $a0, 0($t0) 
	nop
	jr $ra
	nop
	
exit:
	li $v0, 56 #in ket qua
	la $a0, output3
	la $a1, ($s2)
	syscall
	
