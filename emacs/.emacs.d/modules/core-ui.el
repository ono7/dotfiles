;; Minimal UI
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(set-fringe-mode 4)
(tooltip-mode -1)

(setq inhibit-startup-message t
      ring-bell-function 'ignore
      scroll-conservatively 101)

;; Paren highlight
(setq show-paren-delay 0
      show-paren-style 'parenthesis)
(show-paren-mode 1)

;; Cursor style
(setq-default cursor-type 'box)
(setq x-stretch-cursor t)
(set-cursor-color "#FFD700")
(blink-cursor-mode -1)

;; Disable backup/autosave
(setq make-backup-files nil
      auto-save-default nil
      create-lockfiles nil)

(provide 'core-ui)
