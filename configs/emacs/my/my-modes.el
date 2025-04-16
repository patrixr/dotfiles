;; Language list

(use-package treesit-auto
  :straight t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package json-mode :straight t)
(use-package lua-mode :straight t)
(use-package ruby-mode :straight t)
(use-package rust-mode :straight t)
(use-package python-mode :straight t)
(use-package yaml-mode :straight t)
(use-package typescript-ts-mode
  :mode (("\\.ts\\'" . typescript-ts-mode)
         ("\\.tsx\\'" . tsx-ts-mode)))
(use-package clojure-mode :straight t)
(use-package cider :straight t)
(use-package kotlin-mode :straight t)
(use-package go-mode :straight t)
(use-package markdown-mode
  :straight t
  :config
  (setq markdown-fontify-code-blocks-natively t)
  (add-to-list 'markdown-code-lang-modes '("js" . typescript-mode))
  (custom-set-faces
   '(markdown-code-face ((t (:inherit font-lock-constant-face :background nil))))))

(defun my-go-mode-hook ()
  (add-hook 'before-save-hook 'gofmt-before-save)
  (local-set-key (kbd "M-.") 'godef-jump)
)
(add-hook 'go-mode-hook 'my-go-mode-hook)

(setq-default major-mode
              (lambda () ; guess major mode from file name
                (unless buffer-file-name
                  (let ((buffer-file-name (buffer-name)))
                    (set-auto-mode)))))

(setq-default tab-width 2)
(setq-default typescript-indent-level 2)
(setq-default js-indent-level 2)
(setq-default yaml-indent-offset 2)

(provide 'my-modes)
