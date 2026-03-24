;;; my-modes.el --- Major modes configuration -*- lexical-binding: t; -*-

(eval-when-compile
  (require 'straight nil t)
  (require 'use-package nil t))

(use-package json-mode :straight t)
(use-package lua-mode :straight t)
(use-package ruby-mode :straight t)
(use-package rust-mode :straight t)
(use-package python-mode :straight t)
(use-package yaml-mode :straight t)
(use-package typescript-mode
  :straight t
  :mode (("\\.ts\\'" . typescript-mode)
         ("\\.tsx\\'" . typescript-mode)))
(use-package
  nushell-mode
  :straight (nushell-mode :type git :host github :repo "mrkkrp/nushell-mode"))
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

(setq-default major-mode
              (lambda () ; guess major mode from file name
                (unless buffer-file-name
                  (let ((buffer-file-name (buffer-name)))
                    (set-auto-mode)))))

(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)
(setq-default typescript-indent-level 2)
(setq-default js-indent-level 2)
(setq-default yaml-indent-offset 2)

(provide 'my-modes)
;;; my-modes.el ends here
