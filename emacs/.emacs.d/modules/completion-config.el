;; ==============================
;; COMPLETION: Vertico + Orderless
;; ==============================
(use-package vertico
  :init (vertico-mode)
  :config
  (setq vertico-cycle t))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        orderless-matching-styles '(orderless-flex)))

(use-package consult
  :bind (("C-x b" . consult-buffer)
         ("C-x C-r" . consult-recent-file)))

(use-package marginalia
  :init (marginalia-mode))

;; ==============================
;; PROJECTS: Make Projectile obey orderless
;; ==============================
(use-package projectile
  :init (projectile-mode)
  :config
  (setq projectile-enable-caching t
        projectile-indexing-method 'alien
        projectile-sort-order 'recently-active
        projectile-completion-system 'default))

(provide 'completion-config)
