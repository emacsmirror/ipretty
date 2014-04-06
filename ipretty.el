;;; ipretty.el --- Interactive Emacs Lisp pretty-printing

;; Copyright (C) 2014, Steckerhalter

;; Author: steckerhalter
;; URL: https://github.com/steckerhalter/ipretty
;; Keywords: pretty-print elisp buffer
;; License: GPLv3, see https://github.com/ipretty/LICENSE

;; This file is not part of GNU Emacs.

;;; Commentary:

;; `ipretty.el' provides interactive functions to pretty-print the
;; result of an expression and a global made `ipretty-mode' that
;; advices `eval-print-last-sexp' to pretty print.

;;; Code:

;;;###autoload
(defun ipretty-last-sexp ()
  "Pretty-print the last sexp into the current buffer."
  (interactive)
  (if (bound-and-true-p ipretty-mode)
      (eval-print-last-sexp t)
    (eval-print-last-sexp t)
    (backward-sexp 1)
    (indent-pp-sexp t)))

;;;###autoload
(defun ipretty-last-sexp-other-buffer (&optional buffer-name)
  "Display the last sexp pretty-printed in other buffer.
If BUFFER-NAME (a string)is provided it will be used to name the
buffer, otherwise the default `*pp-display-expression*' is used."
  (interactive)
  (pp-display-expression (eval (preceding-sexp)) (or buffer-name "*pp-display-expression*")))

(defadvice eval-print-last-sexp (after eval-print-last-sexp-after-advice)
  "Advice `eval-print-last-sexp' to pretty-print the result."
    (backward-sexp 1)
    (indent-pp-sexp t))

;;;###autoload
(define-minor-mode ipretty-mode
  "Toggle ipretty mode globally.
   With no argument, this command toggles the mode.
   Non-null prefix argument turns on the mode.
   Null prefix argument turns off the mode."
  :global t

  (if ipretty-mode
      (ad-activate-regexp "eval-print-last-sexp-after-advice")
    (ad-deactivate-regexp "eval-print-last-sexp-after-advice")))


(provide 'ipretty)
;;; ipretty.el ends here
