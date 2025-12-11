;; ============================
;; GLOBAL LSP CONFIG
;; ============================

(require 'cl-lib)

;; ============================
;; Full Documentation Toggle
;; ============================

(defun my/lsp-describe-toggle ()
  "Toggle LSP help window for symbol at point.
If a help buffer is visible, close its window.
Otherwise, show full LSP documentation for the symbol at point."
  (interactive)
  (let ((help-win
         (cl-find-if
          (lambda (w)
            (with-current-buffer (window-buffer w)
              (derived-mode-p 'help-mode)))
          (window-list))))
    (if help-win
        (delete-window help-win)
      (lsp-describe-thing-at-point))))

;; ============================
;; GLOBAL COMPLETION (manual only)
;; ============================

(use-package corfu
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto nil)
  (corfu-preview-current nil)
  (corfu-quit-no-match t)
  (corfu-quit-at-boundary t)
  (corfu-min-width 20))

(setq lsp-completion-provider :capf)
(setq lsp-company-backends nil)

(use-package orderless
  :custom
  (completion-styles '(orderless basic)))

;; ============================
;; LSP MODE
;; ============================

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :custom
  (lsp-use-plists t)
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-enable-symbol-highlighting nil)
  (lsp-enable-on-type-formatting nil)
  (lsp-completion-provider :capf)
  (lsp-signature-auto-activate nil)
  (lsp-modeline-code-actions-enable nil)
  (lsp-ui-sideline-enable nil)
  (lsp-idle-delay 0.3)
  :init
  (setq lsp-keymap-prefix "C-c l"))

;; ============================
;; Disable go-mode default bindings
;; ============================

(with-eval-after-load 'go-mode
  ;; Remove go-mode’s default K binding in both vanilla + evil
  (define-key go-mode-map (kbd "K") nil)
  (with-eval-after-load 'evil
    (evil-define-key 'normal go-mode-map (kbd "K") nil)))

;; ============================
;; Evil Keybindings for LSP
;; ============================

(with-eval-after-load 'lsp-mode
  (with-eval-after-load 'evil
    ;; Navigation
    (evil-define-key 'normal lsp-mode-map
      (kbd "gd") #'lsp-find-definition
      (kbd "gD") #'lsp-find-declaration
      (kbd "gi") #'lsp-find-implementation
      (kbd "go") #'lsp-find-type-definition
      (kbd "gr") #'lsp-find-references

      ;; Rename
      (kbd "gR") #'lsp-rename

      ;; Code actions
      (kbd "ga") #'lsp-execute-code-action

      ;; Format buffer
      (kbd "g=") #'lsp-format-buffer)

    ;; Documentation toggle (your K key)
    (define-key evil-normal-state-map (kbd "K") #'my/lsp-describe-toggle)))

;; ============================
;; Insert Mode Bindings
;; ============================

(with-eval-after-load 'evil
  ;; Manual LSP signature help
  (define-key evil-insert-state-map (kbd "C-S-y") #'lsp-signature-activate)

  ;; Manual completion trigger
  (define-key evil-insert-state-map (kbd "C-y") #'completion-at-point)

  ;; Ensure K does NOTHING in insert mode
  (define-key evil-insert-state-map (kbd "K") nil))

(provide 'lsp-config)
