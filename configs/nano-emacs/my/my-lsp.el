(use-package lsp-mode
  :straight t
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (
         (python-mode . lsp)
         (go-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration)))

(use-package lsp-ui
  :straight t
  :commands lsp-ui-mode)

(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode))

(provide 'my-lsp)
