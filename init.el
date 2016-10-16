;;; init.el --- Andy's emacs config

;;; Commentary:

;; Raffles laptop emacs config

;;; Code:

(set-frame-font "Ubuntu Mono 15")

;;(set-frame-font "Ubuntu Light 15")
;;(set-frame-font "Ubuntu Normal 15")
(set-frame-font "Fixed 10")

;; Nice runing from Mac. (set-frame-font "-misc-fixed-medium-r-normal--10-*-75-75-c-60-iso8859-7" )
;;(set-frame-font "Misc Fixed 14")

(set-frame-font "-misc-fixed-medium-r-normal--18-*-75-75-c-90-iso8859-3" )

(require 'compile)
(require 'package)

(add-to-list 'package-archives '("melpa"     . "http://melpa.org/packages/"))
(setq auto-mode-alist
      (cons '("SConstruct" . python-mode) auto-mode-alist))
(setq auto-mode-alist
      (cons '("SConscript" . python-mode) auto-mode-alist))


(add-to-list 'auto-mode-alist '("\\.jsx\\'" . jsx-mode))
(autoload 'jsx-mode "jsx-mode" "JSX mode" t)


(defun slurp (x)
  "Clojure slurp function.  Slurp file X."
  (with-temp-buffer 
    (insert-file-contents x)
    (buffer-string)))

(defun debug-discovery ()
  "Debug the discovery app."
  (interactive)
  (gdb "gdb -i=mi -nx -x /home/andy/discovery.gdbinit"))

(global-set-key (kbd "C-x C-o") 'ff-find-other-file)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-c C-h C-s") 'helm-swoop)
(global-set-key (kbd "C-c C-h C-l") 'helm-locate)
(global-set-key (kbd "C-c C-h C-a") 'helm-do-ag)

(global-set-key (kbd "M-g M-f") 'helm-gtags-find-files)
(global-set-key (kbd "M-g M-t") 'helm-gtags-find-tag)
(global-set-key (kbd "M-g M-r") 'helm-gtags-find-rtag)

(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-b") 'helm-mini)

(global-set-key (kbd "C-x r b") 'helm-bookmarks)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key [f5] 'helm-resume)

(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

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
               1 2 ) )
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

(require 'cl)
(setq auto-mode-alist (remove-if
                       (lambda (x) ( equal (cdr x) 'objc-mode)) auto-mode-alist))
(add-to-list 'auto-mode-alist '("\\.m$" . octave-mode))

(defun compile-in-own-buffer (buf cmd)
  (interactive)
  (let ((compilation-buffer-name-function (lambda (x) buf) ))
    (compile cmd)))

(defun compile-agora ()
  (interactive)
  (compile-in-own-buffer "build agora" "cd ~/repos/agora && cmake -G 'Ninja' && ninja"))

(defun compile-discovery ()
  (interactive)
  (compile-in-own-buffer "build discovery" "cd ~/repos/agora && make"))

(defun find-file-in-clipboard () 
  (interactive)
  (find-file-at-point (x-get-clipboard)))

(global-set-key (kbd "C-c p")  'find-file-in-clipboard)

(defun copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))

(defun do-revert () 
  (interactive) 
  (revert-buffer nil 't))

(package-initialize)

;;(global-set-key (kbd "C-s")  'swiper-helm))
(global-set-key (kbd "C-s")  'isearch-forward)

(require 'haskell-interactive-mode)
(require 'haskell-process)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(LaTeX-command "latex -shell-escape")
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(c-basic-offset 4)
 '(clang-format-executable "clang-format-3.4")
 '(company-clang-arguments (quote ("-std=c++0x")))
 '(compilation-message-face (quote default))
 '(flycheck-clang-language-standard "c++11")
 '(flycheck-gcc-language-standard "c++11")
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t)
 '(haskell-process-suggest-remove-import-lines t)
 '(helm-M-x-fuzzy-match t)
 '(inferior-octave-startup-args (quote ("-i" "--line-editing")))
 '(magit-diff-use-overlays nil)
 '(nyan-mode t)
 '(org-agenda-files (quote ("~/Dropbox/gtd/gtd.org")))
 '(org-directory "~/Dropbox/gtd")
 '(org-format-latex-options
   (quote
    (:foreground default :background default :scale 2.0 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers
                 ("begin" "$1" "$" "$$" "\\(" "\\["))))
 '(org-hide-leading-stars t)
 '(python-shell-interpreter "ipython")
 '(python-shell-interpreter-args "--pylab=qt")
 '(safe-local-variable-values
   (quote
    ((test-case-name . twisted\.internet\.test\.test_qtreactor)
     (test-case-name . twisted\.internet\.test\.test_inotify)
     (test-case-name . twisted\.internet\.test\.test_core))))
 '(show-paren-mode t)
 '(sql-postgres-login-params
   (quote
    ((user :default "andy")
     server
     (database :default "andy"))))
 '(tab-width 4)
 '(vc-annotate-background nil)
 '(vc-annotate-very-old-color nil))
(defun switch-to-org ()
  (interactive)
  (switch-to-buffer "gtd.org")
  )

(global-set-key [f1]  'wg-switch-to-workgroup)
(global-set-key [f2]  'ace-jump-mode)
(global-set-key [f3]  'switch-to-org)
(global-set-key [f4]  'magit-status)
(global-set-key [f6]  'helm-man-woman)
(global-set-key [f7]  'compile)
(global-set-key [f8]  'reboot-python)
(global-set-key [f9]  'py-execute-region)
(global-set-key [f10] 'switch-to-shell)
(global-set-key [f12] 'ace-jump-mode)

(nyan-mode)

(defun dump-fonts ()
  (interactive)
  (let* ( 
         (bufferName (format "fonts_%s.el" (system-name) ) ) 
         (fileName (format "%s/%s" (getenv "HOME")  bufferName) ))
    (switch-to-buffer bufferName)
    (erase-buffer)
    (mapc (lambda (x) (insert (format "(set-frame-font \"%s\" )\n"  x) ) )  (x-list-fonts "*") )
    (mark-whole-buffer)
    (sort-lines nil (point-min) (point-max))
    (write-file fileName )
    (kill-buffer bufferName)
    (message (format "Saved %s ... " fileName))))

(defun switch-to-notes () 
  (interactive)
  (switch-to-buffer "gtd.org"))

(defun switch-to-shell () 
  (interactive)
  (switch-to-buffer "*shell*"))

(windmove-default-keybindings 'meta)

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

(require 'package)

(package-initialize)
(color-theme-initialize)

(require 'color-theme)
(color-theme-midnight)

(global-set-key [f1] 'wg-switch-to-workgroup)
(global-set-key [f7] 'compile)
(global-set-key [f9] 'py-execute-region)
(global-set-key [f10] 'switch-to-shell)
(global-set-key (kbd "C-c o") 'ff-find-other-file)
(global-set-key (kbd "C-c f") 'find-file-at-point)

(windmove-default-keybindings 'meta)

(defun reboot-python ()
  "Reboot python."
  (interactive)
  (save-current-buffer
                                        ; Disable querying while we delete.|
    (let ( kill-buffer-query-functions '() )
      (if (get-buffer "*Python*") (kill-buffer "*Python*") )
      (if (get-buffer "*Jython*") (kill-buffer "*Jython*") ))))

(defun unfill-paragraph (&optional region)
  "Takes a multi-line paragraph ( REGION ) and make it into a single line of text."
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max)))
    (fill-paragraph nil region)))

(global-set-key (kbd "M-Q") 'unfill-paragraph)

(defun insert-hg-ignore () 
  (interactive)
  (insert "`hg root`/.hgignore"))

(global-set-key (kbd "C-c C-h C-g C-i" ) 'insert-hg-ignore)

(require 'workgroups)
(setq wg-prefix-key (kbd "C-c w"))
(setq wg-file "~/wg.el")
(workgroups-mode 1)
(wg-load wg-file)

(tool-bar-mode 0)
(menu-bar-mode 0)

(require 'flymake-haskell-multi)
(autoload 'ghc-init "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init) ))
(add-hook 'haskell-mode-hook 'flymake-haskell-multi-load)

(setq-default indent-tabs-mode nil)

(require 'slime-autoloads)

(slime-setup '(slime-fancy))
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(add-to-list 'auto-mode-alist '("\\.ice$" . idl-mode))

(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(eval-after-load "auto-complete"
  '(add-to-list 'ac-sources 'ac-source-yasnippet))
(ac-config-default)

(require 'ac-slime)
(add-hook 'slime-mode-hook      'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)

(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'slime-repl-mode))

(setq inferior-lisp-program "/usr/bin/sbcl")

(require 'org)
(setq org-default-notes-file (concat org-directory "~/Dropbox/gtd/gtd.org"))
(define-key global-map "\C-cc" 'org-capture)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(setq org-capture-templates '(
                              ("t" "Todo" entry (file+headline "~/Dropbox/gtd/gtd.org" "Tasks")
                               "* TODO %?\n%F")
                              
                              ("r" "Todo" entry (file+headline "~/Dropbox/gtd/gtd.org" "Tasks")
                               "* TODO %?\n  %i\n  %a")
                              
                              ("r" "Todo" entry (file+headline "~/Dropbox/gtd/gtd.org" "Tasks")
                               "* TODO %?\n%F")
                              
                              ("p" "Performance" entry (file+headline "~/Dropbox/gtd/gtd.org" "Performance")
                               "* TODO %?\n")
                              
                              ("s" "Schedule" entry (file+headline "~/Dropbox/gtd/gtd.org" "Schedule")
                               "* %?\n")
                              
                              ("j" "Journal" entry (file+datetree "~/Dropbox/gtd/journal.org")
                               "* %U %?")))


(global-set-key (kbd "C-c s") 'ispell)
(global-set-key (kbd "C-c r") 'revert-buffer-with-prejudice)

(require 'flycheck-pyflakes)
(add-hook 'python-mode-hook 'flycheck-mode)

(autoload 'pylint "pylint")
(add-hook 'python-mode-hook 'pylint-add-menu-items)
(add-hook 'python-mode-hook 'pylint-add-key-bindings)

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

(defun daysBetween (s f)
  (let* ((seconds-per-day ( * 24 60 60 ))
         (conv (lambda (x)
                 (let ((bits (mapcar 'string-to-int (split-string x "-"))))
                   (apply 'encode-time (list 0 0 0 (nth 2 bits) (nth 1 bits) (nth 0 bits))))))
         (st (funcall conv s))
         (ft (funcall conv f)))
    (/ (time-to-seconds (time-subtract ft st)) seconds-per-day)))

;; (daysBetween "1973-09-21" "2016-07-12") 15635.0
 
(defun rangeExperiment ()
  (interactive)
  (compile-in-buffer "cd ~/repos/pingu && rdmd -unittest rangeExperiment.d" "rangeExperiment"))

(eval-after-load 'company
  '(progn
     (define-key company-mode-map (kbd "C-:") 'helm-company)
     (define-key company-mode-map (kbd "M-/") 'company-complete)
     (define-key company-active-map (kbd "C-:") 'helm-company)))

(defun pingu ()
  (interactive)
  (compile-in-buffer "cd ~/repos/pingu && rdmd -unittest --main -version=diagnostic Order.d" "pingu"))

(global-set-key (kbd "C-c C-h C-p") 'pingu)

(eval-after-load 'company
  '(progn
     (define-key company-mode-map (kbd "C-:") 'helm-company)
     (define-key company-active-map (kbd "C-:") 'helm-company)))

(add-to-list 'exec-path "/home/andy/bin")

(autoload 'utop-minor-mode "utop" "Minor mode for utop" t)
(add-hook 'tuareg-mode-hook 'utop-minor-mode)

(load "auctex.el" nil t t)

;;(define-key octave-mode-map (kbd "C-c C-c") 'octave-send-buffer)
;;(define-key octave-mode-map (kbd "C-c C-r") 'octave-send-region)

;;(require 'octave)
(eval-after-load 'octave '(progn
                           (define-key octave-mode-map (kbd "C-c C-c") 'octave-send-buffer)
                           (define-key octave-mode-map (kbd "C-c C-r") 'octave-send-region)
                           (define-key octave-mode-map (kbd "C-c C-p") 'run-octave)
                           ) )

(eval-after-load 'nodejs-repl
  '(progn
     (define-key js2-mode-map (kbd "C-c C-r") 'nodejs-repl-send-region)))

(defun end-of-sml (a b &rest xs)
  (interactive)
  (switch-to-buffer "*SML*")
  (end-of-buffer) ) 

; (advice-add 'sml-prog-proc-load-file :after 'end-of-sml)
; (advice-remove 'sml-prog-proc-load-file)

;; SQL Sticc
;;(require 'sql)
;;(load-file "~/.emacs.d/sql-interactive-remove-continuation-prompt.el")
;;(require 'sql-interactive-remove-continuation-prompt)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init.el)
;;; init.el ends here
