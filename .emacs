;; emacs config file

;;;;
;; initialize package installation logic
;;;;

(require 'package)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

(package-initialize)

;;;;
;; utility functions
;;;;

(defun util/replace-tabs ()
  "replace tabs with spaces"
  (interactive)
  (set-variable 'tab-width 2)
  (mark-whole-buffer)
  (untabify (region-beginning) (region-end))
  (keyboard-quit))

(defun util/fix-format ()
  "re-indent entire buffer"
  (interactive)
  (mark-whole-buffer)
  (indent-region (region-beginning) (region-end))
  (keyboard-quit))

(defun util/toggle-comment-on-line ()
  "comment or uncomment current line"
  (interactive)
  (comment-or-uncomment-region (line-beginning-position) (line-end-position)))

(defun util/install-package-if-missing (package)
  "perform package installation if package is missing"
  (unless (package-installed-p package)
    (package-refresh-contents)
    (package-install package)))

(defun util/friendlier-visible-bell ()
  "A friendlier visual bell effect. (https://www.emacswiki.org/emacs/AlarmBell#toc8)"
  (invert-face 'mode-line)
  (run-with-timer 0.1 nil 'invert-face 'mode-line))

(defun util/delete-process-interactive ()
  "delete process using an ido-read buffer (http://stackoverflow.com/questions/11572934/how-do-i-kill-a-running-process-in-emacs#11573495)"
  (interactive)
  (let ((pname (ido-completing-read "Process Name: " (mapcar 'process-name (process-list)))))
    (delete-process (get-process pname))))

(defun util/change-font-height ()
  "interactively change font height attribute"
  (interactive)
  (let ((updated-height (read-from-minibuffer (format "Enter new height (current is %d): " (face-attribute 'default :height)))))
    (set-face-attribute 'default nil :height (string-to-number updated-height))))

;;;;
;; install packages
;;;;

(util/install-package-if-missing 'base16-theme)
(util/install-package-if-missing 'cider)
(util/install-package-if-missing 'clojure-mode)
(util/install-package-if-missing 'clojure-mode-extra-font-locking)
(util/install-package-if-missing 'company)
(util/install-package-if-missing 'evil)
(util/install-package-if-missing 'json-mode)
(util/install-package-if-missing 'magit)
(util/install-package-if-missing 'markdown-mode)
(util/install-package-if-missing 'midje-mode)
(util/install-package-if-missing 'paredit)
(util/install-package-if-missing 'rainbow-delimiters)
(util/install-package-if-missing 'sql-indent)
(util/install-package-if-missing 'wiki-summary)

;;;;
;; requires / hooks / init
;;;;

(require 'company)
(require 'evil)
(require 'json-mode)
(require 'magit)
(require 'markdown-mode)
(require 'paredit)
(require 'rainbow-delimiters)
(require 'uniquify)

(evil-mode 1)

(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'cider-repl-mode-hook #'eldoc-mode)
(add-hook 'cider-repl-mode-hook #'midje-mode)
(add-hook 'cider-repl-mode-hook #'paredit-mode)
(add-hook 'cider-repl-mode-hook #'rainbow-delimiters-mode)
(add-hook 'clojure-mode-hook #'eldoc-mode)
(add-hook 'clojure-mode-hook #'paredit-mode)
(add-hook 'emacs-lisp-mode-hook #'eldoc-mode)
(add-hook 'emacs-lisp-mode-hook #'paredit-mode)
(add-hook 'ielm-mode-hook #'eldoc-mode)
(add-hook 'ielm-mode-hook #'paredit-mode)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; normal <delete> key binding in paredit
(eval-after-load 'paredit
  '(progn
     (define-key paredit-mode-map (kbd "<delete>")
       nil)))

;; load sql-indent
(eval-after-load "sql"
  '(load-library "sql-indent"))

;; disable evil mode in cider-repl
(evil-set-initial-state 'cider-repl-mode 'emacs)

(setq cider-prompt-save-file-on-load nil)
(setq cider-repl-result-prefix ";; => ")
(setq nrepl-hide-special-buffers t)

(add-to-list 'auto-mode-alist '("\\.json$" . json-mode))

;;;;
;; emacs general / ui settings
;;;;

(load-theme 'base16-ashes t)

;; don't use backup files
(setq make-backup-files nil)

;; set the initial mode and nix the scratch message
(setq initial-major-mode 'fundamental-mode)
(setq initial-scratch-message nil)

;; use y/n instead of yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;; don't use hard tabs
(setq-default indent-tabs-mode nil)

;; no electric-indent
(setq electric-indent-mode nil)

;; get rid of toolbar, scrollbar, and menubar
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; column numbering
(column-number-mode t)

;; better handling of duplicate named files
(setq uniquify-buffer-name-style 'forward)

;; mouse scrolling fix
(setq mouse-wheel-scroll-amount '(4 ((shift) . 4) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)

;; don't show the welcome message
(setq inhibit-startup-message t)

;; global highlight lines
(custom-set-faces
 '(hl-line ((t (:background "#393f45")))))
(global-hl-line-mode 1)

;; use friendlier visual bell
(setq visible-bell nil)
(setq ring-bell-function #'util/friendlier-visible-bell)

;; matching parens highlight
(show-paren-mode 1)

;; global line numbers
(global-linum-mode 1)

;; no cursor blinking
(blink-cursor-mode 0)

;; full path in title bar
(setq-default frame-title-format "%b (%f)")

;; set font height
(set-face-attribute 'default nil :height 160)

;; set font face to Monaco if on macOS
(if (string= system-type "darwin")
    (set-frame-font "Monaco" nil t))

;; override custom file
(setq custom-file "~/.emacs.d/custom.el")
(if (not (file-exists-p custom-file))
    (write-region "" nil custom-file))
(load custom-file)

(add-to-list 'load-path "/usr/local/bin")
(add-to-list 'exec-path "~/bin/")

;;;;
;; key bindings
;;;;

;; fix format of buffer
(global-set-key (kbd "C-c C-f") 'util/fix-format)

;; comment line with Ctrl-Shift-/
(global-set-key (kbd "C-?") 'util/toggle-comment-on-line)

;; magit status for the current buffer
(global-set-key (kbd "C-x g") 'magit-status)

;; clear Cider's repl buffer with Ctrl+1
(eval-after-load 'cider-repl
  '(define-key cider-repl-mode-map
     (kbd "C-1") 'cider-repl-clear-buffer))
