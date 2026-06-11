(use-package grid
  :ensure t
  :init
  (unless (package-installed-p 'grid)
    (package-vc-install "https://github.com/ichernyshovvv/grid.el")))

(require 'grid)

(defun mk-dashboard-menu ()
  (enlight-menu
   '(("Quick Access"
      ("Emacs Config"
       (dired "~/.config/emacs")
       "e")
      ("Recent Files"
       (recentf-open-files)
       "r")))))

(use-package enlight
  :ensure t
  :custom
  (enlight-content
   (concat
    (mk-dashboard-menu))))

(add-hook 'enlight-mode-hook (lambda () (display-line-numbers-mode -1)))

(setopt initial-buffer-choice #'enlight)
