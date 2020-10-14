;;; init.el --- Andy's emacs config

;;; Commentary:

;; Ritz laptop Emacs config

;;; Code:

;; (set-frame-font "-Misc-Misc Tamsyn-normal-normal-normal-*-20-*-*-*-c-100-iso10646-1" )

;; (set-frame-font "Bedstead 15")

;; (set-frame-font "Meslo LG L" 't)
;; (set-frame-font "Misc Fixed" 't) 
;; (set-frame-font "Tamsyn" 't)
;; (set-frame-font "Andale Mono 13")
;; (set-frame-font "Hack" 't) 
;; (set-frame-font "Misc Fixed" 't)

;;(set-frame-font "-Misc-Misc Tamsyn-normal-normal-normal-*-20-*-*-*-c-100-iso10646-1" )
(set-frame-font "Hack 12")
;;(set-frame-font "Bedstead Semicondensed 18")


;;(set-frame-font "Terminus 16")

;; (set-frame-font "Liberation Mono" 't)
;; (set-frame-font "Ubuntu Mono" 't)

;; (set-frame-font "Ubuntu Mono 16")
;; (set-frame-font "DejaVu Sans Mono" 't)
;; (set-frame-font "Consolas" 't)
;; (set-frame-font "Inconsolata" 't)
;; (set-frame-font "Courier New Bold" 't)
;; (set-frame-font "Courier New 20")

;; ΠπðÐþÐσΣ Ж ж Unicode test!! Ꝥ

;; (set-frame-font "-unknown-Dina-normal-normal-normal-*-10-*-*-*-c-*-iso10646-1")
;; (set-frame-font "-unknown-Dina-normal-normal-normal-*-12-*-*-*-c-*-iso10646-1")
;; (set-frame-font "-unknown-Dina-normal-normal-normal-*-13-*-*-*-c-*-iso10646-1")

;; (set-frame-font "-xos4-xos4 Terminus-normal-normal-normal-*-12-*-*-*-c-60-iso10646-1")
;; (set-frame-font "-xos4-xos4 Terminus-normal-normal-normal-*-14-*-*-*-c-80-iso10646-1")
;; (set-frame-font "-xos4-xos4 Terminus-normal-normal-normal-*-16-*-*-*-c-80-iso10646-1")
;; (set-frame-font "-xos4-xos4 Terminus-normal-normal-normal-*-18-*-*-*-c-100-iso10646-1")
;; (set-framee-font "-xos4-xos4 Terminus-normal-normal-normal-*-20-*-*-*-c-100-iso10646-1")
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
;; (set-frame-font "Hack 14")
(require 'compile)
(require 'package)
(package-initialize)

;; Notes on ripgrep https://gist.github.com/pesterhazy/fabd629fbb89a6cd3d3b92246ff29779

(add-to-list 'package-archives '("melpa"     . "http://melpa.org/packages/"))
(add-to-list 'auto-mode-alist '("SConscript" . python-mode))
(add-to-list 'auto-mode-alist '("SConstruct" . python-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
;;(add-to-list 'auto-mode-alist '("\\.hdl\\'" . nand2tetris-mode))

(add-to-list 'auto-mode-alist '("\\.jsx\\'" . jsx-mode))
(autoload 'jsx-mode "jsx-mode" "JSX mode" t)

(require 'dash)
;; (mapcar (lambda (hook) (add-hook hook (lambda ()
;;                                         (auto-fill-mode 't)
;;                                         (flyspell-mode 't))))
;;         (list (org-mode-hook org-capture-mode-hook )))

;;(eval-after-load "org"
;;   '(define-key org-mode-map [remap org-kill-line] nil))

(add-hook 'org-mode-hook
          (lambda ()
            (message "Running your org mode hok")
            (auto-fill-mode 't)
            (flyspell-mode 't)
            (define-key org-mode-map [f1] 'org-kanban/shift)
            (define-key org-mode-map [f8] 'org-kanban/shift)))

;; Meh copy/paste. Maybe nicer way of reducing boilerplate
(add-hook 'org-capture-mode-hook
          (lambda ()
            ;;(message "Running your org mode hok")
            (auto-fill-mode 't)
            (flyspell-mode 't)))

(message "Woohoo")

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

(defun debug-test-binary ()
  "Debug the discovery app."
  (interactive)
  (gdb "gdb -i=mi -nx -x /home/andy/gdbinit/test_binary.gdbinit"))

(defun debug-test-mmapper ()
  "Mmapper"
  (interactive)
  (shell-command "rm -rf /tmp/test.*")
  (gdb "gdb -i=mi -nx -x /home/andy/gdbinit/test_mmapper.gdbinit"))

(defun debug-test-admin ()
  "Debug the discovery app."
  (interactive)
  (gdb "gdb -i=mi -nx -x /home/andy/gdbinit/test_admin.gdbinit"))

(defun test_agora ()
  "Debug the discovery app."
  (interactive)
  (gdb "gdb -i=mi -nx -x /home/andy/gdbinit/test_agora.gdbinit"))

(defun debug-chatserver ()
  "Debug the discovery app."
  (interactive)
  (gdb "gdb -i=mi -nx -x /home/andy/chatServer.gdbinit"))

(defun debug-epoll-session ()
  "Debug the discovery app."
  (interactive)
  (gdb "gdb -i=mi -nx -x /home/andy/gdbinit/test_epoll.gdbinit"))

(global-set-key (kbd "C-x C-o") 'ff-find-other-file)
(global-set-key (kbd "C-=") 'undo)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "<menu>") 'helm-M-x)

(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-c C-h C-s") 'helm-swoop)
(global-set-key (kbd "C-c C-h C-l") 'helm-locate)
(global-set-key (kbd "C-c C-h C-a") 'helm-do-ag)
(global-set-key (kbd "C-c C-f C-i C-x") 'parse-fix)


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

;;(require 'flycheck-kotlin)
;;(add-hook 'kotlin-mode-hook 'flycheck-mode)

;; (set-frame-font "Liberation Mono 12")
;; (set-frame-font "Ubuntu Mono 14")

(add-hook
 'd-mode-hook
 (lambda () 
   (define-key d-mode-map (kbd "<f9>") 'dfmt-buffer)))

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

;; (add-hook
;;  'python-mode-hook
;;  (lambda ()
;;    (define-key python-mode-map (kbd "C-M-x") 'python-eval-defun-at-point)))

(defun compile-agora-debug ()
  (interactive)
  (compile-in-own-buffer "build agora debug" "rm -rf ~/agora_debug && mkdir -p ~/agora_debug && cd ~/agora_debug && cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=~/agora_debug/install -G 'Unix Makefiles' ~/repos/agora && make install"))

(defun compile-agora-release ()
  (interactive)
  (compile-in-own-buffer "build agora release" "rm -rf ~/agora_debug && mkdir -p ~/agora_release && cd ~/agora_release && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=~/agora_release/install -G 'Unix Makefiles' ~/repos/agora && make install"))

(defun fast-compile-agora-debug ()
  (interactive)
  (compile-in-own-buffer "build agora debug" "cd ~/agora_debug && make -j 4"))

(defun fast-compile-agora-release ()
  (interactive)
  (compile-in-own-buffer "build agora release" "cd ~/agora_release && make -j 4 && make install"))

(defun fast-compile-agora-release ()
  (interactive)
  (compile-in-own-buffer "build agora release" "cd ~/agora_release && make -j 4"))


(defun compile-box2d ()
  (interactive)
  (compile-in-own-buffer "build box2d debug" "rm -rf ~/box2d_debug && mkdir -p ~/box2d_debug && cd ~/box2d_debug && cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=~/agora_debug/install -G 'Unix Makefiles' ~/repos/Box2D && make VERBOSE=1"))


(defun compile-box2d ()
  (interactive)
  (compile-in-own-buffer "build box2d debug" "cd ~/box2d_debug && cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=~/agora_debug/install -G 'Unix Makefiles' ~/repos/Box2D && make VERBOSE=1"))


(defun compile-agora-release ()
  (interactive)
  (compile-in-own-buffer "build agora release" "rm -rf ~/agora_release && mkdir -p ~/agora_release && cd ~/agora_release && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=~/agora_release/install -G 'Unix Makefiles' ~/repos/agora && make install"))

(defun compile-gem ()some
  (interactive)
  (compile-in-own-buffer "build gem" "cd ~/repos/gem/cpp && scons"))

(defun compile-imgui-example ()
  (interactive)
  (compile-in-own-buffer "build imgui-example" "cd ~/repos/imgui/examples/sdl_opengl3_example && scons -c && scons"))


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
  (message "f is %s" (car kill-ring))
  (find-file-at-point (car kill-ring)))

;;(x-get-selection) 

(global-set-key (kbd "C-c p")  'find-file-in-clipboard)
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



(require 'dash)
(require 's)
(require 'multiple-cursors)
(require 'helm)
(helm-mode 1)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;;(global-set-key (kbd "C-s")  'swiper-helm))
;;(global-set-key (kbd "C-s")  'isearch-forward)

(require 'workgroups)
(setq wg-prefix-key (kbd "C-c w"))
(workgroups-mode)
(wg-load "~/.emacs.d/wg.el")

(require 'haskell-interactive-mode)
(require 'haskell-process)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)

;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/Dropbox/gtd/flagged.org")
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")

(projectile-mode)
(helm-projectile-on)
;; '(flycheck-clang-language-standard "c++14")
;; '(flycheck-gcc-language-standard "c++14")

(defun text-scale-smaller ()
  (interactive)
  (text-scale-adjust -1))

(defun text-scale-bigger ()
  (interactive)
  (text-scale-adjust 1))

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

;; (global-set-key [f1]  'wg-switch-to-workgroup)
;; (global-set-key [f2]  'helm-world-time)
;; (global-set-key [f3]  'helm-cscope-find-global-definition)
(global-set-key [f4]  'magit-status)
;;(global-set-key [f6]  'helm-man-woman)
(global-set-key [f7]  'compile)
(global-set-key [f8]  'reboot-python)
(global-set-key [f9]  'py-execute-region)
(global-set-key [f9]  'org-table-recalculate)

;; (global-set-key [f10] 'switch-to-shell)
(global-set-key [f10] 'clang-format-buffer)
(global-set-key [f12] 'ace-jump-mode)

(global-set-key (kbd "M-SPC") 'ace-jump-mode)
;;(global-set-key [f1] 'wg-switch-to-workgroup)
(global-set-key (kbd "C-c o") 'ff-find-other-file)
(global-set-key (kbd "C-c f") 'find-file-at-point)
(global-set-key (kbd "C-M-g") 'dumb-jump-go)

(nyan-mode 't)

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

(require 'color-theme)
(color-theme-initialize)
;;(color-theme-midnight)
;;(color-theme-deep-blue)

(windmove-default-keybindings 'meta)

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
    (org-ctrl-c-ctrl-c)))
(global-set-key [f7]  'refresh-kanban)


(require 'workgroups)
(setq wg-prefix-key (kbd "C-c w"))
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

;; (setq org-capture-templates '(("t" "Todo" entry (file+headline "~/Dropbox/gtd/kanban.org" "Tasks")
;;                                "* TODO %?")
;;                               ("r" "Todo" entry (file+headline "~/Dropbox/gtd/kanban.org" "Tasks")
;;                                "* TODO %?\n  %i\n  %a")
;;                               ("r" "Todo" entry (file+headline "~/Dropbox/gtd/kanban.org" "Tasks")
;;                                "* TODO %?\n%F")
;;                               ("c" "Correspondance" entry (file+datetree "~/Dropbox/gtd/corresp.org")
;;                                "* %U %?")
;;                               ("j" "Journal" entry (file+datetree "~/Dropbox/gtd/journal.org")
;;                                "* %U %?")))

(global-set-key (kbd "C-c s") 'ispell)
(global-set-key (kbd "C-c r") 'revert-buffer-with-prejudice)

(require 'flycheck-pyflakes)
(add-hook 'python-mode-hook 'flycheck-mode)




;;(autoload 'pylint "pylint")
;;(add-hook 'python-mode-hook 'pylint-add-menu-items)
;;(add-hook 'python-mode-hook 'pylint-add-key-bindings)

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



(defun parse-epoch-time (s)
  "Parse symbol into an epoch time. Use heuristics to determine if dealing
with micros, seconds, nanos etc. Display result using 'message' if successful"
  (require 'dash)
  (let* ((x (float (string-to-number s)))
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
         (match (-some inrange '(("s"  . 0)
                                 ("ms" . 3)
                                 ("µs" . 6) 
                                 ("ns" . 9)))))
    (if match
        (let* ((seconds (car match))
               (prefix  (cdr match))
               (isofmt  (format-time-string "%Y-%m-%dT%H:%M:%S.%N" (seconds-to-time seconds))))
          (message (format "%s (%s) -> %s" x prefix isofmt))))))

(global-set-key [f11] 'parse-fix)

; (parse-epoch-time "1482672627.025747002" ) "1482672627.025747 (s) -> 2016-12-25T13:30:27.025747060"
; (parse-epoch-time "1482672627025.747023" ) "1482672627025.747 (ms) -> 2016-12-25T13:30:27.025747060"
; (parse-epoch-time "1482672627025747.032" ) "1482672627025747.0 (µs) -> 2016-12-25T13:30:27.025747060"
; (parse-epoch-time "1482672627025747023"  ) "1.482672627025747e+18 (ns) -> 2016-12-25T13:30:27.025747060"
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
      (message "%s" (re-search-backward "<message"))
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


(load "~/.emacs.d/tags.el")

(defun parse-fix ()
  (interactive)
  (let* ((msg (thing-at-point 'line))
         (parsed (->> msg
                      (string-match "8=FIX.*")
                      (substring msg)
                      (s-split "")
                      (--map (s-split "=" it))
                      (--filter (= (length it) 2))
                      (--map (apply 'cons it))
                      (-map (-lambda ((tag_value &as tag . value))
                               (list (gethash tag tags-hash)
                                     tag
                                     (--if-let (gethash tag_value enums-hash) (format "%s (%s)" value it) value))))
                      (--map (apply 'format "%30s : %5s = %-10s" it))
                      (s-join "\n"))))
    (switch-to-buffer (generate-new-buffer "FIX"))
    (insert (format "\n%s\n==========================\n\n%s" msg parsed))))



;;(global-set-key [f3] 'parse-sbe)

(defun wu (fmt x)
  (message fmt x)
  x)

;; Fixed !!!
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

(format "%s" 12)

;; (commify 1234) "1,234"
;; (commify 63766473674326) "63,766,473,674,326"
;; (commify 1234)

(defun parse-epoch-time-at-point ()
  (interactive)
  (parse-epoch-time (thing-at-point 'symbol)))

(global-set-key (kbd "C-c C-p C-t") 'parse-epoch-time-at-point)

(require 'time)

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
;; (daysBetween "1973-05-09" "2019-07-26")

(eval-after-load 'company
  '(progn
     (define-key company-mode-map (kbd "C-:") 'helm-company)
     (define-key company-mode-map (kbd "M-/") 'company-complete)
     (define-key company-active-map (kbd "C-:") 'helm-company)))

(add-to-list 'exec-path "/home/andy/bin:/home/andy/.sdkman/candidates/leiningen/current/bin")
(add-to-list 'exec-path "/home/andy/.sdkman/candidates/leiningen/current/bin")
(add-to-list 'exec-path "/home/andy")

(autoload 'utop-minor-mode "utop" "Minor mode for utop" t)
(add-hook 'tuareg-mode-hook 'utop-minor-mode)

(load "auctex.el" nil t t)

(eval-after-load 'lisp-interaction
  (progn
    (message "Adding to lisp interaction mode")
    (define-key lisp-interaction-mode-map (kbd "C-c C-c") 'eval-defun)
    (define-key lisp-mode-map (kbd "C-c C-c") 'eval-defun)
    ))

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
                            (define-key hy-mode-map (kbd "C-c C-r") 'hy-shell-eval-region)
                            (define-key hy-mode-map (kbd "<f8>") 'run-octave)))



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

;; Want to have inline images displayed after executin a block of python code
(advice-add 'org-babel-execute-src-block :after (lambda (&rest args)
                                                  (message "Display images %s" (length args))
                                                  (org-display-inline-images)))

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
(load-theme 'deeper-blue 't)

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

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init.el)
;;; init.el ends here
 
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'downcase-region 'disabled nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(LaTeX-command "latex -shell-escape")
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(c-basic-offset 4)
 '(case-fold-search t)
 '(clang-format-executable "clang-format")
 '(company-clang-arguments nil)
 '(compilation-message-face (quote default))
 '(custom-safe-themes
   (quote
    ("8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "d8dc153c58354d612b2576fea87fe676a3a5d43bcc71170c62ddde4a1ad9e1fb" "274fa62b00d732d093fc3f120aca1b31a6bb484492f31081c1814a858e25c72e" "013c62a1fcee7c8988c831027b1c38ae215f99722911b69e570f21fc19cb662e" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "4597d1e9bbf1db2c11d7cf9a70204fa42ffc603a2ba5d80c504ca07b3e903770" "bbb4a4d39ed6551f887b7a3b4b84d41a3377535ccccf901a3c08c7317fad7008" "aa0a998c0aa672156f19a1e1a3fb212cdc10338fb50063332a0df1646eb5dfea" "5715d3b4b071d33af95e9ded99a450aad674e308abb06442a094652a33507cd2" "53d1bb57dadafbdebb5fbd1a57c2d53d2b4db617f3e0e05849e78a4f78df3a1b" "a866134130e4393c0cad0b4f1a5b0dd580584d9cf921617eee3fd54b6f09ac37" "0598de4cc260b7201120b02d580b8e03bd46e5d5350ed4523b297596a25f7403" "891debfe489c769383717cc7d0020244a8d62ce6f076b2c42dd1465b7c94204d" "242ed4611e9e78142f160e9a54d7e108750e973064cee4505bfcfc22cc7c61b1" "4e21fb654406f11ab2a628c47c1cbe53bab645d32f2c807ee2295436f09103c6" "723e48296d0fc6e030c7306c740c42685d672fd22337bc84392a1cf92064788a" "c5d320f0b5b354b2be511882fc90def1d32ac5d38cccc8c68eab60a62d1621f2" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "3d5307e5d6eb221ce17b0c952aa4cf65dbb3fa4a360e12a71e03aab78e0176c5" "7bc31a546e510e6bde482ebca992e293a54cb075a0cbfb384bf2bf5357d4dee3" "4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" "4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" default)))
 '(debug-on-error t)
 '(display-time-world-list
   (quote
    (("Australia/Perth" "Perth")
     ("Asia/Dubai" "Dubai")
     ("Europe/Munich" "Munich")
     ("Europe/London" "London")
     ("Europe/Paris" "Paris")
     ("Europe/Berlin" "Berlin")
     ("America/New_York" "New York")
     ("America/Chicago" "Chicago"))))
 '(flycheck-c/c++-clang-executable "clang-5.0")
 '(flycheck-clang-args (quote ("-xc++")))
 '(flycheck-clang-language-standard "c++14")
 '(fountain-export-font "Courier New")
 '(fountain-export-include-scene-numbers t)
 '(gdb-many-windows t)
 '(global-company-mode t)
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t)
 '(haskell-process-suggest-remove-import-lines t)
 '(helm-M-x-fuzzy-match t)
 '(helm-ag-base-command "rg-wrapper --vimgrep --no-heading --smart-case")
 '(helm-display-buffer-default-size 100)
 '(helm-locate-project-list (quote ("/home/andy/repos/dev")))
 '(helm-org-rifle-show-path t)
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
 '(inhibit-startup-screen t)
 '(initial-buffer-choice "~/rasa.el")
 '(magit-diff-use-overlays nil)
 '(midnight-mode nil)
 '(nyan-mode t)
 '(org-agenda-files
   (quote
    ("/home/andy/Dropbox/gtd/flagged.org" "/home/andy/Dropbox/gtd/journal.org" "/home/andy/Dropbox/gtd/kanban.org" "/home/andy/Dropbox/gtd/sym_contract_notes_from_fiona.org" "/home/andy/Dropbox/gtd/gtd.org")))
 '(org-capture-templates
   (quote
    (("t" "Todo" entry
      (file+headline "~/Dropbox/gtd/kanban.org" "Tasks")
      "* TODO %?" :prepend t)
     ("r" "Todo" entry
      (file+headline "~/Dropbox/gtd/gtd.org" "Tasks")
      "* TODO %?" :prepend t)
     ("r" "Todo" entry
      (file+headline "~/Dropbox/gtd/kanban.org" "Tasks")
      "* TODO %?
%F" :prepend t)
     ("c" "Correspondance" entry
      (file+datetree "~/Dropbox/gtd/corresp.org")
      "* %U %?")
     ("j" "Journal" entry
      (file+datetree "~/Dropbox/gtd/journal.org")
      "* %U %?"))))
 '(org-confirm-babel-evaluate nil)
 '(org-directory "~/Dropbox/gtd")
 '(org-format-latex-options
   (quote
    (:foreground default :background default :scale 3.0 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers
                 ("begin" "$1" "$" "$$" "\\(" "\\["))))
 '(org-hide-leading-stars t)
 '(org-log-done (quote time))
 '(org-preview-latex-image-directory "/var/tmp/ltximg/")
 '(org-todo-keyword-faces
   (quote
    (("BLOCKED" :foreground "red" :weight bold)
     ("TODOTODAY" :foreground "yellow" :weight bold)
     ("INPROGRESS" :foreground "green" :weight bold)
     ("DONE" :foreground "green" :weight bold))))
 '(org-todo-keywords
   (quote
    ((sequence "TODO" "TODOTODAY" "INPROGRESS" "BLOCKED" "DONE" "NEVER"))))
 '(package-selected-packages
   (quote
    (arduino-mode command-log-mode smart-dash zones psgml reason-mode webfeeder olivetti unicode-fonts hy-mode org-kanban nhexl-mode dracula-theme slime ob-kotlin amd-mode sed-mode ranger thrift doom-themes aggressive-indent meson-mode ace-mc helm-org-rifle elixir-mode dfmt ubuntu-theme f3 f org-mobile-sync company-dcd dirtree direx indium flymake-cursor darcula-theme typescript-mode go julia-shell julia-repl julia-mode flycheck-kotlin erlang google-this py-autopep8 flymake-python-pyflakes haskell-mode editorconfig flycheck-clang-tidy kotlin-mode erc-view-log color-theme-sanityinc-solarized color-theme-solarized scala-mode helm-unicode cmake-mode nim-mode json-rpc restclient workgroups2 gnuplot gnuplot-mode orgtbl-ascii-plot forth-mode csv-mode git-gutter rjsx-mode org-present json-mode d-mode ponylang-mode flycheck-pony cider clojure-mode wrap-region multiple-cursors ag helm-projectile dumb-jump helm-cscope ein elpy swift3-mode yaml-mode workgroups web-mode utop tuareg tide switch-window swiper-helm solarized-theme sml-mode smex skewer-mode scala-mode2 sass-mode rust-mode rtags rainbow-delimiters quack pylint protobuf-mode paredit org nyan-mode nurumacs nasm-mode monokai-theme monky markdown-mode magit less-css-mode jsx-mode js3-mode jedi jade-mode ido-ubiquitous iasm-mode helm-swoop helm-package helm-gtags helm-dash helm-company helm-cider helm-ag groovy-mode graphviz-dot-mode go-mode ghci-completion ghc-imported-from ghc ggtags geiser fsharp-mode fountain-mode flycheck-pyflakes flycheck-irony flycheck-haskell find-file-in-project ensime elm-mode edts dash-functional dart-mode csv-nav csharp-mode coffee-mode clang-format caroline-theme caml auctex ace-jump-mode ac-slime ac-helm ac-haskell-process ac-clang ac-cider abyss-theme 2048-game)))
 '(projectile-tags-backend (quote ggtags))
 '(python-shell-interpreter "ipython3")
 '(python-shell-interpreter-args "--simple-prompt --pylab")
 '(safe-local-variable-values
   (quote
    ((helm-ag-command-option . "-tpy -tcpp -td")
     (test-case-name . twisted\.internet\.test\.test_qtreactor)
     (test-case-name . twisted\.internet\.test\.test_inotify)
     (test-case-name . twisted\.internet\.test\.test_core))))
 '(send-mail-function (quote smtpmail-send-it))
 '(show-paren-mode t)
 '(sql-postgres-login-paramsupo
   (quote
    ((user :default "andy")
     server
     (database :default "andy"))))
 '(tab-width 4)
 '(vc-annotate-background nil)
 '(vc-annotate-very-old-color nil t)
 '(wg-morph-on nil))
(put 'scroll-left 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
(menu-bar-mode 0)


