NAME = crypto_lab

all: build

build:
	dune build

run:
	dune exec ./bin/$(NAME).exe -- $(ARGS)

test:
	dune runtest

check: build test

clean:
	dune clean

format:
	ocamlformat --enable-outside-detected-project -i lib/*.ml lib/*.mli bin/*.ml test/*.ml

check-format:
	ocamlformat --enable-outside-detected-project --check lib/*.ml lib/*.mli bin/*.ml test/*.ml

.PHONY: all build run test check clean format check-format

