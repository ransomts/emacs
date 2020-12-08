(require 'package)
(setq package-archives '( ("gnu" . "https://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(shell-command "touch ~/.emacs.d/configuration/customize.el")
(setq custom-file "~/.emacs.d/configuration/customize.el")
(load custom-file)

(org-babel-load-file "/home/tsranso/.emacs.d/configuration/config.org")

