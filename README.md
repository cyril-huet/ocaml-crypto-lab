# OCaml Crypto Lab

[![CI](https://github.com/cyril-huet/ocaml-crypto-lab/actions/workflows/ci.yml/badge.svg)](https://github.com/cyril-huet/ocaml-crypto-lab/actions/workflows/ci.yml)

OCaml Crypto Lab is a small educational project about number theory and basic
cryptography. The code is split into short modules so that each algorithm can
be read and tested separately.

This is a learning project. It is not a secure cryptography library and must
not be used to protect real data.

## What the project contains

### Number theory

- absolute values, greatest common divisor and least common multiple;
- coprime numbers and modular powers;
- prime checks and lists of primes;
- divisors and prime factorisation;
- Euler's totient function;
- modular inverses.

### Classical ciphers

- Caesar encryption and decryption;
- ROT13;
- Atbash;
- Vigenere encryption and decryption.

### Public-key examples

- RSA key creation, number encryption and text encryption;
- Diffie-Hellman key exchange;
- ElGamal encryption and decryption.

All public-key examples use small numbers so that the calculations stay easy
to inspect by hand.

## Architecture

```text
lib/
├── number_theory.ml       arithmetic, primes and modular operations
├── encoding.ml            strings, character codes and hexadecimal
├── ciphers.ml             Caesar, ROT13, Atbash and Vigenere
├── rsa.ml                 small RSA example
├── diffie_hellman.ml      small key exchange example
├── elgamal.ml             small ElGamal example
├── file_tools.ml          simple text file operations
└── key_files.ml           saving and loading RSA keys

bin/crypto_lab.ml          command-line interface
test/test.ml               100 algorithm tests
test/test_files.ml         file and key tests
```

The project intentionally avoids external OCaml libraries. The only build
tool needed is Dune.

## Requirements

- OCaml 5.2.1;
- Dune 2.9 or newer;
- `ocamlformat` is optional and is only needed for formatting commands.

## Build and test

```sh
dune build
dune runtest
```

The same commands are available through the Makefile:

```sh
make
make test
make check
```

The test program runs exactly 100 checks covering arithmetic, encodings,
classical ciphers, RSA, Diffie-Hellman and ElGamal.

There are also separate tests for reading files, writing files and saving RSA
keys. They use temporary files and remove them when they finish.

## Command-line examples

```sh
dune exec ./bin/crypto_lab.exe -- help
dune exec ./bin/crypto_lab.exe -- gcd 24 18
dune exec ./bin/crypto_lab.exe -- prime 97
dune exec ./bin/crypto_lab.exe -- primes 30
dune exec ./bin/crypto_lab.exe -- factors 360
dune exec ./bin/crypto_lab.exe -- caesar encrypt 3 "Hello World"
dune exec ./bin/crypto_lab.exe -- caesar decrypt 3 "Khoor Zruog"
dune exec ./bin/crypto_lab.exe -- rot13 "Hello"
dune exec ./bin/crypto_lab.exe -- atbash "Hello"
dune exec ./bin/crypto_lab.exe -- vigenere encrypt LEMON "ATTACK AT DAWN"
dune exec ./bin/crypto_lab.exe -- hex encode "Hello"
dune exec ./bin/crypto_lab.exe -- rsa demo "Hello"
dune exec ./bin/crypto_lab.exe -- rsa generate 61 53 17 public.key private.key
dune exec ./bin/crypto_lab.exe -- rsa encrypt public.key message.txt message.crypto
dune exec ./bin/crypto_lab.exe -- rsa decrypt private.key message.crypto message.out
dune exec ./bin/crypto_lab.exe -- diffie-hellman
dune exec ./bin/crypto_lab.exe -- elgamal 7
```

With the Makefile, arguments can be passed through `ARGS`:

```sh
make run ARGS='rsa "Hello"'
```

The generated private key and encrypted files are ignored by Git. Do not put a
real private key in a public repository.

## Why the algorithms are simple

The modular inverse is found by trying possible values. This is very easy to
understand, but it becomes slow for large numbers. The prime search and the
public-key examples have the same educational goal: show the main idea with
small integers before thinking about optimised implementations.

The project is therefore useful for learning, but it makes no security claim.

## Project files

```text
.
├── .github/workflows/ci.yml
├── bin/
├── lib/
├── test/
├── .gitignore
├── .ocaml-version
├── dune-project
├── LICENSE
├── Makefile
└── README.md
```

## License

This project is released under the MIT License. See [LICENSE](LICENSE).

