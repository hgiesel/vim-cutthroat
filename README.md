# cutthroat.nvim

A simple plugin implementing cutlass-mode.

. [Cutthroat Cutlass mode](#cutthroat-cutlass-mode)
. [Cutthroat Commands](#cutthroat-commands)
. [Cutthroat Yank-Ring](#cutthroat-yank-ring)

## Cutthroat Cutlass mode


## Cutthroat Commands

Cutthroat doesn't do any mappings automatically. Any mappings you wish, you'll have to do yourself.

| internal mappings                  | usage case                              | suggested mappings
| ---------------------------------- | --------------------------------------- | ------------------ |
| `<plug>(CutthroatDelete)`          | equivalent to executing `v<motion>ygvd` | `x`
| `<plug>(CutthroatDeleteLine)`      | equivalent to executing `Vygvd`         | `X`
| `<plug>(CutthroatDeleteToEOL)`     | equivalent to executing `v$ygvd`        | `xx`
| `<plug>(CutthroatChange)`          | equivalent to executing `v<motion>ygvc` | -
| `<plug>(CutthroatChangeLine)`      | equivalent to executing `Vygvc`         | -
| `<plug>(CutthroatChangeToEOL)`     | equivalent to executing `v$ygvc`        | -
| `<plug>(CutthroatReplace)`         | equivalent to executing `v<motion>p`    | `gr`, `s`
| `<plug>(CutthroatReplaceLine)`     | equivalent to executing `Vp`            | `grr`, `ss`
| `<plug>(CutthroatReplaceToEOL)`    | equivalent to executing `v$p`           | `gR`, `S`
| `<plug>(CutthroatSubstitute)`      | equivalent to executing `v<motion>ygvp` | -
| `<plug>(CutthroatSubstituteLine)`  | equivalent to executing `Vygvp`         | -
| `<plug>(CutthroatSubstituteToEOL)` | equivalent to executing `v$ygvp`        | -

## Cutthroat Yank-Ring



## Inspirations for this plugin

* [svermeulen](https://github.com/svermeulen)s plugins, including:
  * [vim-easyclip](https://github.com/svermeulen/vim-easyclip)
  * [vim-subversive](https://github.com/svermeulen/vim-subversive)
  * [vim-yoink](https://github.com/svermeulen/vim-yoink)
