(in-package #:with-setf)

;;------------------------------------------------------------

(defun with-setf-internals (env places values)
  (let ((expanded
         (loop :for place :in places :for value :in values :collect
            (multiple-value-bind (dummies vals new setter getter)
                (get-setf-expansion place env)
              (assert (not (cdr new)) () "with-setf failed to expand: ~a"
                      place)
              (let ((new (car new))
                    (old-value (gensym "OLD-VAL")))
                (list `(,@(mapcar #'list dummies vals)
                          (,old-value ,getter)
                          (,new ,value))
                      setter
                      `(let ((,new ,old-value))
                         ,setter)))))))
    (values (mapcan #'first (copy-list expanded))
            (mapcar #'second expanded)
            (mapcar #'third expanded))))

(defmacro with-setf (&environment env place value &body body)
  "Used like this:
   (with-setf (aref x 0) 10
     blah
     blah)"
  (multiple-value-bind (lets setters restores)
      (with-setf-internals env (list place) (list value))
    `(let* (,@lets)
       ,@setters
       (unwind-protect (progn ,@body)
         ,@restores))))

(defmacro with-setf* (&environment env place-value-pairs &body body)
  "Used like this:
   (with-setf* ((aref a 0) 10
                (foo :plinge) :narf)
     (print \"blarr\"))"
  (destructuring-bind (places values)
      (loop :for x :in place-value-pairs :for i :from 0
         :if (evenp i) :collect x :into places
         :else :collect x :into vals
         :finally (return (list places vals)))
    (multiple-value-bind (lets setters restores)
        (with-setf-internals env places values)
      `(let* (,@lets)
         ,@setters
         (unwind-protect (progn ,@body)
           ,@restores)))))

;;------------------------------------------------------------
