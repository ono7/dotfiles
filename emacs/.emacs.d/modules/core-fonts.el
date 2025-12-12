;; Fonts

;; Add line spacing for better readability
(setq line-spacing 5)

;; iosevka!!
(set-face-attribute 'default nil :family "Iosevka Custom" :height 240)
(set-face-attribute 'bold nil :family "Iosevka Custom" :weight 'bold)
(set-face-attribute 'italic nil :family "Iosevka Custom" :slant 'italic)
(set-face-attribute 'bold-italic nil :family "Iosevka Custom"
                    :weight 'bold :slant 'italic)

(with-eval-after-load 'markdown-mode
  (set-face-attribute 'markdown-code-face nil
                      :inherit 'default
                      :family "Iosevka Custom")
  (set-face-attribute 'markdown-pre-face nil
                      :inherit 'default
                      :family "Iosevka Custom")
  (set-face-attribute 'markdown-inline-code-face nil
                      :inherit 'default
                      :family "Iosevka Custom"))


(provide 'core-fonts)
