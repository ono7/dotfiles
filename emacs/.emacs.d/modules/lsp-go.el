(use-package go-mode
  :mode "\\.go\\'"
  :hook ((go-mode . (lambda () (setq tab-width 4)))))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-auto-guess-root t
        lsp-log-io nil
        lsp-enable-snippet nil
        lsp-prefer-flymake nil))

(use-package lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode))

(provide 'lsp-go)
