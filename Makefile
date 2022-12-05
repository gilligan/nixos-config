all: build

HOST=$(shell hostname)

build:
	rebuild

switch:
	sudo --preserve-env rebuild switch
