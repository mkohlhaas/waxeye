;; Waxeye Parser Generator
;; www.waxeye.org
;; Copyright (C) 2008-2010 Orlando Hill
;; Licensed under the MIT license. See 'LICENSE' for details.

#lang racket/base
(require (only-in racket/list remove-duplicates add-between))
(provide (all-defined-out))


;; ast
;;
;; t = The type of the ast as a symbol
;; c = The list of the ast's children as nested asts or characters
;; p = The position of the ast in the original string as a pair of start and end indexes
(struct ast (t c pos) #:mutable)


(struct parse-error (pos line col expected received snippet))


(define (ast->string ast)
  (let ((indent-level 0) (o (open-output-string)))
    (define (display-a c)
      (when (> indent-level 0)
            (display "->  " o))
      (display (ast-t c) o)
      (set! indent-level (+ indent-level 1))
      (for-each (lambda (a)
                  (newline o)
                  (display-iter a))
                (ast-c c))
      (set! indent-level (- indent-level 1)))
    (define (display-c c)
      (when (> indent-level 0)
            (display "|   " o))
      (display c o))
    (define (display-iter ast)
      (when (or (char? ast) (ast? ast))
            (let loop ((i 1))
              (when (< i indent-level)
                    (display "    " o)
                    (loop (+ i 1))))
            (if (char? ast)
                (display-c ast)
                (display-a ast))))
    (display-iter ast)
    (get-output-string o)))


(define (display-ast ast)
  (display
   (cond
    ((ast? ast) (ast->string ast))
    ((parse-error? ast) (parse-error->string ast))
    (else ast)))
  (newline))


(define (ast->string-sexpr ast)
  (let ((o (open-output-string)))
    (define (display-iter ast)
      (display "(" o)
      (display (ast-t ast) o)
      (for-each (lambda (a)
                  (display " " o)
                  (if (ast? a)
                      (display-iter a)
                      (display a o)))
                (ast-c ast))
      (display ")" o))
    (display-iter ast)
    (get-output-string o)))


(define (parse-error->string error)
  (define (comma-separate l)
    ; Simulate string-join with string-append . add-between,
    ; because racketscript cannot handle racket/string.
    (apply string-append (add-between (map symbol->string l) ", ")))
  (define (expected nts)
    (let ((len (length nts)))
      (if (= len 0)
          "<end of input>"
          (string-append "[" (comma-separate nts) "]"))))
  (string-append
   (number->string (parse-error-line error))
   ":"
   (number->string (parse-error-col error))
   " expected: "
   (expected (remove-duplicates (parse-error-expected error)))
   " received: "
   (parse-error-received error)
   "\n"
   (parse-error-snippet error)))


(define (display-parse-error error)
  (display (parse-error->string error))
  (newline))
