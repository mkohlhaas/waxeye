# Waxeye Parser Generator

Waxeye is a parser generator based on parsing expression grammars (PEGs). It
supports C, Java, Javascript, Python, Ruby and Scheme.

# Installation & Usage

```shell
$ git clone https://github.com/waxeye-org/waxeye.git
$ cd waxeye
$ make compiler
$ sudo cp -R bin /usr/local/
$ sudo cp -R lib /usr/local/
$ cd src/racket/waxeye
$ raco pkg install
$ cd ../../grammars
$ waxeye -g racket . calc.waxeye
$ cp parser.rkt ../src/example/racket
$ cd ../src/example/racket
$ racket calculator.rkt
```
