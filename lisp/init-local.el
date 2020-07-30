;;; init-local.el --- wjn local settings -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(add-hook 'java-mode-hook
          (function
           (lambda ()
             (setq tab-width 4)
             )))

(provide 'init-local)
;;; init-local.el ends here
