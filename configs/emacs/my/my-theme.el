(use-package doom-themes
  :straight t
  :config
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one-light t)
  (doom-themes-visual-bell-config) ; Enable flashing mode-line on errors
  (doom-themes-neotree-config) ; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-org-config)) ; Corrects (and improves) org-mode's native fontification.

(provide 'my-theme)
