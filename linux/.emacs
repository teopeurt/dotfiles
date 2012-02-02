;; https://github.com/dengzhp/dotfiles.git

(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/plugins")
(progn (cd "~"))

;;;;苹果键位remap
(setq mac-command-modifier 'meta) ;映射苹果键
(setq mac-control-modifier 'control) ;映射Ctrl键
(setq mac-option-modifier 'alt) ;映射Alt键

;;disable some trackpad actions
(dolist (k '([mouse-1] [down-mouse-1] [C-down-mouse-1] [S-mouse-1]))
(global-unset-key k))

;; start emacs-server
(server-start)

;; User interface
(setq inhibit-startup-message t)
(setq initial-scratch-message "Hey, How are you\n")
(setq visible-bell t)
(setq line-number-mode t)		;;;;显示行号
(setq column-number-mode t)		;;;;显示列号
(setq-default indent-tabs-mode t)
(setq-default tab-width 4)
;(setq scroll-step 1)
(setq scroll-margin 3
      scroll-conservatively 10000)
(show-paren-mode t)
(setq show-paren-style 'parentheses)
(setq frame-title-format "%b@Emacs")

(setq default-major-mode 'text-mode)
(global-font-lock-mode t);语法高亮
(auto-image-file-mode t);打开图片显示功能
(display-time-mode 1)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(tool-bar-mode -1);去掉工具栏
(scroll-bar-mode -1);去掉滚动条
(mouse-avoidance-mode 'jump);光标靠近鼠标指针时 让鼠标指针自动让开
(setq x-select-enable-clipboard t);支持emacs和外部程序的粘贴
(setq default-fill-column 80);默认显示 80列就换行

;;窗口最大化
(require 'maxframe)
(add-hook 'window-setup-hook 'maximize-frame t)

(defalias 'yes-or-no-p 'y-or-n-p)

;; no trailing whitespace:
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;ido
(ido-mode t)

;; overrides Emacs’ default mechanism for making buffer names unique
(require 'uniquify)

;font
;(set-default-font "Bitstream Vera Sans Mono-13")
(set-default-font "DejaVu Sans Mono-12")

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(c-basic-offset 4)
 '(c-default-style "K&R")
 '(c-echo-syntactic-information-p t)
 '(c-report-syntactic-errors t)
 '(c-tab-always-indent nil)
 '(exec-path (quote ("/usr/bin" "/bin" "/usr/sbin" "/sbin" "/usr/local/bin")))
 '(kill-whole-line t)
 '(uniquify-buffer-name-style (quote post-forward) nil (uniquify)))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
)

; return a backup file path of a give file path
; with full directory mirroring from a root dir
; non-existant dir will be created
(defun my-backup-file-name (fpath)
  "Return a new file path of a given file path.
If the new path's directories does not exist, create them."
  (let (backup-root bpath)
    (setq backup-root "~/backup")
    (setq bpath (concat backup-root fpath "~"))
    (make-directory (file-name-directory bpath) bpath)
    bpath
  )
)
(setq make-backup-file-name-function 'my-backup-file-name)

;;ignore running process when quit emacs
(setq kill-buffer-query-functions
     (remove 'process-kill-buffer-query-function kill-buffer-query-functions))


;;My keys binding

;;Genral purpose
(global-set-key [(meta g)] 'goto-line)

(global-set-key (kbd "M-[") 'rgrep)

;;region indent
(global-set-key (kbd "C-M-=") 'indent-region)

;;;;自动补齐策略
(defun my-indent-or-complete ()
   (interactive)
   (if (looking-at "\\>")
 	  (hippie-expand nil)
 	  (indent-for-tab-command))
)

(setq hippie-expand-try-functions-list
	'(
	  try-expand-dabbrev                 ; 搜索当前 buffer
	  try-expand-dabbrev-visible         ; 搜索当前可见窗口
	  try-expand-dabbrev-all-buffers     ; 搜索所有 buffer
	  try-expand-dabbrev-from-kill       ; 从 kill-ring 中搜索
	  try-complete-file-name-partially   ; 文件名部分匹配
	  try-complete-file-name             ; 文件名匹配
	  try-expand-all-abbrevs             ; 匹配所有缩写词
	  try-expand-list                    ; 补全一个列表
	  try-expand-line                    ; 补全当前行
	  try-expand-whole-kill
	  try-complete-lisp-symbol-partially ; 部分补全 elisp symbol
	  try-complete-lisp-symbol))         ; 补全 lisp

(global-set-key (kbd "M-/") 'my-indent-or-complete)

;; copy one line is mark not active
(global-set-key (kbd "M-w") 'huangq-save-line-dwim)

(defun huangq-save-one-line (&optional arg)
  "save one line. If ARG, save one line from first non-white."
  (interactive "P")
  (save-excursion
    (if arg
        (progn
          (back-to-indentation)
          (kill-ring-save (point) (line-end-position)))
      (kill-ring-save (line-beginning-position) (line-end-position)))))

;;;###autoload
(defun huangq-kill-ring-save (&optional n)
  "If region is active, copy region. Otherwise, copy line."
  (interactive "p")
  (if (and mark-active transient-mark-mode)
      (kill-ring-save (region-beginning) (region-end))
    (if (> n 0)
        (kill-ring-save (line-beginning-position) (line-end-position n))
      (kill-ring-save (line-beginning-position n) (line-end-position)))))

;;;###autoload
(defun huangq-save-line-dwim (&optional arg)
  "If region is active, copy region.
If ARG is nil, copy line from first non-white.
If ARG is numeric, copy ARG lines.
If ARG is non-numeric, copy line from beginning of the current line."
  (interactive "P")
  (if (and mark-active transient-mark-mode)
      ;; mark-active, save region
      (kill-ring-save (region-beginning) (region-end))
    (if arg
        (if (numberp arg)
            ;; numeric arg, save ARG lines
            (huangq-kill-ring-save arg)
          ;; other ARG, save current line
          (huangq-save-one-line))
      ;; no ARG, save current line from first non-white
      (huangq-save-one-line t))))


;; behave like vi's o command
(defun my-open-line-below (arg)
  "Move to the next line and then opens a line."
  (interactive "p")
  (end-of-line)
  (open-line arg)
  (next-line arg)
  (indent-according-to-mode))

(global-set-key (kbd "C-o") 'my-open-line-below)

;; behave like vi's O command
(defun my-open-line-above (arg)
  "Open a new line before the current one."
  (interactive "p")
  (beginning-of-line)
  (open-line arg)
  (indent-according-to-mode))

(global-set-key (kbd "M-o") 'my-open-line-above)
;;----------------------------------------------------------------------

(global-set-key "%" 'match-paren)

(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
	((looking-at "\\s\)") (forward-char 1) (backward-list 1))
	(t (self-insert-command (or arg 1)))))


;;C-w remove a line
(defadvice kill-region (before slickcut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
   (line-beginning-position 2)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; mode-hook

;; C/C++/Java mode
(defun my-c-mode-hook()
(interactive)
(c-toggle-auto-state)
(c-semi&comma-no-newlines-before-nonblanks)
(c-toggle-hungry-state)
(imenu-add-menubar-index)
(which-function-mode t)
;; gtags mode
(gtags-mode 1)
;(smart-operator-mode 1)
(setq c-macro-shrink-window-flag t)
(setq c-macro-preprocessor "cpp")
(setq c-macro-cppflags " ")
(setq c-macro-prompt-flag t)
(setq hs-minor-mode t)
(setq comment-column 48)
(setq abbrev-mode t)
;;左侧显示行号, linum.el
(linum-mode 1)
)

(defun my-c++-mode-hook()
(interactive)
;; 自动模式 在此种模式下当你键入{时 会自动根据你设置的对齐风格对齐
(c-toggle-auto-state)
(c-semi&comma-no-newlines-before-nonblanks)
;; 此模式下，当按Backspace时会删除最多的空格
(c-toggle-hungry-state)
;; 在菜单中加入当前Buffer的函数索引
(imenu-add-menubar-index)
;; 在状态条上显示当前光标在哪个函数体内部
(which-function-mode)
;; gtags mode
(gtags-mode 1)
;(smart-operator-mode 1)
(setq hs-minor-mode t)
(setq comment-column 48)
(setq abbrev-mode t)
;;左侧显示行号, linum.el
(linum-mode 1)
)

(defun my-java-mode()
(interactive)
(c-set-style "java")
(c-toggle-auto-state)
(c-toggle-hungry-state)
(imenu-add-menubar-index)
(which-function-mode)
(gtags-mode 1)
(setq comment-column 48)
)

(defun my-python-mode-hook()
(which-function-mode 1)
(linum-mode 1))

(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c++-mode-hook)
(add-hook 'java-mode-hook 'my-java-mode)
(add-hook 'python-mode-hook 'my-python-mode-hook)

;; --------------------------------------------------

;; 为 view-mode 加入 vim 的按键
(setq view-mode-hook
      (lambda ()
        (define-key view-mode-map "h" 'backward-char)
        (define-key view-mode-map "l" 'forward-char)
        (define-key view-mode-map "j" 'next-line)
        (define-key view-mode-map "k" 'previous-line)))


(defun stop-using-minibuffer ()
  "kill the minibuffer"
  (when (and (>= (recursion-depth) 1) (active-minibuffer-window))
    (abort-recursive-edit)))

(add-hook 'mouse-leave-buffer-hook 'stop-using-minibuffer)


;;plugins

(load "~/.emacs.d/load_plugins")
