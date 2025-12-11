;; ============================
;; Go Language Support
;; ============================

(use-package go-mode
  :hook ((go-mode . lsp-deferred)
         (go-mode . my/go-format-on-save)))

;; Remove go-mode's default K binding (godef-describe)
(with-eval-after-load 'go-mode
  (define-key go-mode-map (kbd "K") nil)
  (with-eval-after-load 'evil
    (evil-define-key 'normal go-mode-map (kbd "K") nil)))

(defun my/go-format-on-save ()
  (add-hook 'before-save-hook #'lsp-format-buffer nil t))

(provide 'go-config)
