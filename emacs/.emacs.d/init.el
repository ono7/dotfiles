;;; init.el --- Clean, Fast, Modern Emacs Config

;; 1. Debugging & Startup Speed
(setq debug-on-error t)

;; Improve startup performance by reducing Garbage Collection frequency
;; default is 800kb, we raise to 100mb
(setq gc-cons-threshold (* 100 1024 1024))

;; Display startup time
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "*** Emacs loaded in %s seconds with %d garbage collections."
                     (emacs-init-time "%.2f")
                     gcs-done)))

;; Add modules to load path
(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))

;;; UI Cleanup
(setq warning-suppress-types '((files)))
(setq use-short-answers t)             ; y or n
(setq confirm-kill-emacs 'y-or-n-p)    ; Confirm quit
(column-number-mode 1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode 1)
(show-paren-mode 1)                    ; Highlight matching parents
(setq x-stretch-cursor nil)            ; Don't stretch cursor on tabs

;;; Core Behavior
(setopt delete-pair-blink-delay 0)
(setq kill-do-not-save-duplicates t)
;; (setq list-buffers-brief t)
(prefer-coding-system 'utf-8)

;; Performance for long lines
(setopt bidi-paragraph-direction 'left-to-right)
(setopt bidi-inhibit-bpa t)
(global-so-long-mode 1)

;; File Saving (User Preference: No Autosave)
(setopt history-length 1000
        use-dialog-box nil
        delete-by-moving-to-trash t
        create-lockfiles nil
        auto-save-default nil          ; Explicitly disable auto-save
        ring-bell-function 'ignore
        delete-pair-push-mark t)

;;; Keybindings (General)
(global-set-key (kbd "C-S-v") 'yank)
(global-set-key (kbd "C-e") #'move-end-of-line)
(global-set-key (kbd "C-x k") 'kill-current-buffer)
(global-set-key (kbd "C-x C-g") 'find-file-at-point)
(global-set-key (kbd "C-c i m") 'imenu)

;; Smart Beginning of Line (Toggle between 0 and indent)
(defun my-smart-beginning-of-line ()
  "Move to first non-whitespace or beginning of line."
  (interactive)
  (let ((orig (point)))
    (back-to-indentation)
    (when (= orig (point))
      (move-beginning-of-line 1))))
(global-set-key (kbd "C-a") #'my-smart-beginning-of-line)

;; Duplicate Line
(defun rc/duplicate-line ()
  "Duplicate current line"
  (interactive)
  (let ((column (- (point) (line-beginning-position)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))
(global-set-key (kbd "C-,") 'rc/duplicate-line)

;; Insert Timestamp (Moved from C-x p d to C-c t to save Project prefix)
(defun rc/insert-timestamp ()
  (interactive)
  (insert (format-time-string "(%Y%m%d-%H%M%S)" nil t)))
(global-set-key (kbd "C-c t") 'rc/insert-timestamp)

;; Ripgrep Selected Text
(defun rc/rgrep-selected (beg end)
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))
                 (list (point-min) (point-min))))
  (consult-ripgrep nil (buffer-substring-no-properties beg end)))
;; Mapped to M-s s (Search selection)
(global-set-key (kbd "M-s s") 'rc/rgrep-selected)

;;; Number Incrementing (Vim Style C-a / C-x)
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

(global-set-key (kbd "C-c +") 'my/increment-number-decimal)
(global-set-key (kbd "C-c -") 'my/decrement-number-decimal)

;;; External Modules
(require 'core-bootstrap)
(require 'core-ui)
(require 'core-fonts)
(require 'core-osx)
(require 'core-editing)
(require 'core-rg)
;; (require 'evil-config) ; Disabled as requested
(require 'theme-config)
(require 'org-config)
(require 'vterm-config)
(require 'lsp-config)
(require 'python-config)
(require 'go-config)
(require 'ansible-config)
(require 'json-config)
(require 'yaml-config)
(require 'magit-config)

;;; Navigation Stack (The "Modern" Setup)

;; 0. Goto Last Change (Vim's g;)
(use-package goto-chg
  :ensure t
  :bind ("C-." . goto-last-change))

;; 1. Vertico: The vertical completion UI
(use-package vertico
  :init
  (vertico-mode)
  (setq vertico-cycle t))

;; 2. Orderless: Fuzzy matching
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; 3. Consult: Search Commands
(use-package consult
  :bind (("C-x b" . consult-project-buffer)  ; Your Tier 2 Switcher
         ("M-s r" . consult-ripgrep)         ; Your Tier 3 Search
         ("M-y"   . consult-yank-pop)        ; Clipboard history
         ("C-x r b" . consult-bookmark)      ; Bookmarks
         ("M-g g" . consult-goto-line)))     ; Goto line with preview

;; 4. Marginalia: Rich metadata
(use-package marginalia
  :init
  (marginalia-mode))

;; 5. Harpoon: Tier 1 Instant Switcher
(use-package harpoon
  :ensure t
  :config
  (setq harpoon-separate-by-branch nil)
  :bind (("C-c a" . harpoon-add-file)
         ("C-c h" . harpoon-quick-menu-hydra)
         ("C-c 1" . harpoon-go-to-1)
         ("C-c 2" . harpoon-go-to-2)
         ("C-c 3" . harpoon-go-to-3)
         ("C-c 4" . harpoon-go-to-4)))

;;; Utilities
(use-package async
  :ensure t
  :after dired
  :init (dired-async-mode 1))

(use-package savehist
  :init
  (savehist-mode t)
  (add-to-list 'savehist-additional-variables 'global-mark-ring))

(use-package repeat
  :init (repeat-mode +1))

;; Load the package
(use-package expand-region
  :ensure t ; Optional: ensures the package is installed if missing
  :bind ("C-=" . er/expand-region))

;; linting
;; (use-package flycheck
;; :ensure t
;;  :config
;;  (add-hook 'after-init-hook #'global-flycheck-mode))

;; this will honor the settings in ripgreprc
;; Force Emacs to recognize the ripgrep config file
(setenv "RIPGREP_CONFIG_PATH" (expand-file-name "~/.ripgreprc"))

;; TODO: this should be a core binding
;; Function to mimic Vim's 'o' (Open line below)
(defun my/open-line-below ()
  "Move to end of line, insert new line, and indent."
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))

;; Function to mimic Vim's 'O' (Open line above)
(defun my/open-line-above ()
  "Move to start of line, insert new line above, and indent."
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))

;; Keybindings
;; M-o is usually 'facemap-menu' (rich text formatting), safe to override for coding
(global-set-key (kbd "M-o") 'my/open-line-below)
(global-set-key (kbd "M-O") 'my/open-line-above)
