(defun reload ()
  "Reloads the configuration file."
  (interactive)
  (load-file (expand-file-name "~/.config/emacs/init.el")))

(defun load-files-from-directory (dir files)
  (dolist (file files)
    (load-file (expand-file-name file dir))))
