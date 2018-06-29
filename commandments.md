# Commandments

## The First Commandment

To transform a function whose value is a Boolean into a function whose value is a goal, replace `cond` with `conde` and unnest each question and answer.

Unnest the answer `#t` (or `#f`) by replacing it with `#s` (or `#u`).

Note: When unnesting, we can use *cons*, since it can operate on logic variables.


## The Second Commandment

To transform a function whose value is **not** a Boolean into a function whose value is a goal, add an extra argument to hold its value, replace `cond` with `conde` and unnest each question and answer.
