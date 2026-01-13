;;; init.el --- Clean, Fast, Modern Emacs Config -*- lexical-binding: t; -*-
(global-set-key (kbd "M-s") #'isearch-forward-regexp)
(global-set-key (kbd "M-r") #'isearch-backward-regexp)
;;
;; C-x s = save file
;; C-c f = dired
;; c-w on selection (cut selection)
;; c-x k (kill current buffer)

;;; 1. Startup & Performance
(setq gc-cons-threshold (* 100 1024 1024)) ; 100MB GC threshold
(setq read-process-output-max (* 1024 1024)) ; Increase read size for LSP/JSON

(add-hook 'emacs-startup-hook
          (lambda ()
            (message "*** Emacs loaded in %s seconds with %d garbage collections."
                     (emacs-init-time "%.2f")
                     gcs-done)))

;;; 3. General Preferences
(setenv "RIPGREP_CONFIG_PATH" (expand-file-name "~/.ripgreprc"))
(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))

;; setup package manager
(require 'core-bootstrap)

(prefer-coding-system 'utf-8)
(setq-default bidi-paragraph-direction 'left-to-right
              bidi-inhibit-bpa t)     ; Performance for long lines
(global-so-long-mode 1)               ; Handle minified files

;; UI Cleanup
(setq warning-suppress-types '((files))
      use-short-answers t             ; y or n
      confirm-kill-emacs 'y-or-n-p    ; Confirm quit
      ring-bell-function 'ignore
      x-stretch-cursor nil)           ; Don't stretch on tabs

(column-number-mode 1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(save-place-mode 1)

(add-hook 'after-init-hook
	  (lambda ()
	    (blink-cursor-mode 1)
	    (setq blink-cursor-blinks 0)))

(show-paren-mode 1)

;; File Handling (No Autosave/Backup)
(setq history-length 1000
      use-dialog-box nil
      delete-by-moving-to-trash t
      create-lockfiles nil
      auto-save-default nil
      make-backup-files nil)

;; Editing Behavior
(setq delete-pair-blink-delay 0
      kill-do-not-save-duplicates t
      delete-pair-push-mark t)
(global-subword-mode 1)               ; CamelCase movement

;;; 4. Custom Helper Functions & Keybindings

;; Smart Beginning of Line
(defun my-smart-beginning-of-line ()
  "Move to first non-whitespace or beginning of line."
  (interactive)
  (let ((orig (point)))
    (back-to-indentation)
    (when (= orig (point))
      (move-beginning-of-line 1))))

;; Duplicate Line
(defun rc/duplicate-line ()
  "Duplicate current line."
  (interactive)
  (let ((column (- (point) (line-beginning-position)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))

;; Vim-like Open Line Below
(defun my/open-line-below ()
  "Move to end of line, insert new line, and indent."
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))

;; Vim-like Open Line Above
(defun my/open-line-above ()
  "Move to start of line, insert new line above, and indent."
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))

;; Vim-like Number Increment
(defun my/increment-number-decimal (&optional arg)
  "Increment the number forward from point by ARG."
  (interactive "p")
  (save-excursion
    (skip-chars-backward "0123456789")
    (or (looking-at "[0123456789]+")
        (re-search-forward "[0123456789]+" nil t))
    (replace-match (number-to-string (+ (string-to-number (match-string 0)) (or arg 1))))))

(defun my/decrement-number-decimal (&optional arg)
  (interactive "p")
  (my/increment-number-decimal (- (or arg 1))))

(defun rc/insert-timestamp ()
  (interactive)
  (insert (format-time-string "(%Y%m%d-%H%M%S)" nil t)))

;; General Bindings
(global-set-key (kbd "C-S-v") 'yank)
(global-set-key (kbd "C-e") #'move-end-of-line)
(global-set-key (kbd "C-a") #'my-smart-beginning-of-line)
(global-set-key (kbd "C-x k") 'kill-current-buffer)
(global-set-key (kbd "C-x C-g") 'find-file-at-point)
(global-set-key (kbd "C-c i m") 'imenu)
(global-set-key (kbd "C-,") 'rc/duplicate-line)
(global-set-key (kbd "C-c t") 'rc/insert-timestamp)
(global-set-key (kbd "M-o") 'my/open-line-below)
(global-set-key (kbd "M-O") 'my/open-line-above)
(global-set-key (kbd "C-c +") 'my/increment-number-decimal)
(global-set-key (kbd "C-c -") 'my/decrement-number-decimal)

;;; 5. Core Navigation Stack
(use-package recentf
  :straight nil
  :init (recentf-mode 1)
  :custom
  (recentf-max-saved-items 200)
  (recentf-max-menu-items 50))

(use-package vertico
  :init
  (vertico-mode)
  (setq vertico-cycle t))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :init (marginalia-mode))

(use-package savehist
  :init
  (savehist-mode t)
  (add-to-list 'savehist-additional-variables 'global-mark-ring))

(use-package consult
  :bind (("C-x b" . consult-project-buffer)
         ("M-s r" . consult-ripgrep)
         ("M-y"   . consult-yank-pop)
         ("C-x r b" . consult-bookmark)
         ("M-g g" . consult-goto-line)
         ("M-s s" . rc/rgrep-selected))
  :config
  (defun rc/rgrep-selected (beg end)
    "Run consult-ripgrep on selected region."
    (interactive (if (use-region-p)
                     (list (region-beginning) (region-end))
                   (list (point-min) (point-min))))
    (consult-ripgrep nil (buffer-substring-no-properties beg end))))

(use-package harpoon
  :config (setq harpoon-separate-by-branch nil)
  :bind (("C-c a" . harpoon-add-file)
         ("C-c h" . harpoon-quick-menu-hydra)
         ("C-c 1" . harpoon-go-to-1)
         ("C-c 2" . harpoon-go-to-2)
         ("C-c 3" . harpoon-go-to-3)
         ("C-c 4" . harpoon-go-to-4)))

(use-package goto-chg
  :bind ("C-." . goto-last-change))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package async
  :defer t
  :init (dired-async-mode 1))

(use-package repeat
  :init (repeat-mode +1))

(use-package treesit-auto
  :straight t
  :custom
  (treesit-auto-install 'prompt) ; Prompt to install grammar if missing
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; make isearch space act like lazy greedy operator (.*?)
(setq search-whitespace-regexp ".*?")

;;; 6. Module Loader
(require 'core-ui)
(require 'core-fonts)
;; (require 'core-osx)
;; (require 'core-rg)
(require 'theme-config)
;; (require 'org-config)
;; (require 'lsp-config)
;; (require 'python-config)
;; (require 'go-config)
;; (require 'ansible-config)
;; (require 'json-config)
;; (require 'yaml-config)
;; (require 'magit-config)

;; Global default: spaces
;; (setq indent-tabs-mode t)
(setq indent-tabs-mode nil)
(setq tab-always-indent nil)
(setq tab-width 4)

(use-package multiple-cursors
  :ensure t
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"     . mc/mark-all-like-this)))

(with-eval-after-load 'isearch
  ;; Force immediate movement on first stroke if search string exists
  (define-key isearch-mode-map (kbd "C-s") 'isearch-repeat-forward)
  (define-key isearch-mode-map (kbd "C-r") 'isearch-repeat-backward)
  
  ;; Map M-s to toggle regex (overriding the M-s prefix within isearch)
  (define-key isearch-mode-map (kbd "M-s") 'isearch-toggle-regexp))

(setq whitespace-style '(face trailing lines-tail)) ;; Remove 'tabs' from this list

(defun my-go-mode-setup ()
  "Custom settings for Go mode."
  (setq tab-width 4))

(add-hook 'go-mode-hook 'my-go-mode-setup)

;; search regex forward and backwards
(global-set-key (kbd "M-s") #'isearch-forward-regexp)
(global-set-key (kbd "M-r") #'isearch-backward-regexp)
