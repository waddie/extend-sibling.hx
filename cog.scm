;;; cog.scm - Forge package manifest for extend-sibling.hx
;;;
;;; Installable with Steel's package manager:
;;;
;;;   forge pkg install --git https://github.com/waddie/extend-sibling.hx
;;;
;;; then, in ~/.config/helix/init.scm:
;;;
;;;   (require "extend-sibling.hx/extend-sibling.scm")
;;;
;;; Forge copies this directory to ~/.steel/cogs/extend-sibling.hx/.

(define package-name 'extend-sibling.hx)
(define version "0.1.0")

;; ts-utils.hx: shared tree-sitter glue and sibling navigation.
(define dependencies
  '((#:name "ts-utils.hx"
     #:git-url
     "https://github.com/waddie/ts-utils.hx"
     #:sha
     "ea38be16925c0024ed9f3ca2340e0fee291b5439")))
