;;; init-local.el --- wjn local settings -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(add-hook 'c-mode-hook 'counsel-gtags-mode)
(add-hook 'c++-mode-hook 'counsel-gtags-mode)

(add-hook 'java-mode-hook
          (function
           (lambda ()
             (setq tab-width 4)
             )))
(add-hook 'java-mode-hook 'counsel-gtags-mode)

(when (maybe-require-package 'counsel-gtags)
  (with-eval-after-load 'counsel-gtags
    (define-key counsel-gtags-mode-map (kbd "<f12>") 'counsel-gtags-dwim)))

(provide 'init-local)
;;; init-local.el ends here
