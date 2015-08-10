
all:
	cd ..
	zip -9 -q -r Game.love .
	make run
run:
	open -n -a love Game.love 
