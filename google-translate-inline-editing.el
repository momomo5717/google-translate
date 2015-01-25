(defun google-translate-inline-translate (&optional source-language
                                                    target-language
                                                    point-pos-delta)
  (interactive)
  (let* ((buffer-name google-translate-buffer-name)
         (buffer (get-buffer buffer-name))
         (start (next-single-property-change (point-min) 'read-only))
         (end (next-single-property-change start 'read-only))
         (text (buffer-substring-no-properties (+ start 1) end))
         (source-language (if (null source-language)
                              (buffer-local-value 'gt-source-language buffer)
                            source-language))
         (target-language (if (null target-language)
                              (buffer-local-value 'gt-target-language buffer)
                            target-language))
         (point-pos nil))
    (with-current-buffer buffer
      (setq point-pos (point))
      (google-translate-translate source-language target-language text)
      (goto-char point-pos))))

(defvar google-translate-inline-editing-text-mode-map
  (let ((map (make-sparse-keymap)))
    (suppress-keymap map)
    (define-key map (kbd "q") 'google-translate-kill-window)
    map))

(defun google-translate-kill-window ()
  (interactive)
  (kill-buffer-and-window))

(defun google-translate-inline-translate-reversed ()
  (interactive)
  (let* ((buffer-name google-translate-buffer-name)
         (buffer (get-buffer buffer-name))
         (source-language (buffer-local-value 'gt-source-language buffer))
         (target-language (buffer-local-value 'gt-target-language buffer)))
    (google-translate-inline-translate target-language source-language)))

(defun google-translate-inline-change-source-language ()
  (interactive)
  (google-translate-inline-translate (google-translate-read-source-language) nil))

(defun google-translate-inline-change-target-language ()
  (interactive)
  (google-translate-inline-translate nil (google-translate-read-target-language)))

(define-derived-mode google-translate-inline-editing-mode fundamental-mode "GTInlineEditing"
  "Google Translate Inline Editing major mode. This major mode is mainly intended to
provide key bindings for easier editing of translated text in the regular buffer."
  :group 'google-translate)

(define-key google-translate-inline-editing-mode-map
  (kbd "C-c C-c") 'google-translate-inline-translate)
(define-key google-translate-inline-editing-mode-map
  (kbd "C-c C-r") 'google-translate-inline-translate-reversed)
(define-key google-translate-inline-editing-mode-map
  (kbd "C-c C-s") 'google-translate-inline-change-source-language)
(define-key google-translate-inline-editing-mode-map
  (kbd "C-c C-t") 'google-translate-inline-change-target-language)
(define-key google-translate-inline-editing-mode-map [?\t] 'forward-button)


(provide 'google-translate-inline-editing)

;;; google-translate-inline-editing-mode.el ends here