;; Add modules/ to load path
(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))

(setq warning-suppress-types '((files)))

(require 'core-bootstrap)
(require 'core-ui)
(require 'core-fonts)
(require 'core-osx)
(require 'core-editing)
(require 'evil-config)
(require 'theme-config)
(require 'completion-config)
(require 'project-config)
(require 'lsp-go)
(require 'org-config)
