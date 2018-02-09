(define list?
  (lambda (l)
    (cond
      ((null? l) #t)
      ((pair? l) (list? (cdr l)))
    (else #f))))

(define listo
  (lambda (l)
    (conde
      ((nullo l) succeed)   ; can we unify with '()?
      ((pairo l)            ; can we unify l with a pair? if so...
        (fresh (d)
          (cdro l d)        ; ... can we unify the cdr of l with a fresh variable d?
          (listo d)))       ; ... can we unify the fresh variable d with a list (recursive call)?
    (else fail))))

; the fresh portion above "unnests" (list? (cdr l))


(run 5 (x)
  (listo `(a b c . ,x)))


(define x 'egg)
(define y 'mcmuffin)
; dot notation
`(,x . (,y . ())) ; => '(egg mcmuffin)

; list-of-lists?
(define lol?
  (lambda (l)
    (cond
      ((null? l) #t)
      ((list? (car l)) (lol? (cdr l)))
    (else #f))))

; this version differs from lol? b/c it has goals as questions and answers,
; rather than Boolean values as questions and answers
(define lolo
  (lambda (l)
    (conde
      ((nullo l) succeed)
      ((fresh (a)           ; QUESTION 1:
          (caro l a)          ; can we associate a with car of l ?
          (listo a))          ; can we associate the car of l with a list ?
       (fresh (d)           ; QUESTION 2:
          (cdro l d)          ; associate d with cdr of l ?
          (lolo d)))          ; recur on cdr of l ?
    (else fail))))

; notice how the components under (fresh ...) unnest (list? (car l)) and (lol? (cdr l))
; SO: (list? (car l)) => (caro l a) and (listo a), where a is fresh
; AND: (lol? (cdr l)) => (cdro l d), where d is fresh

; the value of (lolo l) is always a goal

(run 1 (l)
  (lolo l))
; => '(())
; REMINDER: this value means: "The set of solutions contains only the empty list"
; l is fresh, so nullo succeeds, thereby associating l w/ '()

(run* (q)
  (fresh (x y)
    (lolo `((a b) (,x c) (d ,y)))
    (== #t q)))
; => (#t), since q is associated w/ #t b/c we have a list of lists, and so lolo succeeds

(run 1 (x)
  (lolo `((a b) (c d) ,x)))
; => '(())
; since replacing x w/ empty list gives us '((a b) (c d) . ())
