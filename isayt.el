;;; isayt.el --- Automatically indent lisp expressions while typing -*- lexical-binding: t -*-
;;
;; Author: Andrey Listopadov
;; Homepage: https://gitlab.com/andreyorst/isayt
;; Package-Requires: ((emacs "26.1"))
;; Keywords: indent lisp tools
;; Prefix: isayt
;; Version: 0.0.5
;;
;; This program is free software: you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with isayt.  If not, see <http://www.gnu.org/licenses/>.
;;
;;; Commentary:
;;
;; `isayt' is a minor mode to adjust indentation of S-expressions
;; automatically as you type.  Similar to `aggressive-indent-mode' but
;; is much simpler, and not based on timer.
;;
;;; Code:

(defgroup isayt nil
  "Customization group for isayt."
  :prefix "isayt-"
  :group 'electricity
  :group 'indent)

(defcustom isayt-ignored-commands '(undo undo-tree-undo undo-tree-redo whitespace-cleanup)
  "Commands after which indentation should not be performed."
  :type '(repeat symbol)
  :group 'isayt
  :package-version '(isayt . "0.0.6"))

(defvar-local isayt--last-change nil
  "Position of last text change.")

(defun isayt--track-changes (start &rest _)
  "Track START of the change.
Change info is reported by `after-change-functions' hook."
  (setq isayt--last-change start))

(defun isayt--indent-sexp ()
  "Automatically indent expression when appropriate."
  (when isayt--last-change
    (setq isayt--last-change nil)
    (unless (memq this-command isayt-ignored-commands)
      (ignore-errors
        (let ((ppss (syntax-ppss)))
          (save-restriction
            (save-mark-and-excursion
              (unless (and (nth 3 ppss)
                           (not (nth 4 ppss)))
                (let ((changes (prepare-change-group))
                      (inhibit-modification-hooks t))
                  (indent-sexp)
                  (undo-amalgamate-change-group changes))))))))))

;;;###autoload
(define-minor-mode isayt-mode
  "Indent S-expressions As You Type minor mode.

Automatically indents current expressions when changing text around it."
  :lighter " isayt"
  :init-value nil
  (if (and isayt-mode
           (not current-prefix-arg))
      (progn (add-hook 'after-change-functions #'isayt--track-changes t t)
             (add-hook 'post-command-hook #'isayt--indent-sexp -90 t))
    (remove-hook 'after-change-functions #'isayt--track-changes t)
    (remove-hook 'post-command-hook #'isayt--indent-sexp t)))

(provide 'isayt)
;;; isayt.el ends here
