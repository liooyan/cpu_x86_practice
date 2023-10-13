
CC_i686 := gcc -m32
AS_i686 := as -m32

CC_x86_64 := gcc
AS_x86_64 := as

## debug
DEBUG = -g3
O := -Og
W := -Wall -Wextra -Wno-unknown-pragmas
CFLAGS := -std=gnu99 -ffreestanding $(O) $(W)  $(DEBUG)
LDFLAGS := -ffreestanding $(O) -nostdlib -lgcc $(DEBUG)

PROJECT_NAME = cpu_x86

INCLUDES_DIR := includes
INCLUDES  := $(patsubst %, -I%, $(INCLUDES_DIR))

BUILD_DIR := build
OBJECT_DIR := ${BUILD_DIR}/obj
TARGET_DIR := ${BUILD_DIR}/target


ISO_DIR := ${BUILD_DIR}/iso
ISO_BOOT_DIR := ${ISO_DIR}/boot
ISO_GRUB_DIR := ${ISO_BOOT_DIR}/grub


SCAN_SRC_DIR = $(shell find $(1) -name "*.[cS]")
SRC :=  $(patsubst ./%, $(OBJECT_DIR)/%_i686.o, $(call SCAN_SRC_DIR))


$(OBJECT_DIR)/%.S_i686.o: %.S
	@mkdir -p $(@D)
	$(CC_i686)    $(INCLUDES)   -c $< -o $@ $(CFLAGS)

$(OBJECT_DIR)/%.c_i686.o: %.c
	@mkdir -p $(@D)
	$(CC_i686)    $(INCLUDES)    -c $< -o $@ $(CFLAGS)

$(OBJECT_DIR):
	@mkdir -p $(OBJECT_DIR)

$(TARGET_DIR):
	@mkdir -p $(TARGET_DIR)



all :  $(OBJECT_DIR) $(TARGET_DIR) $(PROJECT_NAME)

$(TARGET_DIR)/setup.elf : ${SRC}
	@echo " LINK: $(TARGET_DIR)/setup.elf"
	$(CC_i686)  -T boot/setup.ld  -o $(TARGET_DIR)/setup.elf ${SRC} $(LDFLAGS)

# 使用grub打包
$(PROJECT_NAME) :  $(TARGET_DIR)/setup.elf
	@mkdir -p $(ISO_GRUB_DIR)
	@cp GRUB_TEMPLATE  $(ISO_GRUB_DIR)/grub.cfg
	@cp $(TARGET_DIR)/setup.elf $(ISO_BOOT_DIR)
	@grub-mkrescue -o $(ISO_DIR)/$(PROJECT_NAME).iso $(ISO_DIR)


clean:
	rm -rf ${BUILD_DIR}


qemu-32 :
	@qemu-system-i386 -cdrom $(ISO_DIR)/$(PROJECT_NAME).iso   -s -S -nographic