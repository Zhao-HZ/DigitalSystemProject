all:
	@rgbasm -L -o ./src/main.o ./src/main.asm
# 	@rgblink -o project.gb ./src/main.o
	@rgblink -o project.gb ./src/main.o
	@rgbfix -v -p 0xFF project.gb
	@cp project.gb ~/desk/bgbw64

clean:
	rm ./src/*.o ./*.gb
