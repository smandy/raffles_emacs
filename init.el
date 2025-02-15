
;;; init.el --- Andy's emacs config

;;; Commentary:

;; Ritz/Raffles/Duck laptop Emacs config

;;; Code:

;;(set-frame-font "Andale Mono 12")
(set-frame-font "Liberation Mono 12")


(defadvice org-archive-subtree (around fix-hierarchy activate)
  (let* ((fix-archive-p (and (not current-prefix-arg)
                             (not (use-region-p))))
         (afile (org-extract-archive-file (org-get-local-archive-location)))
         (buffer (or (find-buffer-visiting afile) (find-file-noselect afile))))
    ad-do-it
    (when fix-archive-p
      (with-current-buffer buffer
        (goto-char (point-max))
        (while (org-up-heading-safe))
        (let* ((olpath (org-entry-get (point) "ARCHIVE_OLPATH"))
               (path (and olpath (split-string olpath "/")))
               (level 1)
               tree-text)
          (when olpath
            (org-mark-subtree)
            (setq tree-text (buffer-substring (region-beginning) (region-end)))
            (let (this-command) (org-cut-subtree))
            (goto-char (point-min))
            (save-restriction
              (widen)
              (-each path
                (lambda (heading)
                  (if (re-search-forward
                       (rx-to-string
                        `(: bol (repeat ,level "*") (1+ " ") ,heading)) nil t)
                      (org-narrow-to-subtree)
                    (goto-char (point-max))
                    (unless (looking-at "^")
                      (insert "\n"))
                    (insert (make-string level ?*)
                            " "
                            heading
                            "\n"))
                  (cl-incf level)))
              (widen)
              (org-end-of-subtree t t)
              (org-paste-subtree level tree-text))))))))


(defun num-to-words (n)
  "Convert a number N to its English words representation up to 999 trillion."
  (let* ((ones '("zero" "one" "two" "three" "four" "five" "six" "seven" "eight" "nine"))
         (teens '("ten" "eleven" "twelve" "thirteen" "fourteen" "fifteen"
                  "sixteen" "seventeen" "eighteen" "nineteen"))
         (tens '("" "" "twenty" "thirty" "forty" "fifty" "sixty" "seventy" "eighty" "ninety"))
         (scales '("" "thousand" "million" "billion" "trillion"))
         
         ;; Function to convert numbers less than 1000
         (convert-hundreds (lambda (num)
                             (let* ((hundreds (if (>= num 100)
                                                  (concat (nth (/ num 100) ones) " hundred") ""))
                                    (remainder (% num 100))
                                    (tens-and-ones (cond ((and (>= remainder 10) (< remainder 20))
                                                          (nth (- remainder 10) teens))
                                                         ((>= remainder 20)
                                                          (concat (nth (/ remainder 10) tens)
                                                                  (if (> (% remainder 10) 0)
                                                                      (concat "-" (nth (% remainder 10) ones)))))
                                                         ((> remainder 0)
                                                          (nth remainder ones)))))
                               (string-join (remove nil (list hundreds tens-and-ones)) " "))))

         ;; Split number into groups of thousands
         (groups (let ((res '()))
                   (while (> n 0)
                     (push (% n 1000) res)
                     (setq n (/ n 1000)))
                   res)))
    
    ;; Build final result by converting each group
    (string-join
     (remove nil
             (cl-loop for i from 0 to (1- (length groups))
                      for group = (nth i groups)
                      for scale = (nth i scales)
                      for part = (if (zerop group) nil
                                   (concat (funcall convert-hundreds group) 
                                           (if (not (string= scale "")) (concat " " scale))))
                      collect part))
     " ")))



(defun num-to-words (n)
  "Convert a number N to its English words representation up to 999 trillion."
  (let* ((ones '("zero" "one" "two" "three" "four" "five" "six" "seven" "eight" "nine"))
         (teens '("ten" "eleven" "twelve" "thirteen" "fourteen" "fifteen"
                  "sixteen" "seventeen" "eighteen" "nineteen"))
         (tens '("" "" "twenty" "thirty" "forty" "fifty" "sixty" "seventy" "eighty" "ninety"))
         (scales '("" "thousand" "million" "billion" "trillion"))
         
         ;; Function to convert numbers less than 1000
         (convert-hundreds (lambda (num)
                             (let* ((hundreds (if (>= num 100)
                                                  (concat (nth (/ num 100) ones) " hundred") ""))
                                    (remainder (% num 100))
                                    (tens-and-ones (cond ((and (>= remainder 10) (< remainder 20))
                                                          (nth (- remainder 10) teens))
                                                         ((>= remainder 20)
                                                          (concat (nth (/ remainder 10) tens)
                                                                  (if (> (% remainder 10) 0)
                                                                      (concat "-" (nth (% remainder 10) ones)))))
                                                         ((> remainder 0)
                                                          (nth remainder ones)))))
                               (string-join (remove nil (list hundreds tens-and-ones)) " "))))

         ;; Split number into groups of thousands
         (groups (let ((res '()))
                   (while (> n 0)
                     (push (% n 1000) res)
                     (setq n (/ n 1000)))
                   res)))
    
    ;; Build final result by converting each group
    (string-join
     (remove nil
             (cl-loop for i from 0 to (1- (length groups))
                      for group = (nth i groups)
                      for scale = (nth i scales)
                      for part = (if (zerop group) nil
                                   (concat (funcall convert-hundreds group) 
                                           (if (not (string= scale "")) (concat " " scale))))
                      collect part))
     " ")))

;; Example usage:
(num-to-words (* 25 250000)) ; => "six million two hundred fifty thousand"
(num-to-words 123456789012)  ; => "one hundred twenty-three billion four hundred fifty-six million seven hundred eighty-nine thousand twelve"
(num-to-words 1002003)       ; => "one million two thousand three"
(num-to-words 900000000000)  ; => "nine hundred billion"
(num-to-words 0)             ; => "zero"
(num-to-words 1000000000000) ; => "one trillion"




(defun valid-perudo-bid-p (current-bid new-bid)
  "Determine if the NEW-BID is valid given the CURRENT-BID in Perudo.
CURRENT-BID and NEW-BID are cons cells where the car is the quantity and the cdr is the face value."
  (let ((current-quantity (car current-bid))
        (current-face (cdr current-bid))
        (new-quantity (car new-bid))
        (new-face (cdr new-bid)))
    (cond
     ;; If the new face value is greater than the current face value, the bid is valid.
     ((> new-face current-face) t)
     ;; If the new face value is the same, the quantity must be greater.
     ((and (= new-face current-face) (> new-quantity current-quantity)) t)
     ;; If the new face value is less, the quantity must be greater.
     ((< new-face current-face) (> new-quantity current-quantity))
     ;; Otherwise, the bid is not valid.
     (t nil))))

;; Example usage:
(let ((current-bid (cons 6 6))
      (new-bid (cons 7 2)))
  (if (valid-perudo-bid-p current-bid new-bid)
      (message "The bid %s is valid when current bid is %s" new-bid current-bid)
    (message "The bid %s is not valid if %s is current bid" new-bid current-bid )))


(defun kaz ()
  "Tidy up the kazinsky manifesto"
  (interactive)
  (search-forward-regexp "^[0-9]+\. ")
  (let ((c (current-column)))
    (beginning-of-line)
    (forward-line)
    (insert (s-repeat " " c))))

;; (set-frame-font "-Misc-Misc Tamsyn-normal-normal-normal-*-20-*-*-*-c-100-iso10646-1" )

(defun switch-to-gtd-org ()
  (interactive)
  (switch-to-buffer (find-file "/home/andy/repos/gtd/gtd.org")))

(global-set-key [f9] 'switch-to-gtd-org)

(global-set-key [f12] 'org-archive-subtree)

(defun as/do-nothing (&rest args)
  (interactive)
  ;;(message "Doing nothing with %s %s" args (format-time "%H:%M:%S.%3N" (current-time)) )
  (message "Doing nothing with %s" args)
  )

(global-set-key [touchscreen-end] 'as/do-nothing)
(global-set-key [touchscreen-begin] 'as/do-nothing)
(global-set-key [touchscreen-update] 'as/do-nothing)

(require 'cc-mode)

(defun markdown-html (buffer)
  (princ (with-current-buffer buffer
           (format "<!DOCTYPE html><html><title>Impatient Markdown</title><xmp theme=\"united\" style=\"display:none;\"> %s  </xmp><script src=\"http://ndossougbe.github.io/strapdown/dist/strapdown.js\"></script></html>" (buffer-substring-no-properties (point-min) (point-max))))
         (current-buffer)))

(set-fontset-font t 'unicode "Noto Sans Symbols2" nil 'append)



;; Duck fonts

;; (set-frame-font "-1ASC-Liberation Mono-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1" )
;; (set-frame-font "-ADBO-Source Code Pro-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1" )
;; (set-frame-font "Consolas 18")
;; (set-frame-font "Liberation Mono 8")
;; (set-frame-font "-xos4-xos4 Terminus-normal-normal-normal-*-16-*-*-*-c-80-iso10646-1" )
;; (set-frame-font "-MS  -Consolas-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1" )


;; (set-frame-font "Bedstead 15")

;; (set-frame-font "Meslo LG L" 't)

;; (set-frame-font "Fixed 18" 't)
;; (set-frame-font "Fixed 20" 't)

;; (set-frame-font "Andale Mono 12")
;; (set-frame-font "Hack" 't) 

;; (set-frame-font "Fixed 14" 't)
;; (set-frame-font "-Misc-Misc Tamsyn-normal-normal-normal-*-20-*-*-*-c-100-iso10646-1" )
;;(set-frame-font "JetBrains Mono 12")

(setq as/kilograms_per_pound 0.454)
(setq as/pounds_per_kilogram (/ 1.0 as/kilograms_per_pound))
(setq as/feet_per_metre 3.28)
(setq as/metres_per_foot (/ 1.0  as/feet_per_metre))

(defun as/stones_to_pounds (stones pounds)
  (+ (* 14 stones) pounds))

(defun as/pounds_to_kilograms (x) ( * x as/kilograms_per_pound))
(defun as/kilograms_to_pounds (x) ( * x as/pounds_per_kilogram))

(global-set-key (kbd "C-<return>") 'yas-expand)
(global-set-key (kbd "M-4") 'ispell-word)
(global-set-key (kbd "M-o") 'ace-window)

;;(global-set-key (kbd "M-p") 'ace-jump-buffer)
(global-set-key (kbd "M-p") 'frog-jump-buffer)
(global-set-key (kbd "M-9") 'frog-jump-buffer)


;;(set-frame-font "Terminus 12")

;;(set-frame-font "Hack 12")
;;(set-frame-font "Bedstead Semicondensed 18")

;; (set-frame-font "Misc Fixed 12")
;;(set-frame-font "Terminus 16")

;; (set-frame-font "Liberation Mono" 't)
;; (set-frame-font "Liberation Mono 12" 't)
;; (set-frame-font "Ubuntu Mono 16" 't)

;; (set-frame-font "Ubuntu Mono 16")
;; (set-frame-font "Consolas" 't)
;; (set-frame-font "Courier New Bold" 't)
;; (set-frame-font "Courier New 20")

;; ΠπðÐþÐσΣ Ж ж Unicode test!! Ꝥ

;; (set-frame-font "-xos4-xos4 Terminus-normal-normal-normal-*-12-*-*-*-c-60-iso10646-1")
;; (set-frame-font "-xos4-xos4 Terminus-normal-normal-normal-*-14-*-*-*-c-80-iso10646-1")
;; (set-frame-font "-xos4-xos4 Terminus-normal-normal-normal-*-16-*-*-*-c-80-iso10646-1")
;; (set-frame-font "-xos4-xos4 Terminus-normal-normal-normal-*-18-*-*-*-c-100-iso10646-1")
;; (set-frame-font "-xos4-xos4 Terminus-normal-normal-normal-*-20-*-*-*-c-100-iso10646-1")
;; (set-frame-font "-xos4-xos4 Terminus-normal-normal-normal-*-22-*-*-*-c-110-iso10646-1")
;; (set-frame-font "-xos4-xos4 Terminus-normal-normal-normal-*-24-*-*-*-c-120-iso10646-1")
;; (set-frame-font "-xos4-xos4 Terminus-normal-normal-normal-*-28-*-*-*-c-140-iso10646-1")
;; (set-frame-font "-xos4-xos4 Terminus-normal-normal-normal-*-32-*-*-*-c-160-iso10646-1")

;; (set-frame-font "-Misc-Misc Tamsyn-normal-normal-normal-*-15-*-*-*-c-80-iso10646-1")
;; (set-frame-font "-Misc-Misc Tamsyn-normal-normal-normal-*-16-*-*-*-c-80-iso10646-1")
;; (set-frame-font "-Misc-Misc Tamsyn-normal-normal-normal-*-20-*-*-*-c-100-iso10646-1")

;; (set-frame-font "Liberation Mono 14")
;; (set-frame-font "Ubuntu Mono 20")

;; (set-frame-font "Misc Fixed 8")
;; (set-frame-font "Misc Fixed 10")
;; (set-frame-font "Misc Fixed 11")
;; (set-frame-font "Misc Fixed 13")
;; (set-frame-font "Misc Fixed 14")
;; (set-frame-font "-misc-fixed-medium-r-normal--14-*-75-75-c-70-iso8859-5")

;; (set-frame-font "-misc-fixed-medium-r-normal--30-*-75-75-c-90-iso8859-8")
;; (set-frame-font "-misc-fixed-medium-r-normal--12-*-75-75-c-90-iso8859-8")
;; (set-frame-font "Misc Fixed 12")
;; (set-frame-font "-Misc-Misc Tamsyn-normal-normal-normal-*-20-*-*-*-c-100-iso10646-1" )
;; (set-frame-font "Inconsolata 15")
;; (set-frame-font "Andale Mono 20")
;;(set-frame-font "Andale Mono 12")

;; Good for coding
;;(set-frame-font "Hack 12")

(require 'compile)
;;(require 'package)


;; Notes on ripgrep https://gist.github.com/pesterhazy/fabd629fbb89a6cd3d3b92246ff29779

(add-to-list 'package-archives '("melpa"     . "http://melpa.org/packages/"))
(add-to-list 'auto-mode-alist '("SConscript" . python-mode))
(add-to-list 'auto-mode-alist '("SConstruct" . python-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
;;(add-to-list 'auto-mode-alist '("\\.hdl\\'" . nand2tetris-mode))

(package-initialize)

(require 'flycheck-clangcheck)
(require 'calfw-org)
;; Clojure-like results when evaluating lisp
(require 'eros)
(eros-mode 1)


(defun clang-format-save-hook-for-this-buffer ()
  "Create a buffer local save hook."
  (add-hook 'before-save-hook
            (lambda ()
              (when (locate-dominating-file "." ".clang-format")
                (clang-format-buffer))
              ;; Continue to save.
              nil)
            nil
            ;; Buffer local hook.
            t))

;; Run this for each mode you want to use the hook.
(add-hook 'c-mode-hook (lambda () (clang-format-save-hook-for-this-buffer)))
(add-hook 'c++-mode-hook (lambda () (clang-format-save-hook-for-this-buffer)))
(add-hook 'glsl-mode-hook (lambda () (clang-format-save-hook-for-this-buffer)))


(add-to-list 'auto-mode-alist '("\\.jsx\\'" . jsx-mode))
(add-to-list 'auto-mode-alist '("\\.restclient\\'" . restclient-mode))

(autoload 'jsx-mode "jsx-mode" "JSX mode" t)

(require 'dash)

(add-hook 'magit-mode-hook
          (lambda ()
            (magit-todos-mode 't)))


(add-hook 'org-mode-hook
          (lambda ()
            ;;(message "Running your org mode hook")
            (auto-fill-mode 't)
            (org-hide-block-all)
            ;;(anki-editor-mode 't)
            (org-superstar-mode 't)
            ;;(define-key org-mode-map (kbd "<f9>") 'kill-capture-buffer-after-anki-push)
            (flyspell-mode 't)))

;; Meh copy/paste. Maybe nicer way of reducing boilerplate
(add-hook 'org-capture-mode-hook
          (lambda ()
            ;;(message "Running your org mode hok")
            (auto-fill-mode 't)
            (flyspell-mode 't)))

;; https://orgmode.org/manual/Breaking-Down-Tasks.html

;; Get parent to switch to done when all children are done
(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook #'org-summary-todo)

(eval-after-load "org-present"
  '(progn
     (add-hook 'org-present-mode-hook
               (lambda ()
                 (org-present-big)
                 (org-display-inline-images)))
     (add-hook 'org-present-mode-quit-hook
               (lambda ()
                 (org-present-small)
                 (org-remove-inline-images)
                 (org-present-show-cursor)
                 (org-present-read-write)))))

(require 'org-inlinetask)

(defun slurp (x)
  "Clojure slurp function. Slurp file X."
  (with-temp-buffer
    (insert-file-contents x)
    (buffer-string)))

(defun spit (fn x)
  "Write file!!"
  (with-temp-buffer
    (insert x)
    (message "Got this far")
    (write-file fn)))

(defun debug-discovery ()
  "Debug the discovery app."
  (interactive)
  (gdb "gdb -i=mi -nx -x /home/andy/discovery.gdbinit"))

(defun debug-guilistener ()
  "Debug the discovery app."
  (interactive)
  (gdb "gdb -i=mi -nx guilistener -x /home/andy/repos/aurora/code/tickserver/src/main/cpp/.gdbinit"))

(global-set-key (kbd "C-x C-o") 'ff-find-other-file)
(global-set-key (kbd "C-=") 'undo)

(defun insert-white-star ()
  (interactive)
  (insert (char-from-name "WHITE STAR")))

(defun insert-black-star ()
  (interactive)
  (insert (char-from-name "BLACK STAR")))

(global-set-key [kp-home] 'neuter-tasks)

(defun as/insert-inactive-time-stamp ()
  (interactive)
  (org-time-stamp-inactive 't))

(global-set-key [kp-begin] 'org-sort-entries)
(global-set-key [kp-left] 'calendar)
(global-set-key [kp-right] 'as/insert-inactive-time-stamp)

(global-set-key [kp-subtract] 'insert-white-star)
(global-set-key [kp-add] 'insert-black-star)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "<menu>") 'helm-M-x)

(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-c C-h C-s") 'helm-swoop)
(global-set-key (kbd "C-c C-h C-l") 'helm-locate)
(global-set-key (kbd "C-c C-h C-o") 'helm-occur)
(global-set-key (kbd "C-c C-h C-a") 'helm-do-ag)
(global-set-key (kbd "C-c C-p C-f") 'parse-fix)
(global-set-key (kbd "C-c C-s C-w") 'ispell-word)

(global-set-key (kbd "C-c C-s C-o") 'switch-to-gtd-org)

(global-set-key (kbd "M-g M-f") 'helm-gtags-find-files)
(global-set-key (kbd "M-g M-t") 'helm-gtags-find-tag)
(global-set-key (kbd "M-g M-r") 'helm-gtags-find-rtag)

(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-b") 'helm-mini)
(global-set-key (kbd "C-x r b") 'helm-bookmarks)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key [f5] 'helm-resume)

(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
(define-key global-map (kbd "C-;") 'ace-jump-mode)


(global-set-key (kbd "C-c C-m C-s" ) 'magit-status)
;; For d
(add-to-list 'compilation-error-regexp-alist
             '("^object\.Exception@\\(.*\\)(\\([0-9]+\\)).*"
               1 2))

;; For d
(add-to-list 'compilation-error-regexp-alist
             '("^core\.exception\.AssertError@\\(.*\\)(\\([0-9]+\\)).*"
               1 2 ) )

;; For node.js
(add-to-list 'compilation-error-regexp-alist
             '("^.*at.*(\\(.*\\):\\([0-9]+\\):.*"
               1 2 ) )1
;; (setq compilation-error-regexp-alist (cdr compilation-error-regexp-alist))

(add-to-list
 'compilation-error-regexp-alist
 '("^\\([^ \n]+\\)(\\([0-9]+\\)): \\(?:Error\\|.\\|warnin\\(g\\)\\|remar\\(k\\)\\)"
   1 2 nil (3 . 4)))

(defun revert-buffer-with-prejudice ()
  (interactive)
  (revert-buffer 't 't))

(global-set-key (kbd "C-c r")  'revert-buffer-with-prejudice)
(add-to-list 'auto-mode-alist '("build\\.gradle" . groovy-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.m$" . octave-mode))

(defun compile-in-own-buffer (buf cmd)
  (interactive)
  (let ((compilation-buffer-name-function (lambda (x) buf) ))
    (compile cmd)))

(add-hook
 'd-mode-hook
 (lambda () 
   (define-key d-mode-map (kbd "<f9>") 'dfmt-buffer)))

(add-hook
 'clojure-mode-hook
 (lambda ()
   (define-key clojure-mode-map (kbd "C-h f") 'cider-doc)))


(add-hook
  'julia-mode-hook
  (lambda ()
    (define-key julia-mode-map (kbd "<f8>") 'reboot-julia)
    (define-key julia-mode-map (kbd "C-c C-c") 'julia-repl-send-buffer)
    (define-key julia-mode-map (kbd "C-c C-r") 'julia-repl-send-region-or-line) ))

(defun python-eval-defun-at-point ()
  (interactive)
  (save-excursion
    (backward-paragraph)
    (setq start (point))
    (forward-paragraph)
    (setq end (point))
    (python-shell-send-region start end)))

(add-hook
'python-mode-hook
 (lambda ()
   (define-key python-mode-map (kbd "C-M-x") 'python-eval-defun-at-point)
   ;;(pyenv-mode)
   ))

(defun compile-box2d ()
  (interactive)
  (compile-in-own-buffer "build box2d debug" "rm -rf ~/box2d_debug && mkdir -p ~/box2d_debug && cd ~/box2d_debug && cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=~/agora_debug/install -G 'Unix Makefiles' ~/repos/Box2D && make VERBOSE=1"))

(defun copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))

(global-set-key (kbd "C-x p") 'copy-file-name-to-clipboard)

(defun do-revert () 
  (interactive) 
  (revert-buffer nil 't))

(require 'dash)
(require 's)
(require 'multiple-cursors)
;;(require 'helm)
(helm-mode 1)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(require 'haskell-interactive-mode)
(require 'haskell-process)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)

;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/Dropbox/gtd/flagged.org")
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")

(require 'projectile)
;; Needed for projectile version 2.0.0 onwards. ( symmetry has a version from 2018 )


(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(projectile-mode +1)

(helm-projectile-on)

(setq helm-autoresize-max-height 0)
(setq helm-autoresize-min-height 20)
(helm-autoresize-mode 1)
(helm-mode 1)

(defun text-scale-smaller ()
  (interactive)
  (text-scale-adjust -1))

(defun text-scale-bigger ()
  (interactive)
  (text-scale-adjust 1))

(global-set-key [XF86AudioPrev] 'text-scale-smaller)
(global-set-key [XF86AudioNext] 'text-scale-bigger)
(global-set-key [XF86AudioPlay] 'text-scale-orig)

(defun text-scale-orig ()
  (interactive)
  (text-scale-adjust 0))

(global-set-key [f1]  'text-scale-bigger)
(global-set-key [f2]  'text-scale-smaller)
(global-set-key [f3]  'text-scale-orig)

(global-set-key [C-S-triple-mouse-4]  'text-scale-bigger)
(global-set-key [C-S-triple-mouse-5]  'text-scale-smaller)

(global-set-key [C-triple-mouse-4]  'scroll-up-one)
(global-set-key [C-triple-mouse-5]  'scroll-down-one)

(defun scroll-up-one ()
  (interactive)
  (save-excursion
    (scroll-up 1)))

(defun scroll-down-one ()
  (interactive)
  (save-excursion
    (scroll-down 1)))

(global-set-key [f5]  'scroll-up-one)
(global-set-key [f6]  'scroll-down-one)

(global-set-key [f4] 'magit-status)
(global-set-key [f5] 'google-this)

(--each (list c-mode-base-map dired-mode-map compilation-mode-map shell-mode-map)
     (define-key it (kbd "<f7>") 'compile) )

;; GC These when happy the above is working.
;; (define-key c-mode-base-map (kbd "<f7>") 'compile)
;; (define-key dired-mode-map (kbd "<f7>") 'compile)
;; (define-key compilation-mode-map (kbd "<f7>") 'compile)

(defun switch-eshell-to-directory ()
  (interactive)
  (let* ( (dir default-directory))
    
    (switch-to-buffer "*eshell*")
    (end-of-buffer)
    (message "dir is %s" dir)
    (insert (format "cd %s" dir))
    (eshell-send-input)
    ))

(defun switch-shell-to-directory ()
  (interactive)
  (let* ( (dir default-directory))
    (switch-to-buffer "*shell*")
    (end-of-buffer)
    (message "dir is %s" dir)
    (insert (format "cd %s" dir))
    (comint-send-input)
    ))

(--each (list compilation-mode-map dired-mode-map)
  (define-key it (kbd "<f9>") 'switch-eshell-to-directory)
  (define-key it (kbd "<f8>") 'switch-shell-to-directory))



(defun bus-from-clipboard ()
  (interactive)
  (temp-bus (x-get-selection 'CLIPBOARD) "CLIPBOARD"))

(defun bus-from-buffer ()
  (interactive)
  (temp-bus (buffer-string) (buffer-name)))

(defun make-results-buffer (my_buffer_name)
  (if (get-buffer my_buffer_name)
      (kill-buffer my_buffer_name))
  (switch-to-buffer (generate-new-buffer my_buffer_name)))


(defun temp-bus (itinerary name)
  "Convert bus itinerary text to Org mode table format."
  (interactive)
  (let* ((ret (s-match-strings-all (concat "\\([0-9][0-9]:[0-9][0-9]\\)[ \n]+\\([0-9X]+\\)[ \n]+\\([^\n]+\\)[ \n]+towards "
                                           "\\([^\n0-9]+\\)\\([0-9]?[0-9]mins\\|\\([0-9]+hr "
                                           "[0-9]?[0-9]mins\\)\\)[ \n]+\\([^\n]+\\)[ \n]*"
                                           "\\(?:Show \\([0-9]+\\) stops\\)?")
                                   itinerary))
         (make-org (-lambda (x) (format "|%s|\n" (s-join "|" x))))
         (ret (-map 'cdr ret))
         (tmp (message "ret=[%s]" ret))
         (headings (s-split " " "Dep Bus Src Dest Time Time2 Arr Stops"))
         (killlist '("Time2" "Stops"))
         (kill-indices (--map (-elem-index it headings) killlist))
         ;; (tmp (message "killindices=[%s]" kill-indices))
         (drop (-lambda (x) (-remove-at-indices kill-indices x)))
         (headings    (funcall drop headings))
         (strHeading  (funcall make-org headings))
         (header-line (funcall make-org (--map (s-repeat 10 "-" ) headings)))
         (ret (--map (funcall drop it) ret))
         (str-bits (--map (funcall make-org it) ret))
         (bufname (buffer-name)))
    ;;(s-join "\n" ret)
    (make-results-buffer (format "BUS_%s" name))
    (org-mode)
    (insert header-line)
    (insert strHeading)
    (insert header-line)
    (insert (s-join "" str-bits))
    (insert header-line)
    (insert "\n\n")
    ;; (insert (format "strbits=%s\nstrHeading=%s\nret1=%s" str-bits strHeading ret1))
    (beginning-of-buffer)
    (org-cycle)))


(global-set-key (kbd "C-c f") 'format-bus-itinerary)
(global-set-key (kbd "C-c f") 'format-bus-itinerary)


(require 'python)
;; (global-set-key [f8]  'reboot-python)
(define-key python-mode-map (kbd "<f8>")  'reboot-python)

;;(global-set-key [f9]  'py-execute-region)
(define-key python-mode-map (kbd "<f9>") 'py-execute-region)

;; For scons
(define-key python-mode-map (kbd "<f7>")  'compile)
;;(define-key cpp-mode-map (kbd "<f7>")  'compile)


(global-set-key [f9]  'anki-mode-menu)
;;(global-set-key [f10] 'clang-format-buffer)

;; (global-set-key [f10] 'switch-to-shell)
(global-set-key [f10] 'clang-format-buffer)
(global-set-key [f12] 'avy-goto-char)
(global-set-key [f12] 'imenu)


;;(global-set-key (kbd "M-SPC") 'ace-jump-mode)
(global-set-key (kbd "M-SPC") 'avy-goto-char)
;;(global-set-key [f1] 'wg-switch-to-workgroup)
(global-set-key (kbd "C-c o") 'ff-find-other-file)
(global-set-key (kbd "C-c f") 'find-file-at-point)
(global-set-key (kbd "C-M-g") 'dumb-jump-go)

(nyan-mode 't)

(defun format-number-with-separator (number &optional separator)
  "Format NUMBER with a specified SEPARATOR as thousands separators.
If SEPARATOR is not provided, it defaults to a comma."
  (let ((sep (or separator ","))
        (num-str (number-to-string number)))
    (when (string-match "\\`-?[0-9]+\\'" num-str)
      ;; Add separator in groups of three digits from the end.
      (while (string-match "\\([0-9]+\\)\\([0-9]\\{3\\}\\)" num-str)
        (setq num-str (replace-match (concat "\\1" sep "\\2") t nil num-str)))
      num-str)))


(defun dump-fonts ()
  (interactive) 
  (let* ((bufferName (format "fonts_%s.el" (system-name) ) ) 
         (fileName (format "%s/%s" (getenv "HOME")  bufferName) ))
    (switch-to-buffer bufferName)
    (erase-buffer)
    (mapc (lambda (x) (insert (format "(set-frame-font \"%s\" )\n"  x) ) )  (x-list-fonts "*") )
    (mark-whole-buffer)
    (sort-lines nil (point-min) (point-max))
    (write-file fileName )
    (kill-buffer bufferName)
    (message (format "Saved %s ... " fileName))))


(defun org-sort-multi (&rest sort-types)
  "Sort successively by a list of criteria, in descending order of 
importance.
For example, sort first by TODO status, then by priority, then by date, 
then alphabetically, case-sensitive.
Each criterion is either a character or a cons pair (BOOL . CHAR), where 
BOOL is whether or not to sort case-sensitively, and CHAR is one of the 
characters defined in ``org-sort-entries-or-items''.
So, the example above could be accomplished with:
  (org-sort-multi ?o ?p ?t (t . ?a))"
  (interactive)
  (mapc #'(lambda (sort-type)
            (when (characterp sort-type) (setq sort-type (cons nil 
							       sort-type)))
            (org-sort-entries (car sort-type) (cdr sort-type)))
        (reverse sort-types)))

(defun org-sort-custom ()
  "Sort children of node by todo status and by priority and by date, so 
the * TODO [#A] items with latest dates go to the top."
  (interactive)
  (org-sort-multi ?o ?p ?T))


(defun org-sort-schedule ()
  "Sort children of node by todo status and by priority and by date, so 
the * TODO [#A] items with latest dates go to the top."
  (interactive)
  (org-sort-multi ?T))


(defun org-sort-time ()
  "Sort children of node by todo status and by priority and by date, so 
the * TODO [#A] items with latest dates go to the top."
  (interactive)
  (org-sort-multi ?T))

;; Speed of light calculations
(setq as/tera 1e12)
(setq as/nanometer 1e-9)
(setq as/c 3e8) 

(defun  frequency-to-nanometres (f)
  (/ as/c f as/nanometer))

;; (frequency-to-nanometres (* 430 as/tera)) 697.6744186046511
;; (frequency-to-nanometres (* 750 as/tera)) 399.99999999999994


(defun switch-to-notes ()
  (interactive)
  (switch-to-buffer "gtd.org"))

(defun switch-to-shell () 
  (interactive)
  (switch-to-buffer "*shell*"))

;;(windmove-default-keybindings 'meta)

;; (elpy-enable)
(defun plist-to-alist (the-plist)
  (defun get-tuple-from-plist (the-plist)
    (when the-plist
      (cons (car the-plist) (cadr the-plist))))
  (let ((alist '()))
    (while the-plist
      (add-to-list 'alist (get-tuple-from-plist the-plist))
      (setq the-plist (cddr the-plist)))
    alist))


;;(windmove-default-keybindings 'meta)

(defun reboot-python ()
  "Reboot python."
  (interactive)
  (save-current-buffer
    ;; Disable querying while we delete.
    (let (kill-buffer-query-functions '())
      (if (get-buffer "*Python*") (kill-buffer "*Python*"))
      (if (get-buffer "*Jython*") (kill-buffer "*Jython*")))
    (run-python)
    (python-shell-switch-to-shell)))

(defun reboot-julia ()
  "Reboot julia"
  (interactive)
  (save-current-buffer
    ;; Disable querying while we delete.
    (let (kill-buffer-query-functions '())
      (if (get-buffer "*julia*") (kill-buffer "*julia*")))
    (julia-repl)))


(defun reboot-nodejs ()
  "Reboot node."
  (interactive)
  (save-current-buffer
    (let (kill-buffer-query-functions '())
      (if (get-buffer "*nodejs*")
          (kill-buffer "*nodejs*")))))

;;   (sit-for 1)
;;   (nodejs-repl-switch-to-repl)))

;; (save-current-buffer
;;   (sit-for 1)
;;   (nodejs-repl-send-buffer)))

(defun temp ()
  (interactive)
  (let* (proc (nodejs-repl--get-or-create-process))
    (message "proc is %s" proc)))

(defun unfill-paragraph (&optional region)
  "Takes a multi-line paragraph ( REGION ) and make it into a single line of text."
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max)))
    (fill-paragraph nil region)))

(global-set-key (kbd "M-Q") 'unfill-paragraph)

;;(global-set-key (kbd "C-c C-h C-g C-i" ) 'insert-hg-ignore)

(defun refresh-kanban ()
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (next-line)
    (next-line)
    (org-ctrl-c-ctrl-c)))
;;(global-set-key [f7]  'refresh-kanban)


(require 'workgroups2)
;;(setq wg-prefix-key (kbd "C-c w"))
;; (setq wg-file "~/wg.el")
;; (workgroups-mode 1)
;;(wg-load wg-file)


(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)


(setq-default indent-tabs-mode nil)

(require 'slime-autoloads)
(slime-setup '(slime-fancy))
(require 'ac-slime)
(add-hook 'slime-mode-hook      'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
;;(eval-after-load "auto-complete"
;;  '(add-to-list 'ac-modes 'slime-repl-mode))

(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.ice$" . idl-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))


(global-set-key (kbd "C-x C-x") 'expand-abbrev)

(setq inferior-lisp-program "/usr/bin/sbcl")

(require 'org)
(setq org-default-notes-file (concat org-directory "~/repos/gtd/gtd.org"))
(define-key global-map "\C-cc" 'org-capture)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(global-set-key (kbd "C-c s") 'ispell)
(global-set-key (kbd "C-c r") 'revert-buffer-with-prejudice)

(with-eval-after-load 'flycheck
  (add-hook 'flycheck-mode-hook #'flycheck-pycheckers-setup))

(require 'semantic)

(setq helm-semantic-fuzzy-match t
      helm-imenu-fuzzy-match    t)

;; TODO - These two broken I think . Problem with the lambda
(defun compile-in-buffer (cmd buf)
  (interactive)
  (let* ((compilation-buffer-name-function (lambda (x) buf) ) )
    (compile cmd)))

(defun compile-dev ()
  (interactive)
  (compile-in-buffer "cd ~/repos/dev/cpp && scons" "dev"))

(defun compile-asteroids ()
  (interactive)
  (compile-in-buffer "cd ~/repos/sdl/asteroids && scons" "asteroids"))

(setq helm-dash-common-docsets '("org.libsdl.sdl20" "C++" "Boost"))

(defun new-scratch  ()
  (interactive)
  (switch-to-buffer (generate-new-buffer "*scratch*")))

(global-set-key [kp-begin] 'new-scratch)

(defun paste-to-temp-buffer ()
  (interactive)
  (switch-to-buffer (generate-new-buffer "temp"))
  (yank))
(global-set-key [kp-end] 'paste-to-temp-buffer)

(defun parse-epoch-time (s)
  "Parse symbol into an epoch time. Use heuristics to determine if dealing
   with micros, seconds, nanos etc. Display result using
   'message' if successful"
  (cond ((stringp s)
        (let* ((x (float (string-to-number s))) ;; Non number parses to zero
               (unix-epoch-year 1970)
               (seconds-per-day (* 24 60 60))
               (seconds-per-year (* 365.25 seconds-per-day))
               (is-in-range? (-lambda ((handy-prefix . tenth-power))
                               (let* ((divisor (expt 10 tenth-power))
                                      (seconds-since-unix-epoch (/ x divisor))
                                      (maybe-year? (+ unix-epoch-year
                                                      (/ seconds-since-unix-epoch seconds-per-year))))
                                 (when (< 1980 maybe-year? 2100)
                                   (cons seconds-since-unix-epoch handy-prefix)))))
               (success? (-some is-in-range? '(("s"  . 0)
                                               ("ms" . 3)
                                               ("µs" . 6) 
                                               ("ns" . 9)))))
          (-if-let ((seconds-since-unix-epoch . handy-prefix) success?)
              (message (format "%s (%s) -> %s" x
                               handy-prefix
                               (format-time-string
                                "%Y-%m-%dT%H:%M:%S.%N"
                                (seconds-to-time seconds-since-unix-epoch)))))))))

;; (parse-epoch-time "1482672627") 
;; (parse-epoch-time "1482672627.025747002") 
;; (parse-epoch-time "1482672627025.747023")   
;; (parse-epoch-time "1482672627025747.032")  
;; (parse-epoch-time "1482672627025747023") 

(defun parse-epoch-time-at-point ()
  "Have a go at parsing a 'x-since-epoch' timestamp from the current point"
  (interactive)
  (parse-epoch-time (thing-at-point 'symbol)))
(global-set-key (kbd "C-c C-p C-t") 'parse-epoch-time-at-point)

(defun my-epoch-parser-idle-function ()
  "Run `my-hover-function` if Emacs is idle."
  (when (not (input-pending-p))  ; Check if there's no pending input
    (parse-epoch-time-at-point)))

(run-with-idle-timer 1.0 t 'my-epoch-parser-idle-function)

(defun int-limits ()
  "Print the maximum and minimum values for 32-bit signed and unsigned integers."
  (let ((signed-max (1- (expt 2 31)))
        (signed-min (- (expt 2 31)))
        (unsigned-max (1- (expt 2 32)))
        (unsigned-min 0))

   (format "\n;; 64-bit Signed Integer Range: %s to %s\n;; 64-bit Unsigned Integer Range: %s to %s" signed-min signed-max unsigned-min unsigned-max)))


(defun int64-limits ()
  "Print the maximum and minimum values for 64-bit signed and unsigned integers."
  (let ((signed-max (1- (expt 2 63)))
        (signed-min (- (expt 2 63)))
        (unsigned-max (1- (expt 2 64)))
        (unsigned-min 0))
    (format ";;\n;; 64-bit Signed Integer Range: %s to %s\n;; 64-bit Unsigned Integer Range: %s to %s" signed-min signed-max unsigned-min unsigned-max)))


;; Experiment - ( rough) capture timestamps with current-time in emacs
;; and time.time() in python. Reverse engineer the time value in python
;; Six seconds apart - think that's how long it took me :-)

;;In [76]: time.time()
;;Out[76]: 1710215086.2924154t

;;(current-time) (26095 53160 665501 998000)

;;In [78]: (26095 << 16) + 53160
;;Out[78]: 1710215080

;; Even better - ( proper bit masks)

;; In [93]: (26095 << 16) | 53160 & ((1 << 16) - 1 )
;; Out[93]: 1710215080

;; ( - 1710215080 1710215086.2924154) -6.292415380477905

(require 'dash)

(defun purge-undo-trees ()
  (interactive)
  (let* ((gitroot (get-git-root))
         (ret (shell-command-to-string (format "find %s -name '*~undo-tree~'" gitroot)))
         (files (s-split "\n" ret)))
    (message "files is [%s]" files)
    (-each files (-lambda (fn)
                   (message "deleting " fn)
                   (f-delete fn)
                   ))))



(defun get-git-root ()
  (interactive)
  (let ((dd (expand-file-name default-directory))
        (ret (string-trim (shell-command-to-string
                           "git rev-parse --show-toplevel"))))
    (message "default dir is %s" dd)
    ret))

;; (get-git-root) 
(defun peek-flycheck (arg)
  (message "args are %s" arg)
  (s-join " " arg))

(defun common-aurora-python-dir ()
  (format "%s/code/common/src/main/python" (get-git-root)))


(defun checksingular (x)
  (unless (= (length x) 2) (error "No single result"))
  x )

(require 'shadchen)
(defun find-aurora ()
  (--> (shell-command-to-string "locate --regex aurora/.git$")
       (s-trim it)
       (s-split "\n" it)
       (-filter 'f-dir? it)
       (-remove 's-blank? it)
       (match it
         ((list x) x)
         (_ (error "No unique match for filtered results '%s'" it)))))

;;(find-aurora) 

; (setq foo '("woot")) }
; (setq foo '("woot" "toot")) }
; (package-install 'dash-functional) }
; (require 'shadchen) }
; (match foo }
;   ((list x) x) }
;   ) }
;; (--map (s-split "\n" it) it)
;; (-map (lambda (x) (format "%s/.git" x) it)
;; (progn (message "%s" it) it)
;; (--map (s-split "\n" it) (list "foo\ngoo" "bar\nsue"))
;; (funcall (lambda (x) (f-dir? (format "%s/.git" x))) "/home/andy/repos/randomcpp")



(defun add-to-path (orig to-add)
  (->> (--if-let orig (format "%s:%s" it to-add) to-add) 
       (s-split ":")
       (-distinct)
       (s-join ":")))


(defun remove-from-path (orig to-remove)
  (->> (--if-let orig (format "%s:%s" it to-remove) to-remove)
       (s-split ":")
       (-distinct)
       (remove to-remove)
       (s-join ":")))

(setq p "foo:bar:baz:banana")
(setq p (add-to-path p "gaz!"))
(setq p (remove-from-path p "baz"))
(setq p (remove-from-path p "gaz!"))

(defun add-aurora-pythonpath ()
  (interactive)
  (let* ((env-var "PYTHONPATH")
         (new-dir (common-aurora-python-dir))
         (new-path (add-to-path (getenv env-var) new-dir)))
    (message "New %s is %s" env-var new-path)
    (setenv env-var new-path)
    (setenv "AURORA_ROOT"  (get-git-root))))

;; (getenv "AURORA_ROOT")

(defun remove-aurora-pythonpath ()
  (interactive)
  (let* ((env-var "PYTHONPATH")
         (old-dir (common-aurora-python-dir))
         (path (remove-from-path (getenv env-var old-dir))) )
    (message "New %s is %s" env-var path)
    (setenv env-var path)))

(defun parse-sbe ()
  (interactive)
  (save-excursion
    (let ((sum 0)
          (size-alist '(("int64"        . 8 )
                        ("float"        . 4 )
                        ("double"       . 8 )
                        ("orderType"    . 1 )
                        ("responseType" . 1 )
                        ("side"         . 1 )
                        ("uint32"        . 4 )
                        ("int32"        . 4 ))))
      (message "%s" (re-search-backward "<sbe\:message"))
      (beginning-of-line)
      (forward-line)
      (while (not (re-search-forward "</sbe\:message>" (line-end-position) t) )
        (let* ((current-line (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
               (ign (message "Current line is %s" current-line))
               (match-first (lambda (re errMsg)
                              (string-match re current-line)
                              (let ((ret (match-string 1 current-line)))
                                (unless ret
                                  (error errMsg))
                                ret)))
               (name (funcall match-first "name=\\\"\\([^\\\"]+\\)\\\"" "Cant find name"))
               (type (funcall match-first "type=\\\"\\([^\\\"]+\\)\\\"" "Cant fine type"))
               (size (let ((initSize (assoc type size-alist )))
                       (unless initSize 
                         (error (format "Can't find size for type '%s' in -- \n'%s'\n*** Fix 'sizes-alist in parse-sbe ****" type current-line)))
                       (cdr initSize)))
               (newSum (+ sum size))
               (trailing (mod sum size))
               (misalign (not (zerop trailing)))
               (status (if misalign "ERR" "OK"))
               (message (format " <!-- %2d + %2d = %2d %3s %s-->" sum size newSum status trailing)))
          (setq sum newSum)
          (search-forward "/>" (line-end-position))
          (insert message)
          (when (< (point) (line-end-position))
            (kill-line))
          (forward-line))))))


(load "~/.emacs.d/tags.el")
;;(load "~/.emacs.d/org_archive.el")


;;(global-set-key  [f7] 'get-tag-counts)

(defun get-tag-counts ()
  "Reimplementation in a more functional style. Not sure if I succeeded"
  (interactive)
  (let ((buffer-name (format "TAG COUNTS for %s" (buffer-name)))
        (count 0)
        (all-tags (make-hash-table :test 'equal)))
    (org-map-entries
     (lambda ()
       (let* ((tag-string (car (last (org-heading-components))))
              (tag-string (if tag-string  tag-string ""))
              (bits (->> tag-string
                         (s-split  ":")
                         (-remove 's-blank-str?))))
         (setq count (1+ count))
         (-each bits (lambda (x) (puthash x (1+ (gethash x all-tags 0)) all-tags))))))
    ;;(message "hash is %s" all-tags)
    (let* ((all-pairs (list))
           (ign (maphash (lambda (x y) (push (cons x y) all-pairs)) all-tags))
           (all-pairs (-sort (lambda (x y) (> (cdr x) (cdr y))) all-pairs)))
      ;;(ign (message "Pairs is %s" (length sorted))))
      (if (get-buffer buffer-name)
          (kill-buffer buffer-name))
      (switch-to-buffer-other-window (generate-new-buffer buffer-name))
      (insert (format "%s tags\n\n" count))
      (-each all-pairs (lambda (x) (insert (format "%20s : %3d\n" (car x) (cdr x)))))
      (beginning-of-buffer))))
(define-key org-mode-map  (kbd "<f7>") 'get-tag-counts)
(define-key org-mode-map  (kbd "<f9>") 'org-display-outline-path)




(defun my-outline-path ()
  (interactive)
  (message (s-join " > " (org-get-outline-path))))

(define-key org-mode-map  (kbd "<f10>") 'my-outline-path)

(defun my/org-archive-subtree-preserve-structure ()
  "Archive the current subtree while preserving its hierarchical structure in the archive file."
  (interactive)
  (let* ((org-archive-location (or (org-entry-get nil "ARCHIVE" t)
                                   org-archive-location))
         (archive-file (car (org-split-string org-archive-location "::")))
         (archive-buffer (find-file-noselect archive-file))
         (current-path (org-get-outline-path t)) ; Get hierarchical path as a list
         (subtree-text (org-get-subtree)))
    ;; Remove subtree from the current file
    (org-cut-subtree)
    (with-current-buffer archive-buffer
      ;; Navigate to or create the appropriate hierarchy in the archive file
      (goto-char (point-min))
      (dolist (heading current-path)
        (unless (re-search-forward
                 (format org-complex-heading-regexp-format (regexp-quote heading))
                 nil t)
          ;; If heading doesn't exist, create it
          (goto-char (point-max))
          (unless (bolp) (insert "\n"))
          (org-insert-heading)
          (insert heading))
        (org-narrow-to-subtree)) ; Narrow to keep searching within the subtree
      (widen) ; Exit narrowed view before pasting
      ;; Move to the correct location and paste the subtree
      (goto-char (point-max))
      (unless (bolp) (insert "\n"))
      (insert subtree-text))
    ;; Save changes in the archive file
    (with-current-buffer archive-buffer
      (save-buffer))))



(defun org-get-subtree ()
  "Return the text of the current subtree as a string."
  (save-restriction
    (org-narrow-to-subtree)
    (buffer-substring-no-properties (point-min) (point-max))))




(defun get-heading-counts ()
  "Reimplementation in a more functional style. Not sure if I succeeded"
  (interactive)
  (let ((buffer-name "HEADING COLLISION COUNTS")
        (all-headings (make-hash-table :test 'equal))
        (top-level-headings (make-hash-table :test 'equal))
        (count 0)
        )
    (org-map-entries
     (lambda ()
       (let* ((heading (nth 4  (org-heading-components)))
              (level (nth 0  (org-heading-components)))
              ;;(urg (message "Heading is %s" heading))
              )
         (setq count (1+ count))
         (puthash heading (1+ (gethash heading all-headings 0)) all-headings)
         (if (= level 1)
             ;; (if 't
             (puthash heading (1+ (gethash heading top-level-headings 0)) top-level-headings)))))
    (let* ((all-pairs (list))
           (ign (maphash (lambda (x y) (push (cons x y) all-pairs)) all-headings))
           (all-pairs (-sort (lambda (x y) (> (cdr x) (cdr y))) all-pairs))
           (all-pairs2 (-filter (lambda (pair)
                                  ;;(message "key is %s -> %s" (car pair) (gethash (car pair) top-level-headings))
                                  (> (gethash (car pair) top-level-headings 0 ) 1))
                                all-pairs))
           )
      (if (get-buffer buffer-name)
          (kill-buffer buffer-name))
      (switch-to-buffer-other-window (generate-new-buffer buffer-name))
      (insert (format "%s collisions\n\n" (length all-pairs2)))
      (-each all-pairs2 (lambda (x) (insert (format "%20s : %3d\n" (car x) (cdr x)))))
      (beginning-of-buffer))))


(defun my-org-sort-custom
    (interactive)
  (org-sort-custom)
  (org-cycle))

(define-key org-mode-map  (kbd "<f8>") 'get-heading-counts)
(define-key org-mode-map  (kbd "<f10>") 'my-org-sort-custom)



(defun parse-fix ()
  "Parse a fix message at point, display result in a 'FIX' buffer"
  (interactive)
  (let* ((msg (thing-at-point 'line))
         (parsed (->> msg
                      (string-match "8=FIX.*")
                      (substring msg)
                      (s-split "")
                      (--map (s-split "=" it))       ;; Split into pairs
                      (--filter (= (length it) 2))   ;; reject non-pair pairs
                      (--map (apply 'cons it))       ;; turn into cons cells forconvenience (list a b ) -> (a . b)
                      (-map (-lambda ((tag_value &as tag . value))
                              (list (gethash tag tags-hash) tag
                                    (--if-let (gethash tag_value enums-hash) (format "%s (%s)" value it) value))))
                      ;; (-map (-lambda (x) (message "%s" x) x))
                      (--map (apply 'format "%20s : %4s = %-10s" it))
                      (s-join "\n"))))
    (make-results-buffer "FIX")
    (insert (format "\n%s\n==========================\n\n%s" msg parsed))
    (beginning-of-buffer)))

(global-set-key [f11] 'parse-fix)
;; 8=FIX.4.29=16335=D34=97249=TESTBUY352=20190206-16:25:10.40356=TESTSELL311=14163685067084226997921=238=10040=154=155=AAPL60=20190206-16:25:08.968207=TO6000=TEST123410=106"  

;;(global-set-key [f3] 'parse-fix)

;;(frog-menu-read "Select option: " '("Option1" "Option2" "Option3"))



(defun flyspell-correct-using-frog-menu ()
  (interactive)
  (let* ((corrections (flyspell-correct-word-generic))
         (choice (frog-menu-read "Correct with: " corrections)))
    (when choice
      (flyspell-do-correct 'save choice nil (point) (point)))))

(defun wu (fmt x)
  (message fmt x)
  x)

;; Fixed !!!
;; Hmmm - not quite fixed still inserts leading comma when num digist is 3*n
(defun commify (s)
  (->>
   s
   (format "%s")
   (s-reverse)
   (s-split "")
   (cdr)
   (-partition-all 3)
   (-interpose '(","))
   (-flatten)
   (s-join "")
   (s-reverse)))


;; Execute either of these progn forms to switch between python2/3
(if nil
    (progn
      (set-variable 'python-shell-interpreter "ipython2")
      (set-variable 'flycheck-python-pylint-executable "pylint2")
      (set-variable 'flycheck-python-pyflakes-executable "pyflakes-python2")))

(if nil
    (progn (set-variable 'python-shell-interpreter "ipython")
           (set-variable 'flycheck-python-pylint-executable "pylint")
           (set-variable 'flycheck-python-pyflakes-executable "pyflakes")))

(defun daysBetween (s f)
  (let* ((seconds-per-day ( * 24 60 60 ))
         (conv (lambda (x)
                 (let ((bits (mapcar 'string-to-number (split-string x "-"))))
                   (apply 'encode-time (list 0 0 0
                                             (nth 2 bits)
                                             (nth 1 bits)
                                             (nth 0 bits))))))
         (st (funcall conv s))
         (ft (funcall conv f)))
    (/ (time-to-seconds (time-subtract ft st)) seconds-per-day)))
;; (daysBetween "1973-05-09" "2023-05-16") 18269.0

(eval-after-load 'company
  '(progn
     (define-key company-mode-map (kbd "C-:") 'helm-company)
     (define-key company-mode-map (kbd "M-/") 'company-complete)
     (define-key company-active-map (kbd "C-:") 'helm-company)))

(add-to-list 'exec-path "/home/andy/bin")
(add-to-list 'exec-path "/home/andy/.sdkman/candidates/leiningen/current/bin")
(add-to-list 'exec-path "/home/andy")
(add-to-list 'exec-path "/home/andy/.pyenv/shims")


(autoload 'utop-minor-mode "utop" "Minor mode for utop" t)
(add-hook 'tuareg-mode-hook 'utop-minor-mode)

(load "auctex.el" nil t t)

(eval-after-load 'lisp-interaction
  (progn
    (message "Adding to lisp interaction mode")
    (define-key lisp-interaction-mode-map (kbd "C-c C-c") 'eval-defun)
    (define-key lisp-mode-map (kbd "C-c C-c") 'eval-defun)))

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (define-key emacs-lisp-mode-map (kbd "C-c C-r") 'eval-region)
            (define-key emacs-lisp-mode-map (kbd "C-c C-c") 'eval-defun)))

(add-hook 'tuareg-mode-hook
          (lambda ()
            (define-key tuareg-mode-map (kbd "C-c C-c") 'tuareg-eval-buffer)))

(require 'cider-mode)
(add-hook 'cider-mode-hook
          (lambda ()
            (define-key cider-mode-map (kbd "C-c C-r") 'cider-eval-region))
          (define-key cider-mode-map (kbd "C-c C-c") 'cider-eval-defun-at-point))

(eval-after-load 'octave '(progn
                            (define-key octave-mode-map (kbd "C-c C-c") 'octave-send-buffer)
                            (define-key octave-mode-map (kbd "C-c C-r") 'octave-send-region)
                            (define-key octave-mode-map (kbd "C-c C-p") 'run-octave)
                            (define-key octave-mode-map (kbd "<f8>") 'run-octave)))

(eval-after-load 'hy-mode '(progn
                             (define-key hy-mode-map (kbd "C-c C-c") 'hy-shell-eval-buffer)
                             (define-key hy-mode-map (kbd "C-c C-r") 'hy-shell-eval-region)))

(eval-after-load 'nodejs-repl
  '(progn
     (define-key js2-mode-map (kbd "C-c C-r") 'nodejs-repl-send-region)
     (define-key js2-mode-map (kbd "C-c C-c") 'nodejs-repl-send-buffer)
     (define-key js2-mode-map [f8] 'reboot-nodejs)))

(add-hook 'js2-mode-hook
          (lambda ()
            (define-key js2-mode-map (kbd "C-x C-e") 'nodejs-repl-send-last-expression)
            (define-key js2-mode-map (kbd "C-c C-r") 'nodejs-repl-send-region)
            (define-key js2-mode-map (kbd "C-c C-l") 'nodejs-repl-load-file)
            (define-key js2-mode-map (kbd "C-c C-p") 'nodejs-repl)
            (define-key js2-mode-map (kbd "C-c C-z") 'nodejs-repl-switch-to-repl)))

(require 'ob-python)
(require 'ob-octave)
(require 'ob-scala)

;; Want to have inline images displayed after executing a block of python code
(advice-add 'org-babel-execute-src-block :after (lambda (&rest args)
                                                  (message "Display images %s" (length args))
                                                  (org-display-inline-images)))

;; There was a place before time where undo tree didn't exist
(require 'undo-tree)
;;(global-undo-tree-mode)

;; Add a cc-mode style for editing LLVM C and C++ code
(c-add-style "llvm.org"
             '("gnu"
	       (fill-column . 80)
	       (c++-indent-level . 4)
	       (c-basic-offset . 4)
	       (indent-tabs-mode . nil)
	       (c-offsets-alist . ((arglist-intro . ++)
				   (innamespace . 0)
				   (member-init-intro . ++)))))

;; Files with "llvm" in their names will automatically be set to the
;; llvm.org coding style.
(add-hook 'c-mode-common-hook
	  (function
	   (lambda nil 
	     (if (string-match "llvm" buffer-file-name)
		 (progn
		   (c-set-style "llvm.org"))))))

(require 'dash)
(require 's)

;; Hmmm - the second version is more SIL like but
;; I think the first one is a lot more readable.
(defun convert-fitbit-weight-row-to-org ()
  (interactive)
  (-let* ((line (thing-at-point 'line))
          (bits (s-split "[,-]" line))
          ((day month year weight kilos bmi fat) (--map (string-to-number (s-replace "\"" "" it)) bits))
          ((isofmt) (list (format-time-string "[%Y-%m-%d %a]" (encode-time (list 0 0 0 day month year 0 nil 0 ))))))
    (beginning-of-line)
    (kill-line)
    (insert (format " | # | %s | %.2f | | | Aria |" isofmt weight) )
    (beginning-of-line)
    (next-line)))

(defun convert-fitbit-weight-row-to-org ()
  (interactive)
  (-let* (((day month year weight kilos bmi fat)
           (s-with (thing-at-point 'line)
		   (s-split "[,-]")
		   (--map (s-with it (s-replace "\"" "") (string-to-number))))))
    (beginning-of-line)
    (kill-line)
    (--> (encode-time (list 0 0 0 day month year 0 nil 0 ))
	 (format-time-string "[%Y-%m-%d %a]" it)
	 (format " | # | %s | %.2f | | | Aria |" it weight)
	 (insert it))
    (beginning-of-line)
    (next-line)))
(global-set-key [kp-up] 'convert-fitbit-weight-row-to-org)

(global-set-key [kp-down] 'helm-org-rifle-occur-current-buffer)

(defun end-of-sml (a b &rest xs)
  "A Im interactive."
  (interactive)
  (switch-to-buffer "*SML*")
  (end-of-buffer))

(defun move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(defun move-line-down ()
  "Move down the current line."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))

(global-set-key [(control shift up)]  'move-line-up)
(global-set-key [(control shift down)]  'move-line-down)

(global-set-key [(control shift up)]  'move-line-up)
(global-set-key [(control shift down)]  'move-line-down)

(setq work-agenda-file "/home/andy/Dropbox/gtd/work.org")

(defun agenda-schedule ()
  (interactive)
  (org-store-new-agenda-file-list '("/home/andy/repos/gtd/journal.org" "/home/andy/repos/gtd/gtd.org" "/home/andy/repos/gtd/robbins/ania/ania.org")))


(defun agenda-lagrange ()
  (interactive)
  (org-store-new-agenda-file-list '("/home/andy/Dropbox/drewritchie/the_lagrange.org")))

(defun add-work-to-agenda-files ()
  (interactive)
  (org-store-new-agenda-file-list (add-to-list 'org-agenda-files work-agenda-file))
  (message "work added %s" org-agenda-files))
(global-set-key [kp-home] 'add-work-to-agenda-files)

(defun remove-work-from-agenda-files ()
  (interactive)
  (org-remove-file work-agenda-file)
  (message "work removed %s" org-agenda-files))
(global-set-key [kp-prior] 'remove-work-from-agenda-files)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(frog-menu-actions-face ((t nil)))
 '(frog-menu-posframe-background-face ((t (:background "navy")))))

(provide 'init.el)
;;; init.el ends here

(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'downcase-region 'disabled nil)

;; Maybe don't need this
(setq org-my-anki-file "~/anki.org")

(defun nthroot (n k )
  "Calculate the kth root of n"
  (expt k (/ (log n k) k )) )

;; (nthroot 81 4 ) 3.0000000000000004
;; (nthroot 9 2 ) 3.0
;; (nthroot 144 2) 12.0
;; (nthroot 100 2) 9.999999999999998
;;(nthroot 1000 3) 9.999999999999998

(defun as/danger  (x)
  "Warning function"
  ;;(message "Danger %s" x )
  (if (< 1 x) "danger!!" ""))

;; https://stackoverflow.com/questions/51006855/open-mp4-files-from-orgmode
(require 'openwith)
(openwith-mode t)
(setq openwith-associations '(("\\.mp4\\'" "vlc" (file))))

;; Crypt stuff.
(require 'org-crypt)
(org-crypt-use-before-save-magic)

;; FIX ME!
;;(setq org-crypt-tag-matcher "_crypt")

(setq org-tags-exclude-from-inheritance '("crypt"))





;; Define a variable to store the last symbol
(defvar my-last-hovered-symbol nil)

;; Stuff I got from chatgpt

;; Define the custom hover function
;; (defun my-hover-function ()
;;   "Custom function to be called when hovering over a symbol."
;;   (let ((symbol (thing-at-point 'symbol)))
;;     (when (and symbol (not (equal symbol my-last-hovered-symbol)))
;;       (setq my-last-hovered-symbol symbol)
;;       (message "Hovered over symbol: %s" symbol))))

;; Function to run `my-hover-function` on idle
;; (defun my-hover-idle-function ()
;;   "Run `my-hover-function` if Emacs is idle."
;;   (when (not (input-pending-p))  ; Check if there's no pending input
;;     (my-hover-function)))

;; ;; Enable the hover function by setting up an idle timer
;; (defun enable-my-hover-function ()
;;   "Enable custom hover function."
;;   (interactive)
;;   (run-with-idle-timer 5.0 t 'my-hover-idle-function)
;;   )






;; Add the hover function to programming modes
;;(add-hook 'prog-mode-hook 'enable-my-hover-function)


(require 'cl-lib)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(LaTeX-command "latex -shell-escape")
 '(browse-url-browser-function 'browse-url-chrome)
 '(browse-url-firefox-program "firedragon")
 '(c-basic-offset 4)
 '(case-fold-search t)
 '(cfw:display-calendar-holidays nil)
 '(chess-images-separate-frame nil)
 '(clang-format-executable "clang-format")
 '(company-clang-arguments nil)
 '(compilation-message-face 'default)
 '(custom-enabled-themes '(tron-legacy))
 '(custom-safe-themes
   '("c1577851d2c83199092f5e9239ea523661812e4eb2d7719844ca55c295cf0b27" "1a1ac598737d0fcdc4dfab3af3d6f46ab2d5048b8e72bc22f50271fd6d393a00" "ff24d14f5f7d355f47d53fd016565ed128bf3af30eb7ce8cae307ee4fe7f3fd0" "2e05569868dc11a52b08926b4c1a27da77580daa9321773d92822f7a639956ce" "be84a2e5c70f991051d4aaf0f049fa11c172e5d784727e0b525565bb1533ec78" "944d52450c57b7cbba08f9b3d08095eb7a5541b0ecfb3a0a9ecd4a18f3c28948" "7a424478cb77a96af2c0f50cfb4e2a88647b3ccca225f8c650ed45b7f50d9525" "251ed7ecd97af314cd77b07359a09da12dcd97be35e3ab761d4a92d8d8cf9a71" "821c37a78c8ddf7d0e70f0a7ca44d96255da54e613aa82ff861fe5942d3f1efc" "3319c893ff355a88b86ef630a74fad7f1211f006d54ce451aab91d35d018158f" "a82ab9f1308b4e10684815b08c9cac6b07d5ccb12491f44a942d845b406b0296" "333958c446e920f5c350c4b4016908c130c3b46d590af91e1e7e2a0611f1e8c5" "7a7b1d475b42c1a0b61f3b1d1225dd249ffa1abb1b7f726aec59ac7ca3bf4dae" "6950cff91f52578d46e0c3c0b68d329a72157cca1e2380e2e8e7557b8257eb6d" "dc2cdca2f32386a308057cac6abde24c07b470cf17847c784c79ecd3a23ee09a" "97db542a8a1731ef44b60bc97406c1eb7ed4528b0d7296997cbb53969df852d6" "6c531d6c3dbc344045af7829a3a20a09929e6c41d7a7278963f7d3215139f6a7" "d268b67e0935b9ebc427cad88ded41e875abfcc27abd409726a92e55459e0d01" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "234dbb732ef054b109a9e5ee5b499632c63cc24f7c2383a849815dacc1727cb6" "c2aeb1bd4aa80f1e4f95746bda040aafb78b1808de07d340007ba898efa484f5" "1d5e33500bc9548f800f9e248b57d1b2a9ecde79cb40c0b1398dec51ee820daf" "745d03d647c4b118f671c49214420639cb3af7152e81f132478ed1c649d4597d" "1704976a1797342a1b4ea7a75bdbb3be1569f4619134341bd5a4c1cfb16abad4" "79586dc4eb374231af28bbc36ba0880ed8e270249b07f814b0e6555bdcb71fab" "fee7287586b17efbfda432f05539b58e86e059e78006ce9237b8732fde991b4c" "6c98bc9f39e8f8fd6da5b9c74a624cbb3782b4be8abae8fd84cbc43053d7c175" "f0f5bfda176875f70299b2a3a07e778f23b8af81defe3bc40babd0a85f88d411" "4b0e826f58b39e2ce2829fab8ca999bcdc076dec35187bf4e9a4b938cb5771dc" "e79672e00657fb6950f67d1e560ca9b4881282eb0c772e2e7ee7a15ec7bb36a0" "f4a8885fd1cad56c4e67dc32796d5bd1c3defadde5a1981af08e7f40046ab79b" "edf6cc813aa6c4bc0a22b2f051624b861c20144016b0c1cf3046935807cbe4e6" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "57e3f215bef8784157991c4957965aa31bac935aca011b29d7d8e113a652b693" "cf9414f229f6df728eb2a5a9420d760673cca404fee9910551caf9c91cff3bfa" "1eee77e76b9cd3a2791dcee51ccb39002ccd830f2539be3aec3859c1bccf0112" "d1443dd6612780bf037e703b6ebd936bcd5f2a93821558052b30231b2e1e1168" "0be5c1a44e0a877aa9cedae800c438d09efe12bbc7cbc7f787d43c5b8e7eb0db" "a7525b7e01bdfbd4f576d1143ea0a27a47d05df39d193edebbbdf3255a0708ad" "e1a0ed433cdd00b77f5ded2a3db6379c1e85226aea7cf0b4f4137fd0fdb80420" "10df1e816601ef972dcb593f7b34cbd5a4215794b65386f6bb2ed9d4a7d3f64e" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "f2c35f8562f6a1e5b3f4c543d5ff8f24100fae1da29aeb1864bbc17758f52b70" "51ec7bfa54adf5fff5d466248ea6431097f5a18224788d0bd7eb1257a4f7b773" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "d8dc153c58354d612b2576fea87fe676a3a5d43bcc71170c62ddde4a1ad9e1fb" "274fa62b00d732d093fc3f120aca1b31a6bb484492f31081c1814a858e25c72e" "013c62a1fcee7c8988c831027b1c38ae215f99722911b69e570f21fc19cb662e" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "4597d1e9bbf1db2c11d7cf9a70204fa42ffc603a2ba5d80c504ca07b3e903770" "bbb4a4d39ed6551f887b7a3b4b84d41a3377535ccccf901a3c08c7317fad7008" "aa0a998c0aa672156f19a1e1a3fb212cdc10338fb50063332a0df1646eb5dfea" "5715d3b4b071d33af95e9ded99a450aad674e308abb06442a094652a33507cd2" "53d1bb57dadafbdebb5fbd1a57c2d53d2b4db617f3e0e05849e78a4f78df3a1b" "a866134130e4393c0cad0b4f1a5b0dd580584d9cf921617eee3fd54b6f09ac37" "0598de4cc260b7201120b02d580b8e03bd46e5d5350ed4523b297596a25f7403" "891debfe489c769383717cc7d0020244a8d62ce6f076b2c42dd1465b7c94204d" "242ed4611e9e78142f160e9a54d7e108750e973064cee4505bfcfc22cc7c61b1" "4e21fb654406f11ab2a628c47c1cbe53bab645d32f2c807ee2295436f09103c6" "723e48296d0fc6e030c7306c740c42685d672fd22337bc84392a1cf92064788a" "c5d320f0b5b354b2be511882fc90def1d32ac5d38cccc8c68eab60a62d1621f2" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "3d5307e5d6eb221ce17b0c952aa4cf65dbb3fa4a360e12a71e03aab78e0176c5" "7bc31a546e510e6bde482ebca992e293a54cb075a0cbfb384bf2bf5357d4dee3" "4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" "4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" default))
 '(dash-docs-enable-debugging nil)
 '(debug-on-error t)
 '(exwm-floating-border-color "#181818")
 '(flycheck-c/c++-clang-executable "clang")
 '(flycheck-clang-args '("-xc++"))
 '(flycheck-clang-language-standard "c++14")
 '(flycheck-clangcheck-dbname "compile_commands.json")
 '(flycheck-gcc-args '("--std=c++23" "-DICE_CPP11_MAPPING"))
 '(flycheck-pycheckers-checkers '(pylint flake8 pyflakes mypy3))
 '(flycheck-python-mypy-executable "/home/andy/help/bin/mypy")
 '(fountain-export-font "Courier New")
 '(fountain-export-include-scene-numbers t)
 '(frog-jump-buffer-max-buffers 24)
 '(gdb-many-windows t)
 '(global-company-mode t)
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t)
 '(haskell-process-suggest-remove-import-lines t)
 '(helm-M-x-fuzzy-match t)
 '(helm-completion-style 'emacs)
 '(helm-display-buffer-default-size 100)
 '(helm-locate-project-list '("/home/andy/repos/dev"))
 '(helm-org-rifle-show-full-contents nil)
 '(helm-org-rifle-show-path t)
 '(helm-rg-default-directory 'git-root)
 '(helm-rg-ripgrep-executable "/usr/bin/rg")
 '(highlight-tail-colors ((("#3d413c") . 0) (("#3a4143") . 20)))
 '(ibuffer-saved-filter-groups
   '(("python"
      ("python"
       (mode . python-mode)))
     ("mydefs"
      ("agora+dev"
       (used-mode . c++-mode)))))
 '(ibuffer-saved-filters
   '(("foo2"
      (mode . c++-mode)
      (or
       (projectile-files . "/mnt/hdd/andy/repos/dev")
       (projectile-files . "/mnt/hdd/andy/repos/agora")))
     ("foo"
      (mode . c++-mode)
      (or
       (projectile-files . "/mnt/hdd/andy/repos/dev")
       (projectile-files . "/mnt/hdd/andy/repos/agora")))
     ("~/filters.el"
      (mode . c++-mode)
      (or
       (projectile-files . "/mnt/hdd/andy/repos/dev")
       (projectile-files . "/mnt/hdd/andy/repos/agora")))
     ("gnus"
      (or
       (mode . message-mode)
       (mode . mail-mode)
       (mode . gnus-group-mode)
       (mode . gnus-summary-mode)
       (mode . gnus-article-mode)))
     ("programming"
      (or
       (mode . emacs-lisp-mode)
       (mode . cperl-mode)
       (mode . c-mode)
       (mode . java-mode)
       (mode . idl-mode)
       (mode . lisp-mode)))))
 '(ignored-local-variable-values '((auto-revert-mode . t)))
 '(image-file-name-extensions
   '("png" "jpeg" "jpg" "gif" "tiff" "tif" "xbm" "xpm" "pbm" "pgm" "ppm" "pnm" "svg" "pdf"))
 '(inferior-octave-startup-args '("-i" "--line-editing"))
 '(inhibit-startup-screen t)
 '(ispell-program-name "/usr/bin/hunspell")
 '(jdee-db-active-breakpoint-face-colors (cons "#000000" "#80A0C2"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#000000" "#A2BF8A"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#000000" "#3f3f3f"))
 '(lsp-pylsp-plugins-flake8-exclude [])
 '(lsp-pylsp-plugins-flake8-ignore ["E265" "E402" "D102" "E302" "D103" "E303"])
 '(lsp-pylsp-plugins-mypy-enabled t)
 '(lsp-pylsp-plugins-mypy-enables 't)
 '(lsp-pylsp-plugins-pydocstyle-add-ignore ["D103"])
 '(lsp-pylsp-plugins-pydocstyle-enabled nil)
 '(magit-todos-exclude-globs '(".git/" "deps/" "vendor/"))
 '(midnight-mode nil)
 '(nyan-mode t)
 '(objed-cursor-color "#C16069")
 '(octave-source-directories '("/home/andy/repos/octave/libinterp"))
 '(org-agenda-custom-commands
   '(("i" . "Inline")
     ("il" . "Inline2")
     ("il" tags-todo "+LEVEL=15+TODO=\"TODO\"|+LEVEL=15+TODO=\"DONE\"" nil)
     ("im" tags-todo "+morning" nil)))
 '(org-agenda-files
   '("/home/andy/repos/gtd/gtd.org" "/home/andy/repos/gtd/journal.org"))
 '(org-babel-load-languages '((dot . t) (emacs-lisp . t) (C . t) (shell . t)))
 '(org-capture-templates
   '(("t" "Todo" entry
      (file+olp "~/repos/gtd/gtd.org" "Inbox")
      "* TODO %U %?" :prepend t)
     ("T" "Aurora Todo" entry
      (file+headline "~/repos/aurora/todos.org" "TODO")
      "* TODO %?" :prepend t)
     ("c" "Phone Call" entry
      (file+olp "~/repos/gtd/gtd.org" "Calls")
      "* %U %?" :prepend t)
     ("i" "Inbox" entry
      (file+headline "~/repos/gtd/gtd.org" "Inbox")
      "* %U %?" :prepend t)
     ("m" "Meditations" entry
      (file+headline "~/repos/gtd/gtd.org" "Meditations")
      "* %?" :prepend t)
     ("A" "Anki basic" entry
      (file+headline org-my-anki-file "Dispatch Shelf")
      "* %<%H:%M>\12:PROPERTIES:\12:ANKI_NOTE_TYPE: Basic\12:ANKI_DECK: main\12:END:\12** Front\12%?\12** Back\12" :kill-buffer 't)
     ("s" "Schedule" entry
      (file+olp "~/repos/gtd/gtd.org" "Schedule")
      "* %u %?" :prepend 't)
     ("p" "Shopping" entry
      (file+headline "~/repos/gtd/_shopping.org" "Stuff")
      "* TODO %?" :prepend t)
     ("j" "Journal" entry
      (file+datetree "~/repos/gtd/journal.org")
      "* %U %?")))
 '(org-confirm-babel-evaluate nil)
 '(org-crypt-disable-auto-save t)
 '(org-crypt-key "andyrsmith@gmail.com")
 '(org-crypt-tag-matcher "crypt")
 '(org-directory "~/Dropbox/gtd")
 '(org-format-latex-options
   '(:foreground default :background default :scale 3.0 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers
                 ("begin" "$1" "$" "$$" "\\(" "\\[")))
 '(org-goto-max-level 10)
 '(org-hide-leading-stars t)
 '(org-log-done nil)
 '(org-lowest-priority 90)
 '(org-outline-path-complete-in-steps nil)
 '(org-preview-latex-image-directory "/var/tmp/ltximg/")
 '(org-refile-targets '((org-agenda-files :maxlevel . 10)))
 '(org-todo-keyword-faces
   '(("BLKD" :foreground "red" :weight bold)
     ("FAIL" :foreground "red" :weight bold)
     ("TDAY" :foreground "yellow" :weight bold)
     ("PNDG" :foreground "orange" :weight bold)
     ("PROG" :foreground "orange" :weight bold)
     ("DONE" :foreground "green" :weight bold)
     ("NEVR" :foreground "dark gray" :weight bold)
     ("" :foreground "dark gray" :weight bold)
     ("MUST" :foreground "red" :weight bold)))
 '(org-todo-keywords
   '((sequence "TODO" "TODOTODAY" "PROG" "BLKD" "DONE" "NEVR")))
 '(org-twbs-todo-kwd-class-done "label label-success")
 '(org-twbs-todo-kwd-class-undone "label label-warning")
 '(org-use-tag-inheritance '("wifidetails" "astronomy"))
 '(package-selected-packages
   '(format-all shadchen dash hide-mode-line elisp-format clang-format+ magit-todos lsp-treemacs lsp-ui helm-lsp lsp-mode flycheck-clangcheck pyenv-mode geiser-racket compat magit-gerrit eros axe helm-rg flycheck-mypy forest-blue-theme impatient-mode rg "rg" geiser-guile worf openwith helm-org-ql org-latex-impatient org-drill ace-isearch frog-jump-buffer ace-jump-buffer ztree anki-connect ace-window swift-mode ada-mode yasnippet-classic-snippets yasnippet-snippets helm-dash magit color-theme-sanityinc-tomorrow org-superstar anki-editor key-chord git-timemachine org-anki anki-mode chess weyland-yutani-theme afternoon-theme tron-legacy-theme ox-twbs undo-tree arduino-mode command-log-mode smart-dash zones psgml reason-mode webfeeder olivetti hy-mode org-kanban dracula-theme slime ob-kotlin amd-mode sed-mode ranger doom-themes aggressive-indent meson-mode ace-mc helm-org-rifle elixir-mode dfmt f3 f org-mobile-sync company-dcd dirtree direx indium flymake-cursor darcula-theme typescript-mode go julia-shell julia-repl julia-mode flycheck-kotlin erlang google-this py-autopep8 flymake-python-pyflakes haskell-mode editorconfig flycheck-clang-tidy kotlin-mode erc-view-log color-theme-sanityinc-solarized color-theme-solarized scala-mode helm-unicode cmake-mode nim-mode json-rpc restclient workgroups2 gnuplot gnuplot-mode orgtbl-ascii-plot forth-mode csv-mode git-gutter org-present json-mode d-mode ponylang-mode flycheck-pony cider clojure-mode multiple-cursors ag helm-projectile projectile dumb-jump helm-cscope ein elpy yaml-mode web-mode utop tuareg tide switch-window swiper-helm solarized-theme sml-mode smex scala-mode2 sass-mode rust-mode rtags rainbow-delimiters quack pylint protobuf-mode paredit org nyan-mode nurumacs nasm-mode monokai-theme monky markdown-mode less-css-mode jsx-mode js3-mode jedi jade-mode ido-ubiquitous iasm-mode helm-swoop helm-package helm-gtags helm-company helm-cider helm-ag groovy-mode graphviz-dot-mode go-mode ghci-completion ghc-imported-from ghc ggtags geiser fsharp-mode fountain-mode flycheck-pyflakes flycheck-irony flycheck-haskell find-file-in-project ensime elm-mode edts dash-functional dart-mode csv-nav csharp-mode coffee-mode clang-format caroline-theme caml auctex ace-jump-mode ac-slime ac-helm ac-haskell-process ac-clang ac-cider abyss-theme 2048-game))
 '(pdf-view-midnight-colors (cons "#eceff4" "#323334"))
 '(projectile-globally-ignored-files '("TAGS" "urg"))
 '(projectile-indexing-method 'hybrid)
 '(projectile4-tags-backend 'ggtags)
 '(python-shell-interpreter "ipython3")
 '(python-shell-interpreter-args "--simple-prompt --pylab")
 '(rustic-ansi-faces
   ["#323334" "#C16069" "#A2BF8A" "#ECCC87" "#80A0C2" "#B58DAE" "#86C0D1" "#eceff4"])
 '(safe-local-variable-values
   '((etags-regen-ignores "test/manual/etags/")
     (etags-regen-regexp-alist
      (("c" "objc")
       "/[ \11]*DEFVAR_[A-Z_ \11(]+\"\\([^\"]+\\)\"/\\1/" "/[ \11]*DEFVAR_[A-Z_ \11(]+\"[^\"]+\",[ \11]\\([A-Za-z0-9_]+\\)/\\1/"))
     (helm-ag-command-option . "-tpy -tcpp -td")
     (test-case-name . twisted.internet.test.test_qtreactor)
     (test-case-name . twisted.internet.test.test_inotify)
     (test-case-name . twisted.internet.test.test_core)))
 '(send-mail-function 'smtpmail-send-it)
 '(sentence-end "\\. ")
 '(show-paren-mode t)
 '(sql-postgres-login-params '((user :default "andy") server (database :default "andy")))
 '(sql-postgres-login-paramsupo '((user :default "andy") server (database :default "andy")))
 '(tab-width 2)
 '(undo-tree-history-directory-alist '((".*" . "~/.emacs.d/undo")))
 '(world-clock-list
   '(("Australia/Perth" "Perth")
     ("Asia/Dubai" "Dubai")
     ("Europe/Munich" "Munich")
     ("Europe/London" "London")
     ("Europe/Paris" "Paris")
     ("Europe/Berlin" "Berlin")
     ("America/New_York" "New York")
     ("America/Chicago" "Chicago"))))
(put 'scroll-left 'disabled nil)
(put 'dired-find-aorlternate-file 'disabled nil)
(menu-bar-mode 0)

(put 'erase-buffer 'disabled nil)
