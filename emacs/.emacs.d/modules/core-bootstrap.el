;; Straight Bootstrap -*- lexical-binding: t; -*-
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el"
                         user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

(defun my-format-elisp-on-save ()
  "Indent the entire buffer before saving if in Emacs Lisp mode."
  (when (eq major-mode 'emacs-lisp-mode)
    (indent-region (point-min) (point-max) nil)))

;; auto format lisp files
(add-hook 'before-save-hook #'my-format-elisp-on-save)

(provide 'core-bootstrap)
