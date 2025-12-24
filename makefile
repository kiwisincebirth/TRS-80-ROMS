.PHONY: all clean

all: MDL1LEV2 MDL1REV4

Z80ASM=z88dk-z80asm -b -l -g

MDL1LEV2:
	@echo "Generating MDL1LEV2"
	@${Z80ASM} MDL1LEV2.Z80
MDL1REV4:
	@echo "Generating MDL1REV4"
	@${Z80ASM} MDL1REV4.Z80
MDL3LEV2:
	@echo "Generating MDL3LEV2"
	@${Z80ASM} MDL3LEV2.Z80

clean:
	@rm -f *.bin *.def *.lis *.map *.o *.sym
