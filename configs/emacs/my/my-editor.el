;; Automatic whitespace trimming

(use-package ws-butler
  :straight t
  :hook (prog-mode . ws-butler-mode))

;; Highlighted current line

(global-hl-line-mode 1)

(provide 'my-editor)
