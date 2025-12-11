(use-package vterm
  :ensure t
  :bind ("C-c t" . vterm-toggle-in-current-directory)
  :config
  (defun vterm-toggle-in-current-directory ()
    "Toggle vterm buffer in current file's directory."
    (interactive)
    (let ((vterm-buffer-name (format "*vterm-%s*" default-directory)))
      (if (get-buffer vterm-buffer-name)
          (if (eq (current-buffer) (get-buffer vterm-buffer-name))
              (bury-buffer)
            (switch-to-buffer vterm-buffer-name))
        (let ((default-directory (if buffer-file-name
                                     (file-name-directory buffer-file-name)
                                   default-directory)))
          (vterm vterm-buffer-name))))))

(provide 'vterm-config)
