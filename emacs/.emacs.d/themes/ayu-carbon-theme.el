(deftheme ayu-carbon "Ayu Carbon — aligned with Neovim ayu-dark overrides, Visual/Search reverted")

(let ((fg      "#BEBEBC")
      (bg      "#151F2D")
      ;; ORIGINAL VISUAL + SEARCH VALUES
      (visual  "#223E65")
      (search-bg "#3A6FB0")
      (search-fg "#FFFFFF")

      (cursorl "#1E2E45")
      (line-nr "#3A4555")
      (comment "#5F6C77")
      (string  "#8CA64A")
      (special "#D89F5C")
      (type    "#7AA7D8")
      (func    "#AABFD9")
      (nontext "#5A6B85")
      (err     "#D35A63")
      (warn    "#D89F5C"))

  (custom-theme-set-faces
   'ayu-carbon

   ;; === Core UI ===
   `(default                   ((t (:foreground ,fg :background ,bg))))
   `(cursor                    ((t (:background "#FF69B4")))) ;; hot-pink override
   `(region                    ((t (:background ,visual))))
   `(hl-line                   ((t (:background ,cursorl))))
   `(line-number               ((t (:foreground ,line-nr :background ,bg))))
   `(line-number-current-line  ((t (:foreground "yellow" :background ,bg))))
   `(vertical-border           ((t (:foreground ,bg))))
   `(fringe                    ((t (:background ,bg))))

   ;; Non-text items (Neovim "EndOfBuffer" mapping)
   `(shadow                    ((t (:foreground ,nontext))))

   ;; === Paren Matching (keep original) ===
   `(show-paren-match
     ((t (:foreground ,bg :background "#AABFD9" :weight bold))))
   `(show-paren-mismatch
     ((t (:foreground ,bg :background ,err))))

   ;; === Search (keep your original Emacs style) ===
   `(isearch        ((t (:foreground ,search-fg :background ,search-bg))))
   `(lazy-highlight ((t (:foreground ,search-fg :background ,search-bg))))

   ;; === Popup Menu (Company) ===
   `(company-tooltip
     ((t (:background "#1D2738" :foreground ,fg))))
   `(company-tooltip-selection
     ((t (:background ,search-bg :foreground ,search-fg))))

   ;; === Messages ===
   `(error   ((t (:foreground ,err))))
   `(warning ((t (:foreground ,warn))))
   `(success ((t (:foreground "#AAD94C"))))

   ;; === Syntax ===
   `(font-lock-comment-face        ((t (:foreground ,comment :slant italic))))
   `(font-lock-string-face         ((t (:foreground ,string))))
   `(font-lock-constant-face       ((t (:foreground ,fg))))   ;; neutralized
   `(font-lock-function-name-face  ((t (:foreground ,func))))
   `(font-lock-keyword-face        ((t (:foreground ,special :weight bold))))
   `(font-lock-type-face           ((t (:foreground ,type))))
   `(font-lock-variable-name-face  ((t (:foreground ,fg))))   ;; neutral
   `(font-lock-preprocessor-face   ((t (:foreground ,fg))))
   `(font-lock-builtin-face        ((t (:foreground ,fg))))
   `(font-lock-punctuation-face    ((t (:foreground ,fg))))
   `(font-lock-operator-face       ((t (:foreground ,fg))))

   ;; === Diff (mapped from Neovim) ===
   `(diff-added      ((t (:foreground ,fg :background "#1C2E2E"))))
   `(diff-changed    ((t (:background "#2A3245" :foreground ,fg))))
   `(diff-removed    ((t (:foreground ,err :background ,bg))))
   `(diff-refine-added   ((t (:background "#1C2E2E" :weight bold))))
   `(diff-refine-removed ((t (:background "#2A1E1E" :weight bold))))
   ))

(provide-theme 'ayu-carbon)
