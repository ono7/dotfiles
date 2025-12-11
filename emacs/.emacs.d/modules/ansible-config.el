(use-package ansible
  :hook (yaml-mode . ansible)
  :config
  (setq ansible::get-become-pass nil))

(use-package ansible-doc
  :after ansible
  :hook (ansible . ansible-doc-enable))

(use-package ansible-vault
  :after ansible
  :commands (ansible-vault-mode))

(provide 'ansible-config)
