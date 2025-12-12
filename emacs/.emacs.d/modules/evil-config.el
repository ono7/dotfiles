(use-package evil
  (use-package evil
    :init
    (setq evil-want-keybinding nil
          evil-want-C-u-scroll t
          evil-want-C-i-jump t
	  ;; --- Ex command history ---
	  evil-ex-save-history t
	  evil-ex-history-file (expand-file-name "evil-ex-history" user-emacs-directory)
	  evil-want-autoload-ex t)

    :config
    ;; Evil ex command history persistence
    (setq evil-ex-save-history t)
    (setq evil-ex-history-file (expand-file-name "evil-ex-history" user-emacs-directory))

    ;; Ensure evil-ex is fully enabled
    (setq evil-want-autoload-ex t)

    (evil-mode 1))

  (use-package evil-collection
    :after evil
    :config
    (evil-collection-init))

  (use-package evil-commentary
    :after evil
    :config
    (evil-commentary-mode 1))

  (with-eval-after-load 'evil
    ;; ============================
    ;; Insert mode customizations
    ;; ============================
    (define-key evil-insert-state-map (kbd "C-a") #'move-beginning-of-line)
    (define-key evil-insert-state-map (kbd "C-e") #'move-end-of-line)
    (define-key evil-insert-state-map (kbd "M-b") #'backward-word)
    (define-key evil-insert-state-map (kbd "M-f") #'forward-word)
    (define-key evil-insert-state-map (kbd "C-k") #'kill-line)
    (define-key evil-insert-state-map (kbd "C-d") #'delete-char)
    (define-key evil-insert-state-map (kbd "C-h") #'delete-backward-char)

    (define-key evil-normal-state-map (kbd "SPC a") 
		(lambda ()
		  (interactive)
		  (evil-goto-first-line)
		  (evil-visual-line)
		  (evil-goto-line)))

    ;; ============================
    ;; Normal mode adjustments
    ;; ============================
    (define-key evil-normal-state-map (kbd "C-d") #'delete-char)

    ;; ============================
    ;; Global C-a / C-e
    ;; ============================
    (global-set-key (kbd "C-a") #'move-beginning-of-line)
    (global-set-key (kbd "C-e") #'move-end-of-line)

    ;; ============================
    ;; Cursor shapes
    ;; ============================
    (setq evil-normal-state-cursor  'box
          evil-visual-state-cursor  'box
          evil-insert-state-cursor  'box
          evil-replace-state-cursor 'box
          evil-operator-state-cursor 'box))

  ;; ============================
  ;; Window movement
  ;; ============================
  (require 'windmove)
  (with-eval-after-load 'evil
    (evil-define-key 'normal 'global
      (kbd "C-h") #'windmove-left
      (kbd "C-j") #'windmove-down
      (kbd "C-k") #'windmove-up
      (kbd "C-l") #'windmove-right))

  (provide 'evil-config)
  :init
  (setq evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-want-C-i-jump t
	;; --- Ex command history ---
	evil-ex-save-history t
	evil-ex-history-file (expand-file-name "evil-ex-history" user-emacs-directory)
	evil-want-autoload-ex t)

  :config
  ;; Evil ex command history persistence
  (setq evil-ex-save-history t)
  (setq evil-ex-history-file (expand-file-name "evil-ex-history" user-emacs-directory))

  ;; Ensure evil-ex is fully enabled
  (setq evil-want-autoload-ex t)

  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode 1))

(with-eval-after-load 'evil
  ;; ============================
  ;; Insert mode customizations
  ;; ============================
  (define-key evil-insert-state-map (kbd "C-a") #'move-beginning-of-line)
  (define-key evil-insert-state-map (kbd "C-e") #'move-end-of-line)
  (define-key evil-insert-state-map (kbd "M-b") #'backward-word)
  (define-key evil-insert-state-map (kbd "M-f") #'forward-word)
  (define-key evil-insert-state-map (kbd "C-k") #'kill-line)
  (define-key evil-insert-state-map (kbd "C-d") #'delete-char)
  (define-key evil-insert-state-map (kbd "C-h") #'delete-backward-char)

  (define-key evil-normal-state-map (kbd "SPC a") 
	      (lambda ()
		(interactive)
		(evil-goto-first-line)
		(evil-visual-line)
		(evil-goto-line)))

  ;; ============================
  ;; Normal mode adjustments
  ;; ============================
  (define-key evil-normal-state-map (kbd "C-d") #'delete-char)

  ;; ============================
  ;; Global C-a / C-e
  ;; ============================
  (global-set-key (kbd "C-a") #'move-beginning-of-line)
  (global-set-key (kbd "C-e") #'move-end-of-line)

  ;; ============================
  ;; Cursor shapes
  ;; ============================
  (setq evil-normal-state-cursor  'box
        evil-visual-state-cursor  'box
        evil-insert-state-cursor  'box
        evil-replace-state-cursor 'box
        evil-operator-state-cursor 'box))

;; ============================
;; Window movement
;; ============================
(require 'windmove)
(with-eval-after-load 'evil
  (evil-define-key 'normal 'global
    (kbd "C-h") #'windmove-left
    (kbd "C-j") #'windmove-down
    (kbd "C-k") #'windmove-up
    (kbd "C-l") #'windmove-right))

(provide 'evil-config)
