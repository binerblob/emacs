(use-package persist-text-scale
  :ensure t
  :custom
  ;; Time interval, in seconds, between automatic saves of text scale data.
  ;; If set to an integer value, enables periodic autosaving of persisted text
  ;; scale information at the specified interval.
  ;; If set to nil, disables timer-based autosaving entirely.
  (persist-text-scale-autosave-interval (* 7 60))
  :config
  (persist-text-scale-mode))
