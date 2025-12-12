(use-package evil
  :init
  (setq evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-want-C-i-jump t)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode 1))

;; Custom keys
(with-eval-after-load 'evil
  (define-key evil-insert-state-map (kbd "C-a") #'move-beginning-of-line)
  (define-key evil-insert-state-map (kbd "C-e") #'move-end-of-line)
  (define-key evil-insert-state-map (kbd "M-b") #'backward-word)
  (define-key evil-insert-state-map (kbd "M-f") #'forward-word)
  (define-key evil-insert-state-map (kbd "C-k") #'kill-line)
  (define-key evil-insert-state-map (kbd "C-d") #'delete-char)
  (define-key evil-insert-state-map (kbd "C-h") #'delete-backward-char)
  (defun my/evil-select-all ()
    (interactive)
    (evil-goto-first-line)
    (evil-visual-line)
    (evil-goto-line))

  ;; ... preserve your existing keys below ...
  (define-key evil-insert-state-map (kbd "C-a") #'move-beginning-of-line)

  ;; normal mode adjustments
  (define-key evil-normal-state-map (kbd "C-d") #'delete-char)

  ;; global C-a / C-e
  (global-set-key (kbd "C-a") #'move-beginning-of-line)
  (global-set-key (kbd "C-e") #'move-end-of-line)

  ;; cursor shapes
  (setq evil-normal-state-cursor  'box
        evil-visual-state-cursor  'box
        evil-insert-state-cursor  'box
        evil-replace-state-cursor 'box
        evil-operator-state-cursor 'box))

;; Window movement
(require 'windmove)
(with-eval-after-load 'evil
  (evil-define-key 'normal 'global
    (kbd "C-h") #'windmove-left
    (kbd "C-j") #'windmove-down
    (kbd "C-k") #'windmove-up
    (kbd "C-l") #'windmove-right))

(provide 'evil-config)
