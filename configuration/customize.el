(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-package-update-delete-old-versions t)
 '(auto-package-update-interval 90)
 '(auto-package-update-prompt-before-update t)
 '(bbdb-dial-function
   (quote
    (closure
     (t)
     (phone-number)
     (kdeconnect-send-sms
      (read-string "Enter message: ")
      (string-to-int
       (replace-regexp-in-string "[() -]" "" phone-number))))))
 '(calendar-latitude 34.67)
 '(calendar-location-name "Clemson, SC")
 '(calendar-longitude -82.84)
 '(custom-safe-themes
   (quote
    ("732b807b0543855541743429c9979ebfb363e27ec91e82f463c91e68c772f6e3" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" default)))
 '(dashboard-items (quote ((recents . 5) (agenda . 5) (registers . 5))) t)
 '(dired-listing-switches "-alh --no-group")
 '(dired-no-confirm (quote (byte-compile copy delete)))
 '(dired-omit-files "^\\..*~?$")
 '(dired-recursive-copies (quote always))
 '(dired-recursive-deletes (quote always))
 '(epa-pinentry-mode (quote loopback))
 '(erc-autojoin-channels-alist (quote (("freenode.net"))))
 '(erc-autojoin-mode nil)
 '(erc-autojoin-timing (quote ident))
 '(erc-hide-list (quote ("JOIN" "PART" "NICK" "QUIT")))
 '(erc-hide-timestamps t)
 '(erc-list-mode t)
 '(erc-log-channels-directory "~/.emacs.d/erc_log")
 '(erc-log-mode t)
 '(erc-log-write-after-insert t)
 '(erc-log-write-after-send t)
 '(erc-modules
   (quote
    (autojoin button completion dcc fill irccontrols keep-place list log match menu move-to-prompt netsplit networks noncommands notifications readonly ring services sound stamp track)))
 '(erc-nick "tinhatcat")
 '(erc-prompt "<tinhatcat>")
 '(erc-sound-mode t)
 '(eshell-cmpl-ignore-case t)
 '(eshell-destroy-buffer-when-process-dies t)
 '(eshell-highlight-prompt nil)
 '(eshell-prompt-function (quote my-eshell-prompt))
 '(eshell-visual-commands
   (quote
    ("vi" "vim" "screen" "top" "htop" "less" "more" "rtv")))
 '(gnus-always-read-dribble-file t)
 '(gnus-directory "~/.emacs.d/gnus")
 '(helm-dictionary-browser-function (quote browse-url-chrome))
 '(helm-dictionary-database "/usr/share/dict/words")
 '(helm-dictionary-online-dicts
   (quote
    (("wiktionary" . "http://en.wiktionary.org/wiki/%s")
     ("Oxford English Dictionary" . "www.oed.com/search?searchType=dictionary&q=%s")
     ("Merriam-Webster" . "https://www.merriam-webster.com/dictionary/%s"))))
 '(helm-dictionary-use-full-frame nil t)
 '(inferior-lisp-program "sbcl" t)
 '(org-agenda-files
   (quote
    ("~/.emacs.d/org/research.org" "~/.emacs.d/org/schedule.org" "~/.emacs.d/org/todo.org")))
 '(package-enable-at-startup nil)
 '(package-selected-packages
   (quote
    (cmake-mode which-key wiki-summary hackernews spotify sx ob-async symon nov auto-package-update smartparens dad-joke gnuplot theme-changer smart-mode-line magit org-bullets exwm xelb page-breaks-line slime transmission pdf-tools material-theme helm-tramp helm-dictionary helm-bbdb emms dashboard)))
 '(slime-contribs (quote (slime-fancy)) t)
 '(sml/no-confirm-load-theme t)
 '(sml/theme (quote respectful))
 '(tooltip-mode nil)
 '(which-key-idle-delay 3.0)
 '(which-key-mode t))
 
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
