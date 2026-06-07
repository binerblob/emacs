;; Enable view-mode when entering read-only
(setq view-read-only t)

;; Enhanced keybindings
(with-eval-after-load 'view
  ;; Navigation
  (define-key view-mode-map (kbd "n") 'next-line)
  (define-key view-mode-map (kbd "p") 'previous-line)
  (define-key view-mode-map (kbd "f") 'forward-char)
  (define-key view-mode-map (kbd "b") 'backward-char)

  ;; Selection
  (define-key view-mode-map (kbd "SPC") 'set-mark-command)
  (define-key view-mode-map (kbd "g") 'keyboard-quit))

(defun view-mode-toggle ()
  (interactive)
  (let ((inhibit-message t)) (view-mode 'toggle))
  (message "%s" (if view-mode "View mode enabled" "Insert mode enabled")))

;; Quick toggle keys
(keymap-global-set "C-<tab>" #'view-mode-toggle)

;; Optional: return to view-mode after saving
(add-hook 'after-save-hook 
          (lambda ()
            (when (and buffer-file-name (not view-mode))
              (view-mode 1))))

;; Visual feedback - box cursor in view mode, bar when editing
(add-hook 'view-mode-hook
          (defun view-mode-hookee+ ()
            (setq cursor-type (if view-mode 'box 'bar))))

;; Enable view-mode for files by default
(add-hook 'find-file-hook 
          (lambda ()
            (unless (or (derived-mode-p 'dired-mode))
              (view-mode 1))))
