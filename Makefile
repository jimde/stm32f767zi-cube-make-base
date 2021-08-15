PROJ = image

TOOLCHAIN	= arm-none-eabi-
CC			= $(TOOLCHAIN)gcc
AS			= $(TOOLCHAIN)as
AR			= $(TOOLCHAIN)ar
LD			= $(TOOLCHAIN)gcc
NM			= $(TOOLCHAIN)nm
OBJCOPY		= $(TOOLCHAIN)objcopy
OBJDUMP		= $(TOOLCHAIN)objdump
READELF		= $(TOOLCHAIN)readelf
SIZE		= $(TOOLCHAIN)size
GDB			= $(TOOLCHAIN)gdb

MARCH = cortex-m7

BIN = $(OUTDIR)/$(PROJ).bin
ELF = $(OUTDIR)/$(PROJ).elf
MAP = $(OUTDIR)/$(PROJ).map

CUBEDIR = STM32CubeF7

OBJDIR		= obj
OBJDIR_CUBE	= objcube
OUTDIR		= bin
SCRIPTDIR	= scripts

# Source directories
SRCDIR			= src
SRCDIR_HAL		= $(CUBEDIR)/Drivers/STM32F7xx_HAL_Driver/Src
SRCDIR_CUBE_BSP	= $(CUBEDIR)/Drivers/BSP/STM32F7xx_Nucleo_144

# Header directories
INCS = -Ih
INCS += -I$(CUBEDIR)/Drivers/STM32F7xx_HAL_Driver/Inc
INCS += -I$(CUBEDIR)/Drivers/CMSIS/Device/ST/STM32F7xx/Include
INCS += -I$(CUBEDIR)/Drivers/BSP/STM32F7xx_Nucleo_144
INCS += -I$(CUBEDIR)/Drivers/CMSIS/Include

# User sources
SRCS = $(wildcard $(SRCDIR)/*.c)
OBJS = $(patsubst $(SRCDIR)/%.c, $(OBJDIR)/%.o, $(SRCS))

# HAL sources, filter out all template files
SRCS_CUBE = $(filter-out $(wildcard $(SRCDIR_HAL)/*_template.c), $(wildcard $(SRCDIR_HAL)/*.c))
OBJS_CUBE = $(patsubst $(SRCDIR_HAL)/%.c, $(OBJDIR_CUBE)/%.o, $(SRCS_CUBE))

# BSP sources
SRCS_CUBE_BSP = $(SRCDIR_CUBE_BSP)/stm32f7xx_nucleo_144.c
OBJS_CUBE_BSP = $(patsubst $(SRCDIR_CUBE_BSP)/%.c, $(OBJDIR_CUBE)/%.o, $(SRCS_CUBE_BSP))

# Startup file
SRCS_S	=  $(SRCDIR)/startup_stm32f767xx.s
OBJS_S	=  $(patsubst $(SRCDIR)/%.s, $(OBJDIR)/%.o, $(SRCS_S))
OBJS	+= $(OBJS_S)

LINKER_SCRIPT = $(SRCDIR)/linker.ld

DEFINES			= -DSTM32F767xx -D__STARTUP_CLEAR_BSS -D__START=main
COMMON_FLAGS	= -mcpu=$(MARCH) -mthumb -mfloat-abi=soft $(INCS) $(DEFINES)

CFLAGS	= -c $(COMMON_FLAGS) -std=gnu11 -Wall -g -O0
LDFLAGS	= $(COMMON_FLAGS) --specs=nano.specs --specs=nosys.specs -L. -T $(LINKER_SCRIPT) -Wl,-Map=$(MAP)

.DEFAULT_GOAL = all

all: setup $(BIN)

$(ELF): $(OBJS) $(OBJS_CUBE) $(OBJS_CUBE_BSP)
	@echo $@
	@$(CC) $(LDFLAGS) -o $@ $^

$(BIN): $(ELF)
	@echo $@
	@$(OBJCOPY) -O binary $< $@

clean:
	@rm -f *.o *.elf *.map $(OUTDIR)/* $(OBJDIR)/* $(OBJDIR_CUBE)/*

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	@echo $<
	@$(CC) $(CFLAGS) -c $< -o $@

$(OBJDIR)/%.o: $(SRCDIR)/%.s
	@echo $<
	@$(CC) $(CFLAGS) -c $< -o $@

$(OBJDIR_CUBE)/%.o: $(SRCDIR_HAL)/%.c
	@echo $<
	@$(CC) $(CFLAGS) -c $< -o $@

$(OBJDIR_CUBE)/%.o: $(SRCDIR_CUBE_BSP)/%.c
	@echo $<
	@$(CC) $(CFLAGS) -c $< -o $@

setup:
	@mkdir -p $(OBJDIR)
	@mkdir -p $(OBJDIR_CUBE)
	@mkdir -p $(OUTDIR)

connect:
	@JLinkExe -device STM32F767ZI -if SWD -speed 4000 -autoconnect 1

install: $(BIN)
	@$(SCRIPTDIR)/install.sh

debug: $(BIN)
	@$(SCRIPTDIR)/debug.sh
