;; Chapter 1: Playthings

(run* (q)
  (fresh (x)
    (== x #t)
    (== #t q)))

(run* (q)
  (fresh (x)
    (== x #t)))

(run* (q)
  (fresh (x)
    (== (eq? x q) q)))

(run* (x)
  (conde
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

(define teacupo
  (lambda (x)
    (conde
      ((== 'tea x) succeed)
      ((== 'cup x) succeed)
      (else fail))))

(run* (r)
  (fresh (x y)
    (conde
      ((teacupo x) (== #t y) succeed)
      ((== #f x) (== #t y))
      (else fail))
    (== (cons x (cons y '())) r)))
