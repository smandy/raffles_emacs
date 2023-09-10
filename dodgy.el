;; This buffer is for text that is not saved, and for Lisp evaluation.
;; To create a file, visit it with <open> and enter text in its buffer.

(global-set-key (kbd "g") (lambda (&rest x) (interactive) (message "Woohoo %s" x)))

(global-set-key (kbd "g") 'self-insert-command)

(defun square (x) ( * x x ))

(square 9) 81

(cl-loop for x from 1 upto 20 collect x) 

(require 'dash)

(--map (list it (* it it)) (number-sequence 1 100))

(message args)

(cl-evenp)

(cl-loop for x from 1 to 10
         if (cl-evenp x)
         collect (list x (* x x ))) ((2 4) (4 16) (6 36) (8 64) (10 100))

(apply (list 'square 2))














