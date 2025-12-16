;; Add modules/ to load path
(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))

;; dont highlight on mark
;; (setq transient-mark-mode nil)
;; (transient-mark-mode -1)

(setq warning-suppress-types '((files)))
(setq use-short-answers t) ;; y or n

(global-set-key (kbd "C-S-v") 'yank) ;; paste
;; (global-set-key (kbd "C-a") #'move-beginning-of-line)
(global-set-key (kbd "C-e") #'move-end-of-line)


(defun my-smart-beginning-of-line ()
  "Move to first non-whitespace or beginning of line.
If already at indentation, move to column 0."
  (interactive)
  (let ((orig (point)))
    (back-to-indentation)
    (when (= orig (point))
      (move-beginning-of-line 1))))

(global-set-key (kbd "C-a") #'my-smart-beginning-of-line)

;; Kill current buffer immediately (skip the "Kill buffer?" prompt)
(global-set-key (kbd "C-x k") 'kill-current-buffer)

;;(global-unset-key (kbd "C-x C-z"))
;;(global-set-key ((kbd "C-x C-z") 'grep-find))

(setq kill-do-not-save-duplicates t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq list-buffers-brief t)

;; Move the help prefix from C-h → F1
(global-set-key (kbd "<f1>") help-map)

;; Remove Emacs’ default C-h binding so Evil can continue using it
;; (global-unset-key (kbd "C-h"))

;; core settings
(require 'core-bootstrap)
(require 'core-ui)
(require 'core-fonts)
(require 'core-osx)
(require 'core-editing)
(require 'core-rg)
;; (require 'evil-config)
(require 'theme-config)
;; (require 'completion-config)
;; (require 'project-config)
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

;; new things for vanilla emacs

;; 1. Setup "g;" behavior (requires 'goto-chg package)
(use-package goto-chg
  :ensure t
  :bind ("C-." . goto-last-change))

(blink-cursor-mode 1)
(ido-mode 1)
(ido-everywhere 1)
