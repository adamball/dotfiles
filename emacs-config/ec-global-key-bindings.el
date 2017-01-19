;; global keybindings

;; Link win (super) key to meta
(setq x-super-keysym 'meta)

;; comment line with Ctrl-Shift-/
(global-set-key (kbd "C-?") 'toggle-comment-on-line)

;; magit status for the current buffer
(global-set-key (kbd "C-x g") 'magit-status)

(provide 'ec-global-key-bindings)
