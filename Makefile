.PHONY: all clean test

all: cp852decoder

cp852decoder: cp852decoder.pas
	fpc -Mdelphi cp852decoder.pas

test: cp852decoder
	./cp852decoder < data852.txt > data852.txt.out
	diff dataUTF8.txt data852.txt.out

clean:
	rm cp852decoder *.o *.rst *.out
