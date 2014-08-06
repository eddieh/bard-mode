;;; bard-mode.el --- Bard major mode

;; Copyright (C) 2014  Eddie Hillenbrand

;; Author: Eddie Hillenbrand
;; Keywords: bard, languages

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; This mode is a major mode for editing Bard code.

;;; Code:

(defvar bard-mode-hook nil)

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.bard\\'" . bard-mode))

;; taken from js-mode
(defun bard-regexp-opt-symbol (list)
  "Like `regexp-opt', but surround the result with `\\\\_<' and `\\\\_>'."
  (concat "\\_<" (regexp-opt list t) "\\_>"))

(defconst bard-start-identifier-re "[a-zA-Z_]"
  "Regexp matching the start of a Bard identifier, without grouping.")

(defconst bard-identifier-re (concat bard-start-identifier-re
				  "\\(?:\\s_\\|\\sw\\)*")
  "Regexp matching a Bard identifier, without grouping.")

(defconst bard-method-re
  (concat
   "^\\s-*method\\s-+\\(" bard-identifier-re "\\)")
  "Regexp matching the start of a Bard method header. Match group
  1 is the name of the method.")

(defconst bard-non-statement-keywords
  (bard-regexp-opt-symbol
   '("alias"
     "aspect"
     "augment"
     "catch"
     "CATEGORIES"
     "class"
     "case"
     "compound"
     "else"
     "elseIf"
     "endAspect"
     "endAugment"
     "endClass"
     "endCompound"
     "endContingent"
     "endDelegate"
     "endEnumeration"
     "endForEach"
     "endFunction"
     "endIf"
     "endLoop"
     "endPrimitive"
     "endWhich"
     "endWhichIs"
     "endTry"
     "endWhile"
     "ENUMERATE"
     "enumeration"
     "in"
     "METHODS"
     "method"
     "of"
     "others"
     "primitive"
     "PROPERTIES"
     "satisfied"
     "SHARED"
     "task"
     "unsatisfied"
     "withTimeout")))

(defconst bard-control-keywords
  (bard-regexp-opt-symbol
   '("delegate"
     "escapeContingent"
     "escapeForeach"
     "escapeIf"
     "escapeLoop"
     "escapeTry"
     "escapeWhich"
     "escapeWhile"
     "contingent"
     "forEach"
     "function"
     "if"
     "loop"
     "necessary"
     "nextIteration"
     "prior"
     "return"
     "sufficient"
     "throw"
     "trace"
     "tron"
     "troff"
     "which"
     "whichIs"
     "try"
     "while"
     "yield"
     "yield_and_wait"
     "yield_while")))

(defconst bard-operator-keywords
  (bard-regexp-opt-symbol
   '("and"
     "as"
     "downTo"
     "instanceOf"
     "is"
     "isNot"
     "local"
     "not"
     "notInstanceOf"
     "or"
     "pi"
     "this"
     "noAction"
     "null"
     "xor")))

(defvar bard-font-lock-keywords
  (list
   '("#.*" . font-lock-comment-face)
   (list bard-method-re 1 font-lock-function-name-face)
   (list bard-non-statement-keywords 1 font-lock-keyword-face)
   (list bard-control-keywords 1 font-lock-keyword-face)
   (list bard-operator-keywords 1 font-lock-keyword-face)
   "Highlight expressions for Bard mode"))

(defvar bard-mode-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax-entry ?# "<" st)
    (modify-syntax-entry ?\n ">" st)
    st)
  "Syntax table for `bard-mode'.")

(defun bard-mode ()
  "Major mode for editing Bard files"
  :syntax-table bard-mode-syntax-table
  (interactive)
  (kill-all-local-variables)
  (setq-local comment-start "# ")
  (setq-local comment-start-skip "#+\\s-*")
  (set (make-local-variable 'font-lock-defaults)
       '(bard-font-lock-keywords))
  (setq major-mode 'bard-mode)
  (setq mode-name "Bard")
  (run-hooks 'bard-mode-hook))

(provide 'bard-mode)
