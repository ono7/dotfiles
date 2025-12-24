;; *- lexical-binding: t; -*-
(use-package recentf
  :straight nil
  :init (recentf-mode 1)
  :custom
  (recentf-max-saved-items 200)
  (recentf-max-menu-items 50))

(provide 'core-editing)
;; removed extra lines of configuration related to evil mode
