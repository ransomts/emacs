(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")))

(package-initialize)


(setq custom-file "~/.emacs.d/configuration/customize.el")
(f-touch custom-file)
(load custom-file)

(org-babel-load-file "/home/tsranso/.emacs.d/configuration/config.org")

