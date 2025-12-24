;;; theme-config.el --- Visual Configuration -*- lexical-binding: t; -*-

(add-to-list 'custom-theme-load-path
             (expand-file-name "themes" user-emacs-directory))

(load-theme 'ayu-carbon t)

(provide 'theme-config)
