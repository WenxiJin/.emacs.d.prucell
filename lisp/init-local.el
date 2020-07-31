;;; init-local.el --- wjn local settings -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(when (maybe-require-package 'counsel-gtags)
  (with-eval-after-load 'counsel-gtags
    (define-key counsel-mode-map (kbd "C-.") 'counsel-gtags-dwim)))

(add-hook 'java-mode-hook
          (function
           (lambda ()
             (setq tab-width 4)
             )))

(provide 'init-local)
;;; init-local.el ends here
