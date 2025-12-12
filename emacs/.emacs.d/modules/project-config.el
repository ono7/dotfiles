(use-package projectile
  :init (projectile-mode +1)
  :config
  (setq projectile-enable-caching t
        projectile-indexing-method 'alien
        projectile-sort-order 'recently-active))

(setq xref-search-program 'ripgrep)

;; Leader key (SPACE)
(define-prefix-command 'my-leader-map)

;; TODO(jlima): maybe this should be moved to evil-config.lel
(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "SPC") 'my-leader-map)
  (define-key evil-motion-state-map (kbd "SPC") 'my-leader-map))

(define-key my-leader-map (kbd "p") #'projectile-command-map)
(define-key my-leader-map (kbd "f") #'projectile-find-file)
(define-key my-leader-map (kbd "/") #'projectile-ripgrep)
(define-key my-leader-map (kbd "b") #'switch-to-buffer)
(define-key my-leader-map (kbd ".") #'find-file)

;; select entire buffer
(define-key my-leader-map (kbd "a") #'my/evil-select-all)

(provide 'project-config)
