; Chapter 2: Teaching Old Toys New Tricks

(let ((x (lambda (a) a))    ; x is bound to the identity function
      (y 'c))               ; y is bound to the value 'c
    (x y))                  ; apply the identity function to y


; Quasiquote: `(,x ,y) means the list containing variables x and y.
; It does NOT mean the list of values 'x and 'y,
; nor does it mean the function application of x to y
(run* (r)
  (fresh (y x)
    (== `(,x ,y) r))) ; => '(_.0 _.1)


; caro: whereas car takes one argument, caro takes two
; caro associates the car of list p with variable a
(define caro
  (lambda (p a)
    (fresh (d)
      (== (cons a d) p))))    ; d is a fresh variable, e.g. _.0.
                              ; thus, (cons a d) => `(,a _.0)



; in the below example, (caro `(,r ,y) x) ==> p is `(,r ,y), a is x, and d is fresh
(run* (r)
  (fresh (x y)
    (caro `(,x ,y) r)     ; x is associated w/ car of `(,r ,y), which is the fresh variable r
    (== 'pear x)))        ; => '(pear)

(define cdro
  (lambda (p d)
    (fresh (a)
      (== (cons a d) p))))

(run* (x)
  (cdro '(c o r n) `(,x r n)))  ; => associates x w/ o
; as a query, we might read: "What values of x satisfy the cdr of '(c o r n)
; being equal to `(,x r n)?"

(run* (x)
  (conde
    ((cdro '(c o r n) `(,x r n)) succeed)
    ((cdro '(s a l s a) `(,x l s a)) succeed)))   ; => (o a)

(run* (x)
  (caro (cdr '(s a l s a)) x)
  (cdro '(p a s t a) `(,x s t a)))    ; => (a)

(run* (x)
  (caro (cdr '(m u f f i n)) x)
  (cdro '(p a s t a) `(,x s t a)))    ; => (), since there is no value of x that can satisfy both goals


(run* (q)
  (nullo '())
  (== #t q))

(run* (x)
  (nullo x))

(run* (q)
  (eqo 'plum 'pear)   ; this goal fails
  (== #t q))          ; => (), since (run* (q) g ...) has value () if any goal in g ... fails

(run* (q)
  (eqo 'plum 'plum))  ; => (_.0), since the goal succeeds, but q has not been associated and remains fresh
