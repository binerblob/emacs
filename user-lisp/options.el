;; General Emacs config
(set-face-attribute 'default nil :family "Iosevka Nerd Font" :height 135 :weight 'normal)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq-default indent-tabs-mode t)
(setq-default tab-width 4)

(setq inhibit-startup-screen t)
(recentf-mode 1)

(show-paren-mode 1)
(global-display-line-numbers-mode 1)

(windmove-default-keybindings)
(setq-default cursor-type 'bar)

;; Colorschemes to use
(use-package gruber-darker-theme :ensure t)
(use-package pache-dark-theme    :ensure t)
(use-package hc-zenburn-theme    :ensure t)

(load-theme 'pache-dark t)

;; Some more editing macros (say that again?)
(defun newline-below-cursor ()
  "Insert a newline below the cursor."
  (interactive)
  (end-of-line)
  (newline)
  (indent-according-to-mode))

(defun newline-above-cursor ()
  "Insert a newline above the cursor."
  (interactive)
  (goto-char (line-beginning-position))
  (save-mark-and-excursion
  (newline))
  (indent-according-to-mode))

(defun mark-line ()
  "Put mark in across a line."
  (interactive)
  (beginning-of-line)
  (set-mark (point))
  (end-of-line))

(keymap-set global-map "C-<return>" 'newline-below-cursor)
(keymap-set global-map "C-c <return>" 'newline-above-cursor)
(keymap-set global-map "S-SPC" 'mark-line)

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
