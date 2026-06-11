(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(load-file "~/.config/emacs/user-lisp/core.el")

(load-files-from-directory "~/.config/emacs/user-lisp/packages"
 '("multiple-cursors.el"
   "vertico.el"
   "ultra-scroll.el"
   "restart-emacs.el"
   "indent-bars.el"
   "magit.el"))

(load-files-from-directory "~/.config/emacs/user-lisp/"
 '("options.el"
   "language.el"
   "modes.el"))
