;;; .emacs --- my emacs configuration

;;; Commentary:
;; This is hacked together, please don't write code like this.

;;; Code:

;; (set-default-font "mono 15")

(defun my/disable-scroll-bars (frame)
  "Disable scroll bar all frames."
  (modify-frame-parameters frame
						   '((vertical-scroll-bars . nil)
							 (horizontal-scroll-bars . nil))))
(add-hook 'after-make-frame-functions 'my/disable-scroll-bars)

;; Fix scrolling
(setq redisplay-dont-pause t
	  scroll-margin 1
	  scroll-step 1
	  scroll-conservatively 10000
	  scroll-preserve-screen-position 1)

;; Enable showing trailing whitespace.
(setq-default show-trailing-whitespace t)

;; AAAAAAAAAA (enable show-paren-mode always)
(setq show-paren-delay 0)
(show-paren-mode 1)

;; Close all open buffers
(defun close-all-buffers ()
  "Close all open buffers."
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

;; Enable M-x kill-process (to kill the current buffer's process).
(defun kill-process ()
  "Kill the process in the current buffer."
  (interactive)
  (delete-process nil))

(menu-bar-mode -1)                ; disable menu bar
(tool-bar-mode -1)                ; disable tool bar
(blink-cursor-mode 0)             ; disable cursor blink
(scroll-bar-mode -1)              ; disable scroll bar
(setq inhibit-startup-screen t)   ; disable welcome screen
(setq ring-bell-function 'ignore) ; disable bell

;; Only apply one theme at a time
(defadvice load-theme (before theme-dont-propagate activate)
  "Disable theme before loading new one."
  (mapcar #'disable-theme custom-enabled-themes))

;; Other settings
(setq-default tab-width 4)
(setq backup-directory-alist `(("." . "~/.emacs_backup")))

;;; Emacs $PATH
(setenv "PATH" (concat (getenv "PATH") "~/go/bin"))
(setq exec-path (append exec-path '("~/go/bin")))

;;; generate ctags
(setq path-to-ctags "/usr/bin/ctags")

(defun create-tags (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (shell-command
   (format "%s -f TAGS -e -R %s" path-to-ctags (directory-file-name dir-name))))

(defun transparency (value)
  "Sets the transparency of the frame window.  0=transparent/100=opaque"
  (interactive "nTransparency Value 0 - 100 opaque:")
  (set-frame-parameter (selected-frame) 'alpha value))

(defun indent-buffer ()
  "Indent the current buffer."
  (interactive)
  (save-excursion
	(indent-region (point-min) (point-max) nil)))

;; Setup package management
(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)

;; install use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; use-package configuration
(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; Packages
(use-package rainbow-delimiters
  :config
  (rainbow-delimiters-mode))
(use-package slime
  :config
  (setq inferior-lisp-program "/usr/bin/sbcl"))

(use-package forth-mode)
(use-package geiser)
(use-package paredit)
(use-package fzf)
(use-package htmlize)
(use-package haskell-mode
  :config
  (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)

  ;; Ignore compiled Haskell files in filename completions
  (add-to-list 'completion-ignored-extensions ".hi")

  (setq haskell-process-type 'stack-ghci)
  (setq haskell-process-log t)

  ;; https://github.com/rexim/dotfiles/blob/master/.emacs.rc/haskell-mode-rc.el
										;(add-hook 'haskell-mode-hook 'haskell-indent-mode)
  (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
  (add-hook 'haskell-mode-hook 'haskell-doc-mode)
  :bind (:map haskell-mode-map
			  ("C-c C-l" . haskell-process-load-or-reload)
			  ("C-c C-z" . haskell-interactive-switch)))
(use-package markdown-mode )
(use-package fennel-mode)
(use-package lua-mode)
(use-package rust-mode)
(use-package elixir-mode)
(use-package racket-mode)
(use-package clojure-mode)
(use-package cider)
(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))
(use-package yaml-mode)
(use-package go-mode
  :config
  (add-hook 'before-save-hook 'gofmt-before-save)
  (setq gofmt-command "goimports"))

(use-package flycheck
  :config
  (setq flycheck-check-syntax-automatically '(mode-enabled save))
  (add-hook 'after-init-hook #'global-flycheck-mode)
  )
(use-package helm
  :config
  ;; Enable helm
  (require 'helm-config)
  (helm-mode 1))

(use-package auto-complete
  :config
  (setq ac-delay 0)
  (ac-config-default))

(use-package evil
  :config
  ;; evil packages
  (use-package evil-leader
	:config
	(global-evil-leader-mode)
	(evil-leader/set-leader "<SPC>")
	(evil-leader/set-key
	  "f" 'fzf
	  "p" 'previous-buffer
	  "n" 'next-buffer
	  "=" 'indent-buffer
	  "c" 'kill-process
	  )

	;; Golang  bindings
	(evil-leader/set-key-for-mode 'go-mode
	  "gd" 'godef-jump
	  )
	)

  ;; Enable evil-mode
  (evil-mode t)
  (setq evil-want-C-i-jump nil)
  )
;; org-mode
(use-package org
  :config
  ;; I know what i'm running (not really send help fast)
  (setq org-confirm-babel-evaluate nil)

  ;; Better source code window editing
  (setq org-src-window-setup 'other-window)

  ;; Highlight and indent source code blocks
  (setq org-src-fontify-natively t)
  (setq org-src-tab-acts-natively t)
  (setq org-edit-src-content-indentation 0)

  (progn
	(defun imalison:org-inline-css-hook (exporter)
	  "Insert custom inline css to automatically set the
background of code to whatever theme I'm using's background"
	  (when (eq exporter 'html)
		(let* ((my-pre-bg (face-background 'default))
			   (my-pre-fg (face-foreground 'default)))
		  (setq
		   org-html-head-extra
		   (concat
			org-html-head-extra
			(format "<style type=\"text/css\">\n pre.src {background-color: %s; color: %s;}</style>\n"
					my-pre-bg my-pre-fg))))))

	(add-hook 'org-export-before-processing-hook 'imalison:org-inline-css-hook)))

;; org-mode packages
(use-package ob-go)
(use-package ob-rust)
(use-package org-bullets
  :config
  ;; Enable org-bullets in org mode
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; All the themes
(use-package gruber-darker-theme)
(use-package gruvbox-theme)
(use-package solarized-theme)

;; org-mode settings
(setq org-hide-emphasis-markers t)
(setq org-src-tab-acts-natively t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes t)
 '(package-selected-packages
   '(evil-surround paredit geiser forth-mode fennel-mode racket-mode cider-mode cider clojure-mode elixir-mode evil-magit magit yaml-mode use-package transient spacemacs-theme solarized-theme slime rust-mode rainbow-delimiters org-bullets ob-rust ob-go markdown-mode lua-mode htmlize haskell-mode gruvbox-theme gruber-darker-theme go-mode git-commit fzf flycheck evil-leader euslisp-mode auto-complete)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(load-theme 'gruvbox-dark-hard)
