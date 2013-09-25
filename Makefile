all: cp852decoder

cp852decoder: cp852decoder.pas
	fpc -Mdelphi cp852decoder.pas

clean:
	rm cp852decoder *.o *.rst *.out
