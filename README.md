# cutthroat.nvim


A simple plugin implementing cutlass-mode.

. [Cutthroat Cutlass mode](#cutthroat-cutlass-mode)
. [Cutthroat Commands](#cutthroat-commands)
. [Cutthroat Yank-Ring](#cutthroat-yank-ring)

## Cutthroat Cutlass mode


## Cutthroat Commands

Cutthroat doesn't do any mappings automatically. Any mappings you wish, you'll have to do yourself.

| internal mappings                  | usage case                              | suggested mappings
| -----------------------------------| ----------------------------------------|--------------------|
| `<plug>(CutthroatDelete)`          | equivalent to executing `v<motion>ygvd` | `x`
| `<plug>(CutthroatDeleteLine)`      | equivalent to executing `v<motion>ygvd` | `X`
| `<plug>(CutthroatDeleteToEOL)`     | equivalent to executing `v<motion>ygvd` | `xx`
| `<plug>(CutthroatChange)`          | equivalent to executing `v<motion>ygvc` | -
| `<plug>(CutthroatChangeLine)`      | equivalent to executing `v<motion>ygvc` | -
| `<plug>(CutthroatChangeToEOL)`     | equivalent to executing `v<motion>ygvc` | -
| `<plug>(CutthroatReplace)`         | equivalent to executing `v<motion>p`    | `gr`, `s`
| `<plug>(CutthroatReplaceLine)`     | equivalent to executing `v<motion>p`    | `grr`, `ss`
| `<plug>(CutthroatReplaceToEOL)`    | equivalent to executing `v<motion>p`    | `gR`, `S`
| `<plug>(CutthroatSubstitute)`      | equivalent to executing `v<motion>ygvp` | -
| `<plug>(CutthroatSubstituteLine)`  | equivalent to executing `v<motion>ygvp` | -
| `<plug>(CutthroatSubstituteToEOL)` | equivalent to executing `v<motion>ygvp` | -

## Cutthroat Yank-Ring



## Inspirations for this plugin
