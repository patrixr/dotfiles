;;; Personal configuration -*- lexical-binding: t -*-

;; Save the contents of this file under ~/.emacs.d/init.el
;; Do not forget to use Emacs' built-in help system:
;; Use C-h C-h to get an overview of all help commands.  All you
;; need to know about Emacs (what commands exist, what functions do,
;; what variables specify), the help system can provide.

;; ----------------------------------------------
;; PACKAGE MANAGER
;; ----------------------------------------------

(setq quelpa-update-melpa-p nil)
(setq quelpa-upgrade-interval 7)
(setq use-package-always-ensure t)

(add-hook #'after-init-hook #'quelpa-upgrade-all-maybe)

;; Bootstrap quelpa
(unless (package-installed-p 'quelpa)
  (with-temp-buffer
    (url-insert-file-contents "https://raw.githubusercontent.com/quelpa/quelpa/master/quelpa.el")
    (eval-buffer)
    (quelpa-self-upgrade)))

(quelpa '(quelpa-use-package
   :fetcher git
   :url "https://github.com/quelpa/quelpa-use-package.git"))

(require 'quelpa-use-package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

; activate all the packages
(package-initialize)

; fetch the list of packages available 
(unless package-archive-contents
    (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
    (package-install 'use-package))

(use-package emacs
  :config
  (setq tab-always-indent 'complete))

(use-package auto-package-update
  :ensure t
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-prompt-before-update t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe)
    (auto-package-update-at-time "09:00"))

(use-package no-littering)
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

;; ----------------------------------------------
;; NEOTREE
;; ----------------------------------------------

(setq neo-window-width 35)
(setq-default neo-show-hidden-files t)
(use-package neotree)

;; ----------------------------------------------
;; MINIBUFFER
;; ----------------------------------------------

;; Enable vertico
(use-package vertico
  :ensure t
  :init
  (vertico-mode))

;; Add annotations to vertico minibuffer commands
(use-package marginalia
  :after vertico
  :ensure t
  :init
  (marginalia-mode)
  :custom
  (marginalia-align 'left))

;; Improve directory navigation
(with-eval-after-load 'vexrtico
  (define-key vertico-map (kbd "RET") #'vertico-directory-enter)
  (define-key vertico-map (kbd "DEL") #'vertico-directory-delete-word)
  (define-key vertico-map (kbd "M-d") #'vertico-directory-delete-char))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

(use-package orderless
  :ensure t
  :after vertico
  :custom
  (completion-styles '(orderless basic)))

;; ----------------------------------------------
;; FORMATTING
;; ----------------------------------------------

(use-package prettier-js
  :commands (prettier-mode prettier)
  :init
	(add-hook 'js2-mode-hook 'prettier-js-mode)
	(add-hook 'web-mode-hook 'prettier-js-mode)
	(add-hook 'typescript-mode-hook 'prettier-js-mode)
  :config (setq prettier-target-mode "js2-mode"))

;; ----------------------------------------------
;; LSP
;; ----------------------------------------------

(use-package eglot
  :ensure t
  :config

  (add-to-list 'eglot-server-programs '(typescript-mode . ("typescript-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs '((js-mode typescript-mode) . (eglot-deno "deno" "lsp")))

  (defclass eglot-deno (eglot-lsp-server) ()
    :documentation "A custom class for deno lsp.")

  (cl-defmethod eglot-initialization-options ((server eglot-deno))
    "Passes through required deno initialization options"
    (list :enable t
    :lint t)))


;; Enabled inline static analysis
(add-hook 'prog-mode-hook #'flymake-mode)
(add-hook 'typescript-mode-hook 'eglot-ensure)

;; Display messages when idle, without prompting
(setq help-at-pt-display-when-idle t)

;; Language list
(use-package go-mode)
(use-package json-mode)
(use-package lua-mode)
(use-package rust-mode)
(use-package typescript-mode)
(use-package yaml-mode)
(use-package markdown-mode)

;; Miscellaneous options
(setq-default major-mode
              (lambda () ; guess major mode from file name
                (unless buffer-file-name
                  (let ((buffer-file-name (buffer-name)))
                    (set-auto-mode)))))

(setq window-resize-pixelwise t)
(setq frame-resize-pixelwise t)
(save-place-mode t)
(savehist-mode t)
(recentf-mode t)

;; Store automatic customisation options elsewhere
(setq custom-file (locate-user-emacs-file "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

(use-package tempel
  ;; Require trigger prefix before template name when completing.
  ;; :custom
  ;; (tempel-trigger-prefix "<")

  :bind (("M-+" . tempel-complete) ;; Alternative tempel-expand
         ("M-*" . tempel-insert))

  :init

  ;; Setup completion at point
  (defun tempel-setup-capf ()
    ;; Add the Tempel Capf to `completion-at-point-functions'.
    ;; `tempel-expand' only triggers on exact matches. Alternatively use
    ;; `tempel-complete' if you want to see all matches, but then you
    ;; should also configure `tempel-trigger-prefix', such that Tempel
    ;; does not trigger too often when you don't expect it. NOTE: We add
    ;; `tempel-expand' *before* the main programming mode Capf, such
    ;; that it will be tried first.
    (setq-local completion-at-point-functions
                (cons #'tempel-expand
                      completion-at-point-functions)))

  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf)

  ;; Optionally make the Tempel templates available to Abbrev,
  ;; either locally or globally. `expand-abbrev' is bound to C-x '.
  ;; (add-hook 'prog-mode-hook #'tempel-abbrev-mode)
  ;; (global-tempel-abbrev-mode)
  )

;; ----------------------------------------------
;; COMPLETION
;; ----------------------------------------------

(use-package consult)

(setq read-buffer-completion-ignore-case t
      read-file-name-completion-ignore-case t
      completion-ignore-case t)

;;; Pop-up completion
(use-package corfu
  :init
  (global-corfu-mode)
	(corfu-echo-mode)
  :after (tempel)
  :hook ((prog-mode . corfu-mode)
         (shell-mode . corfu-mode)
         (eshell-mode . corfu-mode))
  :bind
  (:map corfu-map
        ("TAB" . corfu-next)
        ([tab] . corfu-next)
        ("S-TAB" . corfu-previous)
        ([backtab] . corfu-previous))
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  (corfu-separator ?\s)          ;; Orderless field separator
  (corfu-quit-no-match 'separator) ; Don't quit if there is `corfu-separator' inserted
  (corfu-echo-documentation 0.25) ;; Documentation in the echo area
  (corfu-scroll-margin 4)
	(corfu-preselect 'prompt)
  
  :config
  (define-key corfu-map (kbd "<tab>") #'corfu-complete))

(use-package corfu-terminal
  :config
  (unless (display-graphic-p)
    (corfu-terminal-mode +1)))

; Add extensions
(use-package cape
  ;; Bind dedicated completion commands
  ;; Alternative prefix keys: C-c p, M-p, M-+, ...
  :bind (("C-c p p" . completion-at-point) ;; capf
         ("C-c p t" . complete-tag)        ;; etags
         ("C-c p d" . cape-dabbrev)        ;; or dabbrev-completion
         ("C-c p h" . cape-history)
         ("C-c p f" . cape-file)
         ("C-c p k" . cape-keyword)
         ("C-c p s" . cape-elisp-symbol)
         ("C-c p e" . cape-elisp-block)
         ("C-c p a" . cape-abbrev)
         ("C-c p l" . cape-line)
         ("C-c p w" . cape-dict)
         ("C-c p :" . cape-emoji)
         ("C-c p \\" . cape-tex)
         ("C-c p _" . cape-tex)
         ("C-c p ^" . cape-tex)
         ("C-c p &" . cape-sgml)
         ("C-c p r" . cape-rfc1345))
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.  The order of the functions matters, the
  ;; first function returning a result wins.  Note that the list of buffer-local
  ;; completion functions takes precedence over the global list.
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  (add-to-list 'completion-at-point-functions #'eglot-completion-at-point)
)

;; ----------------------------------------------
;; EDITING
;; ----------------------------------------------

(setq-default tab-width 2)
(setq-default typescript-indent-level 2)

(use-package simpleclip
  :quelpa (simpleclip :fetcher github :repo "rolandwalker/simpleclip")
  :init
  (simpleclip-mode 1))

(use-package multiple-cursors
  :ensure t
  :diminish
  :bind (
         ("S-M-<down>" . mc/mark-next-like-this)
         ("S-M-<up>" . mc/mark-previous-like-this)
         ("M-C-z" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)
         ("C-S-c C-S-c" . mc/mark-edit-lines)
         ))


(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(global-hl-line-mode 1)     ; Highlight current line
(menu-bar-mode -1)          ; Disable the menu bar

(setq visible-bell t)       ; Set up the visible bell

;; Disable splash screen
(setq inhibit-startup-screen t)

(defun move-line (n)
  "Move the current line up or down by N lines."
  (interactive "p")
  (setq col (current-column))
  (beginning-of-line) (setq start (point))
  (end-of-line) (forward-char) (setq end (point))
  (let ((line-text (delete-and-extract-region start end)))
    (forward-line n)
    (insert line-text)
    ;; restore point to original column in moved line
    (forward-line -1)
    (forward-char col)))

(defun move-line-up (n)
  "Move the current line up by N lines."
  (interactive "p")
  (move-line (if (null n) -1 (- n))))

(defun move-line-down (n)
  "Move the current line down by N lines."
  (interactive "p")
  (move-line (if (null n) 1 n)))

(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)

;; ----------------------------------------------
;; THEME
;; ----------------------------------------------

(use-package all-the-icons)

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled

  (load-theme 'doom-horizon t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package doom-modeline
  :init
  (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 15))

;; ----------------------------------------------
;; PROJECTILE
;; ----------------------------------------------

(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map)))


(define-key global-map (kbd "M-p") 'project-find-file)
(projectile-register-project-type 'npm '("package-lock.json")
                                  :project-file "package.json"
				  :compile "npm install"
				  :test "npm test"
				  :run "npm start"
				  :test-suffix ".test")

(projectile-register-project-type 'pnpm '("pnpm-lock.json")
                                  :project-file "package.json"
				  :compile "pnpm install"
				  :test "pnpm test"
				  :run "pnpm start"
				  :test-suffix ".test")

(projectile-register-project-type 'deno '("deno.json")
                                  :project-file "deno.json"
				  :compile "deno compile"
				  :test "deno test"
				  :run "deno run --allow-all"
				  :test-suffix ".test")

(projectile-register-project-type 'maven '("pom.xml")
                                  :project-file "pom.xml"
                                  :compile "mvn install"
                                  :test "mvn test"
                                  :run "mvn spring-boot:run"
                                  :test-suffix "Test")


;; ----------------------------------------------
;; GENERATED BLOCK
;; ----------------------------------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(projectile doom-themes no-littering auto-package-update)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
