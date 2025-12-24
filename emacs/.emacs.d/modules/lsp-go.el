(use-package go-mode
  :ensure t
  :hook ((go-mode . lsp-deferred)          ; 1. Trigger LSP when entering Go mode
         (go-mode . (lambda ()             ; 2. Formatting & Visuals
                      (setq tab-width 4)
                      (setq indent-tabs-mode t)
                      (setq-local whitespace-style '(face trailing lines-tail empty indentation::space))))))

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-auto-guess-root t
        lsp-log-io nil
        lsp-enable-snippet nil))           ; Removed lsp-prefer-flymake nil (defaults to t/built-in)

(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :hook (lsp-mode . lsp-ui-mode))

(provide 'lsp-go)
