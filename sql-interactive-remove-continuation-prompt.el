;;; sql-interactive-remove-continuation-prompt.el --- Replacement for sql-interactive-remove-continuation-prompt in sql.el  -*- lexical-binding: t; -*-

;; Copyright (C) 2014  Michael R. Mauger

;; Author: Michael R. Mauger <michael@mauger.com>
;; Keywords: processes, languages

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Test replacement for sql-interactive-remove-continuation-prompt
;; found in sql.el 3.4 found in Emacs 24.4.

;;; Code:

;;; Strip out continuation prompts

(defvar sql-preoutput-hold nil)

(defun sql-starts-with-prompt-re ()
  "Anchor the prompt expression at the beginning of the output line.
Remove the start of line regexp."
  (replace-regexp-in-string "\\^" "\\\\`" comint-prompt-regexp))

(defun sql-ends-with-prompt-re ()
  "Anchor the prompt expression at the end of the output line.
Remove the start of line regexp from the prompt expression since
it may not follow newline characters in the output line."
  (concat (replace-regexp-in-string "\\^" "" sql-prompt-regexp) "\\'"))

(defun sql-interactive-remove-continuation-prompt (oline)
  "Strip out continuation prompts out of the OLINE.

Added to the `comint-preoutput-filter-functions' hook in a SQL
interactive buffer.  If `sql-output-newline-count' is greater than
zero, then an output line matching the continuation prompt is filtered
out.  If the count is zero, then a newline is inserted into the output
to force the output from the query to appear on a new line.

The complication to this filter is that the continuation prompts
may arrive in multiple chunks.  If they do, then the function
saves any unfiltered output in a buffer and prepends that buffer
to the next chunk to properly match the broken-up prompt.

If the filter gets confused, it should reset and stop filtering
to avoid deleting non-prompt output."

  ;; continue gathering lines of text iff
  ;;  + we know what a prompt looks like, and
  ;;  + there is held text, or
  ;;  + there are continuation prompt yet to come, or
  ;;  + not just a prompt string
  (when (and comint-prompt-regexp
             (or (> (length (or sql-preoutput-hold "")) 0)
                 (> (or sql-output-newline-count 0) 0)
                 (not (or (string-match sql-prompt-regexp oline)
                          (string-match sql-prompt-cont-regexp oline)))))

    (save-match-data
      (let (prompt-found last-nl)

        ;; Add this text to what's left from the last pass
        (setq oline (concat sql-preoutput-hold oline)
              sql-preoutput-hold "")

        ;; If we are looking for multiple prompts
        (when (and (integerp sql-output-newline-count)
                   (>= sql-output-newline-count 1))
          ;; Loop thru each starting prompt and remove it
          (let ((start-re (sql-starts-with-prompt-re)))
            (while (and (not (string= oline ""))
                      (> sql-output-newline-count 0)
                      (string-match start-re oline))
              (setq oline (replace-match "" nil nil oline)
                    sql-output-newline-count (1- sql-output-newline-count)
                    prompt-found t)))

          ;; If we've found all the expected prompts, stop looking
          (if (= sql-output-newline-count 0)
              (setq sql-output-newline-count nil
                    oline (concat "\n" oline))

            ;; Still more possible prompts, leave them for the next pass
            (setq sql-preoutput-hold oline
                  oline "")))

        ;; If no prompts were found, stop looking
        (unless prompt-found
          (setq sql-output-newline-count nil
                oline (concat oline sql-preoutput-hold)
                sql-preoutput-hold ""))

        ;; Break up output by physical lines if we haven't hit the final prompt
        (let ((end-re (sql-ends-with-prompt-re)))
          (unless (and (not (string= oline ""))
                       (string-match end-re oline)
                       (>= (match-end 0) (length oline)))
            ;; Find everything upto the last nl
            (setq last-nl 0)
            (while (string-match "\n" oline last-nl)
              (setq last-nl (match-end 0)))
            ;; Hold after the last nl, return upto last nl
            (setq sql-preoutput-hold (concat (substring oline last-nl)
                                             sql-preoutput-hold)
                  oline (substring oline 0 last-nl)))))))
  oline)

(provide 'sql-interactive-remove-continuation-prompt)
;;; sql-interactive-remove-continuation-prompt.el ends here
