;;; init.el --- Andy's emacs config


;;; Code

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'auto-mode-alist '("SConscript" . python-mode))
(add-to-list 'auto-mode-alist '("SConstruct" . python-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
;;(add-to-list 'auto-mode-alist '("\\.hdl\\'" . nand2tetris-mode))


(setq eval-expression-print-length 100
      eval-expression-print-level 20)

(package-initialize)

(require 'dash)
(require 's)

;; Curated fonts that work well for me.
;; Refresh ~/fonts_<hostname>.el with `smandy/dump-fonts` when needed.

;; Daily driver
;;(set-frame-font "-*-JetBrains Mono-medium-normal-normal-*-*-*-*-*-m-0-iso10646-1")

(when (display-graphic-p)
  (let ((font (if (string= (car (split-string (system-name) "\\.")) "craigmonie")
                  "Terminus 14"
                "Liberation Mono 18")))
    (when (find-font (font-spec :name font))
      (set-frame-font font))))

;; macOS baseline
;;(set-frame-font "Menlo 18")

;; Old-school terminal/X feel
;;(set-frame-font "Terminus (TTF)-18")

;; BBC Micro Mode 7
;;(set-frame-font "Bedstead


;;(set-frame-font "-*-Gill Sans-regular-normal-normal-*-*-*-*-*-p-0-iso10646-1")

(when (display-graphic-p)
  (set-fontset-font t '(#x1D2E0 . #x1D2F3) "Noto Sans Mayan Numerals"))

(defun p (object)
  "Pretty-print OBJECT to a string."
  (pp-to-string object))


(defun smandy/load-theme-safely (theme)
  "Disable all current themes, then try to load THEME."
  (interactive
   (list
    (intern
     (completing-read
      "Theme: "
      (mapcar #'symbol-name
              (custom-available-themes))))))

  (mapc #'disable-theme custom-enabled-themes)

  
  (condition-case err
      (progn
        (load-theme theme t)
        (message "Loaded theme: %s" theme))
    (error
     (message "Theme %s failed: %s"
              theme
              (error-message-string err)))))


;; These are a few of my favourite themes
(smandy/load-theme-safely 'modus-vivendi-tinted)

;;(smandy/load-theme-safely 'sanityinc-tomorrow-blue)

(defun smandy/capture ()
  (interactive)
  (org-table-convert-region (region-beginning) (region-end) 64 ))

(global-set-key [kp-5] #'smandy/capture)

(defun select-quantstats2 ()
  "Switch to quantstats Conda environment for Python shell."
  (interactive)
  (setq python-shell-interpreter "/opt/miniconda3/envs/quantstats/bin/ipython"
        python-shell-interpreter-args "-i --simple-prompt")
  (message "Using quantstats2 environment."))

(defun select-anaconda2 ()
  "Switch to base Anaconda Python shell."
  (interactive)
  (setq python-shell-interpreter "/opt/miniconda3/bin/ipython"
        python-shell-interpreter-args "-i --simple-prompt")
  (message "Using base Anaconda environment."))

(defun select-nats ()
  "Switch to base Anaconda Python shell."
  (interactive)
  (setq python-shell-interpreter "/opt/miniconda3/envs/nats/bin/ipython"
        python-shell-interpreter-args "-i --simple-prompt")
  (message "Using nats environment."))


;; (symbol-function 'select-anaconda2)
;; (fmakunbound 'select-quantstats)


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
;; (let ((current-bid (cons 6 6))
;;       (new-bid (cons 7 2)))
;;   (if (valid-perudo-bid-p current-bid new-bid)
;;       (message "The bid %s is valid." new-bid)
;;     (message "The bid %s is not valid." new-bid)))

;;(funcall 'valid-perudo-bid-p (list '( 6 . 6 ) '(7 . 2)))


(setq projectile-project-search-path
      '(("~/IdeaProjects/" . 2)))

(defun kaz ()
  "Tidy up the kazinsky manifesto"
  (interactive)
  (search-forward-regexp "^[0-9]+\. ")
  (let ((c (current-column)))
    (beginning-of-line)
    (forward-line)
    (insert (s-repeat " " c))))

(defun switch-to-gtd-org ()
  (interactive)
  (switch-to-buffer (find-file "~/repos/gtd/gtd.org")))

(defun switch-to-scratch ()
  (interactive)
  (switch-to-buffer "*scratch*"))


(global-set-key [kp-5] 'switch-to-scratch)

(global-set-key [f9] 'switch-to-gtd-org)

(defun smandy/do-nothing (&rest args)
  (interactive)
  ;; (message "Doing nothing with %s %s" args (format-time-string "%H:%M:%S.%3N" (current-time)) )

  ;;(message "Doing nothing with %s" args)
  )

;; (tab-bar-mode -1) Disable tabs if some dumn code enables them.

(global-set-key [touchscreen-end] 'smandy/do-nothing)
(global-set-key [touchscreen-begin] 'smandy/do-nothing)
(global-set-key [touchscreen-update] 'smandy/do-nothing)

(require 'cc-mode)

(defun markdown-html (buffer)
  (princ (with-current-buffer buffer
           (format "<!DOCTYPE html><html><title>Impatient Markdown</title><xmp theme=\"united\" style=\"display:none;\"> %s  </xmp><script src=\"http://ndossougbe.github.io/strapdown/dist/strapdown.js\"></script></html>" (buffer-substring-no-properties (point-min) (point-max))))
         (current-buffer)))

(setq smandy/kilograms_per_pound 0.454)
(setq smandy/pounds_per_kilogram (/ 1.0 smandy/kilograms_per_pound))
(setq smandy/feet_per_metre 3.28)
(setq smandy/metres_per_foot (/ 1.0  smandy/feet_per_metre))

(defun smandy/stones_to_pounds (stones pounds)
  (+ (* 14 stones) pounds))

(defun smandy/pounds_to_kilograms (x) ( * x smandy/kilograms_per_pound))
(defun smandy/kilograms_to_pounds (x) ( * x smandy/pounds_per_kilogram))

(global-set-key (kbd "C-<return>") 'yas-expand)
(global-set-key (kbd "M-4") 'ispell-word)
(global-set-key (kbd "M-o") 'ace-window)

;;(global-set-key (kbd "M-p") 'ace-jump-buffer)
(global-set-key (kbd "M-p") 'frog-jump-buffer)
(global-set-key (kbd "M-9") 'frog-jump-buffer)


;;(set-frame-font "Terminus 14")

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

(require 'compile)
;;(require 'package)

;; Notes on ripgrep https://gist.github.com/pesterhazy/fabd629fbb89a6cd3d3b92246ff29779

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

;; (add-hook 'magit-mode-hook
;;           (lambda ()
;;            (magit-todos-mode 't)))


;; TODO - remove us once stable
(setq org-startup-folded nil)
(setq save-place-mode nil)

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

;; (require 'f)

;; Anki stuff - couldn't get it to work.

;; (defun my-anki-finalizer ()
;;   (interactive)
;;             (with-temp-buffer
;;               (insert-file-contents org-my-anki-file)
;;               (message "Buffer is %s" (buffer-string))
;;               (mark-whole-buffer)
;;               (anki-editor-push-notes '(4) )))

;; (defun my-anki-finalizer ()
;;   (interactive)
;;   (message "Running finalizer2 buffer is %s" (buffer-name))
;;   (save-excursion
;;     (switch-to-buffer "anki.org")
;;     (anki-editor-push-notes)
;;   ))

;;(add-hook 'org-capture-after-finalize-hook 'my-anki-finalizer)





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
  (gdb "gdb -i=mi -nx -x /Users/andy.smith/discovery.gdbinit"))

(defun debug-guilistener ()
  "Debug the discovery app."
  (interactive)
  (gdb "gdb -i=mi -nx guilistener -x /Users/andy.smith/repos/aurora/code/tickserver/src/main/cpp/.gdbinit"))

(global-set-key (kbd "C-x C-o") 'ff-find-other-file)
(global-set-key (kbd "C-=") 'undo)

(defun insert-white-star ()
  (interactive)
  (insert (char-from-name "WHITE STAR")))

(defun insert-black-star ()
  (interactive)
  (insert (char-from-name "BLACK STAR")))

(defun insert-number-sign ()
  (interactive)
  (insert (char-from-name "NUMBER SIGN")))

(global-set-key [f6] 'insert-number-sign)

(global-set-key [kp-home] 'neuter-tasks)

(defun smandy/insert-inactive-time-stamp ()
  (interactive)
  (org-time-stamp-inactive 't))


(defun smandy/world-time ()
  "Display current UTC, London, Chicago, New York and Abu Dhabi timestamps.
Use each city's time zone so daylight saving is handled automatically."
  (interactive)
  (let ((now (current-time)))
    (message "%s"
             (mapconcat
              (lambda (city)
                (format "%-11s: %s"
                        (car city)
                        (format-time-string "%Y-%m-%d %H:%M:%S %Z"
                                            now
                                            (cdr city))))
              '(("UTC"       . "UTC0")
                ("London"    . "Europe/London")
                ("Chicago"   . "America/Chicago")
                ("New York"  . "America/New_York")
                ("Abu Dhabi" . "Asia/Dubai"))
              "\n"))))

(global-set-key (kbd "C-c C-w C-t") #'smandy/world-time)

(global-set-key [kp-begin] 'org-sort-entries)
(global-set-key [kp-left] 'calendar)
(global-set-key [kp-right] 'smandy/insert-inactive-time-stamp)

(global-set-key [kp-subtract] 'insert-white-star)
(global-set-key [kp-add] 'insert-black-star)

(global-set-key (kbd "M-x") 'helm-M-x) ;; -- todo reinstate
(global-set-key (kbd "<menu>") 'helm-M-x) ;;-- todo reinstate

;;(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-c C-h C-s") 'helm-swoop)
(global-set-key (kbd "C-c C-h C-l") 'helm-locate)
(global-set-key (kbd "C-c C-h C-o") 'helm-occur)
(global-set-key (kbd "C-c C-h C-a") 'helm-do-ag)
(global-set-key (kbd "C-c C-p C-f") 'parse-fix)

(global-set-key (kbd "C-c C-s C-o") 'switch-to-gtd-org)

(global-set-key (kbd "M-g M-f") 'helm-gtags-find-files)
(global-set-key (kbd "M-g M-t") 'helm-gtags-find-tag)
(global-set-key (kbd "M-g M-r") 'helm-gtags-find-rtag)

(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-b") 'helm-mini)
(global-set-key (kbd "C-x r b") 'helm-bookmarks)
(global-set-key [f5] 'helm-resume)

(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
(define-key global-map (kbd "C-;") 'ace-jump-mode)


(define-key global-map (kbd "C-;") 'ace-jump-mode)


(define-key global-map (kbd "<kp-1>") 'paste-to-temp-buffer)
(define-key global-map (kbd "<kp-2>") 'make-temp-buffer)


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

;;(require 'cl)
;;(setq auto-mode-alist (remove-if
;;                       (lambda (x) ( equal (cdr x) 'objc-mode)) auto-mode-alist))
(add-to-list 'auto-mode-alist '("\\.m$" . octave-mode))

(defun compile-in-own-buffer (buf cmd)
  (interactive)
  (let ((compilation-buffer-name-function (lambda (x) buf) ))
    (compile cmd)))

;;(require 'flycheck-kotlin)
;;(add-hook 'kotlin-mode-hook 'flycheck-mode)

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
   ;; (pyenv-mode)
   ))

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

(require 'multiple-cursors)
;;(require 'helm)
;;(helm-mode 1)

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

(helm-projectile-on) ;;-- to re-enable

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
;; (global-set-key [f6]  'scroll-down-one)

;; (global-set-key [f1]  'wg-switch-to-workgroup)
;; (global-set-key [f2]  'helm-world-time)
;; (global-set-key [f3]  'helm-cscope-find-global-definition)




(global-set-key [f4] 'magit-status)
(global-set-key [f5] 'google-this)
;;(global-set-key [f6]  'helm-man-woman)

;; (require 'eshell-mode)
;; (add-hook 'eshell-mode-hook (lambda ()
;; 			      (define-key eshell-mode-map (kbd "<f7>") 'compile)))




;;(--each (list c-mode-base-map dired-mode-map compilation-mode-map shell-mode-map)
;;     (define-key it (kbd "<f7>") 'compile) )

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
    (eshell-send-input)))


(defun switch-shell-to-directory ()
  (interactive)
  (let* ( (dir default-directory))
    (switch-to-buffer "*shell*")
    (end-of-buffer)
    (message "dir is %s" dir)
    (insert (format "cd %s" dir))
    (comint-send-input)))

(--each (list compilation-mode-map)
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


(defun make-temp-buffer ()
  (interactive)
  (if (get-buffer "TEMP")
      (kill-buffer "TEMP"))
  (switch-to-buffer (generate-new-buffer "TEMP")
                    (lisp-interaction-mode)
                    (text-scale-adjust 3)))


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

(defvar smandy/broken-themes
  '(comidia
    dark-blue2
    whateveryouwant
    solarized)
  "Themes known not to load correctly.")



(defun smandy/dump-themes ()
  "Write an audition file containing all known-good themes."
  (interactive)

  (let* ((buffer-name (format "themes_%s.el" (system-name)))
         (file-name   (expand-file-name buffer-name "~"))

         (sorted-themes
          (sort (copy-sequence (custom-available-themes))
                (lambda (a b)
                  (string< (symbol-name a)
                           (symbol-name b)))))

         (themes
          (--remove (memq it smandy/broken-themes)
                    sorted-themes)))

    (switch-to-buffer buffer-name)
    (erase-buffer)

    (dolist (theme themes)
      (insert
       (format "(smandy/load-theme-safely '%s)\n"
               theme)))

    (write-file file-name)
    (kill-buffer buffer-name)

    (message "Saved %d working themes to %s"
             (length themes)
             file-name)))
(defun smandy/purge-theme-faces (theme)
  "Remove THEME from every face's `theme-face' property."
  (dolist (face (face-list))
    (when (assq theme (get face 'theme-face))
      (custom-theme-reset-faces
       theme
       (list face nil)))))


(defun smandy/test-all-themes ()
  "Try every available theme independently and report failures."
  (interactive)
  (let (failed
        passed)

    (dolist (theme (custom-available-themes))
      ;; Start clean.
      (mapc #'disable-theme custom-enabled-themes)
      (smandy/purge-theme-faces theme)

      (condition-case err
          (progn
            (load-theme theme t)
            (push theme passed)
            (message "OK: %s" theme))

        (error
         (push (cons theme
                     (error-message-string err))
               failed)))

      ;; Remove whatever this theme registered.
      (mapc #'disable-theme custom-enabled-themes)
      (smandy/purge-theme-faces theme))

    (with-output-to-temp-buffer "*Theme Test Results*"
      (princ (format "PASSED: %d\nFAILED: %d\n\n"
                     (length passed)
                     (length failed)))

      (princ "FAILED THEMES\n\n")

      (dolist (x (nreverse failed))
        (princ
         (format "%-30s %s\n"
                 (car x)
                 (cdr x)))))))

(defun smandy/dump-fonts ()
  (interactive)

  (let* ((file-name
          (expand-file-name
           (format "fonts_%s.el" (system-name))
           "~"))

         (fonts
          (sort (copy-sequence (x-list-fonts "*"))
                #'string<)))

    (with-temp-file file-name

      ;; Emergency ejector seat :-)
      (insert "(set-frame-font \"Menlo 13\")\n\n")

      ;; All available fonts.
      (dolist (font fonts)
        (insert
         (format "(set-frame-font %S)\n" font))))

    (message "Saved %d fonts to %s"
             (length fonts)
             file-name)))

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
(setq tera 1e12)
(setq nanometer 1e-9)
(setq c 3e8) 

(defun  frequency-to-nanometres (f)
  (/ c f nanometer))

;; (frequency-to-nanometres (* 430 tera)) 697.6744186046511
;; (frequency-to-nanometres (* 750 tera)) 399.99999999999994


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
  (interactive)
  (when (get-buffer "*julia*")
    (let ((kill-buffer-query-functions nil))
      (kill-buffer "*julia*")))
  (julia-repl))

(defun reboot-octave ()
  (interactive)
  (when (get-buffer "*Inferior Octave*")
    (let ((kill-buffer-query-functions nil))
      (kill-buffer "*Inferior Octave*")))
  (run-octave))


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



(defun smandy/copy-current-line ()
  "Copy the current line to the kill ring."
  (interactive)
  (save-excursion
    (kill-ring-save
     (line-beginning-position)
     (line-beginning-position 2))))

(defun smandy/eval-current-line ()
  "Eval the current line as Elisp."
  (interactive)
  (save-excursion
    (eval-region (line-beginning-position) (line-end-position))))

;; Movement
;;(global-set-key (kbd "<kp-8>") #'previous-line)
;;(global-set-key (kbd "<kp-2>") #'next-line)
(global-set-key (kbd "<kp-4>") #'beginning-of-line)
(global-set-key (kbd "<kp-6>") #'end-of-line)

(global-set-key (kbd "<kp-7>") #'backward-page)
(global-set-key (kbd "<kp-9>") #'forward-page)

(global-set-key (kbd "<kp-1>") #'backward-word)
(global-set-key (kbd "<kp-3>") #'forward-word)

;; Editing
(global-set-key (kbd "<kp-5>") #'smandy/copy-current-line)
(global-set-key (kbd "<kp-0>") #'kill-whole-line)
(global-set-key (kbd "<kp-decimal>") #'yank)

;; Exec / eval current line
(global-set-key (kbd "<kp-multiply>") #'smandy/eval-current-line)
;; If kp-multiply doesn't register on your system, try:
;; (global-set-key (kbd "*") #'smandy/eval-current-line)

;;(global-set-key (kbd "C-c C-h C-g C-i" ) 'insert-hg-ignore)

(defun refresh-kanban ()
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (next-line)
    (next-line)
    (org-ctrl-c-ctrl-c)))
;;(global-set-key [f7]  'refresh-kanban)


;;(require 'workgroups2)
;;(setq wg-prefix-key (kbd "C-c w"))
;; (setq wg-file "~/wg.el")
;; (workgroups-mode 1)
;;(wg-load wg-file)

(tool-bar-mode 0)
(menu-bar-mode 't)
;; (scroll-bar-mode 0)


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

;;(with-eval-after-load 'flycheck
;;  (add-hook 'flycheck-mode-hook #'flycheck-pycheckers-setup))

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

(defun smandy/parse-exact-decimal (s)
  "Parse decimal string S exactly.

Return (INTEGER . SCALE), representing the exact value INTEGER / SCALE.

Examples:

  \"123\"       -> (123 . 1)
  \"123.45\"    -> (12345 . 100)
  \"-0.125\"    -> (-125 . 1000)
  \".5\"         -> (5 . 10)
  \"5.\"         -> (5 . 1)

No floating-point conversion is performed."
  (when (stringp s)
    (let ((s (string-trim s)))
      (when (string-match
             "\\`\\([+-]?\\)\\([0-9]*\\)\\(?:\\.\\([0-9]*\\)\\)?\\'"
             s)
        (let* ((sign
                (if (string= (match-string 1 s) "-")
                    -1
                  1))

               (integer-part
                (or (match-string 2 s) ""))

               (fraction-part
                (or (match-string 3 s) "")))

          ;; Reject "", "+", "-", and ".".
          (when (or (> (length integer-part) 0)
                    (> (length fraction-part) 0))

            (let* ((digits
                    (concat
                     (if (string-empty-p integer-part)
                         "0"
                       integer-part)
                     fraction-part))

                   (scale
                    (expt 10 (length fraction-part)))

                   (integer
                    (* sign
                       (string-to-number digits))))

              (cons integer scale))))))))


(defvar smandy/epoch-time-zones
  '(("Local"    . nil)
    ("Chicago"  . "America/Chicago")
    ("New York" . "America/New_York"))
  
  "Extra time zones shown by `smandy/parse-epoch-time`.")

(defun smandy/parse-epoch-time (s)
  "Parse S as Unix epoch seconds, millis, micros or nanos.

Return the original value and inferred units followed by ISO 8601
timestamps for UTC, local time, and configured zones.  Each timestamp
line begins with the authoritative ISO timestamp, followed by
human-readable timezone information in parentheses."
  (when (stringp s)
    (-let* (((ticks . decimal-scale)
             (smandy/parse-exact-decimal s))

            (units
             '(("s"  . 1)
               ("ms" . 1000)
               ("µs" . 1000000)
               ("ns" . 1000000000)))

            (parse
             (-lambda ((unit . scale))
               (condition-case nil
                   (let* ((time
                           (cons ticks
                                 (* decimal-scale scale)))
                          (year
                           (string-to-number
                            (format-time-string "%Y" time t))))
                     (when (< 1980 year 2100)
                       (cons unit time)))
                 (error nil))))

            ((unit . time)
             (-some parse units)))

      (when time
        (cl-labels
            ((format-zone
              (name zone)
              (let* ((offset
                      (format-time-string "%z" time zone))

                     ;; ISO 8601 requires +01:00 rather than +0100.
                     (iso-offset
                      (if (string= offset "+0000")
                          "Z"
                        (format "%s:%s"
                                (substring offset 0 3)
                                (substring offset 3 5))))

                     ;; Human-readable abbreviation at this instant:
                     ;; GMT/BST, CST/CDT, EST/EDT, etc.
                     (abbr
                      (format-time-string "%Z" time zone))

                     (iso
                      (format-time-string
                       (concat "%Y-%m-%dT%H:%M:%S.%N"
                               iso-offset)
                       time
                       zone))

                     (human-offset
                      (if (string= iso-offset "Z")
                          "UTC"
                        (concat "UTC" iso-offset))))

                ;; Fixed-width fields keep everything aligned.
                (format "%-36s (%-8s — %-3s, %s)"
                        iso
                        name
                        abbr
                        human-offset))))

          (let* ((lines
                  (cons
                   (format-zone "UTC" t)
                   (--map
                    (-let (((name . zone) it))
                      (format-zone name zone))
                    smandy/epoch-time-zones)))

                 (result
                  (format "%s %s\n\n%s"
                          s
                          unit
                          (string-join lines "\n"))))

            (message "%s" result)
            result))))))
;; Tests: all represent approximately the same instant in different units.
(s-join
 "\n"
 (mapcar #'smandy/parse-epoch-time
         '("1482672627"
           "1482672627.025747002"
           "1482672627025.747023"
           "1482672627025747.032"
           
           "1482672627025747023")))

(smandy/parse-epoch-time           "1482672627025.747023" )"1482672627025.747023 ms

2016-12-25T13:30:27.025747023Z       (UTC      — UTC, UTC)
2016-12-25T13:30:27.025747023Z       (Local    — GMT, UTC)
2016-12-25T07:30:27.025747023-06:00  (Chicago  — CST, UTC-06:00)
2016-12-25T08:30:27.025747023-05:00  (New York — EST, UTC-05:00)"



;;(smandy/parse-epoch-time "1482672627025747023")

(defun smandy/epoch-number-at-point ()
  "Return a decimal number around point, or nil.

Recognises an optional sign and fractional part."
  (save-excursion
    (skip-chars-backward "0-9+-.")
    (when (looking-at "[+-]?[0-9]+\\(?:\\.[0-9]+\\)?")
      (match-string-no-properties 0))))

(defun smandy/parse-epoch-time-at-point ()
  "Parse an epoch timestamp at point.

Silently does nothing when point is not on a number."
  (interactive)
  (-when-let (s (smandy/epoch-number-at-point))
    (condition-case nil
        (smandy/parse-epoch-time s)
      (error nil))))

(defun smandy/my-epoch-parser-idle-function ()
  "Run `smandy/parse-epoch-time-at-point` when Emacs is idle."
  (unless (input-pending-p)
    (condition-case nil
        (smandy/parse-epoch-time-at-point)
      (error nil))))

(global-set-key (kbd "C-c C-p C-t")
                #'smandy/parse-epoch-time-at-point)

;; Avoid accumulating duplicate repeating timers when this code is
;; re-evaluated while hacking on the config.
(when (and (boundp 'smandy/epoch-parse-idle-timer)
           (timerp smandy/epoch-parse-idle-timer))
  (cancel-timer smandy/epoch-parse-idle-timer))

(setq smandy/epoch-parse-idle-timer
      (run-with-idle-timer
       1.0 t
       #'smandy/my-epoch-parser-idle-function))


;; Experiment - ( rough) capture timestamps with current-time in emacs
;; and time.time() in python. Reverse engineer the time value in python
;; Six seconds apart - think that's how long it took me :-)

;;In [76]: time.time()
;;Out[76]: 1710215086.2924154t

;;(current-time) (27284 38750 364584 0)

;;(current-time) (27285 50321 962503 0)23

;;In [78]: (26095 << 16) + 53160
;;Out[78]: 1710215080

;; Even better - ( proper bit masks)

;; In [93]: (26095 << 16) | 53160 & ((1 << 16) - 1 )
;; Out[93]: 1710215080

;; ( - 1710215080 1710215086.2924154) -6.292415380477905

(defun smandy/pgformat-region (beg end)
  (interactive "r")
  (shell-command-on-region
   beg end
   "pg_format"
   (current-buffer)
   t))


(defun smandy/int-limits ()
  "Print the maximum and minimum values for 32-bit signed and unsigned integers."
  (let ((signed-max (1- (expt 2 31)))
        (signed-min (- (expt 2 31)))
        (unsigned-max (1- (expt 2 32)))
        (unsigned-min 0))

   (format "\n;; 64-bit Signed Integer Range: %s to %s\n;; 64-bit Unsigned Integer Range: %s to %s" signed-min signed-max unsigned-min unsigned-max)))


(defun smandy/int64-limits ()
  "Print the maximum and minimum values for 64-bit signed and unsigned integers."
  (let ((signed-max (1- (expt 2 63)))
        (signed-min (- (expt 2 63)))
        (unsigned-max (1- (expt 2 64)))
        (unsigned-min 0))
    (format ";;\n;; 64-bit Signed Integer Range: %s to %s\n;; 64-bit Unsigned Integer Range: %s to %s" signed-min signed-max unsigned-min unsigned-max)))

;; (int64-limits) 

;; (int-limits)

;; (/ (1- (expt 2 63)) (expt 10 0)) 9223372036854775807

;; (num-to-words  1482672627) 
;; (num-to-words  1482672627.025747002)
;; (num-to-words  1482672627025.747023)  
;; (num-to-words  1482672627025747.032)  
;; (num-to-words  1482672627025747023) 


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
  (let (
        (dd (expand-file-name default-directory))
        (ret (string-trim (shell-command-to-string
                           "git rev-parse --show-toplevel"))) )
    (message "default dir is %s" dd)
    ret
  ))

;; (get-git-root) 
(defun peek-flycheck (arg)
  (message "args are %s" arg)
  (s-join " " arg))

(defun common-aurora-python-dir ()
  (format "%s/code/common/src/main/python" (get-git-root)))

(defun find-aurora ()
  (let* ((candidates (shell-command-to-string "locate --regex aurora$")))
    candidates))

(find-aurora)

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

(when (file-directory-p "/opt/homebrew/bin")
  (add-to-list 'exec-path "/opt/homebrew/bin")
  (setenv "PATH" (concat "/opt/homebrew/bin:" (getenv "PATH"))))

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


(defun get-heading-counts ()
  "Reimplementation in a more functional style, Not sure if I succeeded"
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


(when (eq system-type 'darwin)
  (setq browse-url-browser-function 'browse-url-chrome
        browse-url-chrome-program "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"))

(dolist (helper '("tags-regenerated.el" "tags-cme-overrides.el" "parse-fix-cme.el"))
  (let ((path (expand-file-name helper user-emacs-directory)))
    (when (file-readable-p path)
      (load-file path))))


(defun my-elisp-report (dir)
  (->> (f-files dir nil t)
       (--filter (f-ext? it "el"))
       (--map
        (list (f-relative it dir)
              (f-size it)))
       (--sort (> (cadr it) (cadr other)))
       (--map
        (-let (((name bytes) it))
          (format "%-50s %8d bytes"
                  name bytes)))
       (s-join "\n")))


(global-set-key [f11] 'parse-fix)
;; 8=FIX.4.29=16335=D34=97249=TESTBUY352=20190206-16:25:10.40356=TESTSELL311=14163685067084226997921=238=10040=154=155=AAPL60=20190206-16:25:08.968207=TO6000=TEST123410=106"

;;(global-set-key [f3] 'parse-fix)

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




(global-set-key [kp-5] 'artist-mode)
(global-set-key [kp-6] 'python-mode)

   


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

(defun smandy/days-between (s f)
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

;; (smandy/days-between "1973-05-09" "2026-09-05")

(eval-after-load 'company
  '(progn
     (define-key company-mode-map (kbd "C-:") 'helm-company)
     (define-key company-mode-map (kbd "M-/") 'company-complete)
     (define-key company-active-map (kbd "C-:") 'helm-company)))

(add-to-list 'exec-path "/Users/andy.smith/bin")
(add-to-list 'exec-path "/Users/andy.smith/.sdkman/candidates/leiningen/current/bin")
(add-to-list 'exec-path "/Users/andy.smith")
(add-to-list 'exec-path "/Users/andy.smith/.pyenv/shims")


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

;; (require 'cider-mode)
;; (add-hook 'cider-mode-hook
;;           (lambda ()
;;             (define-key cider-mode-map (kbd "C-c C-r") 'cider-eval-region))
;;           (define-key cider-mode-map (kbd "C-c C-c") 'cider-eval-defun-at-point))

(eval-after-load 'octave '(progn
                            (define-key octave-mode-map (kbd "C-c C-c") 'octave-send-buffer)
                            (define-key octave-mode-map (kbd "C-c C-r") 'octave-send-region)
                            (define-key octave-mode-map (kbd "C-c C-p") 'run-octave)
                            (define-key octave-mode-map (kbd "<f8>") 'reboot-octave)))


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
(require 'ob-mermaid nil t)
;;(require 'ob-scala) -- todo - reinstate

;; Want to have inline images displayed after executin a block of python code
(advice-add 'org-babel-execute-src-block :after (lambda (&rest args)
                                                  (message "Display images %s" (length args))
                                                  (org-display-inline-images)))

;; There was a place before time where undo tree didn't exist
(require 'undo-tree)
(global-undo-tree-mode)


(defvar smandy/current-color-theme nil
  "The most recently loaded Emacs color theme.")

(defun smandy/remember-color-theme (theme &rest _)
  "Remember THEME as the current color theme."
  (setq smandy/current-color-theme theme))

(advice-add 'load-theme :after #'smandy/remember-color-theme)

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

(setq work-agenda-file (expand-file-name "~/Dropbox/gtd/work.org"))

(defun agenda-schedule ()
  (interactive)
  (org-store-new-agenda-file-list '("~/repos/gtd/journal.org" "~/repos/gtd/gtd.org" "~/repos/gtd/robbins/ania/ania.org")))


(defun agenda-lagrange ()
  (interactive)
  (org-store-new-agenda-file-list '("/Users/andy.smith/Dropbox/drewritchie/the_lagrange.org")))

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
 '(frog-menu-posframe-background-face ((t (:background "navy"))))
 '(helm-selection ((t (:extend t :background "blue3" :underline nil))))
 '(region ((t (:background "cyan" :foreground "black")))))

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

(defun danger  (x)
  "Warning function"
  ;;(message "Danger %s" x )
  (if (< 1 x) "danger!!" ""))


(defun as2/days_to_months (x) ( / (/ x 365.0 ) ( / 1.0 12 ) )  )

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



;; (cencel-timer epoch-parse-idle-timer)

;; Add the hover function to programming modes
;;(add-hook 'prog-mode-hook 'enable-my-hover-function)



(defun smandy/tramp-ssh-shell ()
  "Open an SSH shell on the host and directory of the current TRAMP buffer."
  (interactive)
  (unless (file-remote-p default-directory)
    (user-error "Current buffer is not visiting a remote directory"))

  (let* ((vec  (tramp-dissect-file-name default-directory))
         (host (tramp-file-name-host vec))
         (user (tramp-file-name-user vec))
         (dir  (tramp-file-name-localname vec))
         ;; Usually HOST is your ~/.ssh/config alias, so USER is unnecessary.
         (destination
          (if (and user (not (string-empty-p user)))
              (format "%s@%s" user host)
            host))
         (buffer-name (format "*ssh:%s:%s*" host dir))
         (command
          (format
           "ssh -t %s %s"
           (shell-quote-argument destination)
           (shell-quote-argument
            (format "cd %s && exec \"${SHELL:-/bin/sh}\" -l"
                    (shell-quote-argument dir))))))

    (pop-to-buffer
     (get-buffer-create buffer-name))

    (unless (comint-check-proc (current-buffer))
      (erase-buffer)
      (ansi-term "/bin/zsh" buffer-name)
      (term-send-raw-string command)
      (term-send-raw-string "\n"))))


(require 'cl-lib)


(defun smandy/my-sql-csv-region-to-org-table (beg end)
  "Copy CSV in the active region to a results buffer and convert it to an Org table."
  (interactive "r")
  (unless (use-region-p)
    (user-error "No active region"))

  ;; Capture the text before changing buffers.
  (let ((csv (buffer-substring-no-properties beg end)))
    (make-results-buffer "ORG_SQL")

    ;; `make-results-buffer' is assumed to switch to the result buffer.
    (let ((inhibit-read-only t))
      (erase-buffer)
      (org-mode)
      (insert csv)

      ;; Remove a final newline so it does not become an empty table row.
      (goto-char (point-max))
      (when (bolp)
        (delete-char -1))

      ;; Convert the entire buffer, explicitly using comma as separator.
      (org-table-convert-region
       (point-min)
       (point-max)
       ",")

      (goto-char (point-min))
      (org-table-align))))


;; VMS-style numbered backups, tucked into a .backups/ subdir beside the file.
;; NB: a *relative* dir in `backup-directory-alist' is expanded against the
;; file's own directory and the name is left unmangled (see
;; `make-backup-file-name-1').  An absolute dir would instead flatten the whole
;; path into one central dir with `/' -> `!'.
;;
;; Don't be tempted by `make-backup-file-name-function' here: it is consulted
;; only when `version-control' is `never'.  In every other case (including nil)
;; `find-backup-file-name' takes the numbered path and calls
;; `make-backup-file-name-1' directly, so that hook is dead code.
(setq backup-by-copying t
      version-control t
      ;; With a backup per save these go fast -- 10 would be minutes of work.
      kept-new-versions 50
      ;; ...while these two stay pinned as the "when I first opened it" copies.
      kept-old-versions 2
      delete-old-versions t
      backup-directory-alist '(("." . ".backups"))
      ;; Back up files under VC too.  The whole point is an escape hatch for
      ;; uncommitted WIP, so "it's in git" is exactly the case that needs it.
      vc-make-backup-files t)

;; Emacs backs up only on the FIRST save of a buffer visit, so a day's editing
;; leaves a single backup holding the file as it was when you opened it --
;; useless for the woopsy-20-minutes-in case.  Clearing `buffer-backed-up'
;; before each save gives a genuine version per save.
;;
;; (This is what the stray top-level `(setq buffer-backed-up nil)' that used to
;; live here was reaching for; the variable is permanently buffer-local, so up
;; there it only ever set a binding in *scratch*.)
;;
;; No-op saves are free: `save-buffer' checks `buffer-modified-p' before
;; running `before-save-hook', so leaning on C-x C-s doesn't burn versions.
(defun smandy/force-backup-of-buffer ()
  "Reset `buffer-backed-up' so every save gets its own numbered backup."
  (setq buffer-backed-up nil))

(add-hook 'before-save-hook #'smandy/force-backup-of-buffer)

;; Keep buffers in step with the disk.  With agents editing these files too,
;; a buffer is a cache that can silently go stale -- and a stale buffer saved
;; an hour later quietly reverts whatever changed underneath it.
;;
;; Only *unmodified* buffers are reverted, so this never eats my own edits.
;; The other direction is already covered: saving a buffer whose file changed
;; on disk prompts "...has changed since visited or saved.  Save anyway?" --
;; that prompt is load-bearing now, so read it rather than reflexively y-ing.
;;
;; Left polling on (i.e. NOT setting `auto-revert-avoid-polling'): kqueue-only
;; notification misses writes that replace the file via temp-file + rename,
;; which is how plenty of tools -- including some agent edits -- write.
(setq global-auto-revert-non-file-buffers t  ; dired etc. refresh too
      auto-revert-verbose t)                 ; say so when a buffer changes underneath

(global-auto-revert-mode 1)


(defun smandy/bookmark-dedupe ()
  "Remove duplicate bookmarks with the same filename and position."
  (interactive)
  (require 'bookmark)

  (let ((seen (make-hash-table :test #'equal))
        (removed 0))
    (dolist (bm (copy-sequence bookmark-alist))
      (let* ((name (car bm))
             (rec  (cdr bm))
             (file (bookmark-get-filename name))
             (pos  (bookmark-prop-get rec 'position))
             (key  (list file pos)))
        (if (gethash key seen)
            (progn
              (bookmark-delete name)
              (setq removed (1+ removed)))
          (puthash key t seen))))
    (bookmark-save)
    (message "Removed %d duplicate bookmarks" removed)))


(defun smandy/org-capture-inbox ()
  (interactive)
  (org-capture nil "i"))

(global-set-key [kp-8] #'smandy/org-capture-inbox)




(defun smandy/load-theme-safely (theme)
  "Disable all current themes, then try to load THEME.

If THEME is broken, report the error instead of entering the debugger."
  (interactive
   (list
    (intern
     (completing-read "Theme: "
                      (mapcar #'symbol-name
                              (custom-available-themes))))))

  (mapc #'disable-theme custom-enabled-themes)

  (condition-case err
      (progn
        (load-theme theme t)
        (message "Loaded theme: %s" theme))
    (error
     (message "Theme %s failed: %s"
              theme
              (error-message-string err)))))


(defun dump-themes ()
  (interactive)
  (let* ((buffer-name (format "themes_%s.el" (system-name)))
         (file-name   (expand-file-name buffer-name "~")))

    (switch-to-buffer buffer-name)
    (erase-buffer)

    (dolist (theme (sort (copy-sequence (custom-available-themes))
                         (lambda (a b)
                           (string< (symbol-name a)
                                    (symbol-name b)))))
      (insert
       (format "(smandy/load-theme-safely '%s)\n" theme)))

    (write-file file-name)
    (kill-buffer buffer-name)

    (message "Saved %s" file-name)))

(defun smandy/polygon-area (points)
  (->> (-zip-pair points (cdr points))
       (--map
        (-let ((((x1 y1) . (x2 y2)) it))
          (- (* x1 y2)
             (* y1 x2))))
       -sum
       abs
       (* 0.5)))


;; (smandy/polygon-area '((0 0)
;;                 (8 3)
;;                 (13 5)
;;                 (5 2)
;;                 (0 0)))


;; (->> (number-sequence 1 100)
;;      (--map (* 2 it))
;;      (--filter ( = (% it 6 ) 0)))

;; (let ((polygon '((10 11)
;;                  (10 20)
;;                  (20 20)
;;                  (20 10)
;;                  (10 11))))
;;   (smandy/polygon-area polygon))



(defun smandy/load-theme-safely (theme)
  (mapc #'disable-theme custom-enabled-themes)
  (condition-case err
      (load-theme theme t)
    (error
     (message "Theme %s failed: %s"
              theme
              (error-message-string err)))))


(defun smandy/num-to-words (num)
  "Convert a number to its English words representation."
  (let ((ones '("zero" "one" "two" "three" "four" "five" "six" "seven" "eight" "nine"))
        (teens '("ten" "eleven" "twelve" "thirteen" "fourteen" "fifteen" "sixteen" "seventeen" "eighteen" "nineteen"))
        (tens '("" "" "twenty" "thirty" "forty" "fifty" "sixty" "seventy" "eighty" "ninety"))
        (thousands '("" "thousand" "million" "billion" "trillion")))
    (cl-labels ((convert-hundreds (num)
                 (cond
                  ((< num 10) (nth num ones))
                  ((< num 20) (nth (- num 10) teens))
                  ((< num 100)
                   (let ((ten-word (nth (/ num 10) tens))
                         (one-word (nth (% num 10) ones)))
                     (if (= (% num 10) 0)
                         ten-word
                       (concat ten-word "-" one-word))))
                  ((< num 1000)
                   (let ((hundred-word (concat (nth (/ num 100) ones) " hundred"))
                         (remainder (% num 100)))
                     (if (= remainder 0)
                         hundred-word
                       (coxtncat hundred-word " and " (convert-hundreds remainder))))))))
      (if (= num 0)
          "zero"
        (let ((result ""))
          (dotimes (i (length thousands))
            (let ((unit-value (expt 1000 i)))
              (when (>= num unit-value)
                (let ((current-part (convert-hundreds (% (/ num unit-value) 1000))))
                  (setq result (concat current-part
                                       (if (not (string= current-part ""))
                                           (concat " " (nth i thousands))
                                         "")
                                       (if (not (string= result ""))
                                           (concat ", " result)
                                         "")))))))
          result)))))
    
;; Examples of usage:
;; (num-to-words 0)         ;; "zero"
;; (num-to-words 7)         ;; "seven"
;; (num-to-words 11)        ;; "eleven"
;; (num-to-words 23)        ;; "twenty-three"
;; (num-to-words 85)        ;; "eighty-five"
;; (num-to-words 100)       ;; "one hundred"
;; (num-to-words 115)       ;; "one hundred and fifteen"
;; (num-to-words 342)       ;; "three hundred and forty-two"
;; (num-to-words 1000)      ;; "one thousand"
;; (num-to-words 1500)      ;; "one thousand, five hundred"
;; (num-to-words 1234567)   ;; "one million, two hundred and thirty-four thousand, five hundred and sixty-seven"
;; (num-to-words 1000000000) ;; "one billion"

(defun smandy/test-all-themes ()
  "Try loading every available theme and report failures."
  (interactive)
  (let (failed)
    (dolist (theme (custom-available-themes))
      (mapc #'disable-theme custom-enabled-themes)

      (condition-case err
          (progn
            (load-theme theme t)
            (message "OK: %s" theme))

        (error
         (push (cons theme (error-message-string err))
               failed))))

    ;; Clean up whatever the last test left enabled.
    (mapc #'disable-theme custom-enabled-themes)

    (if failed
        (with-output-to-temp-buffer "*Broken Themes*"
          (princ "BROKEN THEMES\n\n")
          (dolist (x (nreverse failed))
            (princ (format "%-30s %s\n"
                           (car x)
                           (cdr x)))))
      (message "Every theme loaded successfully!"))))
;; Optional: restore region face for visibility


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
 '(byte-compile-warnings '(not-unused))
 '(c-basic-offset 4)
 '(case-fold-search t)
 '(cfw:display-calendar-holidays nil)
 '(chess-images-separate-frame nil)
 '(clang-format-executable "clang-format")
 '(company-clang-arguments nil)
 '(compilation-message-face 'default)
 '(custom-safe-themes
   '("c1577851d2c83199092f5e9239ea523661812e4eb2d7719844ca55c295cf0b27"
     "1a1ac598737d0fcdc4dfab3af3d6f46ab2d5048b8e72bc22f50271fd6d393a00"
     "ff24d14f5f7d355f47d53fd016565ed128bf3af30eb7ce8cae307ee4fe7f3fd0"
     "2e05569868dc11a52b08926b4c1a27da77580daa9321773d92822f7a639956ce"
     "be84a2e5c70f991051d4aaf0f049fa11c172e5d784727e0b525565bb1533ec78"
     "944d52450c57b7cbba08f9b3d08095eb7a5541b0ecfb3a0a9ecd4a18f3c28948"
     "7a424478cb77a96af2c0f50cfb4e2a88647b3ccca225f8c650ed45b7f50d9525"
     "251ed7ecd97af314cd77b07359a09da12dcd97be35e3ab761d4a92d8d8cf9a71"
     "821c37a78c8ddf7d0e70f0a7ca44d96255da54e613aa82ff861fe5942d3f1efc"
     "3319c893ff355a88b86ef630a74fad7f1211f006d54ce451aab91d35d018158f"
     "a82ab9f1308b4e10684815b08c9cac6b07d5ccb12491f44a942d845b406b0296"
     "333958c446e920f5c350c4b4016908c130c3b46d590af91e1e7e2a0611f1e8c5"
     "7a7b1d475b42c1a0b61f3b1d1225dd249ffa1abb1b7f726aec59ac7ca3bf4dae"
     "6950cff91f52578d46e0c3c0b68d329a72157cca1e2380e2e8e7557b8257eb6d"
     "dc2cdca2f32386a308057cac6abde24c07b470cf17847c784c79ecd3a23ee09a"
     "97db542a8a1731ef44b60bc97406c1eb7ed4528b0d7296997cbb53969df852d6"
     "6c531d6c3dbc344045af7829a3a20a09929e6c41d7a7278963f7d3215139f6a7"
     "d268b67e0935b9ebc427cad88ded41e875abfcc27abd409726a92e55459e0d01"
     "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58"
     "234dbb732ef054b109a9e5ee5b499632c63cc24f7c2383a849815dacc1727cb6"
     "c2aeb1bd4aa80f1e4f95746bda040aafb78b1808de07d340007ba898efa484f5"
     "1d5e33500bc9548f800f9e248b57d1b2a9ecde79cb40c0b1398dec51ee820daf"
     "745d03d647c4b118f671c49214420639cb3af7152e81f132478ed1c649d4597d"
     "1704976a1797342a1b4ea7a75bdbb3be1569f4619134341bd5a4c1cfb16abad4"
     "79586dc4eb374231af28bbc36ba0880ed8e270249b07f814b0e6555bdcb71fab"
     "fee7287586b17efbfda432f05539b58e86e059e78006ce9237b8732fde991b4c"
     "6c98bc9f39e8f8fd6da5b9c74a624cbb3782b4be8abae8fd84cbc43053d7c175"
     "f0f5bfda176875f70299b2a3a07e778f23b8af81defe3bc40babd0a85f88d411"
     "4b0e826f58b39e2ce2829fab8ca999bcdc076dec35187bf4e9a4b938cb5771dc"
     "e79672e00657fb6950f67d1e560ca9b4881282eb0c772e2e7ee7a15ec7bb36a0"
     "f4a8885fd1cad56c4e67dc32796d5bd1c3defadde5a1981af08e7f40046ab79b"
     "edf6cc813aa6c4bc0a22b2f051624b861c20144016b0c1cf3046935807cbe4e6"
     "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a"
     "57e3f215bef8784157991c4957965aa31bac935aca011b29d7d8e113a652b693"
     "cf9414f229f6df728eb2a5a9420d760673cca404fee9910551caf9c91cff3bfa"
     "1eee77e76b9cd3a2791dcee51ccb39002ccd830f2539be3aec3859c1bccf0112"
     "d1443dd6612780bf037e703b6ebd936bcd5f2a93821558052b30231b2e1e1168"
     "0be5c1a44e0a877aa9cedae800c438d09efe12bbc7cbc7f787d43c5b8e7eb0db"
     "a7525b7e01bdfbd4f576d1143ea0a27a47d05df39d193edebbbdf3255a0708ad"
     "e1a0ed433cdd00b77f5ded2a3db6379c1e85226aea7cf0b4f4137fd0fdb80420"
     "10df1e816601ef972dcb593f7b34cbd5a4215794b65386f6bb2ed9d4a7d3f64e"
     "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d"
     "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3"
     "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016"
     "f2c35f8562f6a1e5b3f4c543d5ff8f24100fae1da29aeb1864bbc17758f52b70"
     "51ec7bfa54adf5fff5d466248ea6431097f5a18224788d0bd7eb1257a4f7b773"
     "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26"
     "d8dc153c58354d612b2576fea87fe676a3a5d43bcc71170c62ddde4a1ad9e1fb"
     "274fa62b00d732d093fc3f120aca1b31a6bb484492f31081c1814a858e25c72e"
     "013c62a1fcee7c8988c831027b1c38ae215f99722911b69e570f21fc19cb662e"
     "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879"
     "4597d1e9bbf1db2c11d7cf9a70204fa42ffc603a2ba5d80c504ca07b3e903770"
     "bbb4a4d39ed6551f887b7a3b4b84d41a3377535ccccf901a3c08c7317fad7008"
     "aa0a998c0aa672156f19a1e1a3fb212cdc10338fb50063332a0df1646eb5dfea"
     "5715d3b4b071d33af95e9ded99a450aad674e308abb06442a094652a33507cd2"
     "53d1bb57dadafbdebb5fbd1a57c2d53d2b4db617f3e0e05849e78a4f78df3a1b"
     "a866134130e4393c0cad0b4f1a5b0dd580584d9cf921617eee3fd54b6f09ac37"
     "0598de4cc260b7201120b02d580b8e03bd46e5d5350ed4523b297596a25f7403"
     "891debfe489c769383717cc7d0020244a8d62ce6f076b2c42dd1465b7c94204d"
     "242ed4611e9e78142f160e9a54d7e108750e973064cee4505bfcfc22cc7c61b1"
     "4e21fb654406f11ab2a628c47c1cbe53bab645d32f2c807ee2295436f09103c6"
     "723e48296d0fc6e030c7306c740c42685d672fd22337bc84392a1cf92064788a"
     "c5d320f0b5b354b2be511882fc90def1d32ac5d38cccc8c68eab60a62d1621f2"
     "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4"
     "3d5307e5d6eb221ce17b0c952aa4cf65dbb3fa4a360e12a71e03aab78e0176c5"
     "7bc31a546e510e6bde482ebca992e293a54cb075a0cbfb384bf2bf5357d4dee3"
     "4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4"
     "4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328"
     default))
 '(dash-docs-enable-debugging nil)
 '(debug-on-error t)
 '(exwm-floating-border-color "#181818")
 '(flycheck-c/c++-clang-executable "clang")
 '(flycheck-clang-args '("-xc++"))
 '(flycheck-clang-language-standard "c++14")
 '(flycheck-clangcheck-dbname "compile_commands.json")
 '(flycheck-gcc-args '("--std=c++23" "-DICE_CPP11_MAPPING"))
;; '(flycheck-pycheckers-checkers '(pylint flake8 pyflakes mypy3))
;; '(flycheck-python-mypy-executable "/Users/andy.smith/help/bin/mypy")
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
 '(helm-locate-project-list '("/Users/andy.smith/repos/dev"))
 '(helm-org-rifle-show-full-contents nil)
 '(helm-org-rifle-show-path t)
 '(helm-rg-default-directory 'git-root)
 '(helm-rg-ripgrep-executable "/usr/bin/rg")
 '(highlight-tail-colors ((("#3d413c") . 0) (("#3a4143") . 20)))
 '(ibuffer-saved-filter-groups
   '(("python" ("python" (mode . python-mode)))
     ("mydefs" ("agora+dev" (used-mode . c++-mode)))))
 '(ibuffer-saved-filters
   '(("foo2" (mode . c++-mode)
      (or (projectile-files . "/mnt/hdd/andy/repos/dev")
          (projectile-files . "/mnt/hdd/andy/repos/agora")))
     ("foo" (mode . c++-mode)
      (or (projectile-files . "/mnt/hdd/andy/repos/dev")
          (projectile-files . "/mnt/hdd/andy/repos/agora")))
     ("~/filters.el" (mode . c++-mode)
      (or (projectile-files . "/mnt/hdd/andy/repos/dev")
          (projectile-files . "/mnt/hdd/andy/repos/agora")))
     ("gnus"
      (or (mode . message-mode) (mode . mail-mode)
          (mode . gnus-group-mode) (mode . gnus-summary-mode)
          (mode . gnus-article-mode)))
     ("programming"
      (or (mode . emacs-lisp-mode) (mode . cperl-mode) (mode . c-mode)
          (mode . java-mode) (mode . idl-mode) (mode . lisp-mode)))))
 '(image-file-name-extensions
   '("png" "jpeg" "jpg" "gif" "tiff" "tif" "xbm" "xpm" "pbm" "pgm" "ppm"
     "pnm" "svg" "pdf"))
 '(inferior-octave-startup-args '("-i" "--line-editing"))
 '(inhibit-startup-screen t)
 '(ispell-program-name "/usr/bin/hunspell")
 '(jdee-db-active-breakpoint-face-colors (cons "#000000" "#80A0C2"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#000000" "#A2BF8A"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#000000" "#3f3f3f"))
 '(lsp-pylsp-plugins-flake8-exclude [])
 '(lsp-pylsp-plugins-flake8-ignore ["E265" "E402" "D102" "E302" "D103" "E303"])
 '(lsp-pylsp-plugins-pydocstyle-add-ignore ["D103"])
 '(lsp-pylsp-plugins-pydocstyle-enabled nil)
 '(magit-todos-exclude-globs '(".git/" "deps/" "vendor/"))
 '(nyan-mode t)
 '(objed-cursor-color "#C16069")
 '(octave-source-directories '("/Users/andy.smith/repos/octave/libinterp"))
 '(org-agenda-custom-commands
   '(("i" . "Inline") ("il" . "Inline2")
     ("il" tags-todo "+LEVEL=15+TODO=\"TODO\"|+LEVEL=15+TODO=\"DONE\""
      nil)
     ("im" tags-todo "+morning" nil)))
 '(org-agenda-files
   '("/home/andy/Dropbox/gtd/work.org" "/home/andy/repos/gtd/gtd.org"
     "/home/andy/repos/gtd/journal.org"))
 '(org-babel-load-languages '((dot . t) (emacs-lisp . t) (C . t)))
 '(org-capture-templates
   '(("t" "Todo" entry (file+headline "~/repos/gtd/gtd.org" "TODOs")
      "* TODO %?" :prepend t)
     ("T" "Aurora Todo" entry
      (file+headline "~/repos/aurora/todos.org" "TODO") "* TODO %?"
      :prepend t)
     ("c" "Phone Call" entry (file+olp "~/repos/gtd/gtd.org" "Calls")
      "* %U %?" :prepend t)
     ("i" "Inbox" entry (file+headline "~/repos/gtd/gtd.org" "Inbox")
      "* %U %?" :prepend t)
     ("m" "Meditations" entry
      (file+headline "~/repos/gtd/gtd.org" "Meditations") "* %?"
      :prepend t)
     ("A" "Anki basic" entry
      (file+headline org-my-anki-file "Dispatch Shelf")
      "* %<%H:%M>\12:PROPERTIES:\12:ANKI_NOTE_TYPE: Basic\12:ANKI_DECK: main\12:END:\12** Front\12%?\12** Back\12"
      :kill-buffer 't)
     ("s" "Schedule" entry (file+olp "~/repos/gtd/gtd.org" "Schedule")
      "* TODO %?" :prepend 't)
     ("p" "Shopping" entry
      (file+headline "~/repos/gtd/_shopping.org" "Stuff") "* TODO %?"
      :prepend t)
     ("j" "Journal" entry (file+datetree "~/repos/gtd/journal.org")
      "* %U %?")
     ("h" "Health Journal" entry
      (file+datetree "~/repos/gtd/health_journal.org") "* %U %?")))
 '(org-confirm-babel-evaluate nil)
 '(org-crypt-disable-auto-save t)
 '(org-crypt-key "andyrsmith@gmail.com")
 '(org-crypt-tag-matcher "crypt")
 '(org-directory "~/Dropbox/gtd")
 '(org-format-latex-options
   '(:foreground default :background default :scale 3.0 :html-foreground
                 "Black" :html-background "Transparent" :html-scale
                 1.0 :matchers ("begin" "$1" "$" "$$" "\\(" "\\[")))
 '(org-goto-max-level 10)
 '(org-hide-leading-stars t)
 '(org-log-done nil)
 '(org-outline-path-complete-in-steps nil)
 '(org-preview-latex-image-directory "/var/tmp/ltximg/")
 '(org-priority-lowest 90)
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
   '(abyss-theme ac-cider ac-clang ac-haskell-process ac-helm ac-slime
                 ace-isearch ace-jump-buffer ace-jump-mode ace-mc
                 ada-mode afternoon-theme ag amd-mode anki-connect
                 anki-editor anki-mode arduino-mode auctex axe caml
                 caroline-theme chess cider clang-format clang-format+
                 clojure-mode cmake-mode coffee-mode
                 color-theme-modern color-theme-sanityinc-solarized
                 color-theme-sanityinc-tomorrow color-theme-solarized
                 command-log-mode company-dcd compat csv-mode csv-nav
                 d-mode darcula-theme dart-mode dash-functional dfmt
                 dirtree doom-themes dracula-theme dumb-jump
                 editorconfig edts ein elisp-format elm-mode elpy
                 ensime erc-view-log erlang eros f f3
                 find-file-in-project flycheck-clang-tidy
                 flycheck-clangcheck flycheck-haskell flycheck-irony
                 flycheck-mypy flycheck-pycheckers flycheck-pyflakes
                 flymake-cursor flymake-python-pyflakes
                 forest-blue-theme forth-mode fountain-mode
                 frog-jump-buffer fsharp-mode geiser geiser-guile
                 geiser-racket ghc ghc-imported-from ghci-completion
                 git-gutter git-timemachine gnuplot gnuplot-mode go
                 go-mode google-this graphviz-dot-mode haskell-mode
                 helm helm-cider helm-company helm-cscope helm-dash
                 helm-gtags helm-lsp helm-org-ql helm-org-rifle
                 helm-package helm-projectile helm-rg helm-swoop
                 helm-unicode hide-mode-line hy-mode iasm-mode
                 ido-ubiquitous impatient-mode indium jade-mode jedi
                 js3-mode json-mode json-rpc jsx-mode julia-mode
                 julia-repl julia-shell key-chord less-css-mode
                 lsp-mode lsp-treemacs lsp-ui magit magit-gerrit
                 magit-todos markdown-mode meson-mode monokai-theme
                 multiple-cursors nasm-mode nim-mode nurumacs
                 nyan-mode ob-kotlin ob-mermaid ob-sql-mode olivetti
                 openwith org org-anki org-kanban org-latex-impatient
                 org-mobile-sync org-superstar ox-twbs paredit
                 ponylang-mode projectile projectile-ripgrep
                 protobuf-mode py-autopep8 pyenv-mode quack
                 rainbow-delimiters ranger restclient rg "rg" rtags
                 rust-mode sass-mode scala-mode scala-mode2 slime
                 smart-dash smex solarized-theme swift-mode
                 swiper-helm switch-window tide tuareg typescript-mode
                 undo-tree utop web-mode webfeeder
                 weyland-yutani-theme worf yaml-mode
                 yasnippet-classic-snippets yasnippet-snippets zones
                 ztree))
 '(projectile-auto-update-cache nil)
 '(projectile-enable-caching 'persistent)
 '(projectile-globally-ignored-directories
   '("*.idea" ".vscode" ".ensime_cache" ".eunit" ".git" ".hg" ".fslckout"
     "_FOSSIL_" ".bzr" "_darcs" ".pijul" ".tox" ".svn" ".stack-work"
     ".ccls-cache" ".cache" ".clangd" ".sl" ".jj" "SMT2_CC" "SMT2_CC2"
     "*build" "*out"))
 '(projectile-globally-ignored-files '("TAGS" "urg" ".git" "build" "log" "logs" ".idea"))
 '(projectile-indexing-method 'hybrid)
 '(projectile4-tags-backend 'ggtags)
 '(python-interpreter "/opt/miniconda3/envs/quantstats/bin/python")
 '(python-shell-interpreter "/opt/miniconda3/envs/quantstats/bin/ipython3")
 '(python-shell-interpreter-args "--simple-prompt")
 '(recentf-auto-cleanup 'never)
 '(rustic-ansi-faces
   ["#323334" "#C16069" "#A2BF8A" "#ECCC87" "#80A0C2" "#B58DAE" "#86C0D1"
    "#eceff4"])
 '(safe-local-variable-values
   '((auto-revert-mode . t) (helm-ag-command-option . "-tpy -tcpp -td")
     (test-case-name . twisted.internet.test.test_qtreactor)
     (test-case-name . twisted.internet.test.test_inotify)
     (test-case-name . twisted.internet.test.test_core)))
 '(send-mail-function 'smtpmail-send-it)
 '(sentence-end "\\. ")
 '(show-paren-mode t)
 '(sql-connection-alist
   '(("aqua_prod" (sql-product 'postgres) (sql-user "cabestan_admin")
      (sql-server "prod-eu-db1") (sql-database "aqua"))
     ("aqua_uat" (sql-product 'postgres) (sql-user "cabestan_admin")
      (sql-server "uat-db1") (sql-database "aqua"))))
 '(sql-postgres-login-params '((user :default "andy") server (database :default "andy")))
 '(sql-postgres-login-paramsupo '((user :default "andy") server (database :default "andy")))
 '(tab-width 2)
 '(undo-tree-history-directory-alist '((".*" . "~/.emacs.d/undo")))
 '(world-clock-list
   '(("Australia/Perth" "Perth") ("Asia/Dubai" "Dubai")
     ("Europe/Munich" "Munich") ("Europe/London" "London")
     ("Europe/Paris" "Paris") ("Europe/Berlin" "Berlin")
     ("America/New_York" "New York") ("America/Chicago" "Chicago"))))
(put 'scroll-left 'disabled nil)
(put 'dired-find-aorlternate-file 'disabled nil)
(menu-bar-mode 0)

(put 'erase-buffer 'disabled nil)
;;(load-file "~/.emacs.d/aqua.sql")
;;(require 'aqua.sql)



(defun smandy/test-theme-in-fresh-emacs (theme)
  "Test THEME in a fresh Emacs process."
  (let* ((emacs (expand-file-name invocation-name invocation-directory))
         (theme-path custom-theme-load-path)
         (library-path load-path)

         (form
          (format
           "(progn
              (setq custom-theme-load-path '%S)
              (setq load-path '%S)

              (condition-case err
                  (progn
                    (load-theme '%s t)
                    (princ \"OK\"))
                (error
                 (princ
                  (format \"FAIL: %%s\"
                          (error-message-string err))))))"
           theme-path
           library-path
           theme))

(output
 (with-temp-buffer
   (call-process emacs nil t nil
                 "--batch"
                 "-Q"
                 "--eval" form)
   (string-trim (buffer-string)))))

    (cons theme output)))

(defun smandy/test-all-themes-fresh ()
  "Test every available theme in a separate Emacs process."
  (interactive)
  (let ((results
         (mapcar #'smandy/test-theme-in-fresh-emacs
                 (custom-available-themes))))

    (with-output-to-temp-buffer "*Theme Test Results*"
      (dolist (result results)
        (princ
         (format "%-30s %s\n"
                 (car result)
                 (cdr result)))))))

(setq source-directory (expand-file-name "~/repos/emacs/"))



(defmacro --pmap (key list)
  "Map KEY over each plist in LIST."
  `(--map (plist-get it ,key) ,list))


(setq my-plist '(
                 :foo "bar"
                      :goo "baz"))

(setq my-alist '( ( :foo "baz")
                  ( :goo "bar")))

(plist-get my-plist :foo)
(plist-get my-plist :goo)

(alist-get :foo my-alist)
(alist-get :goo my-alist)



( let* (( a 3 ))
     `(+ 2 ,a))


(defmacro --pfilter (key predicate list)
  "Keep plists whose KEY value satisfies PREDICATE.

  PREDICATE is written using `it' for the property value."
  `(--filter
     (let ((it (plist-get it ,key)))
       ,predicate)
     ,list))

(require 'dash)

(defmacro --pmap (key list)
  "Map KEY over each plist in LIST."
  `(--map (plist-get it ,key) ,list))

(defmacro --pfilter (key predicate list)
  "Keep plists whose KEY value satisfies PREDICATE.

PREDICATE is written using `it' for the property value."
  `(--filter
     (let ((it (plist-get it ,key)))
       ,predicate)
     ,list))

(defmacro --pfilter-eq (key value list)
  "Keep plists where KEY is `eq' to VALUE."
  `(--filter (eq (plist-get it ,key) ,value) ,list))

(defmacro --pfilter-equal (key value list)
  "Keep plists where KEY is `equal' to VALUE."
  `(--filter (equal (plist-get it ,key) ,value) ,list))


(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode 1)

  ;; Ruff for linting, then mypy for type checking.
  (when (flycheck-valid-checker-p 'python-ruff)
    (flycheck-add-next-checker 'python-ruff 'python-mypy)))

(defun smandy/eros-eval-last-sexp-pp (arg)
  "Evaluate preceding sexp and display the result pretty-printed with EROS.

If the EROS inspect buffer is already visible, update it.
Never open or display the inspect buffer automatically."
  (interactive "P")
  (let ((result (eval-last-sexp arg)))
    (setq eros--last-result result)

    ;; Update the inspector only if the user has explicitly opened it
    ;; and it is currently visible.
    (when-let ((window (get-buffer-window eros--inspect-buffer-name)))
      (with-current-buffer eros--inspect-buffer-name
        (let ((inhibit-read-only t)
              (print-length nil)
              (print-level nil))
          (erase-buffer)
          (pp result (current-buffer))
          (goto-char (point-min))))
      (set-window-point window (point-min)))

    ;; Always give us the pretty EROS overlay.
    (let ((formatted (string-trim-right (pp-to-string result))))
      (if (fboundp 'eros-eval-overlay)
          (eros-eval-overlay formatted (point))
        (eros--make-result-overlay formatted
          :where (point)
          :duration eros-eval-result-duration)))))

(global-set-key [remap eval-last-sexp]
                #'smandy/eros-eval-last-sexp-pp)

;; --- GTD auto-commit+push on save (Claude, 2026-07-25) -----------------
;; Every save of a file in the GTD repo becomes a commit pushed to the
;; golden source in Scotland. Disasters become small visible commits.
;; NOTE: migrate this (with updated path) to whichever machine holds the
;; editing baton — exactly one machine should ever have this hook + clone.
(defvar andy/gtd-repo (expand-file-name "~/gtds/leonardo/gtd/"))
(defun andy/gtd-autopush ()
  (when (and buffer-file-name
             (string-prefix-p andy/gtd-repo (expand-file-name buffer-file-name)))
    (let ((default-directory andy/gtd-repo))
      (start-process-shell-command
       "gtd-autopush" "*gtd-autopush*"
       "git add -A && git commit -qm autosave && git push -q"))))
(add-hook 'after-save-hook #'andy/gtd-autopush)

(defun smandy/eros-pp-eval-last-sexp ()
  "Evaluate the preceding sexp and show its pretty-printed value with EROS."
  (interactive)
  (let ((result (eval (pp-last-sexp) lexical-binding)))
    (setq eros--last-result result)
    (eros--make-result-overlay
     (string-trim-right (pp-to-string result))
     :where (point)
     :duration eros-eval-result-duration)
    result))

(global-set-key (kbd "C-c C-e") #'smandy/eros-pp-eval-last-sexp)




;; -----------------------------------------------------------------------

;; --- Emacs server (Claude, 2026-09-06) ---------------------------------
;; Lets `emacsclient -n FILE' visit files in THIS Emacs instead of spawning
;; a second one. The guard matters: `server-running-p' is true if any Emacs
;; already owns the socket, so a second instance won't steal it and leave
;; `emacsclient' quietly talking to the wrong process.
(require 'server)
(unless (or noninteractive (server-running-p))
  (server-start))
;; -----------------------------------------------------------------------
