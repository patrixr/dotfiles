;; Automatic whitespace trimming

(use-package ws-butler
  :straight t
  :hook (prog-mode . ws-butler-mode))

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
  (add-hook 'js2-mode-hook 'prettier-js-mode)
  (add-hook 'web-mode-hook 'prettier-js-mode))

(provide 'my-editor)
