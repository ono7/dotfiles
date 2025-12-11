;; --- Magit Setup ---
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)) ; Bind the standard Magit status key
  :config
  ;; Enable verbose commits by default for context
  (setq magit-commit-arguments '("--verbose"))
  ;; Enable fine-grained diff highlighting
  (setq magit-diff-refine-hunks 'all))

(provide 'magit-config)
