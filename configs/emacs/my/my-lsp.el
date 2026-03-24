;;; my-lsp.el --- LSP configuration -*- lexical-binding: t; -*-

(eval-when-compile
  (require 'straight nil t)
  (require 'use-package nil t))

;;; Language Server Protocol (LSP) with lsp-mode

;; Helper function to determine if we should use Deno
(defun my-lsp-use-deno-p ()
  "Return t if current project should use Deno LSP."
  (and buffer-file-name
       (locate-dominating-file buffer-file-name "deno.json")))

;; Custom hook to choose between Deno and TypeScript LSP
(defun my-lsp-typescript-hook ()
  "Choose Deno or TypeScript LSP based on project configuration."
  (if (my-lsp-use-deno-p)
      (progn
        (setq-local lsp-enabled-clients '(deno-ls))
        (lsp-deferred))
    (progn
      (setq-local lsp-disabled-clients '(deno-ls))
      (lsp-deferred))))

(use-package lsp-mode
  :straight t
  :commands (lsp lsp-deferred)
  :hook
  ((go-mode . lsp-deferred)
   (go-ts-mode . lsp-deferred)
   (typescript-mode . my-lsp-typescript-hook)
   (typescript-ts-mode . my-lsp-typescript-hook)
   (tsx-ts-mode . my-lsp-typescript-hook)
   (js-mode . my-lsp-typescript-hook)
   (js-ts-mode . my-lsp-typescript-hook)
   (ruby-mode . lsp-deferred)
   (rust-mode . lsp-deferred)
   (rust-ts-mode . lsp-deferred)
   (zig-mode . lsp-deferred)
   (lua-mode . lsp-deferred)
   (clojure-mode . lsp-deferred)
   (python-mode . lsp-deferred)
   (python-ts-mode . lsp-deferred)
   (lsp-mode . lsp-enable-which-key-integration))
  :custom
  ;; Automatically install LSP servers when missing
  (lsp-auto-guess-root t)
  ;; Disable snippets if you don't use them
  (lsp-enable-snippet t)
  ;; Disable headerline breadcrumb for cleaner UI
  (lsp-headerline-breadcrumb-enable nil)
  ;; Auto-install missing LSP servers
  (lsp-enable-suggest-server-download t)
  ;; Performance tuning
  (lsp-idle-delay 0.5)
  (lsp-log-io nil)
  ;; Better completion
  (lsp-completion-provider :capf)
  ;; Lens (code actions, references count, etc.)
  (lsp-lens-enable t)
  ;; Signature help
  (lsp-signature-auto-activate t)
  (lsp-signature-render-documentation t)
  :config
  ;; Set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)

  ;; Disable Deno by default (only enable in projects with deno.json)
  (setq lsp-disabled-clients '(deno-ls)))

(use-package lsp-ui
  :straight t
  :commands lsp-ui-mode
  :after lsp-mode
  :custom
  ;; Sideline (inline diagnostics and code actions)
  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-show-hover nil)
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-show-code-actions nil)
  ;; Peek (definitions, references, etc.)
  (lsp-ui-peek-enable t)
  (lsp-ui-peek-always-show t)
  ;; Doc (documentation popup)
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-doc-delay 0.5)
  :bind
  (:map lsp-ui-mode-map
        ("C-c d" . lsp-ui-doc-show)
        ("C-c i" . lsp-ui-peek-find-implementation)
        ("C-c r" . lsp-ui-peek-find-references)))

;; Note: Company completion for LSP is configured in my-completions.el

;; Language-specific LSP server installation:
;;
;; lsp-mode will prompt you to install servers automatically, or you can
;; install them manually:
;;
;; Go:         M-x lsp-install-server RET gopls
;; TypeScript: M-x lsp-install-server RET ts-ls
;; JavaScript: M-x lsp-install-server RET ts-ls
;; Ruby:       M-x lsp-install-server RET solargraph (or install: gem install solargraph)
;; Rust:       M-x lsp-install-server RET rust-analyzer
;; Zig:        M-x lsp-install-server RET zls
;; Lua:        M-x lsp-install-server RET lua-language-server
;; Clojure:    M-x lsp-install-server RET clojure-lsp
;; Python:     M-x lsp-install-server RET pylsp (or mspyls for Microsoft's server)
;;
;; When you open a file in a supported language, lsp-mode will automatically
;; prompt you to download and install the server if it's not found.

(provide 'my-lsp)
;;; my-lsp.el ends here
