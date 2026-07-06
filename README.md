# extend-sibling.hx

Extend the selection by one tree-sitter sibling node, for Helix.

Helix’s builtin `select_next_sibling` / `select_prev_sibling` replace the whole
selection with the neighbouring node. These commands extend it instead, so you
can accrete nodes:

- `:extend_next_sibling` – grow the selection to include the next sibling.
- `:extend_prev_sibling` – grow the selection to include the previous sibling.

When the current node has no sibling at its level, navigation climbs to the
parent, matching the builtin motions. Operates on the primary selection.

## Install

Install with Forge:

```
forge pkg install --git https://github.com/waddie/extend-sibling.hx
```

Then in `~/.config/helix/init.scm`:

```scheme
(require "extend-sibling.hx/extend-sibling.scm")
```

Optionally bind keys, for example:

```scheme
(keymap (global)
  (normal
    (A-N ":extend_next_sibling")
    (A-P ":extend_prev_sibling"))
  (select
    (A-n ":extend_next_sibling")
    (A-p ":extend_prev_sibling")))
```

## License

Copyright © 2026 Tom Waddington

Distributed under the MIT License. See LICENSE file for details.
