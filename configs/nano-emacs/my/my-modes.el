;; Language list
(use-package go-mode)
(use-package json-mode)
(use-package lua-mode)
(use-package rust-mode)
(use-package typescript-mode)
(use-package yaml-mode)
(use-package markdown-mode)

(setq-default major-mode
              (lambda () ; guess major mode from file name
                (unless buffer-file-name
                  (let ((buffer-file-name (buffer-name)))
                    (set-auto-mode)))))

(setq-default tab-width 2)
(setq-default typescript-indent-level 2)
(setq-default yaml-indent-offset 2)

(provide 'my-modes)
