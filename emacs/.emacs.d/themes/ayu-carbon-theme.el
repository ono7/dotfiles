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
   `(default                 ((t (:foreground ,fg :background ,bg))))
   `(cursor                  ((t (:background "#FF69B4"))))
   `(region                  ((t (:background ,visual))))
   `(ffap                    ((t (:background ,visual))))
   `(highlight               ((t (:background ,visual))))
   `(hl-line                 ((t (:background ,cursorl))))
   `(line-number             ((t (:foreground ,line-nr :background ,bg))))
   `(line-number-current-line ((t (:foreground "yellow" :background ,bg))))
   `(vertical-border         ((t (:foreground ,bg))))
   `(fringe                  ((t (:background ,bg))))

   ;; Non-text items
   `(shadow                  ((t (:foreground ,nontext))))

   ;; === Status Line ===
   `(mode-line
     ((t (:background ,cursorl :foreground ,fg :box (:line-width 1 :color ,cursorl)))))
   
   `(mode-line-inactive
     ((t (:background ,cursorl :foreground ,comment :box (:line-width 1 :color ,cursorl)))))
   
   `(mode-line-highlight
     ((t (:foreground ,special :weight bold))))
   `(mode-line-buffer-id
     ((t (:foreground ,func :weight bold))))
   
   `(mode-line-misc-info
     ((t (:foreground ,fg :background ,visual))))

   ;; === Prompts / Messages ===
   `(minibuffer-prompt         ((t (:foreground ,fg))))
   `(success                   ((t (:foreground ,fg))))
   `(warning                   ((t (:foreground ,fg))))
   `(error                     ((t (:foreground ,err))))

   ;; === LSP highlight cleanup ===
   `(lsp-face-highlight-textual ((t (:foreground ,fg :background nil))))
   `(lsp-face-highlight-read    ((t (:foreground ,fg :background nil))))
   `(lsp-face-highlight-write   ((t (:foreground ,fg :background nil))))

   `(lsp-ui-sideline-code-action      ((t (:foreground ,fg))))
   `(lsp-ui-sideline-current-symbol   ((t (:foreground ,fg))))
   `(lsp-ui-sideline-symbol           ((t (:foreground ,fg))))
   `(lsp-ui-sideline-global           ((t (:foreground ,fg))))

   ;; === Paren Matching ===
   `(show-paren-match
     ((t (:foreground ,bg :background "#AABFD9" :weight bold))))
   `(show-paren-mismatch
     ((t (:foreground ,bg :background ,err))))

   ;; === Search ===
   `(isearch          ((t (:foreground ,search-fg :background ,search-bg))))
   `(lazy-highlight   ((t (:foreground ,search-fg :background ,search-bg))))

   ;; === Company Popup ===
   `(company-tooltip
     ((t (:background "#1D2738" :foreground ,fg))))
   `(company-tooltip-selection
     ((t (:background ,search-bg :foreground ,search-fg))))

   ;; === Syntax ===
   `(font-lock-comment-face         ((t (:foreground ,comment :slant italic))))
   `(font-lock-string-face          ((t (:foreground ,string))))
   `(font-lock-constant-face        ((t (:foreground ,fg))))
   `(font-lock-function-name-face   ((t (:foreground ,func))))
   `(font-lock-keyword-face         ((t (:foreground ,special :weight bold))))
   `(font-lock-type-face            ((t (:foreground ,type))))
   `(font-lock-variable-name-face   ((t (:foreground ,fg))))
   `(font-lock-preprocessor-face    ((t (:foreground ,fg))))
   `(font-lock-builtin-face         ((t (:foreground ,fg))))
   `(font-lock-punctuation-face     ((t (:foreground ,fg))))
   `(font-lock-operator-face        ((t (:foreground ,fg))))

   ;; === Diff ===
   `(diff-added      ((t (:foreground ,fg :background "#1C2E2E"))))
   `(diff-changed    ((t (:background "#2A3245" :foreground ,fg))))
   `(diff-removed    ((t (:foreground ,err :background ,bg))))
   `(diff-refine-added   ((t (:background "#1C2E2E" :weight bold))))
   `(diff-refine-removed ((t (:background "#2A1E1E" :weight bold))))

   ;; === Link face ===
   `(link ((t (:foreground ,fg :underline t))))

   ;; === Tabs (remove literal TAB block highlight) ===
   `(tab ((t (:inherit default :background nil :foreground nil))))
   ))

(provide-theme 'ayu-carbon)
