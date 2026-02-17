.PHONY: all model13all eaca80all model14all model3all clean

all: model13all model12  eaca80all model14all model3all model34all

model13all: model13 model13f model13p
eaca80all: eaca80 eaca80f eaca80p model14eaca
model14all: model14 model14eaca
model3all: model3 model3p model3f model3p50 model3f50 model3frehd
model34all: model34 model3450

Z80ASM=z88dk-z80asm -b -l -g

model13:
	@echo "Generating Model 1 - Rev 1.3"
	@${Z80ASM} -oMDL1REV3.bin MDL1LEV2.Z80
	@echo "Verifying* Model 1 - Rev 1.3"
	@diff MDL1REV3.bin ./test-roms/M1L2_1.3.bin
model13f:
	@echo "Generating Model 1 - Rev 1.3 (FreHD Patched)"
	@${Z80ASM} -DFREHDBT -DPATCH -oMDL1REV3F.bin MDL1LEV2.Z80
model13p:
	@echo "Generating Model 1 - Rev 1.3 (Patched)"
	@${Z80ASM} -DPATCH -oMDL1REV3P.bin MDL1LEV2.Z80

model12:
	@echo "Generating Model 1 - Rev 1.2"
	@${Z80ASM} -DVER12 -oMDL1REV2.bin MDL1LEV2.Z80
	@echo "Verifying* Model 1 - Rev 1.2"
	@diff MDL1REV2.bin ./test-roms/M1L2_1.2.bin

eaca80:
	@echo "Generating EACA80"
	@${Z80ASM} -DEACA80 -DVER12 -oEACA80.bin MDL1LEV2.Z80
	@echo "Verifying* EACA80"
	@diff EACA80.bin ./test-roms/system80_original.rom
eaca80f:
	@echo "Generating EACA80 (FreHD Patched)"
	@${Z80ASM} -DEACA80 -DFREHDBT -DPATCH -oEACA80F.bin MDL1LEV2.Z80
eaca80p:
	@echo "Generating EACA80 (Patched)"
	@${Z80ASM} -DEACA80 -DPATCH -oEACA80P.bin MDL1LEV2.Z80

model14:
	@echo "Generating Model 1 - Rev 1.4"
	@${Z80ASM} -oMDL1REV4.bin MDL1REV4.Z80
model14eaca:
	@echo "Generating Model 1 - Rev 1.4 (EACA80)"
	@${Z80ASM} -DEACA80 -oMDL1REV4EACA.bin MDL1REV4.Z80

model3:
	@echo "Generating Model 3 - Rev 1.3"
	@${Z80ASM} -oMDL3.bin MDL3LEV2.Z80
	@echo "Verifying* Model 3 - Rev 1.3"
	@diff MDL3.bin ./test-roms/Model3-RevC-2EF8.bin
model3f:
	@echo "Generating Model 3 - Rev 1.3 (FreHD Patched)"
	@${Z80ASM} -DPATCH -DFREHDBT -oMDL3F.bin MDL3LEV2.Z80
model3p:
	@echo "Generating Model 3 - Rev 1.3 (Patched)"
	@${Z80ASM} -DPATCH -oMDL3P.bin MDL3LEV2.Z80
model3f50:
	@echo "Generating Model 3 - Rev 1.3 50Hz (FreHD Patched)"
	@${Z80ASM} -DVIDEO50 -DPATCH -DFREHDBT -oMDL3F50.bin MDL3LEV2.Z80
model3p50:
	@echo "Generating Model 3 - Rev 1.3 50Hz (Patched)"
	@${Z80ASM} -DVIDEO50 -DPATCH -oMDL3P50.bin MDL3LEV2.Z80

# This one is NOT part of DISTRIBUTION, it is used to test
# binary compatibility with the (official) Model 3
# FreHD ROM, (test rom) included with commercial products
model3frehd:
	@echo "Generating Model 3 - Rev 1.3 (FreHD)"
	@${Z80ASM} -DFREHDBT -oMDL3LEV2F.bin MDL3LEV2.Z80
	@echo "Verifying* Model 3 - Rev 1.3 (FreHD)"
	@diff MDL3LEV2F.bin ./test-roms/Model3-RevC-FreHD.bin
	@rm MDL3LEV2F.*

model34:
	@echo "Generating Model 3 - Rev 1.4"
	@${Z80ASM} -oMDL3REV4.bin MDL3REV4.Z80
model3450:
	@echo "Generating Model 3 - Rev 1.4 (50Hz)"
	@${Z80ASM} -DVIDEO50 -oMDL3REV450.bin MDL3REV4.Z80

clean:
	@rm -f *.bin *.def *.lis *.map *.o *.sym
