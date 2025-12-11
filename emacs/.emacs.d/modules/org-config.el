(require 'org)
(use-package org
  :straight nil
  :mode ("\\.org\\'" . org-mode)
  :config
  (setq org-directory "~/org"
        org-default-notes-file (concat org-directory "/notes.org")))

(provide 'org-config)
