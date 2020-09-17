; haribote-ipl
; TAB=4

CYLS	EQU		10				; #define CYLS 10

		ORG		0x7c00			; 启动装载程序

; 以下记述用于标准FAT12格式软盘

		JMP		entry
		DB		0x90
		DB		"HARIBOTE"		; 磁盘名称（可以是任意字符串）
		DW		512				; 每个扇区的大小（必须是512）
		DB		1				; 簇的大小（必须为一个扇区）
		DW		1				; FAT12的起始位置（一般从第一个扇区开始
		DB		2				; FAT的个数（必须为2）
		DW		224				; 根目录的大小（一般设成224项）
		DW		2880			; 该磁盘的大小（必须是2880扇区）
		DB		0xf0			; 该磁盘的种类（必须是0xf0
		DW		9				; FAt的长度（必须是9扇区）
		DW		18				; 一个磁道有几个扇区（必须是18）
		DW		2				; 磁头数（必须是2）
		DD		0				; 不使用分区，必须是0
		DD		2880			; 磁盘大小
		DB		0,0,0x29		; 意义不明固定
		DD		0xffffffff		; （可能是）卷标号码
		DB		"HARIBOTEOS "	; 磁盘的名称（11字节）
		DB		"FAT12   "		; 磁盘格式名称（8字节）
		RESB	18				; 先空出18字节

; 程序主体

entry:
		MOV		AX,0			; 初始化寄存器
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX

; 坊磁盘

		MOV		AX,0x0820
		MOV		ES,AX
		MOV		CH,0			; 柱面 0
		MOV		DH,0			; 磁头 0
		MOV		CL,2			; 扇区 2
readloop:
		MOV		SI,0			; 记录失败次数的寄存器
retry:
		MOV		AH,0x02			; AH=0x02 : 读入磁盘
		MOV		AL,1			; 1 个扇区
		MOV		BX,0
		MOV		DL,0x00			; A 驱动器
		INT		0x13			; 调用磁盘BIOS
		JNC		next			; 没出错时跳转到next
		ADD		SI,1			; SI 加 1
		CMP		SI,5			; 比较 SI 与 5
		JAE		error			; SI >= 5 时，跳转到error
		MOV		AH,0x00
		MOV		DL,0x00			; A 驱动器
		INT		0x13			; 重置驱动器
		JMP		retry
next:
		MOV		AX,ES			; 把内存地址后移0x200
		ADD		AX,0x0020
		MOV		ES,AX			; 因为没有 ADD ES,0x020 指令，所以这里稍微绕个弯
		ADD		CL,1			; CL 加 1
		CMP		CL,18			; 比较 CL 与 18
		JBE		readloop		; 如果 CL <= 18，则跳转至readloop 
		MOV		CL,1
		ADD		DH,1
		CMP		DH,2
		JB		readloop		; 如果 DH < 2， 则跳转到readloop
		MOV		DH,0
		ADD		CH,1
		CMP		CH,CYLS
		JB		readloop		; 如果 CH < CYLS，则跳转至readloop

; 虽然读完了，但是因为暂时没有要做的事所以停止等待指令

		
		MOV		[0x0ff0],CH		; IPLがどこまで読んだのかをメモ
		JMP		0xc200

fin:
		HLT						; 让CPu停止，等待指令
		JMP		fin				; 无限循环

error:
		MOV		SI,msg
putloop:
		MOV		AL,[SI]
		ADD		SI,1			; SI 加 1
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e			; 显示一个文字
		MOV		BX,15			; 指定字符颜色
		INT		0x10			; 调用显卡BIOS
		JMP		putloop
msg:
		DB		0x0a, 0x0a		; 换行两次
		DB		"load error"
		DB		0x0a			; 换行
		DB		0

		RESB	0x7dfe-$		; 重复0x00一直到0x7dfe

		DB		0x55, 0xaa
	