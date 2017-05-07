# Logical Laws And Notes

## The Law of Fresh

If `x` is fresh, then `(v x)` succeeds, and associates `x` with `v`.

`(fresh (x ...) g ...)` binds fresh (i.e. unassociated) variables to `x ...` and succeeds if the
goals `g ...` succeed. `(== v x)` succeeds when `x` is fresh.

## The Law of -

`(v w)` is the same as `(w v)`.

## The Law of conde

To get more values from conde, pretend that the successful conde line has failed,
refreshing all variables that got an association from that line.
