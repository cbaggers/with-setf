# with-setf

This project provides 2 macros for setf'ing values for the duration of a scope.

## with-setf

This macro sets a place to a given value at the start of the scope and then restores it to it's original value at the end of the scope.

`with-setf` contains and implicit `unwind-protect` so the original value will be restored even if the stack unwinds.

```
(with-setf (aref x 0) 10
  blah
  blah)
```

## with-setf*

This works like `with-setf` but it allows you to setf multiple places for the duration of the scope.

```
(with-setf* ((aref a 0) 10
             (foo :plinge) :narf)
  (print "blarr"))
```

And as with `with-setf` there is a `unwind-protect` in case of conditions.

## Why?

Some apis are just based around mutating state, gl is a good example. In these cases I still like (and want) to be able to do things by scope.

Something like this

```
(with-setf (depth-test context) nil
  ..draw-some-stuff..)
```
ends up being more reliable than me having to remember to reset the `depth-test` state after this chuck of rendering
