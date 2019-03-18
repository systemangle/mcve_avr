
ELF_NAME := mcve

TOOLCHAIN 		:= /home/user/arduino/hardware/tools/avr/bin

WORKING_DIR 		:= $(dir $(abspath $(lastword $(MAKEFILE_LIST))) )
OUT_DIR			:= $(WORKING_DIR)build
OUT_PRE_DIR		:= $(OUT_DIR)/preproc
CORE_OUT_DIR		:= $(OUT_DIR)/core
INC_DIR			:= $(WORKING_DIR)$(ELF_NAME)/$(ELF_NAME)/inc
SRC_DIR			:= $(WORKING_DIR)$(ELF_NAME)/$(ELF_NAME)/src
CORE_INC_DIR		:= $(WORKING_DIR)$(ELF_NAME)/$(ELF_NAME)/inc/core
CORE_SRC_DIR		:= $(WORKING_DIR)$(ELF_NAME)/$(ELF_NAME)/src/core
MCU_SPEC		:= $(WORKING_DIR)$(ELF_NAME)/mcu_spec/standard

INC			:= -I$(CORE_INC_DIR) -I$(MCU_SPEC) 

PRE_PROS 		:= -DF_CPU=16000000L -DARDUINO=10808 -DARDUINO_AVR_UNO			\
					-DARDUINO_ARCH_AVR 

ASM_FLAGS		:= -c -g -x assembler-with-cpp -flto -MMD -mmcu=atmega328p 		\
					$(PRE_PROS) $(INC)

COMMON_FLAGS 	:= -c -g -Os -w -ffunction-sections -fdata-sections	-flto  		\
					-mmcu=atmega328p $(PRE_PROS) $(INC)

C_FLAGS			:=   -std=gnu11 -fno-fat-lto-objects -MMD $(COMMON_FLAGS)

CXX_FLAGS		:=  -std=gnu++11 -fpermissive -fno-exceptions -MMD				\
					-fno-threadsafe-statics -Wno-error=narrowing 				\
					$(COMMON_FLAGS)

CXX_PRE_FLAGS	:= -std=gnu++11 -fpermissive -fno-exceptions 					\
				   -fno-threadsafe-statics -Wno-error=narrowing 				\
				   -x c++ -E -CC $(COMMON_FLAGS)

vpath %.elf 	$(OUT_DIR)
vpath %.hex 	$(OUT_DIR)
vpath %.dl  	$(OUT_DIR)
vpath %.ctag  	$(OUT_PRE_DIR)
vpath %.o 	$(OUT_DIR) $(CORE_OUT_DIR)
vpath %.a 	$(CORE_OUT_DIR)

all: build $(ELF_NAME).siz

$(ELF_NAME).siz: $(ELF_NAME).hex
	$(TOOLCHAIN)/avr-size -A $(OUT_DIR)/$(ELF_NAME).elf

$(ELF_NAME).hex: $(ELF_NAME).elf
	$(TOOLCHAIN)/avr-objcopy -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load 		\
								--no-change-warnings --change-section-lma 					\
								.eeprom=0 $(OUT_DIR)/$(ELF_NAME).elf 						\
								$(OUT_DIR)/$(ELF_NAME).eep

	$(TOOLCHAIN)/avr-objcopy -O ihex -R .eeprom $(OUT_DIR)/$(ELF_NAME).elf 					\
								$(OUT_DIR)/$(ELF_NAME).hex

$(ELF_NAME).elf: core.a $(ELF_NAME).cpp.o 
	@echo Linking everything together...
	$(TOOLCHAIN)/avr-gcc -w -Os -g -flto -fuse-linker-plugin -Wl,--gc-sections -mmcu=atmega328p	\
				-L$(OUT_DIR) -lm -o $(OUT_DIR)/$(ELF_NAME).elf 				\
				$(OUT_DIR)/$(ELF_NAME).cpp.o $(CORE_OUT_DIR)/core.a 			\
							

core.a: CDC.cpp.o HardwareSerial.cpp.o HardwareSerial0.cpp.o HardwareSerial1.cpp.o 			\
		HardwareSerial2.cpp.o HardwareSerial3.cpp.o IPAddress.cpp.o PluggableUSB.cpp.o 		\
		Print.cpp.o Stream.cpp.o Tone.cpp.o USBCore.cpp.o WInterrupts.c.o WMath.cpp.o 		\
		WString.cpp.o abi.cpp.o hooks.c.o main.cpp.o new.cpp.o wiring.c.o wiring_analog.c.o	\
		wiring_digital.c.o wiring_pulse.S.o wiring_pulse.c.o wiring_shift.c.o

	$(TOOLCHAIN)/avr-gcc-ar rcs $(CORE_OUT_DIR)/$@ $(addprefix $(CORE_OUT_DIR)/, $^)

%.cpp.o: $(CORE_SRC_DIR)/%.cpp
	$(TOOLCHAIN)/avr-g++ $(CXX_FLAGS) $< -o $(CORE_OUT_DIR)/$*.cpp.o			

%.c.o: $(CORE_SRC_DIR)/%.c
	$(TOOLCHAIN)/avr-gcc $(C_FLAGS)  $< -o $(CORE_OUT_DIR)/$*.c.o

%.S.o: $(CORE_SRC_DIR)/%.S
	$(TOOLCHAIN)/avr-gcc $(ASM_FLAGS) $< -o $(CORE_OUT_DIR)/$*.S.o

$(ELF_NAME).cpp.o: $(SRC_DIR)/$(ELF_NAME).cpp
	@echo Compiling sketch...
	$(TOOLCHAIN)/avr-g++ $(CXX_FLAGS) $(SRC_DIR)/$(ELF_NAME).cpp -o $(OUT_DIR)/$(ELF_NAME).cpp.o

burn: $(ELF_NAME).hex
	avrdude -C/etc/avrdude.conf -v -patmega328p -carduino -P/dev/ttyACM0 -b115200 -D -Uflash:w:$(OUT_DIR)/$(ELF_NAME).hex:i
	
build:
	mkdir -p build/{core,preproc}

clean:
	rm -R -f build
