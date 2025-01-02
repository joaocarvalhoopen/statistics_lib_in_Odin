all:
	odin build . -out:./bin/statistics.exe --debug

opti:
	odin build . -out:./bin/statistics.exe --speed

clean:
	rm -f ./bin/statistics.exe

run:
	./bin/statistics.exe