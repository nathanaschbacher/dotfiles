(require 'cl)

;; Setup package repositories and install my defaualt packages.
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t))

(defvar my-packages
  '(
    exec-path-from-shell
    erlang elixir-mode alchemist lfe-mode rust-mode go-mode ponylang-mode
    ansible cargo
    markdown-mode yaml-mode toml-mode json-mode
    company company-erlang company-go company-ansible
    flycheck flycheck-rust flycheck-rebar3 flycheck-mix flycheck-elixir flycheck-dialyzer
    flyspell-lazy
    rustfmt racer
    smooth-scrolling expand-region highlight hlinum git-gutter-fringe
    helm helm-themes helm-projectile helm-flycheck
    projectile perspective persp-mode persp-projectile
    org undo-tree magit
    flatland-theme flatland-black-theme monokai-theme
    nyan-mode
   )
)

(defun my-packages-installed-p ()
  (loop for p in my-packages
        when (not (package-installed-p p)) do (return nil)
        finally (return t)))
 
(unless (my-packages-installed-p)
  ;; check for new packages (package versions)
  (package-refresh-contents)
  ;; install the missing packages
  (dolist (p my-packages)
    (when (not (package-installed-p p))
      (package-install p))))

;; Perform some global setup to the UX and Bindings
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(setq-default indent-tabs-mode nil)
(setq tab-width 4)

(setq default-directory "~/Repositories")

(add-hook 'after-init-hook 'global-company-mode)
;(global-set-key (kbd "s-\\") 'company-complete)
(setq company-idle-delay 0.3)
 
(load-theme 'monokai t)
(setq-default cursor-type 'bar)
(setq inhibit-splash-screen t
      inhibit-startup-message t
      initial-scratch-message nil)
(setq ring-bell-function 'ignore)
(setq make-backup-files nil)

(defalias 'yes-or-no-p 'y-or-n-p)

(require 'undo-tree)
(defalias 'redo 'undo-tree-redo)
(global-undo-tree-mode 1)

(require 'paren)
(setq show-paren-style 'parenthesis)
(setq show-paren-delay 0)
(show-paren-mode +1)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(column-number-mode +1)
(global-linum-mode +1)
;; (setq linum-format "%4d \u2502 ")
(setq linum-format "%4d")
(fringe-mode '(4 . 0))

(require 'git-gutter-fringe)
(global-git-gutter-mode t)
(set-face-foreground 'git-gutter-fr:modified "gold1")
(set-face-foreground 'git-gutter-fr:added    "YellowGreen")
(set-face-foreground 'git-gutter-fr:deleted  "tomato3")
		
(defun p-window () 
    (interactive)
    (other-window -1))
(defun n-window () 
    (interactive)
    (other-window 1))

(defun split-n-switch (direction) 
    (select-window
      (pcase direction
        (0 (split-window-right))
        (1 (split-window-below)))))

(defun delete-window-then-frame ()
  (interactive)
  (if (> (length (window-list)) 1)
      (delete-window)
    (delete-frame)))

(defun spiral-close ()
  (interactive)
  (if (> (length (window-list)) 1) 
      (delete-window-then-frame)
    (kill-buffer (current-buffer))))

(defun spiral-kill ()
  (interactive)
  (if (> (length (window-list)) 1) 
      (kill-buffer (current-buffer))
    (delete-window-then-frame)))

;; Mouse and scrolling behavior.
(require 'smooth-scrolling)
(setq smooth-scroll-margin 4)

(put 'scroll-left 'disabled nil)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
; (setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(setq scroll-error-top-bottom 't)
(setq scroll-preserve-screen-position 't)

(require 'helm)
(require 'helm-config)
(helm-autoresize-mode 1)

(require 'helm-projectile)
(helm-projectile-on)

(defun toggle-helm (helm-command-to-call other-args)
  (funcall helm-command-to-call other-args))

(setq nyan-wavy-trail t)
(setq nyan-minimum-window-width 80)
(setq nyan-bar-length 15)
(nyan-mode)

(global-flycheck-mode)

;;Mode line setup
(setq-default
 mode-line-format
 '(; Position, including warning for 80 columns
   (:propertize " %4l" face mode-line-position-face)
   ":"
   (:eval (propertize "%3c" 'face
                      (if (>= (current-column) 110)
                          'mode-line-80col-face
                        'mode-line-position-face)))
   " "
   ; nyan-mode uses nyan cat as an alternative to %p
   (:eval (when nyan-mode (list (nyan-create))))
   ; emacsclient [default -- keep?]
   mode-line-client
   " "
   ; read-only or modified status
   (:eval
    (cond (buffer-read-only
           (propertize "RO" 'face 'mode-line-read-only-face))
          ((buffer-modified-p)
           (propertize "**" 'face 'mode-line-modified-face))
          (t "  ")))
   " "
   ; directory and buffer/file name
   (:eval  (propertize
            (concat
             (propertize (file-parents-abbrv 3)
                         'face 'mode-line-folder-face)
             (propertize "%b"
                         'face 'mode-line-filename-face))
            'mouse-face 'mode-line-highlight
            'help-echo "Click: Show file buffers\n\ Right-click: Show all buffers"
            'local-map (let ((map (make-sparse-keymap)))
                   (define-key map [mode-line down-mouse-1] 'helm-buffers-list)
                   (define-key map [mode-line down-mouse-3] 'describe-mode)
                   map)))
   ; narrow [default -- keep?]
   " %n"
   ; mode indicators: vc, recursive edit, major mode, minor modes, process, global
   " %["
   ; (:propertize mode-name
   ;              face mode-line-mode-face)
   (:eval  (propertize (format-mode-line mode-name)
      'face 'mode-line-mode-face
      'mouse-face 'mode-line-highlight
      'help-echo "Click: Display major mode menu\n\ Right-click: Show help for major mode"
      'local-map (let ((map (make-sparse-keymap)))
                   (define-key map [mode-line down-mouse-1]
                     `(menu-item ,(purecopy "Menu Bar") ignore
                                 :filter (lambda (_) (mouse-menu-major-mode-map))))
                   (define-key map [mode-line down-mouse-3] 'describe-mode)
                   map)))
   "%] "
   (:eval (propertize (format-mode-line minor-mode-alist)
		      'face 'mode-line-minor-mode-face
		      'mouse-face 'mode-line-highlight
		      'help-echo "Click: Toggle minor modes"
		      'local-map (let ((map (make-sparse-keymap)))
                   (define-key map [mode-line down-mouse-1] mode-line-mode-menu)
                   map)))
   (vc-mode vc-mode)
   (:propertize mode-line-process
                face mode-line-process-face)
   (global-mode-string global-mode-string)
   " "
   ))

(defun file-parents-abbrv (depth)
  (setq fullpath buffer-file-name)
  (if fullpath
      (progn
        (setq pathlist (last (split-string (file-name-directory fullpath) "/" t) depth))
        (setq pathstring (abbreviate-file-name (mapconcat 'identity pathlist "/")))
        (unless (or
             (< (length pathlist) depth)
             (string-prefix-p "~/" pathstring))
          (concat ".../" pathstring "/")))
    ""))

;; Helper function
(defun shorten-directory (dir max-length)
  "Show up to `max-length' characters of a directory name `dir'."
  (let ((path (reverse (split-string (abbreviate-file-name dir) "/")))
        (output ""))
    (when (and path (equal "" (car path)))
      (setq path (cdr path)))
    (while (and path (< (length output) (- max-length 4)))
      (setq output (concat (car path) "/" output))
      (setq path (cdr path)))
    (when path
      (setq output (concat ".../" output)))
    output))

;; Extra mode line faces
(make-face 'mode-line-read-only-face)
(make-face 'mode-line-modified-face)
(make-face 'mode-line-folder-face)
(make-face 'mode-line-filename-face)
(make-face 'mode-line-position-face)
(make-face 'mode-line-mode-face)
(make-face 'mode-line-minor-mode-face)
(make-face 'mode-line-process-face)
(make-face 'mode-line-80col-face)

(set-face-attribute 'mode-line nil
    :foreground "gray20" :background "white"
    :inverse-video nil
    :box '(:line-width 3 :color "white" :style nil))
(set-face-attribute 'mode-line-inactive nil
    :foreground "gray60" :background "gray20"
    :inverse-video nil
    :box '(:line-width 3 :color "gray20" :style nil))
(set-face-attribute 'mode-line-read-only-face nil
    :inherit 'mode-line-face
    :foreground "#4271ae"
    :box '(:line-width 2 :color "#4271ae"))
(set-face-attribute 'mode-line-modified-face nil
    :inherit 'mode-line-face
    :foreground "#c82829"
    :background "#ffffff"
    :box '(:line-width 2 :color "#c82829"))
(set-face-attribute 'mode-line-folder-face nil
    :inherit 'mode-line-face
    :foreground "gray60")
(set-face-attribute 'mode-line-filename-face nil
    :inherit 'mode-line-face
    :foreground "DeepSkyBlue3"
;;    :foreground "#eab700"
    :weight 'bold)
(set-face-attribute 'mode-line-position-face nil
    :inherit 'mode-line-face
    :family "Menlo" :height 100)
(set-face-attribute 'mode-line-mode-face nil
    :inherit 'mode-line-face
    :foreground "gray40")
(set-face-attribute 'mode-line-minor-mode-face nil
    :inherit 'mode-line-mode-face
    :foreground "gray60"
    :height 100)
(set-face-attribute 'mode-line-process-face nil
    :inherit 'mode-line-face
    :foreground "#718c00")
(set-face-attribute 'mode-line-80col-face nil
    :inherit 'mode-line-position-face
    :foreground "black" :background "#eab700")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("3539b3cc5cbba41609117830a79f71309a89782f23c740d4a5b569935f9b7726" default)))
 '(delete-selection-mode t)
 '(face-font-family-alternatives
   (quote
    (("Monospace" "fixed")
     ("CMU Typewriter Text" "fixed")
     ("Sans Serif" "helv" "helvetica" "arial" "fixed")
     ("helv" "helvetica" "arial" "fixed"))))
 '(initial-scratch-message nil)
 '(recentf-mode t)
 '(scroll-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Menlo" :foundry "bitstream" :slant normal :weight normal :height 100 :width normal))))
 '(mode-line-highlight ((t (:background "Orange" :foreground "white" :box (:line-width 4 :color "Orange"))))))

(load-file "~/.emacs.d/my_bindings.el")
