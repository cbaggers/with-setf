# with-setf

This project provides 2 macros for setf'ing values for the duration of a scope.

## with-setf

This macro sets a place to a given value at the start of the scope and then restores it to it's original value at the end of the scope.

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
