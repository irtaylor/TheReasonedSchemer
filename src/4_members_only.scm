; Chapter 4: Members Only


(define mem
  (lambda (x l)
    (cond
      ((null? l) #f)
      ((eq-car? l x) l)
    (else (mem x (cdr l))))))
