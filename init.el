;;; init.el --- Andy's emacs config

;;; Commentary:

;; Raffles laptop Emacs config

;;; Code:

;; (set-frame-font "Fixed 12")
;; (set-frame-font "Liberation Mono 24")

;; (set-frame-font "Ubuntu Mono 48")

;; (setq helm-echo-input-in-header-line nil)

;; Nice runing from Mac. (set-fraxme-font "-misc-fixed-medium-r-normal--10-*-75-75-c-60-iso8859-7
;; (set-frame-font "Ubuntu Light 15")
;; (set-frame-font "Ubuntu Normal 15")
;; (set-frame-font "Fixed 10")

(set-frame-font "-misc-fixed-medium-r-semicondensed--13-*-75-75-c-60-iso8859-16" )
(set-frame-font "-misc-fixed-medium-r-normal--14-*-75-75-c-70-iso8859-5" )
(set-frame-font "-misc-fixed-medium-r-normal--15-*-75-75-c-90-iso8859-8" )

(require 'compile)
(require 'package)

(add-to-list 'package-archives '("melpa"     . "http://melpa.org/packages/"))

(setq auto-mode-alist
      (cons '("SConstruct" . python-mode) auto-mode-alist))
(setq auto-mode-alist
      (cons '("SConscript" . python-mode) auto-mode-alist))


(add-to-list 'auto-mode-alist '("\\.hdl\\'" . nand2tetris-mode))

(add-to-list 'auto-mode-alist '("\\.jsx\\'" . jsx-mode))
(autoload 'jsx-mode "jsx-mode" "JSX mode" t)

(eval-after-load "org-present"
  '(progn
     (add-hook 'org-present-mode-hook
               (lambda ()
                 (org-present-big)
                 (org-display-inline-images)
                                        ;(org-present-hide-cursor)
                                        ;(org-present-read-only))
                 ))
     (add-hook 'org-present-mode-quit-hook
               (lambda ()
                 (org-present-small)
                 (org-remove-inline-images)
                 (org-present-show-cursor)
                 (org-present-read-write)))))

(defun slurp (x)
  "Clojure slurp function.  Slurp file X."
  (with-temp-buffer
    (insert-file-contents x)
    (buffer-string)))

(defun debug-discovery ()
  "Debug the discovery app."
  (interactive)
  (gdb "gdb -i=mi -nx -x /home/andy/discovery.gdbinit"))

(defun debug-chatserver ()
  "Debug the discovery app."
  (interactive)
  (gdb "gdb -i=mi -nx -x /home/andy/chatServer.gdbinit"))

(global-set-key (kbd "C-x C-o") 'ff-find-other-file)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "<menu>") 'helm-M-x)

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

(defun compile-agora-debug ()
  (interactive)
  (compile-in-own-buffer "build agora" "rm -rf ~/agora_debug && mkdir -p ~/agora_debug && cd ~/agora_debug && cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=~/agora_debug/install -G 'Unix Makefiles' ~/repos/agora && make install"))

(defun compile-agora-release ()
  (interactive)
  (compile-in-own-buffer "build agora" "rm -rf ~/agora_release && mkdir -p ~/agora_release && cd ~/agora_release && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=~/agora_release/install -G 'Unix Makefiles' ~/repos/agora && make install"))

(defun compile-gem ()
  (interactive)
  (compile-in-own-buffer "build gem" "cd ~/repos/gem/cpp && scons"))


(defun compile-imgui ()
  (interactive)
  (compile-in-own-buffer "build imgui" "cd ~/repos/imgui && scons -c && scons"))

(defun compile-imgui-example ()
  (interactive)
  (compile-in-own-buffer "build imgui-example" "cd ~/repos/imgui/examples/sdl_opengl3_example && scons -c && scons"))

(defun compile-box2d ()
  (interactive)
  (compile-in-own-buffer "build box2d" "cd /home/andy/repos/Box2D/Box2D/Box2D && scons -c && scons"))

(defun compile-testbed ()
  (interactive)
  (compile-in-own-buffer "build testbed" "cd /home/andy/repos/Box2D/Box2D/Testbed && scons -c && scons"))

(defun compile-demo ()
  (interactive)
  (compile-in-own-buffer "build demo" "cd ~/repos/imgui/examples/sdl_opengl3_example && scons -c && scons"))

(defun compile-discovery ()
  (interactive)
  (compile-in-own-buffer "build discovery" "cd ~/repos/agora && make"))

(defun find-file-in-clipboard () 
  (interactive)
  (find-file-at-point (gui-get-selection)))

;; (global-set-key (kbd "C-c p")  'find-file-in-clipboard)
;; (define-key global-map (kbd "C-c p") nil)

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

(package-initialize)

(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;;(global-set-key (kbd "C-s")  'swiper-helm))
(global-set-key (kbd "C-s")  'isearch-forward)

(require 'workgroups)
(setq wg-prefix-key (kbd "C-c w"))
(workgroups-mode)

(require 'haskell-interactive-mode)
(require 'haskell-process)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)

(projectile-mode)
(helm-projectile-on)

;; '(flycheck-clang-language-standard "c++14")
;; '(flycheck-gcc-language-standard "c++14")


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
 '(company-clang-arguments nil)
 '(compilation-message-face (quote default))
 '(custom-safe-themes
   (quote
    ("4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" default)))
 '(display-time-world-list
   (quote
    (("America/Chicago" "Chicago")
     ("America/New_York" "New York")
     ("Europe/London" "London")
     ("Australia/Perth" "Perth"))))
 '(flycheck-c/c++-clang-executable "clang-5.0")
 '(flycheck-clang-args (quote ("-xc++")))
 '(flycheck-clang-language-standard "c++14")
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t)
 '(haskell-process-suggest-remove-import-lines t)
 '(helm-M-x-fuzzy-match t)
 '(helm-display-buffer-default-size 100)
 '(helm-locate-project-list (quote ("/home/andy/repos/dev")))
 '(ibuffer-saved-filter-groups (quote (("mydefs" ("agora+dev" (used-mode . c++-mode))))))
 '(ibuffer-saved-filters
   (quote
    (("foo2"
      ((mode . c++-mode)
       (or
        (projectile-files . "/mnt/hdd/andy/repos/dev")
        (projectile-files . "/mnt/hdd/andy/repos/agora"))))
     ("foo"
      ((mode . c++-mode)
       (or
        (projectile-files . "/mnt/hdd/andy/repos/dev")
        (projectile-files . "/mnt/hdd/andy/repos/agora"))))
     ("~/filters.el"
      ((mode . c++-mode)
       (or
        (projectile-files . "/mnt/hdd/andy/repos/dev")
        (projectile-files . "/mnt/hdd/andy/repos/agora"))))
     ("gnus"
      ((or
        (mode . message-mode)
        (mode . mail-mode)
        (mode . gnus-group-mode)
        (mode . gnus-summary-mode)
        (mode . gnus-article-mode))))
     ("programming"
      ((or
        (mode . emacs-lisp-mode)
        (mode . cperl-mode)
        (mode . c-mode)
        (mode . java-mode)
        (mode . idl-mode)
        (mode . lisp-mode)))))))
 '(inferior-octave-startup-args (quote ("-i" "--line-editing")))
 '(magit-diff-use-overlays nil)
 '(nyan-mode t)
 '(org-agenda-files nil)
 '(org-directory "~/Dropbox/gtd")
 '(org-format-latex-options
   (quote
    (:foreground default :background default :scale 5.0 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers
                 ("begin" "$1" "$" "$$" "\\(" "\\["))))
 '(org-hide-leading-stars t)
 '(package-selected-packages
   (quote
    (helm-unicode cmake-mode nim-mode json-rpc restclient workgroups2 gnuplot gnuplot-mode orgtbl-ascii-plot forth-mode csv-mode nand2tetris git-gutter rjsx-mode org-present json-mode d-mode ponylang-mode flycheck-pony cider clojure-mode wrap-region multiple-cursors ag helm-projectile dumb-jump helm-cscope ein elpy swift3-mode yaml-mode workgroups web-mode utop tuareg tide switch-window swiper-helm solarized-theme sml-mode smex skewer-mode scala-mode2 sass-mode rust-mode rtags rainbow-delimiters quack pylint protobuf-mode paredit org nyan-mode nurumacs nodejs-repl nasm-mode monokai-theme monky markdown-mode magit less-css-mode jsx-mode js3-mode jedi jade-mode ido-ubiquitous iasm-mode helm-swoop helm-package helm-gtags helm-dash helm-company helm-cider helm-ag groovy-mode graphviz-dot-mode go-mode ghci-completion ghc-imported-from ghc ggtags geiser fsharp-mode fountain-mode flymake-haskell-multi flycheck-pyflakes flycheck-irony flycheck-haskell find-file-in-project ensime elm-mode edts dash-functional dart-mode csv-nav csharp-mode color-theme-solarized color-theme-sanityinc-solarized color-theme-eclipse color-theme-cobalt coffee-mode clang-format caroline-theme caml auctex ace-jump-mode ac-slime ac-helm ac-haskell-process ac-clang ac-cider abyss-theme 2048-game)))
 '(projectile-tags-backend (quote ggtags))
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
 '(vc-annotate-very-old-color nil t)
 '(wg-morph-on nil))
(defun switch-to-org ()
  (interactive)
  (switch-to-buffer "gtd.org")
  )

(global-set-key [f1]  'wg-switch-to-workgroup)
(global-set-key [f2]  'ace-jump-mode)
(global-set-key [f3]  'helm-cscope-find-global-definition)
(global-set-key [f4]  'magit-status)
(global-set-key [f6]  'helm-man-woman)
(global-set-key [f7]  'compile)
(global-set-key [f8]  'reboot-python)
(global-set-key [f9]  'py-execute-region)
;;(global-set-key [f10] 'switch-to-shell)
(global-set-key [f10] 'clang-format-buffer)
(global-set-key [f12] 'ace-jump-mode)
(global-set-key [f1] 'wg-switch-to-workgroup)
(global-set-key (kbd "C-c o") 'ff-find-other-file)
(global-set-key (kbd "C-c f") 'find-file-at-point)

(global-set-key (kbd "C-M-g") 'dumb-jump-go)

(nyan-mode)

(message "goo")

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

;;(global-set-key (kbd "C-c C-h C-g C-i" ) 'insert-hg-ignore)

(require 'workgroups)
(setq wg-prefix-key (kbd "C-c w"))
;; (setq wg-file "~/wg.el")
;; (workgroups-mode 1)
;;(wg-load wg-file)


(tool-bar-mode 0)
(menu-bar-mode 0)

(require 'flymake-haskell-multi)
(autoload 'ghc-init "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init) ))
(add-hook 'haskell-mode-hook 'flymake-haskell-multi-load)

(setq-default indent-tabs-mode nil)

(require 'slime-autoloads)
(slime-setup '(slime-fancy))
(require 'ac-slime)
(add-hook 'slime-mode-hook      'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'slime-repl-mode))

(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.ice$" . idl-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(global-set-key (kbd "C-x C-x") 'expand-abbrev)

(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")

(eval-after-load "auto-complete"
  '(add-to-list 'ac-sources 'ac-source-yasnippet))
(ac-config-default)

;; (eval-after-load "ggtags"
;;   (progn
;;     (define-key ggtags-mode-map (kbd "M->") nil)
;;     (define-key ggtags-mode-map (kbd "M-<") nil)))

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

(defun square-bracket ()
  (interactive)
  (save-excursion)
  (let* ((start-pos (region-beginning))
         (end-pos (region-end)))
    (goto-char start-pos)
    (insert-char ?\[)
    (goto-char (1+ end-pos) )
    (insert-char ?\])))

(defun do-list ()
  (interactive)
  (save-excursion 
    (let* (
           (start-pos (region-beginning))
           (start-line (line-number-at-pos start-pos ))
           (end-line   (line-number-at-pos (region-end))))
      (message (format "%s %s %s" start-pos start-line end-line))
      (goto-char start-pos)
      (message (format "%s %s" end-line (line-number-at-pos)))
      (while (< (line-number-at-pos) end-line)
        (message (format "point is %s end is %s" (line-number-at-pos) end-line))
        (move-beginning-of-line nil)
        (message "boo")
        (insert-char ?\")
        (move-end-of-line nil)
        (insert-char ?\")
        (if (> ( - end-line (line-number-at-pos)  ) 1 )
            (insert-char ?,))
        (next-line 1)
        (message (format "point is %s end is %s" (line-number-at-pos) end-line))
        ))))

(global-set-key (kbd "C-c [") 'square-bracket)
;;(global-set-key (kbd "C-c C-p C-p") 'do-list)

(message "boo")

(defun parse-epoch-time (s)
  "Parse symbol into an epoch time. Use heuristics to determine if dealing
with micros, seconds, nanos etc. Display result using 'message' if successful"
  (let* ((x (float (string-to-number s )))
         (epoch 1970 )
         (secsperday (* 24 60 60))
         (secsperyear (* 365.25 secsperday))
         (inrange
          (lambda (tup)
            (let* ((prefix (car tup))
                   (pow    (cdr tup))
                   (divisor (expt 10 pow))
                   (secs (/ x divisor))
                   (year (+ epoch (/ secs secsperyear))))
              (when (< 1980 year 2060)
                (cons secs prefix)))))
         (match (-some inrange '( ("s"  . 0)
                                  ("ms" . 3)
                                  ("µs" . 6)
                                  ("ns" . 9)))))
    (if match
        (let* ((seconds (car match))
               (prefix  (cdr match))
               (isofmt  (format-time-string "%Y-%m-%dT%H:%M:%S.%N" (seconds-to-time seconds))))
          (message (format "%s (%s) -> %s" x prefix isofmt))))))

; (format-time-string "%H:%M:%S" (current-time))
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
                        ("int32"        . 4 ))))
      (message "%s" (re-search-backward "<message") )
      (beginning-of-line)
      (forward-line)
      (while (not (re-search-forward "</message>" (line-end-position) t) )
        (let* ((current-line (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
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

(global-set-key [f3] 'parse-sbe)
  
(defun parse-epoch-time-at-point ()
  (interactive)
  (parse-epoch-time (thing-at-point 'symbol)))

(global-set-key (kbd "C-c C-p C-t") 'parse-epoch-time-at-point)

;(parse-epoch-time "1482672627.025747002" ) a
;(parse-epoch-time "1482672627025.747023" )
;(parse-epoch-time "1482672627025747.032" )
;(parse-epoch-time "1482672627025747023"  )

(message "garoo")

; (setq python-shell-exec-path '( "/home/andy/anaconda3/bin"))

(defun daysBetween (s f)
  (let* ((seconds-per-day ( * 24 60 60 ))
         (conv (lambda (x)
                 (let ((bits (mapcar 'string-to-int (split-string x "-"))))
                   (apply 'encode-time (list 0 0 0 (nth 2 bits) (nth 1 bits) (nth 0 bits))))))
         (st (funcall conv s))
         (ft (funcall conv f)))
    (/ (time-to-seconds (time-subtract ft st)) seconds-per-day)))

;; (daysBetween "1973-05-09" "2016-11-01") 15882.041666666666
 
(eval-after-load 'company
  '(progn
     (define-key company-mode-map (kbd "C-:") 'helm-company)
     (define-key company-mode-map (kbd "M-/") 'company-complete)
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
     (define-key js2-mode-map (kbd "C-c C-r") 'nodejs-repl-send-region)
     (define-key js2-mode-map (kbd "C-c C-c") 'nodejs-repl-send-buffer)
     ))

(defun end-of-sml (a b &rest xs)
  "A Im interactive."
  (interactive)
  (switch-to-buffer "*SML*")
  (end-of-buffer)) 

; (advice-add 'sml-prog-proc-load-file :after 'end-of-sml)
; (advice-remove 'sml-prog-proc-load-file)

;; SQL Stuff
;; (require 'sql)
;; (load-file "~/.emacs.d/sql-interactive-remove-continuation-prompt.el")
;; (require 'sql-interactive-remove-continuation-prompt)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init.el)
;;; init.el ends here
