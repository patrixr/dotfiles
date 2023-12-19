
(setq quelpa-update-melpa-p nil)
(setq quelpa-upgrade-interval 7)
(setq use-package-ensure-function 'quelpa)
(setq use-package-always-ensure t)

;; Bootstrap quelpa
(unless (package-installed-p 'quelpa)
  (with-temp-buffer
    (url-insert-file-contents "https://raw.githubusercontent.com/quelpa/quelpa/master/quelpa.el")
    (eval-buffer)))

(quelpa '(quelpa-use-package
   :fetcher git
   :url "https://github.com/quelpa/quelpa-use-package.git"))

(require 'quelpa-use-package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(provide 'my-quelpa)
