; naskfunc
; TAB=4

[FORMAT "WCOFF"]
[INSTRSET "i486p"]	
[BITS 32]

[FILE "naskfunc.nas"]

		GLOBAL	_io_hlt,_write_mem8
	

[SECTION .text]

_io_hlt:	; void io_hlt(void);
		HLT
		RET
		
_write_mem8:	; void write_mem8(int addr, int data);
		MOV		ECX,[ESP+4]		; [ESP+4]是第一个参数addr
		MOV		AL,[ESP+8]		; [ESP+8]是第二个参数data
		MOV		[ECX],AL
		RET