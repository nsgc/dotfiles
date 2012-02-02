(add-to-list 'load-path "~/.emacs.d/")


;; auto-install によってインストールされるEmacs Lispをロードパスに加える
;; デフォルトは ~/.emacs.d/auto-install/
(add-to-list 'load-path "~/.emacs.d/auto-install/") 

(require 'auto-install)
;; 起動時にEmacsWikiのページ名を補完候補に加える
(auto-install-update-emacswiki-package-name t)
;; install-elisp.el互換モードにする
(auto-install-compatibility-setup)
;; ediff関連のバッファを1つのフレームにまとめる
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
;; (install-elisp-from-emacswiki "auto-install.el")

(require 'auto-async-byte-compile)
;; 自動バイトコンパイルを無効にするファイル名の正規表現
(setq auto-atync-byte-compile-exclude-files-regexp "/junk/")
;; emacs-lisp-modeの時 enable-auto-async-byte-compile-modeを有効にする
(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)
;; emacs-lisp-modeの時 turn-on-eldoc-modeを有効にする
;; eldoc-modeでミニバッファに関数、変数のヘルプを表示してくれる
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
;; (install-elisp-from-emacswiki "auto-async-byte-compile.el")


;; ELPA Emacs Lisp用のパッケージマネージャ
;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))
;; (install-elisp "http://tromey.com/elpa/package-install.el")


;; 日本語infoの展開先を追加
;; M-x info で読める
(add-to-list 'Info-default-directory-list "~/.emacs.d/info")
;; /usr/share/info/dir にリンクと付けること

;; 2回入力した時に挙動か変わるよ
;; C-a C-a, C-e C-e, M-u M-u(Upcace), M-c M-c(Capitalize), M-l(Downcase)
(require 'sequential-command-config)
(sequential-command-setup-keys)
;; (install-elisp "http://www.emacswiki.org/cgi-bin/wiki/download/sequential-command.el")
;; (install-elisp "http://www.emacswiki.org/cgi-bin/wiki/download/sequential-command-config.el")

;; key-chord.el
;; キーに割り当てが足りない時に
;; space-chord.el
;; Ctl に疲れる時に、Spaceに割り当てれる

;; マイナーモードのキー衝突問題の解消
;; M-x show-minor-mode-map-priority
(require 'minor-mode-hack)
;; (install-elisp-from-emacswiki "minor-mode-hack.el")

;; 現在位置のファイル, URLを開く
;; .emacs <=ここでC-x C-f すると!
(ffap-bindings)

;; ファイル名が重複した場合、バッファ名を分かりやすくする
(require 'uniquify)
;; filename<dir> 形式のバッファ名にする
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
;; * で囲まれたバッファ名は対象外にする
(setq uniquify-ignore-buffer-re "*[^*]+*")

;; バッファ(C-x b) で部分文字列補完、C-s C-r で補完候補の選択をできるように
(iswitchb-mode 1)
;; バッファ読み出し関数を iswitchb にする
(setq read-buffer-function 'iswitchb-read-buffer)
;; 部分文字列の変わりに聖記表現を使う時は t に設定する
(setq iswitchb-regexp nil)
;; 新しいバッファを作成する時にいちいち聞いてこない
(setq iswitchb-prompt-newbuffer nil)

;; 最近使ったファイル一覧をバッファに表示する
;; M-x recentf-open-files
;; TODO キーマップ割り触る?
;; 最近のファイル500個を保存する
(setq recentf-max-saved-items 500)
;; 最近使ったファイルに加えないファイルを正規表現で指定する
(setq recentf-exclude '("/TAGS$" "/var/tmp/"))
(require 'recentf-ext)
;; (install-elisp-from-emacswiki "recentf-ext.el")

;; ブックマーク
;; C-x r m ブックマークをセット
;; C-x r l ブックマークリストを開く
;; ブックマークを変更したら即保存する
(setq bookmark-save-flag t)
(progn
  (setq bookmark-sort-flag nil)
  (defun bookmark-arrange-latest-top ()
    (let ((latest (bookmark-get-bookmark bookmark)))
      (setq bookmark-akist (cons latest (delq latest bookmark-alist))))
    (bookmark-save))
  (add-hook 'bookmark-after-jump-hook 'bookmark-arrange-latest-top))

;; EmacsServer シェルから何度もEmacsにアクセスする時、立ち上げておくと便利
;; (server-start)
;; (global-set-key (kbd "C-x C-c") 'server-edit)
;; (defalias 'exit 'save-buffers-kill-emacs)

;; 使わなくなったバッファを自動で削除tempbuf.el
(require 'tempbuf)
;; ファイルを開いたら自動的にtempbufを有効にする
(add-hook 'find-file-hooks 'turn-on-tempbuf-mode)
;; diredバッファに対してtempbufを有効にする
(add-hook 'dired-mode-hook 'turn-on-tempbuf-mode)
;;     (add-hook 'custom-mode-hook 'turn-on-tempbuf-mode)
;;     (add-hook 'w3-mode-hook 'turn-on-tempbuf-mode)
;;     (add-hook 'Man-mode-hook 'turn-on-tempbuf-mode)
;;     (add-hook 'view-mode-hook 'turn-on-tempbuf-mode)
;; (install-elisp-from-emacswiki "tempbuf.el")

;; 自動でバッファを保存
;; (require 'auto-save-buffers)
;; 2秒毎に保存する
;; (run-with-idle-timer 2 t 'auto-save-buffers)
;; auto-save-buffers の on/off を切り替えるためのキー定義 (C-x a s)
;; (define-key ctl-x-map "as" 'auto-save-buffers-toggle)
;; (install-elisp "http://homepage3.nifty.com/oatu/emacs/archives/auto-save-buffers.el")

;; TODO magit.el を後で入れる

;; Dired(C-x d)でrでファイル名を変更できるように
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

;; Ruby 1.9.3 でmigemoががが
;; (require 'migemo)


;; カーソルの位置を戻す
(require 'point-undo)
;; TODO キー変える
(define-key global-map (kbd "<f7>") 'point-undo)
(define-key global-map (kbd "S-<f7>") 'point-redo)
;; (install-elisp-from-emacswiki "point-undo.el")

;; カーソルの位置に見える印を付ける
(setq-default bm-buffer-persistence nil)
(setq bm-restore-repository-on-load t)
(require 'bm)
(add-hook 'find-file-hooks 'bm-buffer-restore)
(add-hook 'kill-buffer-hook 'bm-buffer-save)
(add-hook 'after-save-hook 'bm-buffer-save)
(add-hook 'after-revert-hook 'bm-buffer-restore)
(add-hook 'vc-before-chechin-hook 'bm-buffer-save)
(global-set-key (kbd "M-SPC") 'bm-toggle)
(global-set-key (kbd "M-[") 'bm-previous)
(global-set-key (kbd "M-]") 'bm-next)
;; (install-elisp "http://cvs.savannah.gnu.org/viewvc/*checkout*/bm/bm/bm.el")

;; 最後の変更箇所に戻る
(require 'goto-chg)
(define-key global-map (kbd "<f8>") 'goto-last-change)
(define-key global-map (kbd "S-<f8>") 'goto-last-change-reverse)
;; (install-elisp-from-emacswiki "goto-chg.el")



;; 6-1 ファイル作成時にテンプレートを挿入する
(auto-insert-mode)
(setq auto-insert-directory "~/.emacs.d/insert/")
(define-auto-insert "\\.rb$" "ruby-template.rb")


;; 6-2 undoやり過ぎた時にredo する
(require 'redo+)
;; Fixme C-M-hoge の時に、C-Mが効かないよーTT
(global-set-key (kbd "C-M-/") 'redo)
(setq undo-no-redo t) ;; 過去のundoがredoされないようにする
(setq undo-limit 600000)
(setq undo-strong-limit 900000)
;; (install-elisp-from-emacswiki "redo+.el")

;; 6-3 矩形を使いやすくする(C-SPCでリージョン後、C-SPCで矩形モードに)
(require 'sense-region)
(sense-region-on)
;; (install-elisp "http://taiyaki.org/elisp/sense-region/src/sense-region.el")

;; 6-5, 6-9 yasnippet.el
;; 略語からテンプレート展開
;; M-x yas/new-snippet
;; (setq yas/trigger-key "TAB")
(add-to-list 'load-path "~/.emacs.d/plugins/yasnippet-0.6.1c")
(require 'yasnippet-config)
(yas/setup "~/.emacs.d/plugins/yasnippet-0.6.1c")
;; C-x y で一度だけスニペットを定義
;; C-x C-y で一度だけのスニペットを呼び出し
;; マクロ的に使える
(global-set-key (kbd "C-x y") 'yas/register-oneshot-snippet)
(global-set-key (kbd "C-x C-y") 'yas/expand-oneshot-snippet)
;; (install-elisp-from-emacswiki "yasnippet-config.el")


;; Elpa
;; ruby-mode
(add-to-list 'load-path "~/.emacs.d/elpa/ruby-mode-1.1")
(autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files" t)
(setq auto-mode-alist (cons '("\\.rb$" . ruby-mode) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode)) interpreter-mode-alist))
(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook '(lambda () (inf-ruby-keys)))

;; ruby-electric.el --- electric editing commands for ruby files
(add-to-list 'load-path "~/.emacs.d/elpa/ruby-electric-1.1")
(require 'ruby-electric)
(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))

(setq ruby-indent-level 2)
(setq ruby-indent-tabs-mode nil)

;; Interactively Do Things (highly recommended, but not strictly required)
(require 'ido)
(ido-mode t)
     
;; Rinari
;; Elpa 版では3.1では上手く動作しないらしいので、githubから落とした
;;;; git clone git://github.com/eschulte/rinari.git
;;;; cd rinari
;;;; git submodule init
;;;; git submodule update
(add-to-list 'load-path "~/.emacs.d/elisp/rinari")
(require 'rinari)

;; 6-14 auto-complete
(require 'auto-complete-config)
(global-auto-complete-mode 1)
;; (auto-install-batch "auto-complete")
(set-face-background 'ac-candidate-face "blue")
(set-face-underline 'ac-candidate-face "black")
(set-face-background 'ac-selection-face "red")


;; Emacs Lisp モード時に Emacs Lispのシンボルも補完
(defun emacs-lisp-ac-setup ()
  (setq ac-sources '(ac-source-words-in-same-mode-buffers ac-source-symbols)))
(add-hook 'emacs-lisp-mode-hook 'emacs-lisp-ac-setup)

;; TODO auto-complete-ruby が上手く動いてないよ
(add-to-list 'load-path "~/.emacs.d/elisp/rcodetools/") 
;; (install-elisp "http://www.cx4a.org/pub/auto-complete-ruby.el")
(require 'auto-complete-ruby)
(add-hook 'ruby-mode-hook
          (lambda ()
            (setq ac-omni-completion-sources '(("\\.\\=" ac-source-rcodetools)))))


;; ショートカット例。各式の最後でC-x C-eしよう
;; (man "ls")
;; (shell-command "who")
;; (find-file ".bash_profile")
;; (install-elisp "Elisp の URL")
;; (install-elisp-from-emacswiki "EmacsWIkiのElisp の URL")
;; (describe-function '関数名)
;; (describe-variable '変数名)
;; (find-function '関数名)
;; (find-variable '変数名)

;;(add-to-list 'load-path "~/.emacs.d/elisp/skk/") 
;;(require 'skk-autoloads)
;;(global-set-key "\C-x\C-q" 'skk-mode)

;;; 現在行に色を付ける
(global-hl-line-mode 1)
;; 色
(set-face-background 'hl-line "darkolivegreen")
;;; 履歴を次回Emacs起動時にも保存する
(savehist-mode 1)
;;; ファイル内のカーソルの位置を記憶する
(setq-default save-place t)
(require 'saveplace)
;;; 対応する括弧を表示する
(show-paren-mode 1)
;;; C-hは後退に割り当てる
(global-set-key (kbd "C-h") 'delete-backward-char)
;;; モードラインに時刻表示
(display-time)
;;; 行番号・桁番号を表示する
(line-number-mode 1)
(column-number-mode 1)
;;; リージョンに色を付ける
(transient-mark-mode 1)
;;; GCを減らして軽くする(デフォルトの10倍)
(setq gc-cons-threshold (* 10 gc-cons-threshold))
;;; ログの記録行数を増やす
(setq message-log-max 10000)
;;; ミニバッファを再帰的に呼び出せるようにする
(setq enable-recursive-minibuffers t)
;;; ダイアログボックスを使わないようにする
(setq use-dialog-box nil)
(defalias 'message-box 'message)
;;; 履歴をたくさん保存する
(setq history-length 1000)
;;; キーストロークをエコーエリアに早く表示する
(setq echo-keystrokes 0.1)
;;; 大きいファイルを開こうとした時に警告を発生させる
;;; デフォルトは10MBなので25MBに拡張する
(setq large-file-warning-threshold (* 25 1024 1024))
;;; ミニバッファで入力を間違っても履歴を残す
;;; 誤って取り消しして入力が失なわれるのを防ぐため
(defadvice abort-recursive-edit (before minibuffer-save activate)
  (when (eq (selected-window) (active-minibuffer-window))
    (add-to-history minibuffer-history-variable (minibuffer-contents))))
;;; yesと入力するのは面倒なのでyで十分
(defalias 'yes-or-no-p 'y-or-n-p)
;;; ツールバーとスクロールバーを消す
;; (tool-bar-mode -1)
;; (scroll-bar-mode -1)
;;; バックアップファイルを作成しないように
(setq backup-inhibited t)

;; テストで関数を作ってみた
(defun kill-whole-line2()
  "現在行をkillする"
  (interactive)				;コマンドにするには必要
  (beginning-of-line)			;行頭にカーソルを持って行く
  (kill-line 1))			;改行ごとkillする