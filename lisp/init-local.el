;;; init-local.el --- wjn local settings -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(when (maybe-require-package 'counsel-gtags)
  (with-eval-after-load 'counsel-gtags
    (define-key counsel-gtags-mode-map (kbd "<f12>") 'counsel-gtags-dwim)))
(add-hook 'c-mode-hook 'counsel-gtags-mode)
(add-hook 'c++-mode-hook 'counsel-gtags-mode)
(add-hook 'java-mode-hook 'counsel-gtags-mode)

;; (when (maybe-require-package 'google-c-style)
;;   (add-hook 'c-mode-hook 'google-set-c-style)
;;   (add-hook 'c++-mode-hook 'google-set-c-style)
;;   )

;; java-mode
(defun my/point-in-defun-declaration-p ()
  (let ((bod (save-excursion (c-beginning-of-defun)
                             (point))))
    (<= bod
        (point)
        (save-excursion (goto-char bod)
                        (re-search-forward "{")
                        (point)))))

(defun my/is-string-concatenation-p ()
  "Returns true if the previous line is a string concatenation"
  (save-excursion
    (let ((start (point)))
      (forward-line -1)
      (if (re-search-forward " \\\+$" start t) t nil))))

(defun my/inside-java-lambda-p ()
  "Returns true if point is the first statement inside of a lambda"
  (save-excursion
    (c-beginning-of-statement-1)
    (let ((start (point)))
      (forward-line -1)
      (if (search-forward " -> {" start t) t nil))))

(defun my/trailing-paren-p ()
  "Returns true if point is a training paren and semicolon"
  (save-excursion
    (end-of-line)
    (let ((endpoint (point)))
      (beginning-of-line)
      (if (re-search-forward "[ ]*);$" endpoint t) t nil))))

(defun my/prev-line-call-with-no-args-p ()
  "Return true if the previous line is a function call with no arguments"
  (save-excursion
    (let ((start (point)))
      (forward-line -1)
      (if (re-search-forward ".($" start t) t nil))))

(defun my/arglist-cont-nonempty-indentation (arg)
  (if (my/inside-java-lambda-p)
      '+
    (if (my/is-string-concatenation-p)
        16
      (unless (my/point-in-defun-declaration-p) '++))))

(defun my/statement-block-intro (arg)
  (if (and (c-at-statement-start-p) (my/inside-java-lambda-p)) 0 '+))

(defun my/block-close (arg)
  (if (my/inside-java-lambda-p) '- 0))

(defun my/arglist-close (arg) (if (my/trailing-paren-p) 0 '--))

(defun my/arglist-intro (arg)
  (if (my/prev-line-call-with-no-args-p) '++ 0))

(defun google-set-java-style ()
  "Configures Emacs' built-in java-mode for compliance with the
Java Style Guide."
  (interactive)
  (setq tab-width 4)
  (setq indent-tabs-mode t)
  (setq c-basic-offset 4)

  (c-set-offset 'inline-open           0)
  (c-set-offset 'topmost-intro-cont    '+)
  (c-set-offset 'statement-block-intro 'my/statement-block-intro)
  (c-set-offset 'block-close           'my/block-close)
  (c-set-offset 'knr-argdecl-intro     '+)
  (c-set-offset 'substatement-open     '+)
  (c-set-offset 'substatement-label    '+)
  (c-set-offset 'case-label            '+)
  (c-set-offset 'label                 '+)
  (c-set-offset 'statement-case-open   '+)
  (c-set-offset 'statement-cont        '++)
  (c-set-offset 'arglist-intro         'my/arglist-intro)
  (c-set-offset 'arglist-cont-nonempty '(my/arglist-cont-nonempty-indentation c-lineup-arglist))
  (c-set-offset 'arglist-close         'my/arglist-close)
  (c-set-offset 'inexpr-class          0)
  (c-set-offset 'access-label          0)
  (c-set-offset 'inher-intro           '++)
  (c-set-offset 'inher-cont            '++)
  (c-set-offset 'brace-list-intro      '+)
  (c-set-offset 'func-decl-cont        '++)
  )
(add-hook 'java-mode-hook 'google-set-java-style)
;; (add-hook 'c++-mode-hook 'google-set-java-style)


(c-add-style "Google" google-c-style)
;;; Based on google-c-style, custmise below
(c-add-style "microsoft-style"
             '("Google"
               (c-offsets-alist
                (innamespace . -)
                (inline-open . 0)
                (inher.cont . c-lineup-multi-inher)
                (arglist-cont-nonempty . 0)
                (template-args-cont . +)
                )))
(add-hook 'c++-mode-hook '(lambda ()
                            (c-set-style "microsoft-style")
                            (setq c-basic-offset 2)))


          (provide 'init-local)
;;; init-local.el ends here
