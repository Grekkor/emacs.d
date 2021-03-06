;; -*- lexical-binding: t -*-

(add-to-list 'load-path ds-dir-config-custom-root)
(add-to-list 'custom-theme-load-path ds-dir-config-custom-root)
(load-file (expand-file-name "themes.el" ds-dir-config-custom-root))

;; org-mode
(setq org-directory "~/sync/notes"
      org-agenda-files '("~/sync/notes/agenda"
                         "~/workspace/todo.org"))

(setq org-capture-templates
      '(("z" "Notes" entry
         (file+headline "~/sync/notes/capture.org" "Inbox")
         "* %^{Title||%:description}\n\nTitle: %:description\nSource: %:link\n\n%:initial"
         :empty-lines 1)
        ("t" "Todo" entry
         (file+headline "~/sync/notes/agenda/inbox.org" "Inbox")
         "* TODO %^{Task name||%:description}\n\nTitle: %:description\nSource: %:link\n\n%:initial"
         :empty-lines 1)))

(setq markdown-css-paths '("https://gongzhitaao.org/orgcss/org.css"))

;; Additional packages
(use-package reverse-im
  :config
  (reverse-im-activate "russian-computer"))

(use-package langtool
  :config
  (setq langtool-http-server-host "localhost"
        langtool-http-server-port 8010))

(use-package memory-usage)

;; TODO: pdf-tools workaround
;; https://github.com/politza/pdf-tools/issues/18#issuecomment-532175227
(use-package pdf-tools
  :no-require t
  :config
  (defun brds/pdf-set-last-viewed-bookmark ()
    (interactive)
    (when (eq major-mode 'pdf-view-mode)
      (bookmark-set (brds/pdf-generate-bookmark-name))))

  (defun brds/pdf-jump-last-viewed-bookmark ()
    (when
        (brds/pdf-has-last-viewed-bookmark)
      (bookmark-jump (brds/pdf-generate-bookmark-name))))

  (defun brds/pdf-has-last-viewed-bookmark ()
    (member (brds/pdf-generate-bookmark-name) (bookmark-all-names)))

  (defun brds/pdf-generate-bookmark-name ()
    (concat "PDF-LAST-VIEWED: " (buffer-file-name)))

  (defun brds/pdf-set-all-last-viewed-bookmarks ()
    (dolist (buf (buffer-list))
      (with-current-buffer buf
        (brds/pdf-set-last-viewed-bookmark))))

  (add-hook 'kill-buffer-hook #'brds/pdf-set-last-viewed-bookmark)
  (add-hook 'pdf-view-mode-hook #'brds/pdf-jump-last-viewed-bookmark)
  (unless noninteractive  ; as `save-place-mode' does
    (add-hook 'kill-emacs-hook #'brds/pdf-set-all-last-viewed-bookmarks)))

;; TODO: cursor disappears when moving fast
;; bring back double buffering for now / override core/os.el
(when os-is-linux
  (setq default-frame-alist (assoc-delete-all
                             'inhibit-double-buffering
                             default-frame-alist)))
