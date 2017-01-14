;; core configuration loading file
;; configuration file layout heavily influenced by https://github.com/awood45/emacs

(add-to-list 'load-path "~/emacs-config/")
(add-to-list 'load-path "~/emacs-config/clojure")
(add-to-list 'load-path "~/emacs-config/elisp")
(add-to-list 'load-path "~/emacs-config/js")
(add-to-list 'load-path "~/emacs-config/ruby")

;; user defined functions
(require 'ec-functions)

;; package installation logic
(require 'ec-package-loader)

;; misc package installation
(require 'ec-misc-imports)

;; emacs lisp specific settings
(require 'ec-elisp)

;; clojure specific settings
(require 'ec-clojure)

;; emacs env settings
(require 'ec-env-settings)

;; global key bindings
(require 'ec-global-key-bindings)
