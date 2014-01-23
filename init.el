(require 'package)

(add-to-list 'package-archives 
	     '("marmalade" .
	       "http://marmalade-repo.org/packages/"))





(package-initialize)

(global-set-key [f1]  'wg-switch-to-workgroup)
(global-set-key [f7]  'compile)
(global-set-key [f8]  'reboot-python)
(global-set-key [f9]  'py-execute-region)
(global-set-key [f10] 'switch-to-shell)

(defun switch-to-shell () 
  (interactive)
  (switch-to-buffer "*shell*")
  )

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
(add-to-list 'package-archives 
	     '("marmalade" .
	       "http://marmalade-repo.org/packages/"))

(package-initialize)

(require 'color-theme)
(color-theme-jonadabian)

(global-set-key [f1] 'wg-switch-to-workgroup)
(global-set-key [f7] 'compile)
(global-set-key [f9] 'py-execute-region)
(global-set-key [f10] 'switch-to-shell)
(global-set-key (kbd "C-c o") 'ff-find-other-file)
(global-set-key (kbd "C-c f") 'find-file-at-point)

(defun switch-to-shell () 
  (interactive)
  (switch-to-buffer "*shell*")
  )

(require 'auto-complete-config)

(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(require 'auto-complete-config)
(ac-config-default)

(windmove-default-keybindings 'meta)

(require 'color-theme)
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




(defun reboot-python ()
  (interactive)
  (save-current-buffer
    ; Stop it from prompting at us
    ( let ( kill-buffer-query-functions '() )
      (if (get-buffer "*Python*") (kill-buffer "*Python*") )
      (if (get-buffer "*Jython*") (kill-buffer "*Jython*") )
      ; (py-shell) todo this seems to launch a messed up ipython
      )
    )
  )

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/gtd.org" "Tasks")
             "* TODO %?\n")
	("p" "Performance" entry (file+headline "~/org/gtd.org" "Performance")
	    "* TODO %?\n")
	("s" "Schedule" entry (file+headline "~/org/gtd.org" "Schedule")
	 "* %?\n")
        ("j" "Journal" entry (file+datetree "~/org/journal.org")
             "* %U %?")))

;(set-default-font "Ubuntu Mono:pixelsize=12:foundry=unknown:weight=normal:slant=normal:width=normal:spacing=100:scalable=true")
;(set-default-font "Ubuntu Mono:pixelsize=16:foundry=unknown:weight=normal:slant=normal:width=normal:spacing=100:scalable=true")
;(set-default-font "Ubuntu Mono:pixelsize=20:foundry=unknown:weight=normal:slant=normal:width=normal:spacing=100:scalable=true")
;(set-default-font "Ubuntu Mono:pixelsize=12:foundry=unknown:weight=normal:slant=normal:width=normal:spacing=100:scalable=true")

(set-default-font "Liberation Mono:pixelsize=14")
(add-to-list 'load-path "~/.emacs.d/python-mode")

(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist (cons '("python" . python-mode)
				   interpreter-mode-alist))
(autoload 'python-mode "python-mode" "Python editing mode." t
  )

(require 'ipython)
(require 'workgroups)

(workgroups-mode 1)
(setq wg-prefix-key (kbd "C-c w"))
(wg-load "~/.emacs.d/workgroups.el")

(tool-bar-mode 0)
(menu-bar-mode 0)

;; (defun set-auto-complete-as-completion-at-point-function ()
;;   (setq wcompletion-at-point-functions '(auto-complete)))
;; (add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)
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
 '(show-paren-mode t)
 '(show-paren-style (quote mixed))
 '(tool-bar-mode nil))




(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; (set-default-font "Liberation Mono:pixelsize=12")
;; (set-default-font "Liberation Mono:pixelsize=12")
;; (set-default-font "Liberation Mono:pixelsize=12")
;; (set-default-font "Liberation Mono:pixelsize=12")
;; (set-default-font "Liberation Mono:pixelsize=12")
;; (set-default-font "Liberation Mono:pixelsize=25")

(add-to-list 'load-path "~/.emacs.d/python-mode")

(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist (cons '("python" . python-mode)
				   interpreter-mode-alist))
(autoload 'python-mode "python-mode" "Python editing mode." t
  )

(require 'ipython)

(require 'workgroups)
(workgroups-mode 1)
(setq wg-prefix-key (kbd "C-c w"))
(wg-load "~/.emacs.d/workgroups.el")

(tool-bar-mode 0)
(menu-bar-mode 0)


(require 'color-theme)



;; (defun set-auto-complete-as-completion-at-point-function ()
;;   (setq wcompletion-at-point-functions '(auto-complete)))
;; (add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)
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







