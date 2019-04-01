;; -*- lexical-binding: t -*-

(defun running-on-hosts (hosts)
  (member*
   (car (split-string ; split the hostname on '.' for complex hostnames
	 (car (split-string ; remove trailing newline from `hostname`
	       (shell-command-to-string "hostname") "\n")) "\\."))
   hosts
   :test '(lambda (x y) (string-match-p y x))))

(defun running-on-wireless (essids)
  (member (shell-command-to-string "iwgetid --raw") essids))

(defun running-on-windows ()
    (string= system-type "windows-nt"))

(mapc (lambda (dir) (make-directory (concat user-emacs-directory dir) t))
      '("org" "gnus" ".sx" "hackernews"))

(let ((default-directory  "~/.emacs.d/packages/"))
  (normal-top-level-add-subdirs-to-load-path))

(require 'use-package)

(use-package gnus
  :bind ("C-M-g" . #'gnus)
  :custom
   (gnus-always-read-dribble-file t)
   (gnus-directory "~/.emacs.d/gnus")
  :config
  (setq-default
   gnus-summary-line-format "%U%R%z %(%&user-date; %[%-23,23f%]  %B%s%)\n"
   gnus-user-date-format-alist '((t . "%m-%d %H:%M"))
   gnus-summary-thread-gathering-function 'gnus-gather-threads-by-references
   gnus-thread-sort-functions '(gnus-thread-sort-by-date)
   gnus-sum-thread-tree-false-root ""
   gnus-sum-thread-tree-indent " "
   gnus-sum-thread-tree-leaf-with-other "├► "
   gnus-sum-thread-tree-root ""
   gnus-sum-thread-tree-single-leaf "╰► "
   gnus-sum-thread-tree-vertical "│"))
(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)

;; (use-package gnus-demon
;;   :ensure t
;;   :hook
;;   (gnus-demon-add-handler #'gnus-demon-scan-news 2 nil)
;;   (message "from hook")
;;   )

(use-package org
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '(
     (awk . t)
     (C . t)
     (ditaa . t)
     (dot . t)
     (emacs-lisp . t)
     (gnuplot . t)
     (haskell . t)
     (java . t)
     (lisp . t)
     (makefile . t)
     (python . t)
     (shell . t)
     (sql . t)
     (sqlite . t)))

  (require 'org-crypt)
  (org-crypt-use-before-save-magic)

  (setq diary-file "~/.emacs.d/org/schedule.org"
	org-agenda-files
	(directory-files (concat user-emacs-directory "org") nil
	"\\(?:\\(?:research\\|sc\\(?:hedule\\|ratch\\)\\|todo\\)\\.org\\)")
	org-agenda-use-time-grid nil
	org-archive-location "~/.emacs.d/org/archive.org::* From %s"
	org-capture-after-finalize-hook nil
	org-capture-templates '(("t" "Todo" entry
				 (file+headline "~/.emacs.d/org/todo.org" "Tasks")
				 "* TODO %?\nEntered on %T\n%i\n%a")
				("e" "Event" entry
				 (file "~/.emacs.d/org/schedule.org")
				 "* %?\nDate %^t")
				("b" "Fix Bug" checkitem
				 (file+headline "~/.emacs.d/org/todo.org" "Bugs")
				 "[ ] %?\n%A\nEntered on %T")
				("n" "General notes" entry
				 (file+headline "~/.emacs.d/org/scratch.org" "Notes")
				 "* Note %?\n%T\n"))
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
  (("C-c a" . #'org-agenda)
   ("C-c c" . #'org-capture)
   ("C-c 1" . #'org-encrypt-entry)
   ("C-c 2" . #'org-decrypt-entry)
   (:map org-mode-map
	 (("C-c r" . #'org-archive-subtree)
	  ("C-c C-r" . #'org-archive-subtree))))
  :hook visual-line-mode)

(use-package ox-hugo
  :ensure t
  :after ox)

(use-package ox-beamer
  :after ox)

(with-eval-after-load 'ox-latex
	(add-to-list 'org-latex-classes
		     '("IEEEtran"
		       "\\documentclass[11pt]{IEEEtran}"
		       ("\\section{%s}" . "\\section*{%s}")
		       ("\\subsection{%s}" . "\\subsection*{%s}")
		       ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
		       ("\\paragraph{%s}" . "\\paragraph*{%s}")
		       ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

(use-package ob-async
  :ensure t
  :after org)

(use-package org-bullets
  :ensure t
  :hook (org-mode . org-bullets-mode))

(use-package erc
  :custom
   (erc-autojoin-channels-alist (quote (("freenode.net"))))
   (erc-autojoin-mode nil)
   (erc-autojoin-timing (quote ident))
   (erc-hide-list (quote ("JOIN" "PART" "NICK" "QUIT")))
   (erc-hide-timestamps t)
   (erc-list-mode t)
   (erc-log-channels-directory "~/.emacs.d/erc_log")
   (erc-log-mode t)
   (erc-log-write-after-insert t)
   (erc-log-write-after-send t)
   (erc-modules
   '(autojoin button completion dcc fill irccontrols keep-place
	      list log match menu move-to-prompt netsplit networks
	      noncommands notifications readonly ring services sound
	      stamp track))
   (erc-nick "tinhatcat")
   (erc-prompt "<tinhatcat>")
   (erc-sound-mode t))

(use-package erc-twitch
  :disabled
  :after erc
  :config
  (setq erc-twitch-networks (quote ("irc.chat.twitch.tv")))
  (erc-twitch-mode))

(use-package dired+
  :bind (:map dired-mode-map
	      (("M-h" . #'dired-omit-mode)
	       ("u" . #'dired-up-directory)))
  :custom
   (dired-listing-switches "-alh --no-group")
   (dired-no-confirm '(byte-compile copy delete))
   (dired-omit-files "^\\..*~?$")
   (dired-recursive-copies 'always)
   (dired-recursive-deletes 'always))

(defmacro with-face (str &rest properties)
  `(propertize ,str 'face (list ,@properties)))

(defun my-eshell-prompt ()
  (let ((header-bg (if (find 'material-light custom-enabled-themes)
		       "#e0f7fa"
		     "#1c1f26"))
	(host (file-remote-p default-directory 'host)))
					;(host (nth 1 (split-string (eshell/pwd) ":"))))
    (concat
     (with-face (concat (eshell/pwd) " ") :background header-bg)
     (with-face (format-time-string "(%H:%M) " (current-time)) :background header-bg :foreground "#888")
     (with-face "\n" :background header-bg)
     (with-face user-login-name :foreground "blue")
     "@"
     (with-face (if (eq nil host) "localhost" host) :foreground "green")
     (if (= (user-uid) 0)
	 (with-face " #" :foreground "red")
       " $")
     " ")))

(use-package eshell
  :bind ("C-x e" . #'eshell)
  :custom
  (eshell-prompt-function 'my-eshell-prompt)
  (eshell-highlight-prompt nil)
  (eshell-cmpl-ignore-case t)
  (eshell-highlight-prompt nil)
  (eshell-destroy-buffer-when-process-dies t)
  (eshell-visual-commands
   '("vi" "vim" "screen" "top" "htop" "less" "more" "rtv")))

(use-package auto-package-update
  :ensure t
  :custom
  (auto-package-update-prompt-before-update t)
  (auto-package-update-delete-old-versions t)
  (auto-package-update-interval 90)
  :config
  (auto-package-update-maybe))

(use-package dad-joke :ensure t)

(use-package material-theme
  :unless (running-on-hosts '("login001"))
  :ensure t
  :config
  (load-theme 'material t))

(use-package theme-changer
  :unless (running-on-hosts '("login001"))
  :ensure t
  :custom
  (calendar-latitude 34.67)
  (calendar-location-name "Clemson, SC")
  (calendar-longitude -82.84)
  :config (change-theme 'material-light 'material))

(when (>= (string-to-number emacs-version) 24.4)
  (use-package helm
    :ensure t
    :bind (("M-x"   . #'helm-M-x)
	   ("C-x b" . #'helm-buffers-list)
	   ("C-x f" . #'helm-find-files)
	   ("C-x C-f" . #'helm-find-files)
	   ("M-y"   . #'helm-show-kill-ring)
	   ("C-c m" . #'helm-man-woman)
	   ("C-c l" . #'helm-locate)
	   ("C-c e" . #'helm-regexp)
	   ("C-c g" . #'helm-google-suggest))
    :config
    (helm-mode t)))

(when (>= (string-to-number emacs-version) 24.4)
  (use-package helm-tramp
    :unless (running-on-hosts '("login001"))
    :ensure t
    :requires helm))

(when (>= (string-to-number emacs-version) 24.4)
  (use-package helm-bbdb
    :unless (running-on-hosts '("login001"))
    :ensure t
    :requires helm
    :bind (("<f5>" . #'helm-bbdb))))

(when (>= (string-to-number emacs-version) 24.4)
  (use-package helm-dictionary
    :unless (running-on-hosts '("login001"))
    :requires helm
    :ensure t
    :bind (("<f8>" . #'helm-dictionary))
    :custom
     (helm-dictionary-browser-function 'browse-url-chrome)
     (helm-dictionary-database "/usr/share/dict/words")
     (helm-dictionary-online-dicts
     '(("wiktionary" . "http://en.wiktionary.org/wiki/%s")
       ("Oxford English Dictionary" . "www.oed.com/search?searchType=dictionary&q=%s")
       ("Merriam-Webster" . "https://www.merriam-webster.com/dictionary/%s")))
     (helm-dictionary-use-full-frame nil)))

(when (>= (string-to-number emacs-version) 25.1)
  (use-package magit
    :ensure t
    :unless (running-on-windows)
    :bind ("C-x g" . #'magit-status)))

(use-package pdf-tools
  :ensure t
  :unless (or (string= nil (getenv "DESKTOP_SESSION")) 
	      (running-on-hosts '("login001")))
  :load-path "site-lisp/pdf-tools/lisp"
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-tools-install)
  (setq pdf-misc-print-programm "/usr/bin/gtklp"))

(use-package nov
  :ensure t
  :unless (or (string= nil (getenv "DESKTOP_SESSION"))
	      (running-on-hosts '("login001")))
  :magic ("%EPUB" . nov-mode))

(use-package dashboard
  :ensure t
  :if (getenv "DESKTOP_SESSION")
  :config
  (dashboard-setup-startup-hook)
  :custom
  (dashboard-items '((recents  . 5)
		     (agenda . 5)
		     (registers . 5))))
		     ;; todo: make (todos . 5) source

(when (>= (string-to-number emacs-version) 24.4)
  (use-package transmission
    :ensure t
    :if (running-on-hosts '("joseki" "tengen"))
    :custom
    (transmission-refresh-modes
     '(transmission-mode
       transmission-files-mode
       transmission-info-mode
       transmission-peers-mode))))

(use-package spotify :ensure t
  :if (running-on-hosts '("tengen" "hoshi" "atari" "joseki"))
  :unless (running-on-windows)
  :bind (("C-c s c" . #'spotify-current)
	 ("C-c s SPC" . #'spotify-playpause)
	 ("C-c s n" . #'spotify-next)
	 ("C-c s p" . #'spotify-previous))
  :config
  (spotify-enable-song-notifications))

(use-package hackernews
  :ensure t
  :bind ("C-c h" . #'hackernews))

(use-package sx
  :ensure t
  :bind ("C-c x" . #'sx-tab-all-questions))

(use-package wiki-summary
  :defer 1
  :bind ("C-c w" . wiki-summary)
  :ensure t
  :preface
  (defun my/format-summary-in-buffer (summary)
    "Given a summary, stick it in the *wiki-summary* buffer and display the buffer"
    (let ((buf (generate-new-buffer "*wiki-summary*")))
      (with-current-buffer buf
	(princ summary buf)
	(fill-paragraph)
	(goto-char (point-min))
	(text-mode)
	(view-mode))
      (pop-to-buffer buf))))

(advice-add 'wiki-summary/format-summary-in-buffer :override #'my/format-summary-in-buffer)

(use-package emms
  :if (running-on-hosts '("joseki" "tengen"))
  :ensure t
  :custom
  (emms-cache-get-function 'emms-cache-get)
  (emms-cache-modified-function 'emms-cache-dirty)
  (emms-cache-set-function 'emms-cache-set)
  (emms-info-functions '(emms-info-mediainfo
			 emms-info-mpd emms-info-cueinfo
			 emms-info-ogginfo))
  (emms-mode-line-cycle t)
  (emms-mode-line-mode-line-function 'emms-mode-line-cycle-mode-line-function)
  (emms-player-mpd-music-directory "/home/tsranso/Music")
  (emms-player-mplayer-command-name "mpv")
  (emms-player-next-function 'emms-score-next-noerror)
  (emms-playlist-default-major-mode 'emms-playlist-mode)
  (emms-playlist-update-track-function 'emms-playlist-mode-update-track-function)
  (emms-track-description-function 'emms-info-track-description))

(use-package bbdb
  :ensure t
  :custom
  (bbdb-dial-function
   (lambda
     (phone-number)
     (kdeconnect-send-sms
      (read-string "Enter message: ")
      (string-to-int
       (replace-regexp-in-string "[() -]" "" phone-number))))))

(use-package slime
  :ensure t
  :custom
  (inferior-lisp-program "sbcl")
  (slime-contribs '(slime-fancy)))

(use-package smart-mode-line
  :ensure t
  :custom
  (sml/theme 'respectful)
  (sml/no-confirm-load-theme t)
  :config
  (sml/setup)
  (setq sml/name-width 30))

(use-package cmake-mode :ensure t)

(use-package gnuplot :ensure t)

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

(use-package which-key
  :ensure t
  :custom (which-key-idle-delay 3.0)
  :config (which-key-mode))

(use-package smartparens
  :ensure t
  :hook (prog-mode . turn-off-smartparens-strict-mode))

(use-package hs-minor-mode
  :hook prog-mode
  :bind (:map hs-minor-mode-map
	      ("C-c b h" . hs-hide-block)
	      ("C-c s" . hs-show-block)
	      ("C-c h" . hs-hide-block)
	      ("C-c b s" . hs-show-block)
	      ("C-c C-b h" . hs-hide-block)
	      ("C-c C-b s" . hs-show-block)))

(use-package ibuffer
  :ensure t
  :bind ("C-x C-b" . #'ibuffer)
  :config
  ;; Use human readable Size column instead of original one
  (define-ibuffer-column size-h
    (:name "Size" :inline t)
    (cond
     ((> (buffer-size) 1000000) (format "%7.1fM" (/ (buffer-size) 1000000.0)))
     ((> (buffer-size) 100000) (format "%7.0fk" (/ (buffer-size) 1000.0)))
     ((> (buffer-size) 1000) (format "%7.1fk" (/ (buffer-size) 1000.0)))
     (t (format "%8d" (buffer-size)))))

  ;; Modify the default ibuffer-formats
  (setq ibuffer-formats
	'((mark modified read-only " "
		(name 18 18 :left :elide)
		" "
		(size-h 9 -1 :right)
		" "
		(mode 16 16 :left :elide)
		" "
		filename-and-process)))

  (setq mp/ibuffer-collapsed-groups (list "helm" "tramp"))

  (defadvice ibuffer (after collapse-helm)
    (dolist (group mp/ibuffer-collapsed-groups)
      (progn
	(goto-char 1)
	(when (search-forward (concat "[ " group " ]") (point-max) t)
	  (progn
	    (move-beginning-of-line nil)
	    (ibuffer-toggle-filter-group)))))
    (goto-char 1)
    (search-forward "[ " (point-max) t))

  (ad-activate 'ibuffer)

  :custom
  (ibuffer-default-sorting-mode 'major-mode)
  (ibuffer-saved-filter-groups
   '(("exwm"
      ("exwm" (mode . exwm-mode))
      ("dired" (mode . dired-mode))
      ("org" (or (mode . org-mode)
		 (filename . "OrgMode")))
      ("erc" (mode . erc-mode))
      ("magit" (name . "magit\*"))
      ("subversion" (name . "\*svn"))
      ("helm" (mode . helm-major-mode))
      ("tramp" (name . "\*tramp\*"))
      ("eshell" (name . "\*eshell"))
      ("gnus" (or
	       (mode . message-mode)
	       (mode . bbdb-mode)
	       (mode . mail-mode)
	       (mode . gnus-group-mode)
	       (mode . gnus-summary-mode)
	       (mode . gnus-article-mode)
	       (name . "^\\.bbdb$")
	       (name . "^\\.newsrc-dribble")))
      ("help" (or (name . "\*Help\*")
		  (name . "\*Apropos\*")
		  (name . "\*info\*"))))))
  (ibuffer-expert t)
  (ibuffer-show-empty-filter-groups nil))

(add-hook 'ibuffer-mode-hook
	  (lambda ()
	    (ibuffer-auto-mode 1)
	    (ibuffer-switch-to-saved-filter-groups "exwm")))

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

(defun edit-as-su (&optional arg)
  "Edit currently visited file as root.

With a prefix ARG prompt for a file to visit.
Will also prompt for a file to visit if current
buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
			 (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(global-set-key (kbd "C-c o") #'edit-as-su)

(use-package async
  :ensure t
  :config
  (dired-async-mode 1)
  (async-bytecomp-package-mode 1))

(setq calendar-mark-diary-entries-flag t
      display-time-24hr-format t
      display-time-default-load-average nil)

(display-time-mode t)

;; (setq 
;;       use-dialog-box nil
;;       line-number-mode t
;;       column-number-mode t)

(tooltip-mode 0)
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

(if  (running-on-windows)
    (setq browse-url-browser-function 'eww-browse-url)
  (setq browse-url-browser-function 'browse-url-chrome
	browse-url-chrome-arguments '("--new-window")))

(setq doc-view-continuous t
      doc-view-resolution 300)

(setq
 backup-by-copying t      ; don't clobber symlinks
 backup-directory-alist
					;'(("." . (if (file-directory-p "/var/emacs/") "/var/emacs/" "/tmp/")))    ; don't litter my fs tree
 '(("." . "/tmp/"))    ; don't litter my fs tree
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)       ; use versioned backups

(recentf-mode 1)

(global-set-key (kbd "<f6>")    #'calc)
(global-set-key (kbd "<f7>")    #'calendar)
(global-set-key (kbd "C-c C-c") #'compile)
(global-set-key (kbd "C-c r")   #'revert-buffer)
(global-set-key (kbd "\C-z")    #'bury-buffer)
(global-set-key (kbd "\C-c v")  #'visual-line-mode)
(global-set-key (kbd "\C-c t")  #'toggle-truncate-lines)

(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      async-bytecomp-package-mode t
      gdb-many-windows t
      large-file-warning-threshold 500000000
      send-mail-function 'smtpmail-send-it
      message-directory "~/.emacs.d/Mail/"
					;tramp-histfile-override "/dev/null" nil (tramp)
      )
(add-to-list 'tramp-remote-path "/home/tsranso/bin")
(add-to-list 'tramp-remote-path "/home/tsranso/.local/bin")
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

(defun launch-program (command)
  (interactive (list (read-shell-command "$ ")))
  (start-process-shell-command command nil command))

(defun lock-screen ()
  (interactive)
  (shell-command "/usr/local/bin/lock.sh"))

(when (and (>= (string-to-number emacs-version) 24.4)
	   (not (running-on-hosts '("login001" "marcher" "atari"))))
  (use-package xelb
    :if (string= "exwm" (getenv "DESKTOP_SESSION"))
    :ensure t)

  (use-package exwm
    :if (string= "exwm" (getenv "DESKTOP_SESSION"))
    :ensure t
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
	    ;; todo ([?\M-o] . [C-x o])
	    ([?\M->] . [C-end])))

    (global-set-key (kbd "<mouse-12>") (lambda () (interactive)
					 (exwm-input--fake-key 26)))

    (dolist (k '(
		 ("s-," . "alternate-screen")
		 ("s-<return>" . "urxvtc")
		 ("s-p" . "nemo")
		 ("s-d" . "discord")
		 ("s-t" . "transmission-remote-gtk")
		 ("s-s" . "spotify")
		 ("s-<tab>" . "google-chrome-stable")
		 ("<C-M-escape>" . "gnome-system-monitor")
		 ("s-m" . "pavucontrol")
		 ("s-<down>" . "amixer sset Master 5%-")
		 ("s-<up>" . "amixer set Master unmute; amixer sset Master 5%+")
		 ("<print>" . "scrot")
		 ("<XF86MonBrightnessUp>" . "light -A 10")
		 ("<XF86MonBrightnessDown>" . "light -U 10")
		 ("<XF86AudioMute>"."amixer -c 0 set Master toggle")
		 ("<XF86AudioLowerVolume>" . "amixer -c 0 sset Master 5%-")
		 ("<XF86AudioRaiseVolume>" . "amixer -c 0 set Master unmute; amixer -c 0 sset Master 5%+")))
      (let ((f (lambda () (interactive)
		 (save-window-excursion
		   (start-process-shell-command "" nil (cdr k))))))
	(exwm-input-set-key (kbd (car k)) f)))

    (require 'exwm-systemtray)
    (exwm-systemtray-enable)

    (add-hook 'exwm-floating-setup-hook #'exwm-layout-hide-mode-line)
    (add-hook 'exwm-floating-exit-hook #'exwm-layout-show-mode-line)

    (add-hook 'exwm-update-title-hook
	      (lambda () (exwm-workspace-rename-buffer exwm-title)))

    (setq exwm-workspace-number 10
	  exwm-workspace-show-all-buffers t
	  exwm-layout-show-all-buffers t)

    (dotimes (i 10)
      (exwm-input-set-key (kbd (format "s-%d" i))
			  `(lambda ()
			     (interactive)
			     (exwm-workspace-switch-create ,i))))

    (push ?\C-q exwm-input-prefix-keys)
    (define-key exwm-mode-map [?\C-q] #'exwm-input-send-next-key)

    (require 'exwm-randr)
    (when (running-on-hosts '("tengen"))
      (setq exwm-randr-workspace-output-plist
	    '(0 "DisplayPort-2"
		1 "HDMI-A-0"
		2 "DVI-D-0"
		3 "DisplayPort-0"
		4 "DisplayPort-1"
		5 "DisplayPort-2"
		6 "HDMI-A-0"
		7 "DVI-D-0"
		8 "DisplayPort-0"
		9 "DisplayPort-1"))
      (add-hook 'exwm-randr-screen-change-hook
		(lambda ()
		  (start-process-shell-command
		   "xrandr" nil
		   (concat "xrandr "
			   "--output DisplayPort-1 --mode 1920x1200 --pos 3120x240 --rotate left "
			   "--output DisplayPort-0 --primary --mode 1920x1200 --pos 1920x240 --rotate left "
			   "--output DisplayPort-2 --mode 1920x1200 --pos 4320x576 "
			   "--output DVI-D-0 --mode 1920x1080 --pos 0x1080 "
			   "--output HDMI-A-0 --mode 1920x1080 --pos 0x0")))))
    (when (running-on-hosts '("hoshi"))
      (setq exwm-randr-workspace-output-plist
	    '(1 "DP-1" 4 "HDMI-1" 7 "DP-2"
		2 "DP-1" 5 "HDMI-1" 8 "DP-2"
		3 "DP-1" 6 "HDMI-1" 9 "DP-2" 0 "DP-2"))
      (add-hook 'exwm-randr-screen-change-hook
		(lambda ()
		  (start-process-shell-command
		   "xrandr" nil
		   (concat "xrandr "
			   "--output HDMI-1 --mode 1920x1080 --pos 1920x0 "
			   "--output DP-2 --mode 1920x1080 --pos 3840x0 "
			   "--output DP-1 --primary --mode 1920x1080 --pos 0x0")))))

    (exwm-randr-enable)
    (exwm-enable)))

(when (running-on-hosts '("joseki"))
  (display-battery-mode t)
  (start-process "" nil "xrdb" "-merge" "/home/tsranso/.config/urxvt/conf")
  (start-process "wifi applet" nil "nm-applet")

  (when (running-on-wireless '("Torus Shaped Earth\n"))
    (start-process "discord" nil "discord")
    (start-process "spotify" nil "spotify")
    (start-process "transmission" nil "transmission-daemon")))

(when (and (running-on-hosts '("tengen"))
	   (not (running-on-windows)))
  (start-process "transmission" nil "transmission-daemon"))

(when (running-on-hosts '("joseki" "hoshi"))
  (unless (file-exists-p "~/.config/mpd/pid")
    (start-process "music player daemon" nil "mpd")))

(when (and (running-on-hosts '("hoshi" "tengen"))
	   (not (running-on-windows)))
  (start-process "discord" nil "discord")
  (start-process "spotify" nil "spotify"))

(when (and (running-on-hosts '("joseki" "hoshi" "tengen"))
	   (not (running-on-windows)))
  (start-process "redshift" nil "redshift" "-l" "34.67:-82.84")
  (start-process "urxvt daemon" nil "urxvtd" "-f" "-q" "-o")
  (start-process "bluetooth applet" nil "blueman-applet"))

(when (not (running-on-hosts '("atari" "login*" "marcher" "tengen" "ivy*" "node*")))
  (start-process "xautolock" nil
		 "xautolock"
		 "-time 10"
		 "-locker lock.sh"))

(when (and (not (running-on-hosts '("login*" "marcher" "ivy*" "node*")))
	   (not (running-on-windows)))
  (start-process "unclutter" nil "unclutter"))

(use-package symon
  :ensure t
  :bind
  ("s-h" . symon-mode))
