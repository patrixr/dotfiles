(use-package flycheck
  :straight t
  :init (global-flycheck-mode))

(use-package lsp-mode
  :straight (lsp-mode
    :host github
    :repo "emacs-lsp/lsp-mode"
    :branch "master")
  :init
  (setq lsp-keymap-prefix "C-c l")
  (setq lsp-headerline-breadcrumb-enable nil)
  :hook (
         (ruby-mode . lsp)
         (python-mode . lsp)
         (lua-mode . lsp)
         (go-mode . lsp)
         (clojure-mode . lsp)
         (kotlin-mode . lsp)
         (typescript-mode . lsp)
         ;; Prefer deno for typescript by disabling ts-ls
         ;;(typescript-mode . (lambda ()
		     ;;	                  (setq lsp-disabled-clients '(jsts-ls ts-ls))
		     ;;	                  (lsp)))
         (lsp-mode . lsp-enable-which-key-integration)))

(use-package lsp-ui
  :straight t
  :commands lsp-ui-mode)

(use-package company
  :defer 0.1
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode))

(provide 'my-lsp)
