
# デフォルト動作

default :
	../tools/make.exe img

# ファイル生成規則

ipl.bin : ipl.nas Makefile
	../tools/nask.exe ipl.nas ipl.bin ipl.lst

helloos.img : ipl.bin Makefile
	../tools/edimg.exe   imgin:../tools/fdimg0at.tek \
		wbinimg src:ipl.bin len:512 from:0 to:0   imgout:helloos.img

# コマンド

asm :
	../tools/make.exe -r ipl.bin

img :
	../tools/make.exe -r helloos.img

run :
	../tools/make.exe img
	copy helloos.img ..\tools\qemu\fdimage0.bin
	../tools/make.exe -C ../tools/qemu

install :
	../tools/make.exe img
	../tools/imgtol.com w a: helloos.img

clean :
	-del ipl.bin
	-del ipl.lst

src_only :
	../tools/make.exe clean
	-del helloos.img
