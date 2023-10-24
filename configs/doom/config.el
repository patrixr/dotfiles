;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; MODES

(defun enable-global-modes ()
  (simpleclip-mode 1)
  (beacon-mode 1))

(add-hook 'emacs-startup-hook 'enable-global-modes)

;; PROJECTILE

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

(projectile-register-project-type 'makefile '("Makefile")
                                  :project-file "Makefile"
                                  :compile "make"
                                  :test "make test"
                                  :run "make start")


;; EGLOT

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs '((js-mode typescript-mode) . (eglot-deno "deno" "lsp")))

  (defclass eglot-deno (eglot-lsp-server) ()
    :documentation "A custom class for deno lsp.")

  (cl-defmethod eglot-initialization-options ((server eglot-deno))
    "Passes through required deno initialization options"
    (list :enable t
    :lint t))
)

;; FORMATTING & EDITING

(setq-hook! 'js-mode-hook +format-with-lsp nil)
(setq-hook! 'js-mode-hook +format-with :none)
(add-hook 'js-mode-hook 'prettier-js-mode)

(add-hook 'typescript-mode-hook 'deno-fmt-mode)
(add-hook 'js2-mode-hook 'deno-fmt-mode)

(setq terraform-format-on-save t)

(setq-default tab-width 2)
(setq-default typescript-indent-level 2)
(setq-default yaml-indent-offset 2)

(define-key global-map (kbd "S-M-<down>") 'mc/mark-next-like-this)
(define-key global-map (kbd "S-M-<up>") 'mc/mark-previous-like-this)

;; THEME

(setq doom-theme 'doom-oceanic-next)

(setq doom-themes-neotree-enable-variable-pitch nil
      doom-themes-neotree-file-icons t)

(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
