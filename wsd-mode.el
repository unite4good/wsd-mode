;;; wsd-mode.el --- Emacs major-mode for www.websequencediagrams.com

;; Author     : Jostein Kjønigsen <jostein@gmail.com>
;; Created    : December 2014
;; Modified   : November 2014
;; Version    : 0.0.1
;; Keywords   : wsd diagrams design process modelling
;; X-URL      : https://github.com/josteink/wsd-mode
;;

(require 'wsd-core)

;; notes about derived mode here: http://www.emacswiki.org/emacs/DerivedMode

(defun wsd-create-font-lock-list (face list)
  (mapcar (lambda (i)
            (list (regexp-quote i) 'quote face))
          list))

(defun wsd-add-keywords (face list)
  (let* ((klist (wsd-create-font-lock-list face list)))
    (font-lock-add-keywords nil klist)))

;;;###autoload
(define-derived-mode wsd-mode fundamental-mode "wsd-mode"
  "Major-mode for websequencediagrams.com"
  (wsd-add-keywords 'font-lock-keyword-face
                    '("title"
                      "participant" " as "
                      "deactivate" "activate"
                      "alt" "else" "end"
                      "note" "over" "right" "left" "of"))
  (wsd-add-keywords 'font-lock-comment-face
                    '("-->-" "-->" "->+" "->-" "->" ": "))

  (local-set-key (kbd "C-c C-c") 'wsd-show-diagram-inline)
  (local-set-key (kbd "C-c C-e") 'wsd-show-diagram-online)
  (local-set-key (kbd "C-c C-k") 'wsd-strip-errors))

;;; Autoload mode trigger
;;;###autoload
(add-to-list 'auto-mode-alist '("\\.wsd$" . wsd-mode))

;;; Autoload to load actual mode.
;;;###autoload
(autoload 'wsd-mode "wsd-mode" "Emacs major-mode for www.websequencediagrams.com." t)

(provide 'wsd-mode)
