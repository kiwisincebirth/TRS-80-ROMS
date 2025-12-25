.PHONY: all model1 clean

all: model1 model3
model1: model12 model13 model14

Z80ASM=z88dk-z80asm -b -l -g

model12:
	@echo "Generating Model 1 Level 2 - Rev 1.2"
	@${Z80ASM} -DVER12 -oMDL1REV2.bin MDL1LEV2.Z80
	@echo "Verifying* Model 1 Level 2 - Rev 1.2"
	@diff MDL1REV2.bin ./test-roms/M1L2_1.2.bin
model13:
	@echo "Generating Model 1 Level 2 - Rev 1.3"
	@${Z80ASM} MDL1LEV2.Z80
	@echo "Verifying* Model 1 Level 2 - Rev 1.3"
	@diff MDL1LEV2.bin ./test-roms/M1L2_1.3.bin
model14:
	@echo "Generating Model 1 Level 2 - Rev 1.4"
	@${Z80ASM} MDL1REV4.Z80
model3:
	@echo "Generating Model 3 Level 2"
	@${Z80ASM} MDL3LEV2.Z80
	@echo "Verifying* Model 3 Level 2"
	@diff MDL3LEV2.bin ./test-roms/Model3-RevB-2EF8.bin

clean:
	@rm -f *.bin *.def *.lis *.map *.o *.sym
