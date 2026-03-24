;;; my-minibuffer.el --- Minibuffer configuration -*- lexical-binding: t; -*-

(eval-when-compile
  (require 'straight nil t)
  (require 'use-package nil t))

;; Vertico: Vertical minibuffer completion
(use-package vertico
  :straight t
  :demand t
  :init
  (vertico-mode))

;; Orderless: Fuzzy completion style
(use-package orderless
  :straight t
  :after vertico
  :custom
  (completion-styles '(orderless basic)))

;; Marginalia: Add annotations to minibuffer commands
(use-package marginalia
  :straight t
  :after vertico
  :init
  (marginalia-mode)
  :custom
  (marginalia-align 'left))

;; Improve directory navigation
(with-eval-after-load 'vertico
  (define-key vertico-map (kbd "RET") #'vertico-directory-enter)
  (define-key vertico-map (kbd "DEL") #'vertico-directory-delete-word)
  (define-key vertico-map (kbd "M-d") #'vertico-directory-delete-char))

;; Consult: Enhanced minibuffer commands with fuzzy finding
(use-package consult
  :straight t
  :bind (("C-x b" . consult-buffer)
         ("M-s l" . consult-line)
         ("M-s r" . consult-ripgrep)))

;; Project.el keybindings (C-x p is a prefix, so we use C-x p f, etc.)
(with-eval-after-load 'project
  (define-key project-prefix-map "f" 'project-find-file)
  (define-key project-prefix-map "b" 'consult-project-buffer))

(provide 'my-minibuffer)
;;; my-minibuffer.el ends here
