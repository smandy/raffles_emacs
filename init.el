(defun slurp (x) 
  (with-temp-buffer 
	 ign
	 (insert-file-contents x)
	 (buffer-string) ) )

(require 'compile)

(require 'package)

(add-to-list 'package-archives 
	     '("marmalade" . "http://marmalade-repo.org/packages/")
	     '("melpa"     . "http://melpa.org/packages/")
	     )
;(add-to-list 'load-path "~/.emacs.d/python-mode")
;(cons 1 '(2 3 4 ))
;(add-to-list 'load-path "~/.emacs.d")

; For node.js
(add-to-list 'compilation-error-regexp-alist
		'("[\w]+ at .*(\\(.*\\):\\([0-9]+\\):.*).*"
		  1 2 ) )

(setq compilation-error-regexp-alist (cdr compilation-error-regexp-alist))

(add-to-list
 'compilation-error-regexp-alist
 '("^\\([^ \n]+\\)(\\([0-9]+\\)): \\(?:Error\\|.\\|warnin\\(g\\)\\|remar\\(k\\)\\)"
   1 2 nil (3 . 4)))



(add-to-list 'load-path "~/.emacs.d/vendor/jade-mode")
(require 'sws-mode)
(require 'jade-mode)
(add-to-list 'auto-mode-alist '("\\.dt\\'" . sws-mode))

(defun do-revert () 
  (interactive) 
  (revert-buffer nil 't))

(require 'org-crypt)
(org-crypt-use-before-save-magic)
(setq org-tags-exclude-from-inheritance (quote ("crypt")))
;; GPG key to use for encryption
;; Either the Key ID or set to nil to use symmetric encryption.
(setq org-crypt-key "9059B882D50776AA")

(defun revert-buffer-with-prejudice () 
  (interactive) 
  (revert-buffer 't 't ))

(global-set-key (kbd "C-c r")  'revert-buffer-with-prejudice)

(package-initialize)




(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

(setq load-path (cons "~/.emacs.d/color-theme"  load-path ) )

(global-set-key [f1]  'wg-switch-to-workgroup)
(global-set-key [f2]  'wg-switch-to-notes)
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

(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(require 'auto-complete-config)
(ac-config-default)

(windmove-default-keybindings 'meta)

					; (elpy-enable)
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

(require 'color-theme)
;(color-theme-deep-blue)
(color-theme-hober)

(global-set-key [f1] 'wg-switch-to-workgroup)
(global-set-key [f7] 'compile)
(global-set-key [f9] 'py-execute-region)
(global-set-key [f10] 'switch-to-shell)
(global-set-key (kbd "C-c o") 'ff-find-other-file)
(global-set-key (kbd "C-c f") 'find-file-at-point)

(defun switch-to-shell () 
  (interactive)
  (switch-to-buffer "*shell*"))

(require 'auto-complete-config)

(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(require 'auto-complete-config)
(ac-config-default)

(windmove-default-keybindings 'meta)

;(require 'color-theme)
					; (elpy-enable)
(defun plist-to-alist (the-plist)
  (defun get-tuple-from-plist (the-plist)
    (when the-plist
      (cons (car the-plist) (cadr the-plist))))
  (let ((alist '()))
    (while the-plist
      (add-to-list 'alist (get-tuple-from-plist the-plist))
      (setq the-plist (cddr the-plist)))
    alist))

(require 'org)
(setq org-default-notes-file (concat org-directory "/notes.org") )
(define-key global-map "\C-cc" 'org-capture)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(global-set-key (kbd "C-c s") 'ispell)
(global-set-key (kbd "C-c s") 'ispell)
(global-set-key (kbd "C-c r") 'revert-buffer-with-prejudice)


(defun do-revert () 
  (interactive) 
  (revert-buffer nil 't))

(defun revert-buffer-with-prejudice () 
  (interactive) 
  (revert-buffer t t ))


(defun reboot-python ()
  (interactive)
  (save-current-buffer
    (let ( kill-buffer-query-functions '() )
      (if (get-buffer "*Python*") (kill-buffer "*Python*") )
      (if (get-buffer "*Jython*") (kill-buffer "*Jython*") ))))

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/Dropbox/gtd.org" "Tasks")
             "* TODO %?\n")
	("p" "Performance" entry (file+headline "~/Dropbox/gtd.org" "Performance")
	    "* TODO %?\n")
	("s" "Schedule" entry (file+headline "~/Dropbox/gtd.org" "Schedule")
	 "* %?\n")
        ("j" "Journal" entry (file+datetree "~/Dropbox/journal.org")
             "* %U %?")))

;; (set-frame-font "-misc-fixed-medium-r-normal--14-*-75-75-c-70-iso8859-5")
;; (set-frame-font "-misc-fixed-medium-r-normal--15-*-75-75-c-90-iso8859-1")
;; (set-frame-font "-misc-fixed-medium-r-normal--10-*-75-75-c-60-iso8859-8")
;; (set-frame-font "-misc-fixed-medium-r-normal--11-*-100-100-c-80-iso8859-8")
;; (set-frame-font "-misc-fixed-medium-r-normal--12-*-100-100-c-80-iso8859-8")
;; (set-frame-font "-misc-fixed-medium-r-normal--14-*-100-100-c-80-iso8859-8")
(set-frame-font "-misc-fixed-medium-r-normal--15-*-75-75-c-90-iso8859-16")
;;(set-frame-font "-misc-fixed-medium-r-semicondensed--13-*-75-75-c-60-iso8859-15")
;; (set-frame-font "-urw-Nimbus Mono L-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-urw-Nimbus Mono L-bold-normal-normal-*-*-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-10-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-12-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-15-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-20-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-21-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-22-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-23-*-*-*-m-0-iso10646-1")


;; (set-frame-font "-unknown-Liberation Mono-normal-normal-normal-*-40-*-*-*-m-0-iso10646-1")

;(add-to-list 'load-path "~/.emacs.d/python-mode")

; Put in thegge front - have had issues/conflicts with elpa :-(
(setq load-path (cons "/home/andy/.emacs.d/python-mode" load-path))
(setq load-path (cons "/home/andy/.emacs.d/ipython"     load-path))

;(require 'python-mode)

(defun insert-hg-ignore () 
  (interactive)
  (insert "`hg root`/.hgignore"))

(global-set-key (kbd "C-c C-h C-g C-i" ) 'insert-hg-ignore)

(add-to-list 'auto-mode-alist '("SConstruct" . python-mode) )
(add-to-list 'auto-mode-alist '("SConscript" . python-mode) )
(add-to-list 'auto-mode-alist '("\\.py$" . python-mode) )

(setq interpreter-mode-alist (cons '("python" . python-mode)
				   interpreter-mode-alist))
(autoload 'python-mode "python-mode" "Python editing mode." t)

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

					;(setq py-install-directory "/home/andy/.emacs.d/python-mode.el-6.1.1")
					;(add-to-list 'load-path py-install-directory)
					;(require 'python-mode)
					;(require 'python-mode)
					;(require 'ipython)
					;(color-theme-solarized-darkp)
					; (elpy-enable)
					; (elpy-use-ipython)
(ido-mode 't)

(require 'flymake-haskell-multi)

(autoload 'ghc-init "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init) ))
(add-hook 'haskell-mode-hook 'flymake-haskell-multi-load)


(require 'ipython)


;(add-to-list 'load-path "/path/to/js2-mode/directory")

(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" "4c9ba94db23a0a3dea88ee80f41d9478c151b07cb6640b33bfc38be7c2415cc4" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "20da72c1ae6c0c78602c99d1ccf20097486efd2e70d7578ea1cf89f8c1aa6b53" default)))
 '(elpy-rpc-backend "rope")
 '(flymake-gui-warnings-enabled nil)
 '(org-agenda-files (quote ("~/org/anotherFile.org" "~/org/gtd.org" "~/org/agenda.org")))
 '(org-agenda-include-diary t)
 '(org-hide-leading-stars t)
 '(py-python-command-args (quote ("--pylab")))
 '(python-python-command "ipython --pylab")
 '(revert-without-query (quote (".*\\.dat")))
 '(show-paren-mode t)
 '(show-paren-style (quote mixed))
 '(tab-width 3)
 '(tool-bar-mode nil))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


