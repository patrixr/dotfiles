;;; my-editor.el --- Editor enhancements -*- lexical-binding: t; -*-

(eval-when-compile
  (require 'straight nil t)
  (require 'use-package nil t))

;;; Editor Configuration

;; Ensure syntax highlighting is always enabled
(global-font-lock-mode 1)

;; Temporarily disabled to debug syntax highlighting issues
;;
;; ;; Apheleia: Asynchronous code formatting without cursor disruption
;; (use-package apheleia
;;   :straight t
;;   :commands apheleia-mode
;;   :hook ((typescript-mode . apheleia-mode)
;;          (js-mode . apheleia-mode)
;;          (json-mode . apheleia-mode))
;;   :config
;;   ;; Apheleia automatically formats on save when apheleia-mode is enabled
;;   ;; It uses prettier for TypeScript/JavaScript by default
;;   ;; Ensure prettier is installed: npm install -g prettier
;;   (setf (alist-get 'prettier apheleia-formatters)
;;         '("prettier" "--stdin-filepath" filepath)))
;;
;; ;; Stripspace: Automatic removal of trailing whitespace on save
;; (use-package stripspace
;;   :straight t
;;   :commands stripspace-local-mode
;;   :hook ((prog-mode . stripspace-local-mode)
;;          (text-mode . stripspace-local-mode)
;;          (conf-mode . stripspace-local-mode))
;;   :custom
;;   ;; Always delete trailing whitespace
;;   (stripspace-only-if-initially-clean nil)
;;   ;; Preserve cursor column position after stripping spaces
;;   (stripspace-restore-column t))

(provide 'my-editor)
;;; my-editor.el ends here
