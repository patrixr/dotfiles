;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(unpin! nim-mode flycheck-nim)

(package! terraform-mode)
(package! prettier-js)
(package! feature-mode) ;; cucumber support
(package! deno-fmt)
(package! simpleclip
  :recipe (:host github :repo "rolandwalker/simpleclip"))
(package! beacon
  :recipe (:host github :repo "malabarba/beacon"))
