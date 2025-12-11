;; Recent files
(use-package recentf
  :straight nil
  :init (recentf-mode 1)
  :custom
  (recentf-max-saved-items 200)
  (recentf-max-menu-items 50))

(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "C-r") #'consult-recent-file))

;; M-q in normal mode
(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "M-q") #'fill-paragraph))

(provide 'core-editing)
