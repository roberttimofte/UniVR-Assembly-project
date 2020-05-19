GCC = gcc -m32 -g -o
EXE = GestioneVettore
SRC = GestioneVettore.s

all:
	@echo "building $(EXE)..."
	$(GCC) $(EXE) $(SRC)
	@echo "...done building"
	@echo "\ntype \"make help\" for command list"

help:
	@echo "make:\t\t build the executable"
	@echo "make run:\t run the executable"
	@echo "make clean:\t remove the executable"
	@echo "make debug:\t run the debugger (ddd)"

run:
	@./$(EXE)

clean:
	@rm -f $(EXE) core

debug:
	@ddd --args $(EXE) 

.PHONY: all, help, run, clean, debug
