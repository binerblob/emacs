;;#---------------#;;
;;# Prerequisites #;;
;;#---------------#;;

;; Extra package repo
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Optimization
(setq gc-cons-threshold 100000000)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold 16777216)))

;;#-----------------------#;;
;;# General Emacs Options #;;
;;#-----------------------#;;

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(windmove-default-keybindings)

(set-face-attribute 'default nil :family "Iosevka Nerd Font" :height 135 :weight 'normal)

(setq-default indent-tabs-mode -1)
(setq-default tab-width 4)
(setq-default cursor-type 'bar)
(setq-default inhibit-startup-screen t)

;; Point backup and autosave files to somewhere else
(make-directory "~/.local/share/emacs/auto-saves" t)

(setq backup-directory-alist `((".*" . "~/.local/share/emacs/auto-saves")))
(setq auto-save-file-name-transforms `((".*" "~/.local/share/emacs/auto-saves/" t)))

;; Point Custom file to an another location
(setq custom-file
      (expand-file-name "custom.el" user-emacs-directory))

(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))

(load custom-file)

;;#-----------------------#;;
;;# Interface Enhancement #;;
;;#-----------------------#;;

;; Colorschemes
(defvar theme-list
  '(gruvbox-theme
    gruber-darker-theme
    pache-dark-theme
    ef-themes
    zenburn-theme))

(dolist (theme theme-list)
  (unless (package-installed-p theme)
    (package-install theme)))

(load-theme 'gruvbox t)

;; Ultra-scroll (smooth scrolling)
(use-package ultra-scroll
  :ensure t
  :init
  (setq scroll-conservatively 1 ; or whatever value you prefer, since v0.4
        scroll-margin 0)        ; important: scroll-margin>0 not yet supported
  :config
  (ultra-scroll-mode 1))

;; Indent bars
(use-package indent-bars
  :ensure t
  :custom
  (indent-bars-starting-column 0)
  (indent-bars-no-descend-lists 'skip)
  (indent-bars-treesit-support t)
  (indent-bars-highlight-current-depth nil)
  (indent-bars-display-on-blank-lines t)
  (indent-bars-treesit-ignore-blank-lines-types '("module"))
  :config
  ;;(add-hook 'prog-mode-hook (lambda () (setq indent-tabs-mode t)))
  (add-hook 'rust-ts-mode-hook (lambda () (setq indent-bars-no-descend-lists nil)))
  :hook
  ((prog-mode) . indent-bars-mode))

;; Restart Emacs command
(use-package restart-emacs :ensure t)

;;#---------------------#;;
;;# Editing Enhancement #;;
;;#---------------------#;;

;; Vim's normal mode o
(defun newline-below-cursor ()
  "Insert a newline below the cursor."
  (interactive)
  (end-of-line)
  (newline)
  (indent-according-to-mode))

;; Vim's normal mode O
(keymap-set global-map "C-<return>" 'newline-below-cursor)

(defun newline-above-cursor ()
  "Insert a newline above the cursor."
  (interactive)
  (goto-char (line-beginning-position))
  (save-mark-and-excursion
  (newline))
  (indent-according-to-mode))

(keymap-set global-map "C-c <return>" 'newline-above-cursor)

;; Vim's normal mode V
(defun mark-line ()
  "Put mark in across a line."
  (interactive)
  (end-of-line)
  (set-mark (point))
  (beginning-of-line))

(keymap-set global-map "C-c C-SPC" 'mark-line)

;; Multiple cursors
(use-package multiple-cursors :ensure t)

(require 'multiple-cursors)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-line)

(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(add-hook 'multiple-cursors-mode-hook
		  (lambda ()
			(setq cursor-type (if multiple-cursors-mode 'box 'bar))))

;;#---------------------------------#;;
;;# LSP, Treesitter, Autocompletion #;;
;;#---------------------------------#;;

;; Autocompletion
(use-package corfu
  :ensure t
  ;; Optional customizations
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-quit-at-boundary t)     ;; Never quit at completion boundary
  (corfu-quit-no-match t)        ;; Never quit, even if there is no match
  (corfu-preview-current nil)    ;; Disable current candidate preview
  (corfu-preselect 'prompt)      ;; Preselect the prompt
  (corfu-on-exact-match 'insert) ;; Configure handling of exact matches
  (corfu-auto t)
  :init
  (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode))

;; Treesitter
(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt) ; Prompts to install missing grammars when opening a file
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; LSP Client config
(require 'eglot)

(use-package rust-mode :ensure t) ;; Rust
(add-to-list 'eglot-server-programs
			 '((rust-ts-mode)
			   . ("rust-analyzer" :initializationOptions (:check (:command "clippy")))))

(use-package dart-mode :ensure t) ;; Dart
(add-to-list 'eglot-server-programs
			 '((dart-ts-mode)
			   . ("dart" "language-server")))

(add-hook 'prog-mode-hook #'eglot-ensure)

;;#------------------#;;
;;# Minibuffer Stack #;;
;;#------------------#;;

(use-package vertico
  :ensure t
  :custom
  (vertico-scroll-margin 0) ;; Different scroll margin
  (vertico-count 10) ;; Show more candidates
  (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  (vertico-posframe-width 100)
  :init
  (vertico-mode))

(use-package vertico-posframe
  :ensure t
  :after vertico
  :config (vertico-posframe-mode 0))

;; Completion style for matching regexps in any order
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  :ensure t
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init

  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;;#-------------#;;
;;# Major Modes #;;
;;#-------------#;;

;; Image viewer
(add-hook 'image-mode-hook
		  (lambda ()
            ;; Hide the cursor
            (blink-cursor-mode 0)
			(setq cursor-type nil)))

;; Emulate a terminal
(use-package eat
  :ensure t
  :config
  (add-hook 'eshell-load-hook #'eat-eshell-mode)
  (add-hook 'eshell-load-hook #'eat-eshell-visual-command-mode))

(defun split-and-eat ()
  "Split the window vertically and launch Eat terminal in the new pane."
  (interactive)
  (split-window-below)
  (other-window 1)
  (eat))

(global-set-key (kbd "C-c e") 'split-and-eat)

;; Dired
(setq dired-listing-switches "-al --group-directories-first")
(setenv "LC_COLLATE" "C")

(require 'dired-x)

(setq dired-omit-files
	  (rx bol (or (seq "." (not (any ".")))
	      "auto-save-list"
	      "elpa"
	      "transient"
	      "history"
	      "recentf"
	      "custom.el"
	      "eln-cache"
	      "eshell"
	      "persist-text-scale")))

;; Org-mode
(require 'org)
(setq org-pretty-entities t)
(setq org-hide-emphasis-markers t)

;; Magit, Git wrapper
(use-package magit :ensure t)

;;#---------------------#;;
;;# Emacs Configuration #;;
;;#---------------------#;;

(use-package emacs
  :custom
  ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
  ;; to switch display modes.
  (context-menu-mode t)
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt))
  
  ;; TAB cycle if there are only few candidates
  ;; (completion-cycle-threshold 3)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (tab-always-indent 'complete)

  ;; Emacs 30 and newer: Disable Ispell completion function.
  ;; Try `cape-dict' as an alternative.
  (text-mode-ispell-word-completion nil)

  ;; Hide commands in M-x which do not apply to the current mode.  Corfu
  ;; commands are hidden, since they are not used via M-x. This setting is
  ;; useful beyond Corfu.
  (read-extended-command-predicate #'command-completion-default-include-p)
  
  :init
  (global-display-line-numbers-mode 1)
  
  :hook
  ((eat-mode compilation-mode org-mode dired-mode) . (lambda () (display-line-numbers-mode -1))))
