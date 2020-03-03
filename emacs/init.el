;; UI Cleanups
(setq inhibit-splash-screen t)
(tool-bar-mode 0)
(menu-bar-mode 0)
(toggle-scroll-bar 0)
(column-number-mode 1)
(set-foreground-color "white")
(set-background-color "black")

;; Control stuff
(windmove-default-keybindings)
(fset 'yes-or-no-p 'y-or-n-p)
(require 'ido)
(ido-mode t)
(global-set-key (kbd "C-c r") 'revert-buffer)

(defun set-pythonpath (file-dir)
  (shell-command (format "cd %s" file-dir))
  (setenv "PYTHONPATH" (shell-command-to-string "git rev-parse --show-toplevel"))
  (setenv "DJANGO_SETTINGS_MODULE" "cpanel.settings")
)


(defun repo-root (file-dir)
  (shell-command (format "cd %s" file-dir))
  (substring (shell-command-to-string "git rev-parse --show-toplevel") 0 -1)
)

(defun find-linter (file-dir)
  (message (concat (repo-root file-dir) "/lint"))
  (setq linter (concat (repo-root file-dir) "/lint"))
  (message linter)
  (if (file-executable-p linter) linter "epylint")
)

;; Python flymake
(when (load "flymake" t)
  (defun flymake-pylint-init ()
    (message (concat "Using linter: " (find-linter (file-name-directory buffer-file-name))))
    (set-pythonpath (file-name-directory buffer-file-name))
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
		       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list (find-linter (file-name-directory buffer-file-name)) (list  local-file))))

  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pylint-init))
)
(setq flymake-log-level -1)

;; Auto-enable flymake when in python mode
(add-hook 'python-mode-hook (lambda() (flymake-mode t)))

;; Highlight trailing whitespace
(add-hook 'python-mode-hook (lambda() (setq show-trailing-whitespace t)))
(add-hook 'term-mode-hook (lambda() (setq show-trailing-whitespace nil)))

;; Fonty-fonty
(set-face-attribute 'default nil
		    :family "Inconsolata" :height 110)

;; Keep reviewers happy
(setq-default indent-tabs-mode nil)
(setq-default show-trailing-whitespace t)

;; Auto-save bullshit

;; Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs.d/.
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(auto-save-file-name-transforms (quote ((".*" "~/.emacsbackup/autosaves/\\1" t))))
 '(backup-directory-alist (quote ((".*" . "~/.emacsbackup/backups/"))))
 '(ecb-layout-name "left7")
 '(ecb-options-version "2.40")
 '(ecb-source-path (quote (("/home/ted/projects/coupon_mnarketplace/coupon_marketplace/webapp/jsapp" "jsapp") ("/home/ted/projects/coupon_marketplace/coupon_marketplace" "dealmint"))))
 '(ecb-tree-indent 2))


;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacsbackup/autosaves/" t)
(make-directory "~/.emacsbackup/backups" t)

;; emacs-server, start, and let C-x k (kill buffer) do the same as C-x #
(server-start)
(add-hook 'server-switch-hook
          (lambda ()
            (when (current-local-map)
              (use-local-map (copy-keymap (current-local-map))))
            (when server-buffer-clients
              (local-set-key (kbd "C-x k") 'server-edit))))
;; butthurt
(setq make-backup-files nil)

;; lang modes
(add-to-list 'load-path (expand-file-name "~/.emacs.d"))
(add-to-list 'load-path "~/.emacs.d/rhtml")
(require 'rhtml-mode)
(require 'scss-mode)
(require 'jinja2-mode)
(require 'js)

(add-to-list 'auto-mode-alist '("\\.html$" . jinja2-mode))
(add-to-list 'auto-mode-alist '("\\.py$" . python-mode))

;; mail
(setq user-full-name "Ted Dziuba")
(setq user-mail-address "ted@milo.com")
(setq mail-specify-envelope-from t
      mail-envelope-from 'header)

;(split-window-horizontally)
;(split-window-horizontally)
(balance-windows-area)

(require 'autopair)
(autopair-global-mode t)

(global-unset-key [(control z)])
(global-unset-key [(control x)(control z)])

(require 'less-mode)
(add-to-list 'auto-mode-alist '("\\.less$" . less-css-mode))

(require 'flymake-node-jshint)
(add-hook 'js-mode-hook (lambda () (flymake-mode 1)))

(require 'php-mode)

(require 'coffee-mode)
(defun coffee-custom ()
  "coffee-mode-hook"
 (set (make-local-variable 'tab-width) 2))

(add-hook 'coffee-mode-hook
  '(lambda() (coffee-custom)))

(require 'flymake-coffee)
(add-hook 'coffee-mode-hook 'flymake-coffee-load)

(require 'clojure-mode)
