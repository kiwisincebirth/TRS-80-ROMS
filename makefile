.PHONY: all clean

all: MDL1REV2 MDL1LEV2 MDL1REV4 MDL3LEV2

Z80ASM=z88dk-z80asm -b -l -g

MDL1REV2:
	@echo "Generating MDL1LEV2-REV12"
	@${Z80ASM} -DVER12 -oMDL1REV2.bin MDL1LEV2.Z80
	@echo "Verifying MDL1LEV2-REV12"
	@diff MDL1REV2.bin ./test-roms/M1L2_1.2.bin
MDL1LEV2:
	@echo "Generating MDL1LEV2"
	@${Z80ASM} -DVER13 -oMDL1LEV2.bin MDL1LEV2.Z80
	@echo "Verifying MDL1LEV2"
	@diff MDL1LEV2.bin ./test-roms/M1L2_1.3.bin
MDL1REV4:
	@echo "Generating MDL1LEV2-REV14"
	@${Z80ASM} MDL1REV4.Z80
MDL3LEV2:
	@echo "Generating MDL3LEV2"
	@${Z80ASM} MDL3LEV2.Z80
	@echo "Verifying MDL3LEV2"
	@diff MDL3LEV2.bin ./test-roms/Model3-RevB-2EF8.bin

clean:
	@rm -f *.bin *.def *.lis *.map *.o *.sym
