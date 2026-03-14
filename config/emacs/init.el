;; Start emacs server if not already running
(if (and (fboundp 'server-running-p)
	 (not (server-running-p)))
    (server-start))

;; Use all-the-icons
(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

;; Some basic configuration
(setq make-backup-files nil) ; stop creating ~ files
(setq vc-follow-symlinks nil) ; follow symlinks without confirmation
;; Basic UI Configuration -------

;; You will most likely need to adjust this font size for your system!
(defvar runemacs/default-font-size 110)

(require 'org-protocol)

(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room
(menu-bar-mode -1)            ; Disable the menu bar
(setq frame-inhibit-implied-resize 0)

;; Set up the visible bell
(setq visible-bell t)

;; ----- Package Manager Configuration -----

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(column-number-mode)
(global-display-line-numbers-mode t)

(use-package command-log-mode)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; ----- Font Configuration -----

(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font" :height runemacs/default-font-size)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "JetBrainsMono Nerd Font" :height 110)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height 110 :weight 'regular)

;; Yasnippet Config
(use-package yasnippet
  :ensure t
  :hook ((text-mode
	  conf-mode
	  org-mode
	  snippet-mode) . yas-minor-mode-on))

(use-package yasnippet-snippets
  :ensure t)

;; Treemacs Configuration
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (treemacs-follow-mode t)
  :bind
  (:map global-map
	("M-0"       . treemacs-select-window)
	("C-x t 1"   . treemacs-delete-other-windows)
	("C-x t t"   . treemacs)
	("C-x t d"   . treemacs-select-directory)
	("C-x t B"   . treemacs-bookmark)
	("C-x t C-t" . treemacs-find-file)
	("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

;; Ivy Configuration -----------------------------------------------------------

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

;; NOTE: The first time you load your configuration on a new machine, you'll
;; need to run the following command interactively so that mode line icons
;; display correctly:
;;
;; M-x all-the-icons-install-fonts

(use-package all-the-icons
  :ensure t)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package doom-themes
  :init (load-theme 'doom-nord t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

;; (use-package ivy-rich
;;   :init
;;   (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; ----- Magit -----
(use-package magit
  :ensure t)

;; ----- Key Binding Configuration -----

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package general
  :config
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (rune/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :ensure t
  :after evil
  :init
  (evil-collection-init))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(rune/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

;; Projectile Configuration ----------------------------------------------------

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/Projects/Code")
    (setq projectile-project-search-path '("~/Projects/Code")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

;; Org Mode Configuration ------------------------------------------------------
(defun efs/org-mode-setup ()
  ;;(org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(setq org-directory "~/Notes/")
(setq org-refile-targets '((org-agenda-files :maxlevel . 1)))
(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)
(setq org-refile-allow-creating-parent-nodes 'confirm)

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")

  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (setq org-agenda-files
	'("~/Notes/tasks.org"
	  "~/Notes/buy.org"
	  "~/Notes/links.org"
	  "~/Notes/notes.org"
	  "~/sites/stallmer/content-org/all-posts.org"))

  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)

  (setq org-todo-keywords
    '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
      (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))


  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  (setq org-tag-alist
    '((:startgroup)
       ; Put mutually exclusive tags here
       (:endgroup)
       ("@errand" . ?E)
       ("@home" . ?H)
       ("@work" . ?W)
       ("agenda" . ?a)
       ("planning" . ?p)
       ("publish" . ?P)
       ("batch" . ?b)
       ("note" . ?n)
       ("idea" . ?i)))

  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
   '(("d" "Dashboard"
     ((agenda "" ((org-deadline-warning-days 7)))
      (todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))
      (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

    ("n" "Next Tasks"
     ((todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))))

    ("W" "Work Tasks" tags-todo "+work-email")

    ;; Low-effort next actions
    ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
     ((org-agenda-overriding-header "Low Effort Tasks")
      (org-agenda-max-todos 20)
      (org-agenda-files org-agenda-files)))

    ("w" "Workflow Status"
     ((todo "WAIT"
            ((org-agenda-overriding-header "Waiting on External")
             (org-agenda-files org-agenda-files)))
      (todo "REVIEW"
            ((org-agenda-overriding-header "In Review")
             (org-agenda-files org-agenda-files)))
      (todo "PLAN"
            ((org-agenda-overriding-header "In Planning")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "BACKLOG"
            ((org-agenda-overriding-header "Project Backlog")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "READY"
            ((org-agenda-overriding-header "Ready for Work")
             (org-agenda-files org-agenda-files)))
      (todo "ACTIVE"
            ((org-agenda-overriding-header "Active Projects")
             (org-agenda-files org-agenda-files)))
      (todo "COMPLETED"
            ((org-agenda-overriding-header "Completed Projects")
             (org-agenda-files org-agenda-files)))
      (todo "CANC"
            ((org-agenda-overriding-header "Cancelled Projects")
             (org-agenda-files org-agenda-files)))))))

  (add-hook 'orgcapture-mode-hook 'evil-insert-state)
  (setq org-capture-templates
	`(
	  ("n" "Note" entry (file, (concat org-directory "notes.org"))
	   "* %?\nEntered on %U\n  %i\n  %a" :prepend t)
	  ("t" "Task" entry (file, (concat org-directory "tasks.org"))
	   "* TODO %?\n  %u\n  %a")
	  ("p" "Protocol" entry (file, (concat org-directory "links.org"))
	   "* %u [[%:link][%:description]]\n %?\n %:initial" :prepend t)
	  ("l" "Protocol link" entry (file, (concat org-directory "links.org"))
	   "* %u [[%:link][%:description]] \n %?" :prepend t)
	  ("F" "elfeed RSS" entry (file ,(concat org-directory "elfeed.org"))
	   "* [[%:link][%:description]] %^g")
	  ))

;; Populates only the EXPORT_FILE_NAME property in the inserted heading.
(with-eval-after-load 'org-capture
  (defun org-hugo-new-subtree-post-capture-template ()
    "Returns `org-capture' template string for new Hugo post.
See `org-capture-templates' for more information."
    (let* ((title (read-from-minibuffer "Post Title: ")) ;Prompt to enter the post title
           (fname (org-hugo-slug title)))
      (mapconcat #'identity
                 `(
                   ,(concat "* TODO " title)
                   ":PROPERTIES:"
                   ,(concat ":EXPORT_FILE_NAME: " fname)
                   ":END:"
                   "%?\n")          ;Place the cursor here finally
                 "\n")))

  (add-to-list 'org-capture-templates
               '("h"                ;`org-capture' binding + h
                 "Hugo post"
                 entry
                 ;; It is assumed that below file is present in `org-directory'
                 ;; and that it has a "Blog Ideas" heading. It can even be a
                 ;; symlink pointing to the actual location of all-posts.org!
                 (file+olp "all-posts.org" "Post Ideas")
                 (function org-hugo-new-subtree-post-capture-template))))

  
  (define-key global-map (kbd "C-c j")
    (lambda () (interactive) (org-capture nil "jj")))

  (efs/org-font-setup))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))


;; ----- EMMS Settings -----
(use-package ox-hugo
  :ensure t
  :pin melpa
  :after ox
  :custom
  (org-hugo-date-format "%Y-%m-%d"))

;; ;; ----- EMMS Settings -----
;; (use-package emms
;;   :ensure t
;;   :bind (("C-c k" . emms-pause)
;; 	 ("C-c L" . emms-next)
;; 	 ("C-c J" . emms-previous)
;; 	 ("C-c l" . emms-seek-forward)
;; 	 ("C-c j" . emms-seek-backward))
;;   :config
;;   (require 'emms-setup)
;;   (emms-all)
;;   (emms-default-players)
;;   (setq emms-source-file-default-directory "~/Music"))

;; ;; ----- mu4e Settings -----
;; (use-package mu4e
;;   :ensure t
;;   :config
;;   (setq mu4e-get-mail-command "mbsync -a -c ~/.config/isync/mbsyncrc"))

;; ----- elfeed Settings -----
(use-package elfeed
  :ensure t
  :bind (("C-x w" . elfeed)
	 :map elfeed-search-mode-map
	 ("C-c v" . sad/elfeed-view-mpv)
	 ("C-c u" . elfeed-update)
	 :map elfeed-show-mode-map
	 ("C-c p" . sad/elfeed-show-play-enclosure))
  :config
  (setq elfeed-search-filter "@6-months-ago +unread -reddit"))

(use-package elfeed-protocol
  :ensure t
  :config
  (setq elfeed-protocol-feeds '(("owncloud+https://stephen@nextcloud.steda.net"
:password "4DMHd-atLiX-CRecc-2EZej-JRxLf")))
  (setq elfeed-protocol-enabled-protocols '(owncloud))
  (elfeed-protocol-enable)
  (setq elfeed-protocol-owncloud-maxsize 1000)
  (setq elfeed-protocol-owncloud-update-with-modified-time t)
  (setq elfeed-protocol-owncloud-fetch-category-as-tag t)
  (setq elfeed-use-curl t)
  (elfeed-set-timeout 36000)
  (setq elfeed-curl-extra-arguments '("--insecure")))

  ;; (use-package elfeed-org
  ;; :ensure t
  ;; :config
  ;; (elfeed-org)
  ;; (setq rmh-elfeed-org-files (list "~/Notes/elfeed.org"))
  ;; (setq rmh-elfeed-org-tree-id "elfeed"))

(add-to-list 'evil-emacs-state-modes 'elfeed-search-mode)
(add-to-list 'evil-emacs-state-modes 'elfeed-show-mode)

(defun sad/elfeed-v-mpv (url)
  "Watch a video from URL in MPV"
  (async-shell-command (format "~/.local/bin/mpv-append-to-playlist '%s'" url)))

(defun sad/elfeed-view-mpv (&optional use-generic-p)
  "Youtube-feed link"
  (interactive "P")
  (let ((entries (elfeed-search-selected)))
    (cl-loop for entry in entries
	     do (elfeed-untag entry 'unread)
	     when (elfeed-entry-link entry)
	     do (sad/elfeed-v-mpv it))
    (mapc #'elfeed-search-update-entry entries)
    (unless (use-region-p) (forward-line))))

(defun sad/elfeed-podcast-tagger (entry)
  (when (elfeed-entry-enclosures entry)
    (elfeed-tag entry 'podcast)))

(defun sad/elfeed-show-play-enclosure (enclosure-index)
  (interactive (list (elfeed--enclosure-maybe-prompt-index elfeed-show-entry)))
  (let ((url (car
              (elt
               (elfeed-entry-enclosures elfeed-show-entry)
               (- enclosure-index 1)))))
    (async-shell-command (format "~/.local/bin/mpv-append-to-playlist '%s'" url) "*mpv*")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("05626f77b0c8c197c7e4a31d9783c4ec6e351d9624aa28bc15e7f6d6a6ebd926" default))
 '(package-selected-packages
   '(treemacs-magit treemacs-icons-dired treemacs-projectile treemacs-evil treemacs elfeed-protocol elfeed-org mastodon yasnippet-snippets yasnippet ox-hugo all-the-icons-nerd-fonts mu4e all-the-icons-completion all-the-icons-dired all-the-icons-ibuffer lua-mode elfeed evil-magit which-key visual-fill-column use-package rainbow-delimiters ivy-rich hydra helpful general forge evil-collection doom-themes doom-modeline counsel-projectile command-log-mode all-the-icons))
 '(warning-suppress-types '((emacs))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
