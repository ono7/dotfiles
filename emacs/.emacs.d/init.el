;; Add modules/ to load path
(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))

(setq warning-suppress-types '((files)))
(setq use-short-answers t) ;; y or n
(global-set-key (kbd "C-S-v") 'yank) ;; paste

;; core settings
(require 'core-bootstrap)
(require 'core-ui)
(require 'core-fonts)
(require 'core-osx)
(require 'core-editing)
(require 'core-rg)
(require 'evil-config)
(require 'theme-config)
(require 'completion-config)
(require 'project-config)
(require 'org-config)

;; terminal
(require 'vterm-config)

;; programming things
(require 'lsp-config)
(require 'python-config)
(require 'go-config)
(require 'ansible-config)
(require 'json-config)
(require 'yaml-config)

;; magit
(require 'magit-config)

(define-key help-mode-map (kbd "q") #'quit-window)
(setq x-stretch-cursor nil)

