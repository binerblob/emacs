(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(load-file "~/.config/emacs/user-lisp/utils.el")

(load-files-from-directory
 "~/.config/emacs/user-lisp/"
 '(
   ;; Modal editing
   "meow.el"

   ;; Terminal emulator
   "vterm.el"

   ;; fzf-lua/telescope-like functionality
   "vertico.el"

   ;; Smooth scrolling
   "ultra-scroll.el"))

;; Colorschemes
(use-package gruber-darker-theme :ensure t)
(use-package miasma-theme        :ensure t)
(use-package moe-theme           :ensure t)
(use-package doom-themes         :ensure t)
(use-package pache-dark-theme    :ensure t)

(load-theme 'pache-dark t)

;; Org-mode config
(require 'org)
(setq org-pretty-entities t)
(add-hook 'org-mode-hook (lambda () (display-line-numbers-mode -1)))

;; General Emacs config
(set-face-attribute 'default nil :family "Iosevka Nerd Font" :height 130 :weight 'normal)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)

(windmove-default-keybindings)

;; Point backup and autosave files to somewhere else
(make-directory "~/.local/share/emacs/auto-saves" t)

(setq backup-directory-alist `((".*" . "~/.local/share/emacs/auto-saves")))
(setq auto-save-file-name-transforms `((".*" "~/.local/share/emacs/auto-saves/" t)))

;; Point Custom file to an another location
(setq custom-file "~/.config/emacs/custom.el")
(load custom-file)
