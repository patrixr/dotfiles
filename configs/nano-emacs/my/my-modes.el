;; Language list
(use-package go-mode :straight t)
(use-package json-mode :straight t)
(use-package lua-mode :straight t)
(use-package rust-mode :straight t)
(use-package typescript-mode :straight t)
(use-package yaml-mode :straight t)
(use-package markdown-mode :straight t)

(setq-default major-mode
              (lambda () ; guess major mode from file name
                (unless buffer-file-name
                  (let ((buffer-file-name (buffer-name)))
                    (set-auto-mode)))))

(setq-default tab-width 2)
(setq-default typescript-indent-level 2)
(setq-default yaml-indent-offset 2)

(provide 'my-modes)
