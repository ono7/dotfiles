(use-package vertico
  :init (vertico-mode)
  :custom (vertico-cycle t))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides
        '((file (styles . (partial-path orderless))))))

(use-package consult
  :bind (("C-x b" . consult-buffer)
         ("C-x C-r" . consult-recent-file)))

(use-package consult-dir
  :after consult
  :bind (("C-x C-f" . consult-dir)))

(use-package marginalia
  :init (marginalia-mode))

;; workaround for partial-path issue
(setq completion-category-overrides
      '((file (styles . (orderless)))))

(provide 'completion-config)
