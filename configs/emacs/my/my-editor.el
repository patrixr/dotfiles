;; Automatically reload files when they change on disk

(global-auto-revert-mode t)

(setq backup-directory-alist            '((".*" . "~/.Trash")))

;; Automatic whitespace trimming

(use-package ws-butler
  :straight t
  :hook (prog-mode . ws-butler-mode))

(use-package add-node-modules-path
  :straight (add-node-modules-path :type git :host github :repo "codesuki/add-node-modules-path"))

;; Highlighted current line

(global-hl-line-mode 1)

;; Prettier

(setq prettier-js-args
      '(
        "--print-width" "120"
        "--single-quote"
        "--tab-width" "2"
        "--trailing-comma" "all"
        "--bracket-spacing" "false"))

(use-package prettier-js
  :straight t
  :init
  (add-hook 'typescript-mode-hook 'prettier-js-mode)
  (add-hook 'js2-mode-hook 'prettier-js-mode)
  (add-hook 'web-mode-hook 'prettier-js-mode))

(eval-after-load 'js-mode
  '(add-hook 'js-mode-hook #'add-node-modules-path))

(eval-after-load 'typescript-mode
  '(add-hook 'typescript-mode-hook #'add-node-modules-path))

(provide 'my-editor)
