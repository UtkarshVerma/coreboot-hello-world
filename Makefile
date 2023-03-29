##
##
## Copyright (C) 2008 Advanced Micro Devices, Inc.
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions
## are met:
## 1. Redistributions of source code must retain the above copyright
##    notice, this list of conditions and the following disclaimer.
## 2. Redistributions in binary form must reproduce the above copyright
##    notice, this list of conditions and the following disclaimer in the
##    documentation and/or other materials provided with the distribution.
## 3. The name of the author may not be used to endorse or promote products
##    derived from this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
## ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
## IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
## ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
## FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
## DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
## OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
## HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
## LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
## OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
## SUCH DAMAGE.
##
.POSIX:

TARGET := hello
SRC_DIR = src
INC_DIR = inc
BUILD_DIR = build
LIBPAYLOAD_DIR = ../libpayload/install/libpayload/

include $(LIBPAYLOAD_DIR)/libpayload.config
ifeq ($(CONFIG_LP_ARCH_MOCK),y)
$(error This sample program does not support ARCH_MOCK. Use sample/arch_mock instead)
endif

include $(LIBPAYLOAD_DIR)/libpayload.xcompile

ARCH-$(CONFIG_LP_ARCH_ARM)   := arm
ARCH-$(CONFIG_LP_ARCH_X86)   := x86_32
ARCH-$(CONFIG_LP_ARCH_ARM64) := arm64

CC := $(CC_$(ARCH-y))
AS := $(AS_$(ARCH-y))
XCC := CC="$(CC)" $(LIBPAYLOAD_DIR)/bin/lpgcc
XAS := AS="$(AS)" $(LIBPAYLOAD_DIR)/bin/lpas
CFLAGS := -fno-builtin -Wall -Werror -Os -I$(INC_DIR)

VPATH := $(SRC_DIR)
SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)

all: $(BUILD_DIR)/$(TARGET).elf

$(BUILD_DIR)/$(TARGET).elf: $(OBJS)
	$(XCC) -o $@ $(OBJS)

$(BUILD_DIR)/%.o: %.c | $(BUILD_DIR)
	$(XCC) $(CFLAGS) -c -o $@ $<

$(BUILD_DIR)/%.S.o: %.S
	$(XAS) --32 -o $@ $<

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	$(RM) -r $(BUILD_DIR)

distclean: clean