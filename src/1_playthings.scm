; Chapter 1: Playthings

; Goals:
;   #s => succeed
;   #u => fail      (i.e. 'unsuccessful')

; Translating the book's way of writing miniKanren to the Scheme implementation is a bit tricky.
; If something is weird, make sure you wrote it correctly!

; Another point: Pay attention to the actual questions posed by the book. Somethings,
; they may ask the value returned by a (run* ...), and other times they will ask, e.g., the
; value associated with a specific variable.

(run* (q)
  fail)     ; => (), since (run* (q) g . . .) has value () if any goal in g . . . fails

; == is the unification operator:
(run* (q)
  (== #t q))    ; => (#t), since #t is associated w/ q if (== #t q) succeeds

; Another to think of the above: "Find me all q, s.t. #t == q succeeds"

(run* (q)
  fail (== #t q))   ; => (), since the goal #u fails


; what value is associated w/ q?
(run* (q)
  succeed (== #t q))

; ^ #t (boolean value) is associated w/ q. thus, the value of the above is (#t)

(run* (r)
  succeed (== 'corn r))   ; => ('corn)

; etc ...

(run* (x)
  (let ((x #t)) (== #f x)))   ; => (). We bind x to #t, but cannot unify w/ #f

(run* (q)
  (fresh (x)        ; fresh follows the syntax of lambda expressions
    (== x #t)
    (== #t q)))

(run* (x)
  succeed)    ; => (_.0), representing a fresh variable


(run* (x)
  (let ((x #t)) (== #t x)))   ; => (_.0). The let expression evaluates to #s. See expression above!

(run* (x)
  (let ((x #f))
    (fresh (x)
      (== #t x))))    ; => (_.0). The x in (== #t x) is introduced by fresh.
                      ; It is NOT the same as the x in the run or let expressions.

(run* (r)
  (fresh (x y)
    (== (cons x (cons y '())) r)))    ; => ('(_.0 _.1))

(run* (r)
  (fresh (x)
    (let ((y x))
      (== (cons y (cons x (cons y '()))) r))))    ; => ('(_.0 _.0 _.0)), since y is bound to x in the let expr

(run* (r)
  (fresh (x)
    (let ((y x))
      (fresh (x)
        (== (cons y (cons x (cons y '()))) r))))) ; => ('(_.0 _.1 _.0)), since in the inner fresh, x and y are different variables

; the fresh variables are reified in the order they appear in the list

(run* (q)
  (== #f q)   ; this goal succeeds, but now q is associated, i.e. not fresh
  (== #t q))  ; => '(), since the not-fresh q fails this goal

(run* (q)
  (== #f q)
  (== #f q))  ; => '(#f)

(run* (q)
  (fresh (x)
    (== x #t)))

(run* (q)
  (fresh (x)
    (== (eq? x q) q)))

(run* (x)
  (conde                       ; e = "Every line", since every line has a chance to succeed!
    ((== 'olive x) succeed)
    ((== 'oil x) succeed)     ; here, we pretend that (== 'olive x) failed, refreshing x
    (else fail)))             ; => (olive oil)

(run 1 (x)
  (conde
    ((== 'olive x) succeed)
    ((== 'oil x) succeed)
    (else fail)))           ; => (olive)


(run* (r)
  (fresh (x y)
    (conde
      ((== 'split x) (== 'pea y))
      ((== 'navy x) (== 'bean y))
      (else fail))
    (== (cons x (cons y '())) r)))

(define teacupo               ; The superscript 'o' indicates that this function returns a goal as its value
  (lambda (x)
    (conde
      ((== 'tea x) succeed)
      ((== 'cup x) succeed)
      (else fail))))

(run* (x)
  (teacupo x))

(run* (r)
  (fresh (x y)
    (conde
      ((teacupo x) (== #t y) succeed)     ; teacupo associates x w/ 'tea and 'cup
      ((== #f x) (== #t y))               ; x is associated w/ #f
      (else fail))
    (== (cons x (cons y '())) r)))        ; returns: ((tea #t) (cup #t) (#f #t))


;; This gets harder...
; Compare this expression...
(run* (r)
  (fresh (x y z)
    (conde
      ((== y x) (fresh (x) (== z x)))
      ((fresh (x) (== y x)) (== z x))
      (else fail))
    (== (cons y (cons z '())) r)))

; With this one...
(run* (r)
  (fresh (x y z)
    (conde
      ((== y x) (fresh (x) (== z x)))
      ((fresh (x) (== y x)) (== z x))
      (else fail))
      (== #f x)
    (== (cons y (cons z '())) r)))


(run* (q)
  (let ((a (== #t q))   ; this is an expression, whose value is a goal.
        (b (== #f q)))
    b))                 ; ... but we only treat the value of (== #f q) as a goal

(run* (q)
  (let ((a (== #t q))
        (b (fresh (x)
              (== x q)
              (== #f x)))
        (c (conde
              ((== #t q) succeed)
              (else (== #f q)))))
    b))
