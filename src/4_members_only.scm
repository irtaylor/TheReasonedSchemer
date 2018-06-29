; Chapter 4: Members Only


(define mem
  (lambda (x l)
    (cond
      ((null? l) #f)
      ((eq-car? l x) l)
    (else (mem x (cdr l))))))

(mem 'tofu '(a b tofu d peas e))
; => '(tofu d peas e)
; mem has non-Boolean return values

(run* (out)
  (== (mem 'tofu '(a b tofu d peas e)) out))
; => '((tofu d peas e))

(define memo
  (lambda (x l out)
    (conde
      ((nullo l) fail)
      ((eq-caro l x) (== l out))
    (else
      (fresh (d)
        (cdro l d)
        (memo x d out))))))

; we've unnested (mem x (cdr l)) into the fresh block above
