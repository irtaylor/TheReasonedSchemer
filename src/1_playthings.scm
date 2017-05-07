;; Chapter 1: Playthings

(run* (q)
  (fresh (x)        ; fresh follows the syntax of lambda expressions
    (== x #t)
    (== #t q)))

(run* (q)
  (fresh (x)
    (== x #t)))

(run* (q)
  (fresh (x)
    (== (eq? x q) q)))

(run* (x)
  (conde                       ; e = "Every line".
    ((== 'olive x) succeed)
    ((== 'oil x) succeed)     ; here, we pretend that (== 'olive x) failed, refreshing x
    (else fail)))

(run 1 (x)
  (conde
    ((== 'olive x) succeed)
    ((== 'oil x) succeed)
    (else fail)))


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
