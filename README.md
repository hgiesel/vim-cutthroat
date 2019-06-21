# cutthroat.nvim

A simple plugin implementing cutlass-mode.

1. [Cutthroat Cutlass mode](#cutthroat-cutlass-mode)
1. [Cutthroat Commands](#cutthroat-cut-commands)
1. [Cutthroat Yank-Ring](#cutthroat-yank-ring)

Does not behave well with yanking to named registers until [this](https://github.com/neovim/neovim/issues/10225) is fixed.

## Cutthroat Cutlass mode

Read [this](https://github.com/nelstrom/vim-cutlass) for an introduction
into cutlass-mode.

The previous vim commands, namely `d`, `D`, `dd`, `c`, `C`, `cc`, `x`, `X`, `s`, `S`
will all become "true deletion" commands, writing exclusively to the "deletion register"
`"-`.

The yank commands `y`, `Y`, `yy` will utilize the "history registers", `"0`, `"1`, `"2`, etc.

Additionally, a new set of commands is introduced, the "cut" commands, which contrast with
the "true deletion" commands. They are explained [in the next section](#cutthroat-cut-commands).

#### Differences to nelstroms cutlass

Note that **cutthroat.vim** does deviate from [this description](https://github.com/nelstrom/vim-cutlass) a bit.

For once, `"0` is included in the history registers. Making the history
registers `"0`, `"1`, `"2`, etc. till `9`. Yanking will write to `""` and `"0`,
shifting the previous content of `"0` to `"1`, `"1` to `"2`,
and so on, till you reach `"9"`.

Another change is how prefixing a deletion command with a register works,
like say `"add`. Instead of working exactly like a *cut* command, writing
to `""`, `"0`, and `"a`, it will only write to `"a` and `"-`.
This makes them stand apart from prefixing a *cut* command,
which would yank to `""`, `"0`, and `"a`.

## Cutthroat Cut Commands

*Cut* commands under the hood just do a yank, followed by the
"true deletion" command.  They mostly keep the previous behavior
of the vim commmands.

Cutthroat doesn't do any mappings automatically. Any mappings you
wish, you'll have to do yourself.

| internal mappings                   | usage case                                         | suggested mappings
| ----------------------------------- | -------------------------------------------------- | ------------------ |
| `<plug>(CutthroatDelete)`           | equivalent to executing `v<motion>ygvd`            | `x`                |
| `<plug>(CutthroatDeleteLine)`       | equivalent to executing `Vygvd`                    | `X`                |
| `<plug>(CutthroatDeleteToEOL)`      | equivalent to executing `v$ygvd`                   | `xx`               |
| `<plug>(CutthroatDeleteVisual)`     | equivalent to executing `ygvd`                     | `x_v`              |
| `<plug>(CutthroatChange)`           | equivalent to executing `v<motion>ygvc`            | -                  |
| `<plug>(CutthroatChangeLine)`       | equivalent to executing `Vygvc`                    | -                  |
| `<plug>(CutthroatChangeToEOL)`      | equivalent to executing `v$ygvc`                   | -                  |
| `<plug>(CutthroatChangeVisual)`     | equivalent to executing `ygvc`                     | -                  |
| `<plug>(CutthroatReplace)`          | equivalent to executing `v<motion>p`               | `gr`, `s`          |
| `<plug>(CutthroatReplaceLine)`      | equivalent to executing `Vp`                       | `grr`, `ss`        |
| `<plug>(CutthroatReplaceToEOL)`     | equivalent to executing `v$p`                      | `gR`, `S`          |
| `<plug>(CutthroatReplaceVisual)`    | equivalent to executing `p`                        | `gr_v`, `s_v`      |
| `<plug>(CutthroatSubstitute)`       | equivalent to executing `v<motion>p:set @"=@-<cr>` | `s`                |
| `<plug>(CutthroatSubstituteLine)`   | equivalent to executing `Vp:set @"=@-<cr>`         | `ss`               |
| `<plug>(CutthroatSubstituteToEOL)`  | equivalent to executing `v$p:set @"=@-<cr>`        | `S`                |
| `<plug>(CutthroatSubstituteVisual)` | equivalent to executing `p:set @"=@-<cr>`          | `s_v`              |

An example config would be:

```vim
nnoremap x <plug>(CutthroatDelete)
nnoremap xx <plug>(CutthroatDeleteLine)
nnoremap X <plug>(CutthroatDeleteToEOL)
xnoremap x <plug>(CutthroatDeleteVisual)

nnoremap s <plug>(CutthroatReplace)
nnoremap ss <plug>(CutthroatReplaceLine)
nnoremap S <plug>(CutthroatReplaceToEOL)
xnoremap s <plug>(CutthroatReplaceVisual)
```

## Cutthroat Yank Ring




## Inspirations for this plugin

* [nelstroms specification](https://github.com/nelstrom/vim-cutlass)
* [nelstroms original article](http://vimcasts.org/blog/2013/11/registers-the-good-the-bad-and-the-ugly-parts/)
* [svermeulen](https://github.com/svermeulen)s plugins, including:
  * [vim-easyclip](https://github.com/svermeulen/vim-easyclip)
  * [vim-subversive](https://github.com/svermeulen/vim-subversive)
  * [vim-yoink](https://github.com/svermeulen/vim-yoink)
