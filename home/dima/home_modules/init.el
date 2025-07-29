(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)

(setq use-package-always-ensure nil) ;; Отключаем автоматическую установку, т.к. Nix делает это.

(set-frame-parameter (selected-frame) 'alpha '(80 . 80))
(add-to-list 'default-frame-alist '(alpha . (85 . 80)))

;; BASIC UI CONFIGURATION
(setq initial-buffer-choice nil)
(setq make-backup-files nil)
(setq auto-save-default nil)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(column-number-mode)
(global-display-line-numbers-mode t)
(line-number-mode 0)

;; fullscreen
;; (add-hook 'window-setup-hook 'toggle-frame-fullscreen)

;; Blinking cursor
(setq blink-cursor-blinks 0)

;; tabs
(setq-default tab-width             4)
(setq-default c-basic-offset        4)
(setq-default standard-indent       4)

;; line hl mode
(global-hl-line-mode t)

;; image in org mode size
(setq org-image-actual-width 700)

;; Set up the visible bell
(setq visible-bell t)

;; Color cursor
(set-frame-parameter nil 'cursor-color "#ffffff")
(add-to-list 'default-frame-alist '(cursor-color . "#ffffff"))

;; font
;; Если шрифт установлен через Nix, Emacs найдет его
(set-face-attribute 'default nil :font "Hack Nerd Font-12")
(when (display-graphic-p)
  (set-face-attribute 'default nil :font "Hack Nerd Font-12" :height 120))

;; set "gnu" style for c
(setq c-default-style "gnu"
      c-basic-offset 4)

;; garbage
(setq gc-cons-threshold (* 10 1000 1000))
(setq gc-cons-percentage 0.6)

;; auto pair
(electric-pair-mode 1)

;; Scroll
(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)

;; Scroll Mouse
(pixel-scroll-precision-mode t)

;; Split window
(add-to-list 'display-buffer-alist
             '("\\*compilation\\*"
               (display-buffer-at-bottom . ((window-height . 0.1)))
               (display-buffer-below-selected)))

(yas-global-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;FUNCTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; resize window
(defun enlarge-vert ()
  (interactive)
  (enlarge-window 4))

(defun shrink-vert ()
  (interactive)
  (enlarge-window -4))

(defun enlarge-horz ()
  (interactive)
  (enlarge-window-horizontally 4))

(defun shrink-horz ()
  (interactive)
  (enlarge-window-horizontally -4))

(defun rc/duplicate-line ()
  "Duplicate current line"
  (interactive)
  (let ((column (- (point) (point-at-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;LLM;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; OPTIONAL configuration
;; (use-package gptel :ensure t) - Removed :ensure t, Nix will ensure it
(use-package gptel)

(setq gptel-model   'mistralai/mistral-small-3.1-24b-instruct:free
      gptel-backend
      (gptel-make-openai "Astral"
        :host "openrouter.ai"
        :endpoint "/api/v1/chat/completions"
        :stream t
        :key "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" 
        :models '(mistralai/mistral-small-3.1-24b-instruct:free)))

(global-set-key (kbd "C-<return>") 'gptel-send)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PACKAGES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Theme gruber-darker
(use-package gruber-darker-theme
  :config
  (load-theme 'gruber-darker t))

(use-package projectile
  :init
  (projectile-mode +1)
  :config
  (setq projectile-project-search-path '("~/Source/" "~/your/other/dev/folders/"))
  (setq projectile-enable-caching t)
  (add-hook 'projectile-mode-hook (lambda () (projectile-project-list-refresh))))

(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-center-content t)
  (setq dashboard-center-items t)
  (setq dashboard-items '((recents . 5)
                          (projects . 4)))
  (setq dashboard-item-issues nil)
  (setq dashboard-item-projectile nil)
  (setq dashboard-item-agenda nil)
  (setq dashboard-item-habit nil)
  (setq dashboard-item-appt nil)
  (setq dashboard-items-bottom nil)
  (setq dashboard-center-content-turing '((agenda . "~/OrgRoam")
                                          (projects . "~/Source/"))))

;; Company
(use-package company
  :config
  (add-hook 'after-init-hook 'global-company-mode))

;; Ivy and Counsel
(use-package ivy
  :diminish
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :after ivy
  :init
  (ivy-rich-mode 1))

;; Lsp servers
(use-package lsp-mode
  :hook
  (c++-mode . lsp)
  (java-mode . lsp)
  (c-mode . lsp)
  (csharp-mode . lsp)
  (go-mode . lsp)
  (lisp-mode . sly) 
  (haskell-mode . lsp))

(use-package yasnippet
  :hook
  (java-mode . yas-global-mode)
  (go-mode . yas-global-mode))

(use-package lsp-ui
  :after lsp-mode
  :custom
  (lsp-ui-doc-show-with-cursor t))

(use-package counsel)

;; Improved candidate sorting with prescient.el
(use-package ivy-prescient
  :after counsel
  :custom
  (ivy-prescient-enable-filtering nil)
  :config
  (ivy-prescient-mode 1))

;; Git
(use-package magit
  :commands magit-status
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package forge
  :after magit)

(use-package ace-window
  :bind ("M-o" . ace-window)
  :config
  (setq aw-keys '(?j ?k ?o ?f ?g ?h ?j ?k ?l))
  (setq aw-minibuffer-flag t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MAPPING;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Move window
(global-set-key (kbd "C-M-p") 'windmove-up)
(global-set-key (kbd "C-M-n") 'windmove-down)
(global-set-key (kbd "C-M-b") 'windmove-left)
(global-set-key (kbd "C-M-f") 'windmove-right)

;; Resize buffers
(define-prefix-command 'my-mapping)
(define-key my-mapping (kbd "C-c k") 'shrink-vert)
(define-key my-mapping (kbd "C-c i") 'enlarge-vert)
(define-key my-mapping (kbd "C-c j") 'shrink-horz)
(define-key my-mapping (kbd "C-c l") 'enlarge-horz)
(define-prefix-command 'window-resize-map)
(global-set-key (kbd "C-x w") 'window-resize-map)

(define-key window-resize-map (kbd "p") (lambda () (interactive) (enlarge-window 8)))
(define-key window-resize-map (kbd "n") (lambda () (interactive) (enlarge-window -8)))
(define-key window-resize-map (kbd "f") (lambda () (interactive) (enlarge-window-horizontally 8)))
(define-key window-resize-map (kbd "b") (lambda () (interactive) (enlarge-window-horizontally -8)))

;; Duplicate line
(global-set-key (kbd "C-,") 'rc/duplicate-line)

;; Ivy
(global-set-key (kbd "C-s") 'swiper)
(define-key ivy-minibuffer-map (kbd "TAB") 'ivy-alt-done)
(define-key ivy-minibuffer-map (kbd "C-l") 'ivy-alt-done)
(define-key ivy-minibuffer-map (kbd "C-j") 'ivy-next-line)
(define-key ivy-minibuffer-map (kbd "C-k") 'ivy-previous-line)
(define-key ivy-switch-buffer-map (kbd "C-k") 'ivy-previous-line)
(define-key ivy-switch-buffer-map (kbd "C-l") 'ivy-done)
(define-key ivy-switch-buffer-map (kbd "C-d") 'ivy-switch-buffer-kill)
(define-key ivy-reverse-i-search-map (kbd "C-k") 'ivy-previous-line)
(define-key ivy-reverse-i-search-map (kbd "C-d") 'ivy-reverse-i-search-kill)

;; Compile
(global-set-key (kbd "C-c C-c") 'compile)
(global-set-key (kbd "C-c c") (lambda () (interactive) (compile "make run")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;HOOKS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; haskell
(add-hook 'haskell-mode-hook #'lsp)
(add-hook 'haskell-literate-mode-hook #'lsp)
(add-hook 'haskell-interactive-switch #'lsp)

;; line-numbers-mode off
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                pdf-view-mode-hook
                eshell-mode-hook
                nov-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; custom-set-variables and custom-set-faces should ideally not be in extraConfig
;; If you want to manage these in a Nix-friendly way, consider setting them directly
;; through `emacs.extraConfig` or by having Emacs load a separate `custom.el` file
;; outside of the Nix store, if you intend to modify them dynamically.
;; For static configuration, you can leave them here.
(custom-set-variables
 '(custom-enabled-themes '(gruber-darker))
 '(custom-safe-themes
   '("014cb63097fc7dbda3edf53eb09802237961cbb4c9e9abd705f23b86511b0a69"
     default))
 ;; package-selected-packages should not be here, as Nix manages them
 '(warning-suppress-log-types '((native-compiler))))

(custom-set-faces
 '(cursor ((t (:background "white"))))
 '(dired-directory ((t (:foreground "#1d8adb"))))
 '(org-block ((t (:inherit white :extend t))))
 '(org-block-begin-line ((t (:inherit org-meta-line :extend nil))))
 '(sly-mrepl-output-face ((t (:foreground "green")))))

(put 'narrow-to-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
(setq standard-indent 2)
