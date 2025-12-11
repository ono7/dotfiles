(use-package ansible
  :hook (yaml-mode . ansible))

(use-package ansible-doc
  :after ansible
  :hook (ansible . ansible-doc-mode))  ;; Changed from ansible-doc-enable

(use-package ansible-vault
  :after ansible
  :commands (ansible-vault-mode))

(provide 'ansible-config)
