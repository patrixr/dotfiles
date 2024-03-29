(use-package copilot
  :straight (:host github :repo "copilot-emacs/copilot.el" :files ("dist" "*.el"))
  :ensure t
  :hook
  (prog-mode . copilot-mode)
  (copilot-mode . (lambda ()
                    (setq-local copilot--indent-warning-printed-p t))))

(defun my/copilot-tab ()
	"Tab command that will complet with copilot if a completion is
available. Otherwise will try company, yasnippet or normal
tab-indent."
	(interactive)
	(or (copilot-accept-completion)
			(company-yasnippet-or-completion)
			(indent-for-tab-command)))

(define-key global-map (kbd "C-x RET") #'my/copilot-tab)

(provide 'my-copilot)
