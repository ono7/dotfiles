;; macOS PATH fix
(use-package exec-path-from-shell
  :init
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

;; macOS frame tweaks
(when (eq system-type 'darwin)
  (setq default-frame-alist
        '((ns-appearance . dark)
          (ns-transparent-titlebar . t))))

(setq mac-mouse-wheel-smooth-scroll nil)

(setq native-comp-async-report-warnings-errors nil)

(when (eq system-type 'darwin)
  (customize-set-variable 'native-comp-driver-options '("-Wl,-w")))

(provide 'core-osx)
