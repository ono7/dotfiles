;;; init.el --- Clean, Fast, Modern Emacs Config -*- lexical-binding: t; -*-

;;; 1. Startup & Performance Invariants

;; NOTE(jlima): Retain high GC threshold strictly during init to prevent startup churn.
(defvar default-gc-cons-threshold (* 16 1024 1024))
(setq gc-cons-threshold (* 100 1024 1024))
(setq read-process-output-max (* 1024 1024))

(add-hook 'emacs-startup-hook
          (lambda ()
            ;; NOTE(jlima): Reset threshold post-startup to prevent massive collection latency during editing.
            (setq gc-cons-threshold default-gc-cons-threshold)
            (message "*** Emacs loaded in %s seconds with %d garbage collections."
                     (emacs-init-time "%.2f")
                     gcs-done)))

;;; 2. Environment & Load Paths

(setenv "RIPGREP_CONFIG_PATH" (expand-file-name "~/.ripgreprc"))
(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))

(require 'core-bootstrap)

;;; 3. General Defaults & UI

(prefer-coding-system 'utf-8)
(setq-default bidi-paragraph-direction 'left-to-right
              bidi-inhibit-bpa t)
(global-so-long-mode 1)

;; UI Declutter
(setq warning-suppress-types '((files))
      use-short-answers t
      confirm-kill-emacs 'y-or-n-p
      ring-bell-function 'ignore
      x-stretch-cursor nil)

(column-number-mode 1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(save-place-mode 1)
(show-paren-mode 1)

(setq blink-cursor-blinks 0)
(blink-cursor-mode 1)

;; File & History Storage
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
(global-subword-mode 1)

(setq-default indent-tabs-mode nil)
(setq tab-always-indent nil
      tab-width 4)

;;; 4. Editing Primitives

(defun my/smart-beginning-of-line ()
  "Move to first non-whitespace or beginning of line."
  (interactive)
  (let ((orig (point)))
    (back-to-indentation)
    (when (= orig (point))
      (move-beginning-of-line 1))))

(defun my/open-line-below ()
  "Vim 'o': open and indent line below."
  (interactive)
  (move-end-of-line 1)
  (newline-and-indent))

(defun my/open-line-above ()
  "Vim 'O': open and indent line above."
  (interactive)
  (move-beginning-of-line 1)
  (save-excursion (newline))
  (indent-according-to-mode))

(defun my/increment-number-decimal (&optional arg)
  "Vim C-a / C-x equivalent: mutate integer under or immediately forward of point."
  (interactive "p")
  (let ((step (or arg 1)))
    (save-excursion
      (skip-chars-backward "0-9")
      (when (re-search-forward "[0-9]+" nil t)
        (replace-match (number-to-string (+ (string-to-number (match-string 0)) step)))))))

(defun my/decrement-number-decimal (&optional arg)
  (interactive "p")
  (my/increment-number-decimal (- (or arg 1))))

(defun rc/insert-timestamp ()
  (interactive)
  (insert (format-time-string "(%Y%m%d-%H%M%S)" nil t)))

;; Global Key Bindings
(global-set-key (kbd "C-a") #'my/smart-beginning-of-line)
(global-set-key (kbd "C-e") #'move-end-of-line)
(global-set-key (kbd "C-x k") #'kill-current-buffer)
(global-set-key (kbd "C-x C-g") #'find-file-at-point)
(global-set-key (kbd "C-c i m") #'imenu)
;; NOTE(jlima): Emacs 29 built-in duplicate-line replaces ad-hoc line-slicing function.
(global-set-key (kbd "C-,") #'duplicate-line)
(global-set-key (kbd "C-c t") #'rc/insert-timestamp)
(global-set-key (kbd "M-o") #'my/open-line-below)
(global-set-key (kbd "M-O") #'my/open-line-above)
(global-set-key (kbd "C-c +") #'my/increment-number-decimal)
(global-set-key (kbd "C-c -") #'my/decrement-number-decimal)

;;; 5. Completion & Navigation Stack

(use-package recentf
  :init (recentf-mode 1)
  :custom
  (recentf-max-saved-items 200)
  (recentf-max-menu-items 50))

(use-package savehist
  :init
  (savehist-mode 1)
  :config
  (add-to-list 'savehist-additional-variables 'global-mark-ring))

(use-package repeat
  :init (repeat-mode 1))

(use-package vertico
  :init
  (vertico-mode 1)
  :custom
  (vertico-cycle t))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :init (marginalia-mode 1))

(use-package consult
  :bind (("C-x b"   . consult-project-buffer)
         ("M-y"     . consult-yank-pop)
         ("C-x r b" . consult-bookmark)
         ("M-g g"   . consult-goto-line)
         ("M-s s"   . rc/rgrep-selected))
  :config
  (defun rc/rgrep-selected (beg end)
    "Run consult-ripgrep on active region."
    (interactive (if (use-region-p)
                     (list (region-beginning) (region-end))
                   (list (point-min) (point-min))))
    (consult-ripgrep nil (buffer-substring-no-properties beg end))))

(use-package beacon
  :config
  (beacon-mode 1)
  (setq beacon-blink-duration 0.2
        beacon-size 20))

(use-package harpoon
  :bind (("C-c a" . harpoon-add-file)
         ("C-c h" . harpoon-quick-menu-hydra)
         ("C-c 1" . harpoon-go-to-1)
         ("C-c 2" . harpoon-go-to-2)
         ("C-c 3" . harpoon-go-to-3)
         ("C-c 4" . harpoon-go-to-4))
  :custom
  (harpoon-separate-by-branch nil))

(use-package goto-chg
  :bind ("C-." . goto-last-change))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package async
  :defer t
  :init (dired-async-mode 1))

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode 1))

(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"     . mc/mark-all-like-this)))

(use-package pcre2el
  :config
  (pcre-mode 1))

(with-eval-after-load 'isearch
  (define-key isearch-mode-map (kbd "M-s /") #'isearch-toggle-pcre))

;;; 6. Module Loader

(require 'core-ui)
(require 'core-fonts)
(require 'theme-config)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(warning-suppress-types
   '((files missing-lexbind-cookie
            "/opt/homebrew/share/emacs/site-lisp/subdirs.el")
     (files))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
