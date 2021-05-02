;;; packages --- Summary
;;; Commentary:

;;; Code:

;; Define package repositories
(require 'package)

(add-to-list 'package-archives
             '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
	     '("org" . "http://orgmode.org/elpa/") t)

(add-to-list 'package-pinned-packages '(cider . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(magit . "melpa-stable") t)


;; Load and activate emacs packages. Do this first so that the
;; packages are loaded before you start trying to modify them.
;; This also sets the load path.
(package-initialize)

;; Download the ELPA archive description if needed.
;; This informs Emacs about the latest versions of all packages, and
;; makes them available for download.
(when (not package-archive-contents)
  (package-refresh-contents))

;; Define he following variables to remove the compile-log warnings
;; when defining ido-ubiquitous
;; (defvar ido-cur-item nil)
;; (defvar ido-default-item nil)
;; (defvar ido-cur-list nil)
;; (defvar predicate nil)
;; (defvar inherit-input-method nil)

;; The packages you want installed. You can also install these
;; manually with M-x package-install
;; Add in your own as you wish:
(defvar my-packages
  '(;; makes handling lisp expressions much, much easier
    ;; Cheatsheet: http://www.emacswiki.org/emacs/PareditCheatsheet
    paredit

    ;; key bindings and code colorization for Clojure
    ;; https://github.com/clojure-emacs/clojure-mode
    clojure-mode

    ;; extra syntax highlighting for clojure
    clojure-mode-extra-font-locking

    ;; integration with a Clojure REPL
    ;; https://github.com/clojure-emacs/cider
    cider

    ;; allow ido usage in as many contexts as possible. see
    ;; customizations/navigation.el line 23 for a description
    ;; of ido
    ido-completing-read+

    ;; Enhances M-x to allow easier execution of commands. Provides
    ;; a filterable list of possible commands in the minibuffer
    ;; http://www.emacswiki.org/emacs/Smex
    smex

    ;; project navigation
    projectile

    ;; colorful parenthesis matching
    rainbow-delimiters

    ;; edit html tags like sexps
    tagedit

    ;; git integration
    magit))


;; Place downloaded elisp files in ~/.emacs.d/vendor. You'll then be able
;; to load them.
;;
;; For example, if you download yaml-mode.el to ~/.emacs.d/vendor,
;; then you can add the following code to this file:
;;
;; (require 'yaml-mode)
;; (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
;; 
;; Adding this code will make Emacs enter yaml mode whenever you open
;; a .yml file
(add-to-list 'load-path "~/.emacs.d/vendor")


;;;;
;; Customization
;;;;

;; Add a directory to our load path so that when you `load` things
;; below, Emacs knows where to look for the corresponding file.
(add-to-list 'load-path "~/.emacs.d/customizations")

;; Sets up exec-path-from-shell so that Emacs will use the correct
;; environment variables
(load "shell-integration.el")

;; These customizations make it easier for you to navigate files,
;; switch buffers, and choose options from the minibuffer.
(load "navigation.el")

;; These customizations change the way emacs looks and disable/enable
;; some user interface elements
(load "ui.el")

;; These customizations make editing a bit nicer.
(load "editing.el")

;; Hard-to-categorize customizations
(load "misc.el")

;; For editing lisps
(load "elisp-editing.el")

;; Langauage-specific
(load "setup-clojure.el")
(load "setup-js.el")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(coffee-tab-width 2)
 '(package-selected-packages
   (quote
    (csharp-mode yasnippet yaml-mode emmet-mode prettier-js flycheck web-mode javascript sudo-edit haskell-mode magit tagedit rainbow-delimiters projectile smex ido-completing-read+ cider clojure-mode-extra-font-locking clojure-mode paredit exec-path-from-shell))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Activate web-mode when editing .js and .js files:
(add-to-list 'auto-mode-alist '("\\.jsx?$" . web-mode))

;; To enable JSX syntax highlighting in .js/.jsx files, add this to your emacs configuration:

(defvar web-mode-content-types-alist)
(setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))

;; Configure indentation and any other preferences in the web-mode-init-hook:

(defvar web-mode-markup-indent-offset)
(defun web-mode-init-hook ()
  "Hooks for Web mode.  Adjust indent."
  (setq web-mode-markup-indent-offset 4))
  
(add-hook 'web-mode-hook  'web-mode-init-hook)

;; Require flycheck before the next block:

(require 'flycheck)

;; Disable the default jslint:

(setq-default flycheck-disabled-checkers
              (append flycheck-disabled-checkers
                      '(javascript-jshint json-jsonlist)))

;; Enable eslint checker for web-mode
(flycheck-add-mode 'javascript-eslint 'web-mode)
;; Enable flycheck globally
(add-hook 'after-init-hook #'global-flycheck-mode)


;; Enable prettier-js-mode for files in a project with prettier (this will use the projects .prettierrc):
(defun add-node-modules-path () "Add node modules.")
(defun web-mode-init-prettier-hook ()
  "Prettier hook."
  (add-node-modules-path)
  (if (locate-dominating-file default-directory ".prettierrc")
      (prettier-js-mode +1)))

(add-hook 'web-mode-hook  'web-mode-init-prettier-hook)

;; Enable emmet-mode with web-mode:
(add-hook 'web-mode-hook  'emmet-mode)

 ;; backspace

(global-set-key (kbd "C-\\") 'delete-backward-char)
               

 ;; goimports

(setq gofmt-command "goimports")
(add-hook 'before-save-hook 'gofmt-before-save)



 ;; deft and zetteldeft
 
;; (require 'use-package)

;; (use-package deft
;;   :ensure t
;;   :custom
;;   (deft-extensions '("org" "md" "txt"))
;;   (deft-directory "~/notes")
;;   (deft-use-filename-as-title t))

;; (use-package zetteldeft
;;   :ensure t
;;   :after deft
;;   :config (zetteldeft-set-classic-keybindings))


 ;; auto-complete

(ac-config-default)

 ;; web-mode

(require 'web-mode)

(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\.twig\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))


(setq web-mode-engines-alist
      '(("php"    . "\\.phtml\\'")
        ("twig"   . "\\.html\\.twig\\'")))


 ;; engine detection

(setq web-mode-enable-engine-detection t)


 ;; sql detection
 
(setq web-mode-enable-sql-detection t)

 ;; Add a snippet

(setq web-mode-extra-snippets
      '(("erb" . (("toto" . "<% toto | %>\n\n<% end %>")))
        ("php" . (("dowhile" . "<?php do { ?>\n\n<?php } while (|); ?>")
                  ("debug" . "<?php error_log(__LINE__); ?>")))
        ))

 ;; CSS colorization

(setq web-mode-enable-css-colorization t)

 ;; Current element highlight

(setq web-mode-enable-current-element-highlight t)

 ;; auto-complete

(setq web-mode-ac-sources-alist
      '(("css" . (ac-source-css-property))
        ("html" . (ac-source-words-in-buffer ac-source-abbrev))))


(setq web-mode-ac-sources-alist
      '(("php" . (ac-source-yasnippet ac-source-php-auto-yasnippets))
        ("html" . (ac-source-emmet-html-aliases ac-source-emmet-html-snippets))
        ("css" . (ac-source-css-property ac-source-emmet-css-snippets))))

 ;; auto complete php templates

(add-hook 'web-mode-before-auto-complete-hooks
          '(lambda ()
             (let ((web-mode-cur-language
                    (web-mode-language-at-pos)))
               (if (string= web-mode-cur-language "php")
                   (yas-activate-extra-mode 'php-mode)
                 (yas-deactivate-extra-mode 'php-mode))
               (if (string= web-mode-cur-language "css")
                   (setq emmet-use-css-transform t)
                 (setq emmet-use-css-transform nil)))))

;; Yasnippet
(add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)

 ;; Global-set-key
 
(global-set-key (kbd "C-c j") 'js-mode)
(global-set-key (kbd "C-c c") 'css-mode)
(global-set-key (kbd "C-c h") 'html-mode)
(global-set-key (kbd "C-c w") 'web-mode)


 ;; smooth scolling

(setq scroll-conservatively 10)


 ;; Set font

(set-face-attribute 'default nil :font "Fira Code")
(set-frame-font "Fira Code" nil t)

;; server-shutdown
(defun server-shutdown ()
 "Save buffers, Quit and Kill"
 (interactive)
 (save-some-buffers)
 (kill-emacs))

;; wsl-copy
(defun wsl-copy (start end)
  (interactive "r")
  (shell-command-on-region start end "clip.exe"))

(global-set-key (kbd "C-c c") 'wsl-copy)

; wsl-paste
(defun wsl-paste ()
  (interactive)
  (let ((clipboard
     (shell-command-to-string "powershell.exe -command 'Get-Clipboard' 2> /dev/null")))
    (setq clipboard (replace-regexp-in-string "\r" "" clipboard)) ; Remove Windows ^M characters
    (setq clipboard (substring clipboard 0 -1)) ; Remove newline added by Powershell
    (insert clipboard)))

(global-set-key (kbd "C-c v") 'wsl-paste)

;; M-X  Shell command
(global-set-key (kbd "M-s") 'shell-command)

;; Comment region
(global-set-key (kbd "C-x ;") 'comment-or-uncomment-region)
;;; .emacs ends here
