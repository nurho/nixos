; Set variables
;(setq inhibit-startup-message t)
(setq standard-indent 2)
(setq visible-bell 1)
(setq default-frame-alist '((undecorated . t))) 
(set-frame-font "DejaVu Sans Mono" t t)

; Theme
(load-theme 'dracula)

; Modes
(global-display-line-numbers-mode 1)
(tool-bar-mode -1)
;(menu-bar-mode -1)
(scroll-bar-mode -1)
;(evil-mode 1)
