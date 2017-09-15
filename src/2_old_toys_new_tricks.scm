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

; what caro does is to ask: "For what values of a can i unify the list `(,a _.0)
; with list p". since var a is the car of (cons a d), then this will tell us the
; car of the list that can unify with the car of p.

; another way to possibly write this:
(define caro2
  (lambda (p a)
    (== (car p) a)))    ; what values of a can unify with (car p)


; miniKanren functions are similar to their functional counterparts, except with the extra
; notion of trying to complete some sort of goal.

(let ((x
        (run* (q)
          (caro '(t e a) q)))
      (y
        (run* (q)
          (caro2 '(t e a) q))))
      (equal? x y))   ; => #t

(run* (q)
  (caro '(t e a) (car `(,q e a))))  ; => (t)


; in the below example, (caro `(,r ,y) x) ==> p is `(,r ,y), a is x, and d is fresh
(run* (r)
  (fresh (x y)
    (caro `(,x ,y) r)     ; x is associated w/ car of `(,r ,y), which is the fresh variable r
    (== 'pear x)))        ; => '(pear)


; in cdro, we fresh the a, instead of the var d, since what we want are the possible values of var d
(define cdro
  (lambda (p d)               ; the first arg is what we take the cdr of. the second arg is the thing we want to unify with.
    (fresh (a)                ; by making a fresh, we say that we don't care about its value
      (== (cons a d) p))))    ; we do, however, care about d, which is a bound variable. thus, we wish to unify p with '(_.0 ,d)
; another way to state the goal: unifying p with a list starting with anything and ending with d.


; will this work?
(define cdro2
  (lambda (p a)
    (== (cdr p) a)))

(run* (x)
  (cdro '(c o r n) x))  ; => ('(o r n))

(run* (x)
  (cdro '(c o r n) `(,x r n)))  ; => associates x w/ o
; as a query, we might read: "What values of x satisfy the cdr of '(c o r n)
; being equal to `(,x r n)?"

(let ((x
        (run* (q)
          (cdro '(c o r n) `(,q r n))))
      (y
        (run* (q)
          (cdro2 '(c o r n) `(,q r n)))))
      (equal? x y))   ; => #t

; This shows that cdro and cdro2 are the same ...
; The idea is to return a goal to unify the cdr of arg1 with arg2


; The fresh variables introduced in caro and cdro serve as the pieces of the list that we don't really care about for our goals' purposes.
; E.g. in caro, the fresh variable stands in for the cdr of the list, meaning we don't care about the cdr.
; In cdro, we don't care about the car of the list.


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

(pair? '(pear))  ; => #true, since it is the pair '(pear . ())

(run* (r)
  (fresh (x y)
    (== (cons x (cons y 'salad)) r))) ; => '(_.0 _.1 salad)


(define conso
  (lambda (a d p)         ; the third var is an output var, necessary to define a unification goal
    (== (cons a d) p)))

; These are functions which return goals.
(run* (q) (conso 'a '(b c) q))  ; => ((a b c)). i.e. find all q such that the unification goal of q with (cons a (b c)) succeeds

; nullo: can we unify the variable with the empty list '()
; eqo: can we unify the two variables
; pairo:  can our variable be unified with a list of any two elements
