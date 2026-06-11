;; Compilation mode
(add-hook 'compilation-mode-hook
	  (lambda ()
	    (display-line-numbers-mode -1)))

;; Prog-mode config
(add-hook 'prog-mode-hook
	  (lambda ()
	    (display-line-numbers-mode 1)
	    (show-paren-mode 1)))

;; Org-mode config
(require 'org)
(setq org-pretty-entities t)
(setq org-hide-emphasis-markers t)
(add-hook 'org-mode-hook
	  (lambda ()
	    (display-line-numbers-mode -1)
	    (show-paren-mode -1)))

;; Image-mode config
(add-hook 'image-mode-hook
          (lambda ()
            ;; Disable line numbers
            (display-line-numbers-mode -1)
            ;; Hide the cursor
            (blink-cursor-mode 0)
	    (setq cursor-type nil)
	    (keymap-set global-map "[" 'image-previous-file)
	    (keymap-set global-map "]" 'image-next-file)))

;; Dired mode
(add-hook 'dired-mode-hook
	  (lambda ()
	    (display-line-numbers-mode -1)))

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

;; config files
(add-hook 'conf-space-mode-hook
	  (lambda ()
	    (display-line-numbers-mode 1)))
