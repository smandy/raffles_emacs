(set-frame-font "Fixed 10")

;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-20-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-misc-fixed-medium-r-normal--10-*-75-75-c-60-iso8859-8")
;; (set-frame-font "-misc-fixed-medium-r-normal--6-*-75-75-c-70-iso8859-5")
;; (set-frame-font "-misc-fixed-medium-r-semicondensed--13-*-75-75-c-60-iso8859-15")
;; (set-frame-font "-urw-Nimbus Mono L-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-urw-Nimbus Mono L-bold-normal-normal-*-*-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-10-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-12-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-15-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-21-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-22-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-23-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-40-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-80-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-12-*-*-*-m-0-iso10646-1")
;; (set-frame-font "Fixed 10")
;; (set-frame-font "Liberation Mono 12")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")
;;(set-frame-font "-misc-fixed-medium-r-normal--15-*-75-75-c-90-iso8859-16")
(set-frame-font "-misc-fixed-medium-r-normal--11-*-100-100-c-80-iso8859-8")

(require 'compile)
(require 'package)

(add-to-list 'package-archives '("melpa"     . "http://melpa.org/packages/") )

(setq auto-mode-alist
      (cons '("SConstruct" . python-mode) auto-mode-alist))
(setq auto-mode-alist
      (cons '("SConscript" . python-mode) auto-mode-alist))


(defun slurp (x)
  (with-temp-buffer 
    ign
    (insert-file-contents x)
    (buffer-string)))

(defun debug-discovery ()
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





;;(global-set-key (kbd "C-x C-b") 'helm-mini)

(global-set-key (kbd "C-x r b") 'helm-bookmarks)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key [f5] 'helm-resume )

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
  (revert-buffer 't 't )
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

(defun revert-buffer-with-prejudice () 
  (interactive) 
  (revert-buffer 't 't ))

(global-set-key (kbd "C-c r")  'revert-buffer-with-prejudice)

(package-initialize)


(eval-after-load "haskell-mode"
  '(progn
     (define-key haskell-mode-map (kbd "C-x C-d") nil)
     (define-key haskell-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
     (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-file)
     (define-key haskell-mode-map (kbd "C-c C-b") 'haskell-interactive-switch)
     (define-key haskell-mode-map (kbd "C-c C-t") 'haskell-process-do-type)
     (define-key haskell-mode-map (kbd "C-c C-i") 'haskell-process-do-info)
     (define-key haskell-mode-map (kbd "C-c M-.") nil)
     (define-key haskell-mode-map (kbd "C-c C-d") nil)))

(require 'haskell-interactive-mode)
(require 'haskell-process)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-basic-offset 4)
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t)
 '(haskell-process-suggest-remove-import-lines t)
 '(org-agenda-files (quote ("~/Dropbox/gtd/gtd.org")))
 '(org-directory "~/Dropbox/gtd")
 '(org-hide-leading-stars t)
 '(python-shell-interpreter "ipython")
 '(python-shell-interpreter-args "--pylab=qt")
 '(tab-width 4))
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
(color-theme-midnight)

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
(ac-config-default)

(require 'ac-slime)
(add-hook 'slime-mode-hook      'set-up-slime-ac)
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

(defun rangeExperiment ()
  (interactive)
  (compile-in-buffer "cd ~/repos/pingu && rdmd -unittest rangeExperiment.d" "rangeExperiment"))


(defun pingu ()
  (interactive)
  (compile-in-buffer "cd ~/repos/pingu && rdmd -unittest --main -version=diagnostic Order.d" "pingu"))

(global-set-key (kbd "C-c C-h C-p") 'pingu)
(defun pingu ()
  (interactive)
  (compile-in-buffer "cd ~/repos/pingu && rdmd Order.d" "pingu"))


(add-to-list 'exec-path "/home/andy/bin")



(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
