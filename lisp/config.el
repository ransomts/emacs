(let ((default-directory  "~/.emacs.d/packages/"))
	(normal-top-level-add-subdirs-to-load-path))

(defun running-on-hosts (hosts)
	(member
	 (car (split-string ; split the hostname on '.' for complex hostnames
		 (car (split-string ; remove trailing newline from `hostname`
		 (shell-command-to-string "hostname") "\n")) "\\."))
	 hosts))

(defun running-on-wireless (essids)
  (member (shell-command-to-string "iwgetid --raw") essids))

;; (running-on-hosts '("joseki" "atari"))

(require 'use-package)

(use-package material-theme
  :ensure t
  :config
  (load-theme 'material t))

(use-package theme-changer
  :ensure t
  :init
  (setq calendar-latitude 34.67
	calendar-location-name "Clemson, SC"
	calendar-longitude -82.84)
  :config (change-theme 'material-light 'material))

(use-package helm
  :ensure t
  :bind (("M-x" . #'helm-M-x)
	 ("C-x b" . #'helm-buffers-list)
	 ("C-x f" . #'helm-find-files)
	 ("C-x C-f" . #'helm-find-files))
  :config
  (helm-mode t))

(use-package helm-tramp
    :ensure t
    :after (helm)
)

(use-package helm-bbdb
  :ensure t
  :after (helm)
  :bind (("<f5>" . #'helm-bbdb)))

(use-package helm-dictionary
      :ensure t
      :after (helm)
      :bind (("<f8>" . #'helm-dictionary))
      :config
      (setq
       helm-dictionary-browser-function 'browse-url-firefox
       helm-dictionary-database "/usr/share/dict/words"
       helm-dictionary-online-dicts
       '(("wiktionary" . "http://en.wiktionary.org/wiki/%s")
	 ("Oxford English Dictionary" . "www.oed.com/search?searchType=dictionary&q=%s")
	 ("Merriam-Webster" . "https://www.merriam-webster.com/dictionary/%s"))
       helm-dictionary-use-full-frame nil))

(global-set-key (kbd "M-o")     #'other-window)
(global-set-key (kbd "M-h")     #'backward-kill-word)                   
(global-set-key (kbd "C-x k")   #'kill-this-buffer)                     
(global-set-key (kbd "C-x C-k") #'kill-this-buffer)                     
(global-set-key (kbd "C-h")     #'delete-backward-char)                 
(global-set-key (kbd "C-x 2")                                           
		(lambda ()                                              
		  (interactive)                                         
		  (split-window-vertically)                             
		  (other-window 1)))

(defun transpose-windows (arg)
  "Transpose the buffers shown in two windows."
  (interactive "p")
  (let ((selector (if (>= arg 0) 'next-window 'previous-window)))
    (while (/= arg 0)
      (let ((this-win (window-buffer))
            (next-win (window-buffer (funcall selector))))
        (set-window-buffer (selected-window) next-win)
        (set-window-buffer (funcall selector) this-win)
        (select-window (funcall selector)))
      (setq arg (if (plusp arg) (1- arg) (1+ arg))))))

(global-set-key (kbd "C-x t") #'transpose-windows)

(defun toggle-frame-split ()
      "If the frame is split vertically, split it horizontally or vice versa.
Assumes that the frame is only split into two."
      (interactive)
      (unless (= (length (window-list)) 2) (error "Can only toggle a frame split in two"))
      (let ((split-vertically-p (window-combined-p)))
	(delete-window) ; closes current window
	(if split-vertically-p
		(split-window-horizontally)
	      (split-window-vertically))
	(switch-to-buffer nil)))

(global-set-key (kbd "C-x |") 'toggle-frame-split)

(use-package magit
	:ensure t
	:bind ("C-x g" . #'magit-status))

(use-package gnus
  :bind ("C-M-g" . #'gnus)
  :config
  (setq
   gnus-always-read-dribble-file t
   gnus-directory "~/.emacs.d/gnus"))

;; (use-package gnus-demon
 ;;   :ensure t
 ;;   :hook
 ;;   (gnus-demon-add-handler #'gnus-demon-scan-news 2 nil)
 ;;   (message "from hook")
;;   )

(use-package pdf-tools
  :ensure t
  :if (not (string= nil (getenv "DESKTOP_SESSION")))
  :load-path "site-lisp/pdf-tools/lisp"
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-tools-install)
  (setq pdf-misc-print-programm "/usr/bin/gtklp"))

(use-package projectile
  :ensure t)
(use-package page-break-lines
  :ensure t)
(use-package dashboard
  :ensure t
  :after (projectile page-line-breaks)
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-items '((recents  . 5)
			  (bookmarks . 5)
			  (projects . 5)
			  (agenda . 5)
			  (registers . 5))))

(use-package org
	:config
	(setq diary-file "~/.emacs.d/org/schedule.org"
	org-agenda-files
	'("~/.emacs.d/org/fun/code-ideas.org"
		"~/.emacs.d/org/fun/music.org"
		"~/.emacs.d/org/scratch.org"
		"~/.emacs.d/org/research.org"
		"~/.emacs.d/org/schedule.org"
		"~/.emacs.d/org/todo.org")
	org-agenda-use-time-grid nil
	org-archive-location "~/.emacs.d/org/archive.org::* From %s"
	org-babel-load-languages
	'((emacs-lisp . t)
		(awk . t)
		(ditaa . t)
		(lisp . t)
		(haskell . t)
		(C . t)
		(gnuplot . t)
		(python . t)
		(shell . t)
		(sqlite . t)
		(java . t))
	org-capture-after-finalize-hook nil
	org-capture-templates '(("t" "Todo" entry
				 (file+headline "~/.emacs.d/org/todo.org" "Tasks")
				 "* TODO %?
					Entered on %T
					 %i
					 %a")
				("e" "Event" entry
				 (file "~/.emacs.d/org/schedule.org")
				 "* %?
					Date %^t")
				("b" "Fix Bug" checkitem
				 (file+headline "~/.emacs.d/org/todo.org" "Bugs")
				 "[ ] %?
					%A
					Entered on %T")
				("n" "General notes" entry
				 (file+headline "~/.emacs.d/org/scratch.org" "Notes")
				 "* Note %?
					 %T
					"))
	org-clock-sound t
	org-confirm-babel-evaluate nil
	org-datetree-add-timestamp 'inactive
	org-default-notes-file "~/.emacs.d/org/todo.org"
	org-directory "~/.emacs.d/org"
	org-gcal-client-secret "UwfWeXumob8oMLGTBs2D6D5j"
	org-gcal-dir "~/.emacs.d/org/org-gcal/"
	org-hide-leading-stars t
	org-highlight-latex-and-related '(latex)
	org-journal-dir "~/.emacs.d/org/journal"
	org-log-done 'time
	org-outline-path-complete-in-steps nil
	org-preview-latex-image-directory "~/.emacs.d/ltxpng/"
	org-refile-targets '((org-agenda-files :maxlevel . 2))
	org-refile-use-outline-path 'file
	org-startup-with-latex-preview t
	org-todo-keyword-faces
	'(("SOON"
		 :foreground "blue"
		 :background "sky blue"
		 :weight bold)
		("DONE"
		 :foreground "darkseagreen4"
		 :background "darkseagreen2"
		 :weight bold))
	org-todo-keywords '((sequence "TODO" "SOON" "DONE")))
	:bind
	(
	 ("C-c a" . #'org-agenda)
	 ("C-c c" . #'org-capture)
	 (:map org-mode-map
	 (("C-c r" . #'org-archive-subtree)
		("C-c C-r" . #'org-archive-subtree)))))

(use-package org-bullets
  :ensure t
  :hook (org-mode . org-bullets-mode))

(use-package erc
      :config
      (setq
       erc-autojoin-channels-alist (quote (("freenode.net")))
       erc-autojoin-mode nil
       erc-autojoin-timing (quote ident)
       erc-hide-list (quote ("JOIN" "PART" "NICK" "QUIT"))
       erc-hide-timestamps t
       erc-list-mode t
       erc-log-channels-directory "~/.emacs.d/erc_log"
       erc-log-mode t
       erc-log-write-after-insert t
       erc-log-write-after-send t
       erc-modules
       '(autojoin button completion dcc fill irccontrols keep-place
	 list log match menu move-to-prompt netsplit networks
	 noncommands notifications readonly ring services sound
	 stamp track ercn)
       erc-nick "Timzi"
       erc-prompt "<Timzi>"
       erc-sound-mode t
       ))

(use-package transmission
      :ensure t
      :if (running-on-hosts '("joseki" "tengen"))
      :config
      (setq
       transmission-refresh-modes
       '(transmission-mode
	 transmission-files-mode
	 transmission-info-mode
	 transmission-peers-mode)))

(use-package emms
  :ensure t
  :config
  (setq
   emms-cache-get-function 'emms-cache-get
   emms-cache-modified-function 'emms-cache-dirty
   emms-cache-set-function 'emms-cache-set
   emms-info-functions '(emms-info-mediainfo
						 emms-info-mpd emms-info-cueinfo
						 emms-info-ogginfo)
   emms-mode-line-cycle t
   emms-mode-line-mode-line-function 'emms-mode-line-cycle-mode-line-function
   emms-player-mpd-music-directory "/home/tsranso/Music"
   emms-player-mplayer-command-name "mpv"
   emms-player-next-function 'emms-score-next-noerror
   emms-playlist-default-major-mode 'emms-playlist-mode
   emms-playlist-update-track-function 'emms-playlist-mode-update-track-function
   emms-track-description-function 'emms-info-track-description))

(use-package bbdb
      :config ()
      (setq
       bbdb-dial-function
       (lambda
	 (phone-number)
	 (kdeconnect-send-sms
	      (read-string "Enter message: ")
	      (string-to-int
	       (replace-regexp-in-string "[() -]" "" phone-number))))))

(use-package dired+
  :bind (:map dired-mode-map
	      (("M-h" . #'dired-omit-mode)
	       ("u" . #'dired-up-directory)))
  :config
  (setq
   dired-listing-switches "-alh --no-group"
   dired-no-confirm '(byte-compile copy delete)
   dired-omit-files "^\\..*~?$"
   dired-recursive-copies 'always
   dired-recursive-deletes 'always))

(use-package slime
      :ensure t
      :config
      (setq inferior-lisp-program "sbcl")
      slime-contribs '(slime-fancy))

(use-package fill-column-indicator
  :ensure t
      :config
      (setq
       fci-rule-column 80
       fill-column 80))

(autoload 'dired-async-mode "dired-async.el" nil t)
(dired-async-mode 1)
(async-bytecomp-package-mode 1)

(setq calendar-mark-diary-entries-flag t
      display-time-24hr-format t
      display-time-default-load-average nil)

(display-time-mode t)

;; (setq menu-bar-mode nil
;;       tool-bar-mode nil
;;       tooltip-use-echo-area t
;;       use-dialog-box nil
;;       line-number-mode t
;;       column-number-mode t)

(fringe-mode 1)
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

(setq x-stretch-cursor t
      sentence-end-double-space nil
      tab-width 4)

(show-paren-mode t)

(setq delete-by-moving-to-trash t
	      trash-directory "/home/tsranso/.local/share/Trash/files/")

(setq 
   ;initial-buffer-choice (lambda nil (get-buffer "*dashboard*"))
   initial-buffer-choice (lambda nil (get-buffer "*scratch*"))
   initial-major-mode 'org-mode
   initial-scratch-message (concat (format-time-string "%Y-%m-%d")
"

"))

(setq proced-auto-update-flag t
	      proced-auto-update-interval 2
	      proced-filter 'user)

(setq browse-url-browser-function 'browse-url-firefox
	      browse-url-firefox-arguments '("-new-window")
	      browse-url-firefox-startup-arguments nil)

(setq doc-view-continuous t
	      doc-view-resolution 300)

(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "/var/emacs/"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

(recentf-mode 1)

(global-set-key (kbd "<f6>")    #'calc)
(global-set-key (kbd "<f7>")    #'calendar)
(global-set-key (kbd "C-x e")   #'eshell)
(global-set-key (kbd "C-c C-c") #'compile)
(global-set-key (kbd "C-c r")   #'revert-buffer)


(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
			async-bytecomp-package-mode t
			gdb-many-windows t
			large-file-warning-threshold 500000000
			send-mail-function 'smtpmail-send-it
			message-directory "~/.emacs.d/Mail/"
					;tramp-histfile-override "/dev/null" nil (tramp)
			)

(use-package smart-mode-line
  :ensure t
  :init 
  (setq sml/theme 'respectful
	sml/no-confirm-load-theme t)
  :config (sml/setup))

(defun launch-program (command)
	(interactive (list (read-shell-command "$ ")))
	(start-process-shell-command command nil command))

(defun lock-screen ()
	(interactive)
	(shell-command "/usr/local/bin/lock.sh"))

(use-package xelb :ensure t)
(use-package exwm
	:ensure t
	:if (string= "exwm" (getenv "DESKTOP_SESSION"))
	:after (xelb)
	:bind
	(("s-x" . #'launch-program)
	 ("s-l" . #'lock-screen)
	 ("s-w" . #'exwm-workplace-switch)
	 ("s-r" . #'exwm-reset)
	 ("C-x C-c" . #'save-buffers-kill-emacs))
	:config
	(setq exwm-input-simulation-keys
	'(([?\C-b] . [left])
		([?\C-f] . [right])
		([?\C-p] . [up])
		([?\C-n] . [down])
		([?\C-a] . [home])
		([?\C-e] . [end])
		([?\M-v] . [prior])
		([?\C-v] . [next])
		([?\C-d] . [delete])
		([?\C-h] . [backspace])
		([?\C-m] . [return])
		([?\C-i] . [tab])
		([?\C-g] . [escape])
		([?\M-g] . [f5])
		([?\C-s] . [C-f])
		([?\C-y] . [C-v])
		([?\M-w] . [C-c])
		([?\M-<] . [home])
		([?\M->] . [C-end])))

	(global-set-key (kbd "<mouse-12>") (lambda () (interactive)
							 (message "my closure")
							 (exwm-input--fake-key 26)))
	(require 'exwm-systemtray)
	(exwm-systemtray-enable)

	(add-hook 'exwm-floating-setup-hook #'exwm-layout-hide-mode-line)
	(add-hook 'exwm-floating-exit-hook #'exwm-layout-show-mode-line)

	(add-hook 'exwm-update-title-hook
			(lambda ()
				(when (or (string-match "Firefox" exwm-class-name)
			(string-match "Chromium" exwm-class-name)
			(string-match "Google-chrome" exwm-class-name))
		(exwm-workspace-rename-buffer exwm-title))))

	(setq exwm-workspace-number 10
	exwm-workspace-show-all-buffers t
	exwm-layout-show-all-buffers t)

	(dotimes (i 10)
		(exwm-input-set-key (kbd (format "s-%d" i))
			`(lambda ()
				 (interactive)
				 (exwm-workspace-switch-create ,i))))

	(setq lexical-binding t)
	(dolist (k '(
				 ("s-<return>" . "urxvtc")
				 ("s-p" . "nemo")
				 ("s-d" . "discord")
				 ("s-t" . "transmission-remote-gtk")
				 ("s-s" . "slack")
				 ("s-<tab>" . "google-chrome-stable")
				 ("<C-M-escape>" . "gnome-system-monitor")
				 ("s-m" . "pavucontrol")
				 ("s-<down>" . "amixer sset Master 5%-")
				 ("s-<up>" . "amixer set Master unmute; amixer sset Master 5%+")
				 ("<XF86MonBrightnessUp>" . "light -A 10")
				 ("<XF86MonBrightnessDown>" . "light -U 10")
				 ("<XF86AudioMute>"."amixer set Master toggle")
				 ("<XF86AudioLowerVolume>" . "amixer sset Master 5%-")
				 ("<XF86AudioRaiseVolume>" . "amixer set Master unmute; amixer sset Master 5%+")))
		;; need a closure here to grab the element pair
		(let ((f (lambda () (interactive)
				 (save-window-excursion
		 (start-process-shell-command "" nil (cdr k))))))
			(exwm-input-set-key (kbd (car k)) f)))

	;; The following example demonstrates how to set a key binding only available
	;; in line mode. It's simply done by first push the prefix key to
	;; `exwm-input-prefix-keys' and then add the key sequence to `exwm-mode-map'.
	;; The example shorten 'C-c q' to 'C-q'.
	(push ?\C-q exwm-input-prefix-keys)
	(define-key exwm-mode-map [?\C-q] #'exwm-input-send-next-key)

	(exwm-enable)
	)

(when (running-on-hosts '("joseki"))
  (display-battery-mode t)
  (start-process "wifi applet" nil "nm-applet")
  (start-process "redshift" nil "redshift-gtk")

  (when (running-on-wireless '("Torus Shaped Earth"))
			     (start-process "discord" nil "discord")
			     (start-process "transmission"
					    nil "transmission-daemon")))

(when (running-on-hosts '("206"))
  (start-process "bluetooth applet" nil "blueman-applet")
  (start-process "slack" nil "slack"))

(when (running-on-hosts '("joseki" "206"))
  (unless (file-exists-p "~/.config/mpd/pid")			 
    (start-process "music player daemon" nil "mpd")))

;; ;; here are my autostart programs
(start-process "unclutter" nil "unclutter")
;; (start-process "thunar daemon" nil "thunar" "--daemon")
(start-process "urxvt daemon" nil "urxvtd" "-f" "-q" "-o")
;; (start-process "syncthing" nil "syncthing")
(start-process "xautolock" nil
	       "xautolock"
	       "-time 10"
	       "-locker lock.sh")
