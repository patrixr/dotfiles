;; ---------------------------------------------------------------------
;; GNU Emacs / N Λ N O - Emacs made simple
;; Copyright (C) 2020 - N Λ N O developers
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.
;; ---------------------------------------------------------------------
(package-initialize)

;; Path to nano emacs modules (mandatory)
(add-to-list 'load-path "./nano")
(add-to-list 'load-path "./my")

;; Custom
(require 'my-straight)
(require 'my-theme)
(require 'my-modes)
(require 'my-bindings)
(require 'my-minibuffer)
(require 'my-lsp)

;; Default layout (optional)
(require 'nano-layout)

;; Theming Command line options (this will cancel warning messages)
(add-to-list 'command-switch-alist '("-default"  . (lambda (args))))
(add-to-list 'command-switch-alist '("-no-splash" . (lambda (args))))
(add-to-list 'command-switch-alist '("-no-help" . (lambda (args))))
(add-to-list 'command-switch-alist '("-compact" . (lambda (args))))

;; Theme
(require 'nano-faces)
(require 'nano-colors)
(require 'nano-theme)
(require 'nano-theme-dark)
(require 'nano-theme-light)

;; Nano default settings (optional)
(require 'nano-defaults)
;; Nano session saving (optional)
(require 'nano-session)
;; Nano header & mode lines (optional)
(require 'nano-modeline)
;; Nano key bindings modification (optional)
(require 'nano-bindings)

;; Nano counsel configuration (optional)
;; Needs "counsel" package to be installed (M-x: package-install)
;; (require 'nano-counsel)

;; Welcome message (optional)
(let ((inhibit-message t))
  (message "N Λ N O Emacs")
  (message (format "Initialization time: %s" (emacs-init-time))))

(provide 'nano)
