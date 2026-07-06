;; extend-sibling.scm — grow the selection by one tree-sitter sibling per press.
;;
;; Helix's builtin select_next_sibling / select_prev_sibling REPLACE the whole
;; selection with the neighbouring node. These commands EXTEND it instead: the
;; anchoring edge is kept and the head is moved to the next/previous sibling, so
;; nodes can be accreted while in select mode. When there is no sibling at the
;; current level we climb to the parent, matching the builtin motions.

(require "ts-utils.hx/ts.scm") ; current-root, current-rope, named-node-at-char,
; node-start-char, node-end-char
(require "ts-utils.hx/nav.scm") ; next-named-sibling/climb, prev-named-sibling/climb
(require "helix/static.scm") ; selection / range accessors and setters
(require "helix/misc.scm") ; set-status!

(provide extend_next_sibling
  extend_prev_sibling)

;;@doc
;; Extend the selection to include the next tree-sitter sibling of the node at
;; the selection's forward edge, keeping the back edge as the anchor. Climbs to
;; the parent when the current node has no next sibling.
(define (extend_next_sibling)
  (extend-sibling-impl next-named-sibling/climb #t))

;;@doc
;; Extend the selection to include the previous tree-sitter sibling of the node
;; at the selection's back edge, keeping the forward edge as the anchor. Climbs
;; to the parent when the current node has no previous sibling.
(define (extend_prev_sibling)
  (extend-sibling-impl prev-named-sibling/climb #f))

;; `step` finds the sibling to grow towards; `forward?` selects which edge of the
;; primary range we navigate from and which edge we keep fixed.
(define (extend-sibling-impl step forward?)
  (let ([root (current-root)]
        [rope (current-rope)])
    (if (not root)
      (set-status! "extend-sibling: no syntax tree")
      (let* ([pr (selection->primary-range (current-selection-object))]
             [from (range->from pr)]
             [to (range->to pr)]
             ;; Navigate from the moving EDGE, not the whole [from,to] span:
             ;; resetting to the full span collapses to the parent once the
             ;; selection covers 2+ siblings, which would break node-by-node
             ;; walking. Forward edge is the last char inside the selection.
             [edge (if forward?
                    (if (> to from) (- to 1) to)
                    from)]
             [node (named-node-at-char root rope edge)])
        (cond
          [(not node) (set-status! "extend-sibling: no node at cursor")]
          [else
            (let ([target (step node)])
              (if (not target)
                (set-status! (if forward?
                              "extend-sibling: no next sibling"
                              "extend-sibling: no previous sibling"))
                ;; Keep the far edge as anchor, move the head to the sibling's
                ;; outer boundary. Forward => (from .. sibling-end);
                ;; backward => (to .. sibling-start).
                (let ([new-range (if forward?
                                  (range from (node-end-char rope target))
                                  (range to (node-start-char rope target)))])
                  (set-current-selection-object!
                    (range->selection new-range)))))])))))
