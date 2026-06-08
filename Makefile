BUILD_DIR=build
BUILD_C=$(BUILD_DIR)/c
BUILD_ASM=$(BUILD_DIR)/asm
SRC_DIR=src
COMPILER=gcc
COMPILER_OPTS=-I include
EXECUTABLE=$(BUILD_DIR)/main
C_SRC=$(wildcard $(SRC_DIR)/*.c)
ASM_SRC=$(wildcard $(SRC_DIR)/*.s)
C_OBJS=$(subst $(SRC_DIR), $(BUILD_C), $(C_SRC:.c=.o))
ASM_OBJS=$(subst $(SRC_DIR), $(BUILD_ASM), $(ASM_SRC:.s=.o))

.PHONY: all
all: clean $(EXECUTABLE)

$(EXECUTABLE): $(C_OBJS) $(ASM_OBJS)
	$(COMPILER) $^ -o $@

$(BUILD_C)/%.o: $(SRC_DIR)/%.c
	mkdir -p $(BUILD_C)
	$(COMPILER) $(COMPILER_OPTS) -c -o $@ $^

$(BUILD_ASM)/%.o: $(SRC_DIR)/%.s
	mkdir -p $(BUILD_ASM)
	$(COMPILER) $(COMPILER_OPTS) -c -o $@ $^

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)

