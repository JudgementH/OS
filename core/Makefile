TOOLPATH = ../tools/
MAKE     = $(TOOLPATH)make.exe -r
NASK     = $(TOOLPATH)nask.exe
EDIMG    = $(TOOLPATH)edimg.exe
IMGTOL   = $(TOOLPATH)imgtol.com
FDIMG0AT = $(TOOLPATH)fdimg0at.tek
COPY     = copy
DEL      = del

# 默认

default :
	$(MAKE) img

# 文件生成

ipl.bin : ipl.nas Makefile
	$(NASK) ipl.nas ipl.bin ipl.lst
	
os.sys : os.nas	Makefile
	$(NASK)	os.nas os.sys os.lst

os.img : ipl.bin os.sys Makefile
	$(EDIMG)   imgin:$(FDIMG0AT) \
		wbinimg src:ipl.bin len:512 from:0 to:0 \
		copy from:os.sys to:@: \
		imgout:os.img

# 批处理

asm :
	$(MAKE) ipl.bin

img :
	$(MAKE) os.img

run :
	$(MAKE) img
	$(COPY) os.img ..\tools\qemu\fdimage0.bin
	$(MAKE) -C ../tools/qemu

install :
	$(MAKE) img
	$(IMGTOL) w a: os.img

clean :
	-$(DEL) ipl.bin
	-$(DEL) ipl.lst
	-$(DEL) os.sys
	-$(DEL) os.lst

src_only :
	$(MAKE) clean
	-$(DEL) os.img

