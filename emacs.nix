{ config, pkgs, ... }:

let
  emacs-base = pkgs.emacs;
  withpkgs = (pkgs.emacsPackagesGen emacs-base).emacsWithPackages;

  keybindings-and-extra = ''
    ;; replace the selected region with yank
    (defun hlolli/yank-replace (beg end)
      (interactive "r")
      (delete-region beg end)
      (yank))
    
    (defun hlolli/indent-buffer ()
      "Indent the currently visited buffer."
      (interactive)
      (indent-region (point-min) (point-max)))
    
    (defun hlolli/chomp (str)
      "Chomp leading and tailing whitespace from STR."
      (while (string-match "\\`\n+\\|^\\s-+\\|\\s-+$\\|\n+\\'"
                           str)
        (setq str (replace-match "" t t str)))
      str)
    
    (defun hlolli/chomp-line-or-region ()
      "Remove leading and traling whitespace from current line or region."
      (interactive)
      (let (pos1 pos2 bds)
        (if (region-active-p)
            (setq pos1 (region-beginning) pos2 (region-end))
          (progn
            (setq bds (bounds-of-thing-at-point 'line))
            (setq pos1 (car bds) pos2 (cdr bds))))
        (setq myStr (buffer-substring pos1 pos2))
        (setq myStrChomped (chomp myStr))
        (delete-region pos1 pos2)
        (goto-char pos1)
        (insert myStrChomped)))
    
    (defun hlolli/echo-active-modes ()
      "Give a message of which minor modes are enabled in the current buffer."
      (interactive)
      (let ((active-modes))
        (mapc (lambda (mode) (condition-case nil
                                 (if (and (symbolp mode) (symbol-value mode))
                                     (add-to-list 'active-modes mode))
                               (error nil) ))
              minor-mode-list)
        (message "Active modes are %s" active-modes)))
    
    (defun hlolli/rename-file-and-buffer ()
      "Rename the current buffer and file it is visiting."
      (interactive)
      (let ((filename (buffer-file-name)))
        (if (not (and filename (file-exists-p filename)))
            (message "Buffer is not visiting a file!")
          (let ((new-name (read-file-name "New name: " filename)))
            (rename-file filename new-name t)
            (set-visited-file-name new-name t t)))))
    
    (defun hlolli/delete-file-and-buffer ()
      "Kill the current buffer and deletes the file it is visiting."
      (interactive)
      (let ((filename (buffer-file-name)))
        (when filename
          (when (yes-or-no-p (format "Are you sure you want to delete? %s" filename))
    	(if (vc-backend filename)
    	    (vc-delete-file filename)
    	  (progn
    	    (delete-file filename)
    	    (message "Deleted file %s" filename)
    	    (kill-buffer)))))))
    
    (defun hlolli/move-file (new-location)
      "Write this file to NEW-LOCATION, and delete the old one."
      (interactive (list (expand-file-name
                          (if buffer-file-name
                              (read-file-name "Move file to: ")
                            (read-file-name "Move file to: "
                                            default-directory
                                            (expand-file-name (file-name-nondirectory (buffer-name))
                                                              default-directory))))))
      (when (file-exists-p new-location)
        (delete-file new-location))
      (let ((old-location (expand-file-name (buffer-file-name))))
        (message "old file is %s and new file is %s"
                 old-location
                 new-location)
        (write-file new-location t)
        (when (and old-location
                   (file-exists-p new-location)
                   (not (string-equal old-location new-location)))
          (delete-file old-location))))
    
    (defun hlolli/sudo-edit (&optional arg)
      "Edit currently visited file as root.
    With a prefix ARG prompt for a file to visit.
    Will also prompt for a file to visit if current
    buffer is not visiting a file."
      (interactive "P")
      (if (or arg (not buffer-file-name))
          (find-file (concat "/sudo:root@localhost:"
                             (ido-read-file-name "Find file(as root): ")))
        (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))
    
    (defun hlolli/comment-or-uncomment-region-or-line ()
      "Comments or uncomments the region or the current line if there's no active region."
      (interactive)
      (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
          (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)))
    
    ;; quickly move to the beginning or end of buffer
    (global-set-key (kbd "C->") #'beginning-of-buffer)
    (global-set-key (kbd "C-<") #'end-of-buffer)
    (global-set-key (kbd "C-x C->") #'beginning-of-buffer)
    (global-set-key (kbd "C-x C-<") #'end-of-buffer)
    
    
    ;; quickly move to beginning or end in terminal mode
    (global-unset-key (kbd "C-x <"))
    (global-unset-key (kbd "C-x >"))
    (global-set-key (kbd "C-x >") #'beginning-of-buffer)
    (global-set-key (kbd "C-x <") #'end-of-buffer)
    
    ;; Comment or uncomment region
    (global-set-key (kbd "C-;") 'hlolli/comment-or-uncomment-region-or-line)
    
    ;; Comment or uncomment region - terminal mode
    (global-unset-key (kbd "C-x ;"))
    (global-set-key (kbd "C-x ;") 'hlolli/comment-or-uncomment-region-or-line)
    
    ;; Disable annoying ctrl-z freeze
    (global-unset-key (kbd "C-z"))

    (defun hlolli/yank-github-link ()
      "Quickly share a github link of what you are seeing in a buffer. Yanks
       a link you can paste in the browser."
      (interactive)
      (let* ((remote (or (magit-get-push-remote) "origin"))
             (url (magit-get "remote" remote "url"))
             (project (if (string-prefix-p "git" url)
                          (substring  url 15 -4)   ;; git link
                        (substring  url 19 -4))) ;; https link
             (link (format "https://github.com/%s/blob/%s/%s#L%d"
                           project
                           (magit-get-current-branch)
                           (magit-current-file)
                           (count-lines 1 (point)))))
        (kill-new link)))
    
    (defun camel-to-snake-case-region ()
      (interactive)
      (progn (replace-regexp "\\([A-Z]\\)" "_\\1" nil (region-beginning) (region-end))
             (downcase-region (region-beginning) (region-end))))
    
    (defun stop-using-minibuffer ()
      "kill the minibuffer"
      (when (and (>= (recursion-depth) 1) (active-minibuffer-window))
        (abort-recursive-edit)))
    
    (add-hook 'mouse-leave-buffer-hook 'stop-using-minibuffer)
    
    (defun hlolli/disable-scroll-bars (frame)
      (modify-frame-parameters frame
                               '((vertical-scroll-bars . nil)
                                 (horizontal-scroll-bars . nil))))
    
    (add-hook 'after-make-frame-functions 'hlolli/disable-scroll-bars)
    
    (defun hlolli/delete-trailing-whitespace ()
      "Delete trailing whitespace except in modes where it
      makes little sense"
      (when (not (and (eq 'string (type-of (buffer-file-name)))
                      (string-match-p ".*\.md$" (buffer-file-name))))
        (delete-trailing-whitespace)))
    
    ;; Delete trailing whitespace on save
    (add-hook 'before-save-hook #'hlolli/delete-trailing-whitespace nil nil)        
  '';
    
  ido-config = '' 
    (ido-mode t)
    (setq ido-everywhere            t
          ido-enable-prefix         nil
          ido-enable-flex-matching  t
          ido-auto-merge-work-directories-length nil
          ;;ido-use-filename-at-point t
          ido-max-prospects         10
          ido-create-new-buffer     'always
          ;; ido-use-virtual-buffers   t
          ;; ido-handle-duplicate-virtual-buffers 2
          ido-default-buffer-method 'selected-window
          ido-default-file-method   'selected-window)
    
    (defun ido-my-keys ()
      (define-key ido-completion-map (kbd "<up>")   'ido-prev-match)
      (define-key ido-completion-map (kbd "<down>") 'ido-next-match))
    
    (add-hook 'ido-setup-hook 'ido-my-keys)
    
    (add-hook 'ido-make-file-list-hook
              (lambda ()
                (define-key ido-file-dir-completion-map (kbd "SPC") 'self-insert-command)))
    
    (setq ido-decorations (quote ("\n-> " "" "\n " "\n ..." "[" "]" "
      [No match]" " [Matched]" " [Not readable]" " [Too big]" "
      [Confirm]")))
    (defun ido-disable-line-truncation () (set (make-local-variable 'truncate-lines) nil))
    (add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-truncation)
    
    (defun recentf-ido-find-file ()
        "Find a recent file using Ido."
        (interactive)
        (let* ((file-assoc-list
                (mapcar (lambda (x)
                          (cons (file-name-nondirectory x)
                                x))
                        recentf-list))
               (filename-list
                (remove-duplicates (mapcar #'car file-assoc-list)
                                   :test #'string=))
               (filename (ido-completing-read "Choose recent file: "
                                              filename-list
                                              nil
                                              t)))
          (when filename
            (find-file (cdr (assoc filename
                                   file-assoc-list))))))
    
    (define-key ido-file-completion-map (kbd "C-w") 'ido-delete-backward-updir)    
  '';
  emacs-config = pkgs.writeText "default.el" ''
      ;; initialize package

      (require 'package)
      (package-initialize 'noactivate)
      (eval-when-compile
        (require 'use-package))
      (load-theme 'vscode-dark-plus t)


      ;; copy fish shell path into the path.
      (let ((path-from-shell (shell-command-to-string 
        "/run/current-system/sw/bin/fish -i -c \"echo -n \\$PATH[1]; for val in \\$PATH[2..-1];echo -n \\\":\\$val\\\";end\"")))
        (setenv "PATH" path-from-shell)
        (setq exec-path (split-string path-from-shell ":")))
      (setenv "PATH" (concat (getenv "PATH") ":/run/current-system/sw/bin:~/.npm-global/bin"))
      (setenv "NODE_PATH" "~/.npm-global/lib/node_modules")

      (setq auto-save-list-file-prefix (concat user-emacs-directory "tmp/auto-save-list/.saves-")
            custom-file (concat user-emacs-directory "tmp/custom.el")
            custom-safe-themes t
            create-lockfiles nil
            completion-show-inline-help nil
            completion-auto-help nil
            electric-indent-mode t
            gc-cons-threshold 20000000
            help-window-select t
            inhibit-startup-message t
            nrepl-use-ssh-fallback-for-remote-hosts t
            nxml-child-indent 4
            nxml-attribute-indent 4
            package-check-signature nil
            require-final-newline t
            ring-bell-function 'ignore
            frame-title-format '((:eval (if (buffer-file-name) (abbreviate-file-name (buffer-file-name)) "%b")))
            savehist-additional-variables '(kill-ring search-ring regexp-search-ring)
            savehist-file (concat user-emacs-directory "tmp/savehist")
            use-package-always-defer t
            auto-revert-check-vc-info t
            use-package-check-before-init t
            left-fringe-width 2
            column-number-indicator-zero-based nil
            right-fringe-width 0 )

      (setq mac-option-key-is-meta nil
            mac-command-key-is-meta t
            mac-command-modifier 'meta
            mac-option-modifier 'none)

      ;; autosave/backups
      (setq backup-directory-alist  `(("." . ,(concat user-emacs-directory "tmp/autosaves")))
        backup-by-copying t    ; Don't delink hardlinks
        version-control t      ; Use version numbers on backups
        delete-old-versions t  ; Automatically delete excess backups
        kept-new-versions 20   ; how many of the newest versions to keep
        kept-old-versions 5    ; and how many of the old
      )

      ;; Disable annoying ctrl-z freeze
      (global-unset-key (kbd "C-z"))

      ;; Use tabbar binding for these keybindings
      (global-unset-key (kbd "C-x <right>"))
      (global-unset-key (kbd "C-x <left>"))

      (use-package magit
        :defer
        :if (executable-find "git")
        :bind (("C-x g" . magit-status)
               ("C-x G" . magit-dispatch-popup))
        :init
        (setq magit-completing-read-function 'ivy-completing-read))

      ;; Completions when finding files
      (use-package ido
        :defer
        :config
        (setq ido-enable-prefix nil
          ido-enable-flex-matching nil
          ido-use-filename-at-point nil
          ido-auto-merge-work-directories-length -1
          ido-use-virtual-buffers t
          ido-max-work-file-list 500
          ido-save-directory-list-file
          (expand-file-name "ido.hist" (concat user-emacs-directory "tmp/")))
        ;; Block annoying ido popup on space
        (defun ido-complete-space () (interactive))
        (custom-set-faces
        ;; Face used by ido for highlighting subdirs in the alternatives.
        '(ido-subdir ((t (:foreground "#7b68ee"))))
        ;; Face used by ido for highlighting first match.
        '(ido-first-match ((t (:foreground "#ff69b4"))))
        ;; Face used by ido for highlighting only match.
        '(ido-only-match ((t (:foreground "#ffcc33"))))
        ;; Face used by ido for highlighting its indicators (don't actually use this)
        '(ido-indicator ((t (:foreground "#ffffff"))))
        ;; Ido face for indicating incomplete regexps. (don't use this either)
        '(ido-incomplete-regexp ((t (:foreground "#ffffff")))))
        (ido-mode t)
        (ido-everywhere 1))

     (use-package rainbow-delimiters
       :defer
       :config
       (add-hook 'eval-expression-minibuffer-setup-hook #'rainbow-delimiters-mode)
       (add-hook 'clojure-mode-hook #'rainbow-delimiters-mode)
       (add-hook 'cider-repl-mode #'rainbow-delimiters-mode))

     (use-package solaire-mode
       :defer
       :hook ((change-major-mode . turn-on-solaire-mode)
              (after-revert . turn-on-solaire-mode)
              (ediff-prepare-buffer . solaire-mode)
              (minibuffer-setup . solaire-mode-in-minibuffer))
       :config
       (add-to-list 'solaire-mode-themes-to-face-swap '"vscode-dark-plus")
       (setq solaire-mode-auto-swap-bg t)
       (solaire-global-mode +1))
      
     (use-package vscode-dark-plus-theme
       :defer
       :after solaire-mode
       :config
       (load-theme 'vscode-dark-plus t))
    
     (use-package web-mode :defer
       :mode  (("\\.json$" . web-mode)
               ("\\.css$" . web-mode)
               ("\\.scss$" . web-mode)
               ("\\.json$" . web-mode)
               ("\\.html$" . web-mode)
               ("\\.php$" . web-mode)
               (".*babelrc.*" . web-mode)))
    
      (use-package js-mode :defer
        :init
        (setq js2-strict-inconsistent-return-warning nil
              js2-strict-cond-assign-warning nil
              js2-strict-var-redeclaration-warning nil
              js2-strict-var-hides-function-arg-warning nil
              js2-move-point-on-right-click nil
              js2-allow-rhino-new-expr-initializer nil
              js2-concat-multiline-strings nil
              js2-highlight-level 3
              js2-include-node-externs t
              )
        :mode (
               ("\\.ts$" . js-mode)
               ("\\.tsx$" . js-mode)
               ("\\.js$" . js-mode)
               ("\\.jsx$" . js-mode)
         ))

      (add-hook 'js-mode-hook
          (lambda ()
            (progn
              (js2-minor-mode t)
              (electric-indent-local-mode t)
              (smartparens-mode t)
              (rainbow-delimiters-mode t)
              (highlight-symbol-mode t))))

              ;; (color-identifiers-mode t)
              ;; (color-identifiers:regenerate-colors)

      ;; Disable blinking cursor
      (blink-cursor-mode 0)

      ;; Display the column number
      (column-number-mode t)

      ;; Show the time
      (display-time-mode)

      ;; Write yes as y and no as n
      (fset 'yes-or-no-p 'y-or-n-p)

      ;; Highlight the current line
      (global-hl-line-mode t)

      ;; Display the line number
      (line-number-mode t)

      ;; Hide the menu bar
      (menu-bar-mode -1)

      ;; Save history
      (savehist-mode 1)

      ;; Display the zoom value
      (size-indication-mode t)

      ;; Hide the scrollbar
      (toggle-scroll-bar -1)

      ;; Hide the toolbar
      (tool-bar-mode -1)

      ;; Use ibuffer instead of buffer-list
      (global-set-key (kbd "C-x C-b") 'ibuffer)

      ;; Auto revert (saved) files when they change on disk
      (global-auto-revert-mode t)

      ;; Never make tabs (exception for Makefiles)
      (setq-default indent-tabs-mode nil)

      (global-set-key (kbd "M-x") 'smex)

      (add-hook 'after-init-hook #'global-prettier-mode)

      ${ido-config}

      ${keybindings-and-extra}
  '';
in {
  emacs = withpkgs (epkgs: (with epkgs.melpaPackages; [
      (pkgs.runCommand "default.el" {} ''
         mkdir -p $out/share/emacs/site-lisp
         cp ${emacs-config} $out/share/emacs/site-lisp/default.el
      '')
      cider
      clojure-mode
      company
      elm-mode
      haskell-mode
      highlight-symbol
      js2-mode
      magit
      nix-mode
      notmuch
      ox-reveal
      prettier
      rainbow-delimiters
      smartparens
      smex
      solaire-mode
      use-package
      vscode-dark-plus-theme
      web-mode
    ])
  );
}
