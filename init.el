;; (set-frame-font "fixed 14")
;; (set-frame-font "Nimbus-Bold")

;;(set-frame-font "-misc-fixed-medium-r-normal--10-*-100-100-c-60-iso8859-1" )
(set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-12-*-*-*-m-0-iso10646-1")
;; Org favourite
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-20-*-*-*-m-0-iso10646-1")


;; (set-frame-font "-misc-fixed-medium-r-normal--10-*-75-75-c-60-iso8859-8")
;; (set-frame-font "-misc-fixed-medium-r-normal--6-*-75-75-c-70-iso8859-5")
;; (set-frame-font "-misc-fixed-medium-r-normal--11-*-100-100-c-80-iso8859-8")
;; (set-frame-font "-misc-fixed-medium-r-semicondensed--13-*-75-75-c-60-iso8859-15")
;; (set-frame-font "-misc-fixed-medium-r-normal--15-*-75-75-c-90-iso8859-16")
;; (set-frame-font "-urw-Nimbus Mono L-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-urw-Nimbus Mono L-bold-normal-normal-*-*-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-10-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-12-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-15-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-21-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-22-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-23-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-40-*-*-*-m-0-iso10646-1")

;;(add-to-list 'load-path "~/.emacs.d/python-mode")
;;(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

(require 'compile)
(require 'package)
(add-to-list 'package-archives '("melpa"     . "http://melpa.org/packages/") )

;;(add-to-list 'package-archives '("melpa-stable"     . "http://stable.melpa.org/packages/") )
;;(add-to-list 'load-path "~/.emacs.d/vendor/swank-js")
;;(add-to-list 'load-path "~/.emacs.d/vendor/slime")
;;(add-to-list 'load-path "~/.emacs.d/python-mode")

;;(cons 1 '(2 3 4 )) 
;;(add-to-list 'load-path "~/.emacs.d")

(defun slurp (x)
  (with-temp-buffer 
	 ign
	 (insert-file-contents x)
	 (buffer-string) ) )

(global-set-key (kbd "C-x C-o") 'ff-find-other-file)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-c C-h C-s") 'helm-swoop)
(global-set-key (kbd "C-x C-b") 'helm-mini)
(global-set-key (kbd "C-x r b") 'helm-bookmarks)

(global-set-key (kbd "C-c C-m C-s" ) 'magit-status)
;; For d
(add-to-list 'compilation-error-regexp-alist
		'("^object\.Exception@\\(.*\\)(\\([0-9]+\\)).*"
		  1 2 ) )

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
  (revert-buffer t t )
  )

(global-set-key (kbd "C-c r")  'revert-buffer-with-prejudice)

(add-to-list 'auto-mode-alist '("build\\.gradle" . groovy-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(defun find-file-in-clipboard () 
  (interactive)
  (find-file-at-point (x-get-clipboard)))
(global-set-key (kbd "C-c p")  'find-file-in-clipboard)

(defun do-revert () 
  (interactive) 
  (revert-buffer nil 't))

;;(require 'org-crypt)
;;(org-crypt-use-before-save-magic)
;;(setq org-tags-exclude-from-inheritance (quote ("crypt")))
;; GPG key to use for encryption
;; Either the Key ID or set to nil to use symmetric encryption.
;;(setq org-crypt-key "9059B882D50776AA")

(defun revert-buffer-with-prejudice () 
  (interactive) 
  (revert-buffer 't 't ))

(global-set-key (kbd "C-c r")  'revert-buffer-with-prejudice)

(package-initialize)

;;(setq load-path (cons "~/.emacs.d/color-theme"  load-path ) )


(defun switch-to-org ()
  (interactive)
  (switch-to-buffer "gtd.org")
  )

(global-set-key [f1]  'wg-switch-to-workgroup)
(global-set-key [f2]  'wg-switch-to-notes)
(global-set-key [f3]  'switch-to-org)
(global-set-key [f4]  'magit-status)


(global-set-key [f7]  'compile)
(global-set-key [f8]  'reboot-python)
(global-set-key [f9]  'py-execute-region)
(global-set-key [f10] 'switch-to-shell)

(defun dump-fonts ()
  (interactive)
  (let* ( 
			(bufferName (format "fonts_%s.el" (system-name) ) ) 
			(myInsert (lambda (x) (progn (insert x) (insert "\n") ) ) )
			(fileName (format "%s/%s" (getenv "HOME")  bufferName) ))
    (switch-to-buffer bufferName)
    (erase-buffer)
    (mapcar (lambda (x) (insert (format "(set-frame-font \"%s\" )\n"  x) ) )  (x-list-fonts "*") )
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
;;(color-theme-deep-blue)
;;(color-theme-hober)
;;(color-theme-cobalt)
(color-theme-clarity)

(global-set-key [f1] 'wg-switch-to-workgroup)
(global-set-key [f7] 'compile)
(global-set-key [f9] 'py-execute-region)
(global-set-key [f10] 'switch-to-shell)
(global-set-key (kbd "C-c o") 'ff-find-other-file)
(global-set-key (kbd "C-c f") 'find-file-at-point)



(defun switch-to-shell () 
  (interactive)
  (switch-to-buffer "*shell*"))

(windmove-default-keybindings 'meta)

;; (require 'color-theme)
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

(defun do-revert () 
  (interactive) 
  (revert-buffer nil 't))

(defun revert-buffer-with-prejudice () 
  (interactive) 
  (revert-buffer t t ))

(defun reboot-python ()
  (interactive)
  (save-current-buffer
    ; Disable querying while we delete.|
    (let ( kill-buffer-query-functions '() )
      (if (get-buffer "*Python*") (kill-buffer "*Python*") )
      (if (get-buffer "*Jython*") (kill-buffer "*Jython*") ))))



(defun unfill-paragraph (&optional region)
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max)))
    (fill-paragraph nil region)))

(global-set-key (kbd "M-Q") 'unfill-paragraph)

;;(define-key global-map "\M-Q" 'unfill-paragraph)
;; Put in thegge front - have had issues/conflicts with elpa :-(

;;(require 'python-mode)

(defun insert-hg-ignore () 
  (interactive)
  (insert "`hg root`/.hgignore"))

(global-set-key (kbd "C-c C-h C-g C-i" ) 'insert-hg-ignore)


;; (require 'python-mode)
;; (setq load-path (cons "/home/andy/.emacs.d/python-mode" load-path))
;; (setq load-path (cons "/home/andy/.emacs.d/ipython"     load-path))

;;(add-to-list 'auto-mode-alist '("SConstruct" . python-mode) )
;;(add-to-list 'auto-mode-alist '("SConscript" . python-mode) )
;;(add-to-list 'auto-mode-alist '("\\.py$" . python-mode) )

;;(setq interpreter-mode-alist (cons '("python" . python-mode)
;;				   interpreter-mode-alist))
;;(autoload 'python-mode "python-mode" "Python editing mode." t)

(require 'workgroups)
(setq wg-prefix-key (kbd "C-c w"))
(setq wg-file "~/wg.el")
(workgroups-mode 1)
(wg-load wg-file)

(tool-bar-mode 0)
(menu-bar-mode 0)

;; (defun set-auto-complete-as-completion-at-point-function ()
;;   (setq wcompletion-at-point-functions '(auto-complete)))
;; (add-hook 'auto-complete-mode-hook 'set-auto-complete-as-comple
;;tion-at-point-function)
;; (add-hook 'nrepl-mode-hook 'set-auto-complete-as-completion-at-point-function)
;; (add-hook 'nrepl-interaction-mode-hook 'set-auto-complete-as-completion-at-point-function)

;;(setq py-install-directory "/home/andy/.emacs.d/python-mode.el-6.1.1")
;;(add-to-list 'load-path py-install-directory)
;;(require 'python-mode)
;;(require 'python-mode)
;;(require 'ipython)
;;(color-theme-solarized-darkp)
;; (elpy-enable)
;; (elpy-use-ipython)

; supercede with helm
;(ido-mode 't)  


(require 'flymake-haskell-multi)
(autoload 'ghc-init "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init) ))
(add-hook 'haskell-mode-hook 'flymake-haskell-multi-load)






(setq-default indent-tabs-mode nil)

;;(require 'ipython)
;;(add-to-list 'load-path "/path/to/js2-mode/directory")

(require 'slime-autoloads)
;;(require 'slime-autoloads)

;(require 'slime-js)
;(slime-setup '(slime-js))

(slime-setup '(slime-fancy))
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;(global-set-key [f5] 'slime-js-reload)
;; (add-hook 'js2-mode-hook
;;           (lambda ()
;;             (slime-js-minor-mode 1)))


(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(require 'auto-complete-config)
(ac-config-default)

(require 'ac-slime)
(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)

(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'slime-repl-mode))

(setq inferior-lisp-program "/usr/bin/sbcl")

(require 'org)
(setq org-default-notes-file (concat org-directory "~/Dropbox/gtd/gtd.org") )
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
(global-set-key (kbd "C-c s") 'ispell)
(global-set-key (kbd "C-c r") 'revert-buffer-with-prejudice)

;; (eval-after-load 'flycheck
;;   '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))


(require 'flycheck-pyflakes)
(add-hook 'python-mode-hook 'flycheck-mode)

(autoload 'pylint "pylint")
(add-hook 'python-mode-hook 'pylint-add-menu-items)
(add-hook 'python-mode-hook 'pylint-add-key-bindings)

(require 'semantic)

;; Enable EDE (Project Management) features
(global-ede-mode 1)
;; (semantic-load-enable-excessive-code-helpers)      ; Enable prototype help and smart completion

(setq helm-semantic-fuzzy-match t
      helm-imenu-fuzzy-match    t)


;;(global-srecode-minor-mode 1)            ; Enable template insertion menu

    ;; (add-hook 'c++-mode-hook 'irony-mode)
    ;; (add-hook 'c-mode-hook 'irony-mode)
    ;; (add-hook 'objc-mode-hook 'irony-mode)
    ;; replace the `completion-at-point' and `complete-symbol' bindings in
    ;; irony-mode's buffers by irony-mode's asynchronous function
    ;; (defun my-irony-mode-hook ()
    ;;   (define-key irony-mode-map [remap completion-at-point]
    ;;     'irony-completion-at-point-async)
    ;;   (define-key irony-mode-map [remap complete-symbol]
    ;;     'irony-completion-at-point-async))
    ;; (add-hook 'irony-mode-hook 'my-irony-mode-hook)

    ;; Only needed on Windows
    (when (eq system-type 'windows-nt)
      (setq w32-pipe-read-delay 0))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("~/Dropbox/gtd/gtd.org")))
 '(org-directory "~/Dropbox/gtd")
 '(org-hide-leading-stars t)
 '(python-shell-interpreter "ipython")
 '(python-shell-interpreter-args "--pylab=qt4"))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


