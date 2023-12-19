;; Vertical minibuffer
(use-package vertico
  :straight t
  :init
  (vertico-mode))

(use-package orderless
  :straight t
  :after vertico
  :custom
  (completion-styles '(orderless basic)))

;; Add annotations to vertico minibuffer commands
(use-package marginalia
  :after vertico
  :ensure t
  :init
  (marginalia-mode)
  :custom
  (marginalia-align 'left))

;; Improve directory navigation
(with-eval-after-load 'vertico
  (define-key vertico-map (kbd "RET") #'vertico-directory-enter)
  (define-key vertico-map (kbd "DEL") #'vertico-directory-delete-word)
  (define-key vertico-map (kbd "M-d") #'vertico-directory-delete-char))

(provide 'my-minibuffer)
