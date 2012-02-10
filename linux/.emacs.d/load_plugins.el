;; color-theme
(require 'color-theme)
(color-theme-initialize)
(color-theme-gray30)

;;global
(autoload 'gtags-mode "gtags" "" t)

(setq gtags-suggested-key-mapping t)

(add-hook 'gtags-select-mode-hook
  '(lambda ()
     (setq hl-line-face 'underline)
     (hl-line-mode 1)
))

(setq gtags-mode-hook
   '(lambda ()
         (define-key gtags-mode-map "\eh" 'gtags-display-browser)
         (define-key gtags-mode-map "\C-]" 'gtags-find-tag-from-here)
         (define-key gtags-mode-map "\C-t" 'gtags-pop-stack)
 ;;      (define-key gtags-mode-map "\el" 'gtags-find-file)
 ;;      (define-key gtags-mode-map "\eg" 'gtags-find-with-grep)
 ;;      (define-key gtags-mode-map "\eI" 'gtags-find-with-idutils)
 ;;      (define-key gtags-mode-map "\es" 'gtags-find-symbol)
 ;;      (define-key gtags-mode-map "\er" 'gtags-find-rtag)
 ;;      (define-key gtags-mode-map "\et" 'gtags-find-tag)
 ;;      (define-key gtags-mode-map "\ev" 'gtags-visit-rootdir)
))


(require 'htmlize)

(add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet) ;; not yasnippet-bundle
(yas/global-mode 1)

(require 'browse-kill-ring)
(browse-kill-ring-default-keybindings)

;;google region
(defun google-region (beg end) "Google the selected region." (interactive "r") (
browse-url (concat "http://www.google.com/search?ie=utf-8&oe=utf-8&q=" (buffer-substring beg end))))
(global-set-key (kbd "C-M-g") 'google-region)

(require 'gist)

;;nxhtml
(load "~/.emacs.d/plugins/nxhtml/autostart")


;;auto-complete
(add-to-list 'load-path "~/.emacs.d/plugins/auto-complete")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/plugins/auto-complete/ac-dict")
(ac-config-default)

;; auto-complete-clang
;; https://github.com/mikeandmore/auto-complete-clang/
(require 'auto-complete-clang)
(setq clang-completion-suppress-error 't)

(defun my-c-mode-common-hook()
  (define-key c-mode-base-map (kbd "M-/") 'ac-complete-clang)
)

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;; sdcv
(require 'sdcv-mode)
(global-set-key (kbd "C-c d") 'sdcv-search)


;; EIM Input Method. Use C-\ to toggle input method.
(add-to-list 'load-path "~/.emacs.d/plugins/eim")
(require 'eim-extra)
(autoload 'eim-use-package "eim" "Another emacs input method")
(setq eim-use-tooltip nil)              ; don't use tooltip
(setq eim-punc-translate-p nil)         ; use English punctuation
(register-input-method
 "eim-py" "euc-cn" 'eim-use-package
 "拼音" "EIM Chinese Pinyin Input Method" "py.txt"
 'my-eim-py-activate-function)
(set-input-method "eim-py")             ; use Pinyin input method
(setq activate-input-method t)          ; active input method
(toggle-input-method nil)               ; default is turn off
(defun my-eim-py-activate-function ()
  (add-hook 'eim-active-hook
            (lambda ()
              (let ((map (eim-mode-map)))
                (define-key eim-mode-map "-" 'eim-previous-page)
                (define-key eim-mode-map "=" 'eim-next-page)))))
