(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

(setq custom-file "~/.emacs.d/lisp/customize.el")
(load custom-file)

(org-babel-load-file "/home/tsranso/.emacs.d/lisp/config.org")

