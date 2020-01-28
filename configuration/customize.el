(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-package-update-delete-old-versions t)
 '(auto-package-update-interval 90)
 '(auto-package-update-prompt-before-update t)
 '(auto-revert-interval 2)
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
 '(dashboard-items
   (quote
    ((recents . 5)
     (agenda . 5)
     (bookmarks . 5)
     (registers . 5))) t)
 '(dired-listing-switches "-alh --no-group")
 '(dired-no-confirm (quote (byte-compile copy delete)))
 '(dired-omit-files "^\\..*~?$")
 '(dired-recursive-copies (quote always))
 '(dired-recursive-deletes (quote always))
 '(emms-cache-get-function (quote emms-cache-get))
 '(emms-cache-modified-function (quote emms-cache-dirty))
 '(emms-cache-set-function (quote emms-cache-set))
 '(emms-info-functions
   (quote
    (emms-info-mediainfo emms-info-mpd emms-info-cueinfo emms-info-ogginfo)) t)
 '(emms-mode-line-cycle t t)
 '(emms-mode-line-mode-line-function (quote emms-mode-line-cycle-mode-line-function) t)
 '(emms-player-mpd-music-directory "/home/tsranso/Music" t)
 '(emms-player-mplayer-command-name "mpv" t)
 '(emms-player-next-function (quote emms-score-next-noerror))
 '(emms-playlist-default-major-mode (quote emms-playlist-mode))
 '(emms-playlist-update-track-function (quote emms-playlist-mode-update-track-function))
 '(emms-track-description-function (quote emms-info-track-description))
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
 '(eshell-history-size 1000000)
 '(eshell-prompt-function (quote my-eshell-prompt))
 '(eshell-visual-commands
   (quote
    ("alsamixer" "glances" "gtop" "htop" "less" "more" "ncdu" "nethogs" "nmon" "pacmixer" "radeontop" "screen" "top" "tuir" "vi" "vim")))
 '(gnus-always-read-dribble-file t)
 '(gnus-blocked-images nil)
 '(gnus-directory "~/.emacs.d/gnus")
 '(helm-completion-style (quote emacs))
 '(helm-dictionary-browser-function (quote browse-url-chrome))
 '(helm-dictionary-database "/usr/share/dict/words")
 '(helm-dictionary-online-dicts
   (quote
    (("wiktionary" . "http://en.wiktionary.org/wiki/%s")
     ("Oxford English Dictionary" . "www.oed.com/search?searchType=dictionary&q=%s")
     ("Merriam-Webster" . "https://www.merriam-webster.com/dictionary/%s"))))
 '(helm-dictionary-use-full-frame nil t)
 '(ibuffer-default-sorting-mode (quote major-mode))
 '(ibuffer-expert t)
 '(ibuffer-formats
   (quote
    ((mark modified read-only " "
	   (name 30 30 :left :elide)
	   " "
	   (size-h 9 -1 :right)
	   " "
	   (mode 16 16 :left :elide)
	   " " filename-and-process))))
 '(ibuffer-saved-filter-groups
   (quote
    (("exwm"
      ("exwm"
       (mode . exwm-mode))
      ("dired"
       (mode . dired-mode))
      ("org"
       (or
	(mode . org-mode)
	(filename . "OrgMode")))
      ("erc"
       (mode . erc-mode))
      ("magit"
       (name . "magit*"))
      ("subversion"
       (name . "*svn"))
      ("customize"
       (mode . Custom))
      ("man pages"
       (mode . Man))
      ("process bufs"
       (mode . comint-mode))
      ("PDF"
       (or
	(mode . PDFView-mode)
	(mode . PDFView)))
      ("compilations"
       (mode . Compilation))
      ("helm"
       (mode . helm-major-mode))
      ("tramp"
       (name . "*tramp*"))
      ("eshell"
       (name . "*eshell"))
      ("gnus"
       (or
	(mode . message-mode)
	(mode . bbdb-mode)
	(mode . mail-mode)
	(mode . gnus-group-mode)
	(mode . gnus-summary-mode)
	(mode . gnus-article-mode)
	(name . "^\\.bbdb$")
	(name . "^\\.newsrc-dribble")))
      ("help"
       (or
	(name . "*Help*")
	(name . "*Apropos*")
	(name . "*info*")))))))
 '(ibuffer-show-empty-filter-groups nil)
 '(inferior-lisp-program "sbcl" t)
 '(org-agenda-files nil)
 '(org-noter-default-notes-file-names (quote ("~/.emacs.d/org/reading.org")))
 '(org-noter-notes-search-path (quote ("~/.emacs.d/org/")))
 '(package-enable-at-startup nil)
 '(package-selected-packages
   (quote
    (org-noter zotxt spaceline helm-google org-journal helm-org-clock visual-fill-column emojify calfw calfw-gcal calfw-ical calfw-org which-key beacon org-gcal deadgrep cmake-mode hydra org-ref dired-subtree hackernews spotify sx ob-async symon nov auto-package-update smartparens dad-joke gnuplot theme-changer smart-mode-line magit org-bullets exwm xelb page-breaks-line slime transmission material-theme helm-tramp helm-dictionary helm-bbdb emms dashboard)))
 '(revert-without-query (quote ("$*\\\\.pdf")))
 '(show-week-agenda-p t t)
 '(slime-contribs (quote (slime-fancy)) t)
 '(sml/no-confirm-load-theme t)
 '(sml/theme (quote respectful))
 '(tooltip-mode nil)
 '(transmission-refresh-modes
   (quote
    (transmission-mode transmission-files-mode transmission-info-mode transmission-peers-mode)))
 '(which-key-idle-delay 3.0))
 
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
