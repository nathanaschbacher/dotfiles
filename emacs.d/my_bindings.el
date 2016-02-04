;; imported from the emacsformacosx defaults because I like them.
;; Here are some Nextstep-like bindings for command key sequences.
(define-key global-map [?\s-,] 'customize)
(define-key global-map [?\s-'] 'next-multiframe-window)
;(define-key global-map [?\s-`] 'other-frame)
;(define-key global-map [?\s-~] 'ns-prev-frame)
(define-key global-map [?\s--] 'center-line)
(define-key global-map [?\s-:] 'ispell)
(define-key global-map [?\s-?] 'info)
;(define-key global-map [?\s-^] 'kill-some-buffers)
;(define-key global-map [?\s-&] 'kill-this-buffer)
;(define-key global-map [?\s-C] 'ns-popup-color-panel)
(define-key global-map [?\s-D] 'dired)
(define-key global-map [?\s-E] 'edit-abbrevs)
(define-key global-map [?\s-L] 'shell-command)
(define-key global-map [?\s-M] 'manual-entry)
;(define-key global-map [?\s-S] 'ns-write-file-using-panel)
(define-key global-map [?\s-S] 'set-visited-file-name)
(define-key global-map [?\s-a] 'mark-whole-buffer)
;(define-key global-map [?\s-c] 'ns-copy-including-secondary)
(define-key global-map [?\s-c] 'kill-ring-save)
(define-key global-map [?\s-d] 'isearch-repeat-backward)
(define-key global-map [?\s-e] 'isearch-yank-kill)
(define-key global-map [?\s-f] 'isearch-forward)
(define-key global-map [?\s-g] 'isearch-repeat-forward)
;(define-key global-map [?\s-h] 'ns-do-hide-emacs)
;(define-key global-map [?\s-H] 'ns-do-hide-others)
(define-key global-map [?\s-j] 'exchange-point-and-mark)
(define-key global-map [?\s-k] 'kill-this-buffer)
(define-key global-map [?\s-l] 'goto-line)
(define-key global-map [?\s-m] 'iconify-frame)
;(define-key global-map [?\s-n] 'make-frame)
;(define-key global-map [?\s-o] 'ns-open-file-using-panel)
;(define-key global-map [?\s-p] 'ns-print-buffer)
(define-key global-map [?\s-p] 'print-buffer)
(define-key global-map [?\s-q] 'save-buffers-kill-emacs)
(define-key global-map [?\s-s] 'save-buffer)
;(define-key global-map [?\s-t] 'ns-popup-font-panel)
(define-key global-map [?\s-u] 'revert-buffer)
(define-key global-map [?\s-v] 'clipboard-yank)
;(define-key global-map [?\s-w] 'delete-frame)
(define-key global-map [?\s-x] 'kill-region)
;(define-key global-map [?\s-y] 'ns-paste-secondary)
(define-key global-map [?\s-z] 'undo)
(define-key global-map [?\s-|] 'shell-command-on-region)

;; bindings for installed packages
(global-set-key (kbd "s-\\") 'company-complete)
(global-set-key (kbd "s-z") 'undo)
(global-set-key (kbd "s-Z") 'redo)
(global-set-key (kbd "s-O") 'neotree-toggle)
(global-set-key (kbd "s-P") 'helm-M-x)

;; my custom window and buffer management.
(global-set-key [wheel-right] 'ignore)
(global-set-key [wheel-left] 'ignore)
(global-set-key (kbd "s-[") 'previous-buffer)
(global-set-key (kbd "s-]") 'next-buffer)
(global-set-key (kbd "s-.") 'keyboard-escape-quit)
(global-set-key (kbd "s-/") 'comment-or-uncomment-region)
(global-set-key (kbd "s-<down>") 'shrink-window)
(global-set-key (kbd "s-<up>") 'enlarge-window)
(global-set-key (kbd "s-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "s-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "s--") 'text-scale-decrease)
(global-set-key (kbd "s-=") 'text-scale-increase)

(global-set-key (kbd "s-{") 'p-window)
(global-set-key (kbd "s-}") 'n-window)

(global-set-key (kbd "s-t") (lambda () (interactive) (split-n-switch 0)))
(global-set-key (kbd "s-T") (lambda () (interactive) (split-n-switch 1)))
(global-set-key (kbd "s-N") 'make-frame)
(global-set-key (kbd "s-n") 'find-file)
(global-set-key (kbd "s-o") 'find-file)

(global-set-key (kbd "s-w") 'spiral-close)
(global-set-key (kbd "M-s-w") 'kill-this-buffer)
