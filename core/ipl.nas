; hello-os
		ORG		0x7c00			; 程序装载到 0x7c00

; 针对FAT12软盘

		JMP		entry
		DB		0x90
		DB		"HELLOIPL"		; 启动区名称（8 word）
		DW		512				; 扇区大小，必须是512
		DB		1				; 簇（cluster）的大小（必须1扇区）
		DW		1				; FAT起始位置，从第一个扇区开始
		DB		2				; FAT格数
		DW		224				; 根目录大小一般为224
		DW		2880			; 磁盘大小必须是2880
		DB		0xf0			; 磁盘种类 必须0xf0
		DW		9				; FAT长度，必须9扇区
		DW		18				; 1个磁道，有几个扇区，必须18
		DW		2				; 磁头数，必须是2
		DD		0				; 不分区，必须是0
		DD		2880			; 重写磁盘大小
		DB		0,0,0x29		; 意义不明，固定
		DD		0xffffffff		; 意义不明
		DB		"HELLO-OS   "	; 磁盘名称（11 word）
		DB		"FAT12   "		; 磁盘格式名称（8 B）
		RESB	18				; 空出18 B

; 程序主体

entry:
		MOV		AX,0			; レジスタ初期化
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX

; ディスクを読む

		MOV		AX,0x0820
		MOV		ES,AX
		MOV		CH,0			; シリンダ0
		MOV		DH,0			; ヘッド0
		MOV		CL,2			; セクタ2

		MOV		AH,0x02			; AH=0x02 : ディスク読み込み
		MOV		AL,1			; 1セクタ
		MOV		BX,0
		MOV		DL,0x00			; Aドライブ
		INT		0x13			; ディスクBIOS呼び出し
		JC		error
		
putloop:
		MOV		AL,[SI]
		ADD		SI,1			; SI‚É1‚ð‘«‚·
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e			; 显示文字
		MOV		BX,15			; 指定字符颜色
		INT		0x10			; 调用显卡
		JMP		putloop
		
		
fin:
		HLT						; CPU休息
		JMP		fin				; 无限循环

error:
		MOV		SI,msg

msg:
		DB		0x0a, 0x0a		; 换行两次
		DB		"hello, world"
		DB		0x0a			; 换行
		DB		0

		RESB	0x7dfe-$		; 

		DB		0x55, 0xaa
		