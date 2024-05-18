(use-package multiple-cursors
  :ensure t
  :diminish
  :bind (
         ("S-M-<down>" . mc/mark-next-like-this)
         ("S-M-<up>" . mc/mark-previous-like-this)
         ("M-C-z" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)
         ("C-S-c C-S-c" . mc/mark-edit-lines)))

(provide 'my-bindings)
