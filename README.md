# cutthroat.nvim

A simple plugin implementing cutlass-mode.

1. [Cutthroat Cutlass mode](#cutthroat-cutlass-mode)
1. [Cutthroat Commands](#cutthroat-cut-commands)
1. [Cutthroat Yank-Ring](#cutthroat-yank-ring)

Does not behave well with yanking to named registers until [this](https://github.com/neovim/neovim/issues/10225) is fixed.

## Cutthroat Cutlass mode

Read [this](https://github.com/nelstrom/vim-cutlass) for an introduction
into cutlass-mode.

This plugin changes the vim commands `d`, `D`, `dd`, `c`, `C`, `cc`, `x`, `X`, `s`, `S`
to **"true deletion"** commands, writing exclusively to the "deletion register" `"-`.

The yank commands `y`, `Y`, `yy` will utilize the "history registers", `"0`, `"1`, `"2`, etc.

Additionally, a new set of commands is introduced, the **"cut"** commands, which contrast with
the "true deletion" commands. They are explained [in the next section](#cutthroat-cut-commands).

#### Differences to nelstroms cutlass

Note that **cutthroat.vim** does deviate from [the definition here](https://github.com/nelstrom/vim-cutlass) a bit.

For once, `"0` is included in the history registers. Making the history
registers `"0`, `"1`, `"2`, etc. till `9` (and possible even further).
Yanking and cutting will write to `""` and `"0`, shifting the previous content of
`"0` to `"1`, `"1` to `"2`, and so on, till you reach `"9"` (and possible even further).

Another change that deviates from [nelstrom's definition](https://github.com/nelstrom/vim-cutlass#redefining-vims-registers)
is how prefixing a deletion command with a register works,
like say `"zdd`. Instead of working exactly like a **cut** command, writing
to `""`, `"0`, and `"z`, it will only write to `"z` and `"-`.
This makes them stand apart from prefixing a **yank**, or **cut** command,
which would yank to `""`, `"0`, and `"a`.

## Cutthroat Yank Ring

The yank ring facilitates accessing prior yanks and [cuts](cutthroat-cut-commands).

Whenever you paste from within the yank ring using the keys, `p`, `P`, `gp`, `gP`, `v_p`, `v_P` (pasting in visual mode),
the yank ring will be enabled. The yank ring is traversed using `<C-n>` and `<C-p>`.

1. `<C-n>` will go forwards in the yank ring
1. `<C-p>` will go backwards in the yank ring

Cutthroat doesn't do any mappings automatically. Any mappings you
wish, you'll have to do yourself.

| internal mappings               | suggested mappings |
| ------------------------------- | ------------------ |
| `<plug>(CutthroatYankRing_p)`   | `p`                |
| `<plug>(CutthroatYankRing_P)`   | `P`                |
| `<plug>(CutthroatYankRing_gp)`  | `gp`               |
| `<plug>(CutthroatYankRing_gP)`  | `gP`               |
| `<plug>(CutthroatYankRing_v_p)` | `v_p`              |
| `<plug>(CutthroatYankRing_v_P)` | `v_P`              |

An example config would be:

```vim
nmap p <plug>(CutthroatYankRing_p)
nmap P <plug>(CutthroatYankRing_P)

nmap gp <plug>(CutthroatYankRing_gp)
nmap gP <plug>(CutthroatYankRing_gP)

xmap p <plug>(CutthroatYankRing_v_p)
xmap P <plug>(CutthroatYankRing_v_P)
```

### Enlarging the Yank Ring

The default ring is of size 10: the registers `"0` till `"9`. However the yank ring
can be configured to reach into the named registers as well, i.e. after `"9`, `"a`
would follow, then `"b`, etc. until `"z`.

For example:

```vim
let g:cutthroat#yankring#named_registers_count = 5
" this would add the registers "a, "b, "c, "d, and "e to the yankring
```

The default is **0**.

### Combining with another map

Chances are, your `p`, or `P` key are already mapped. In this case, you
might use the following options, to point to these mappings from within cutthroat.

```vim
let g:cutthroat#yankring#command_p   = '<plug>(MyAwesomePastePlug)'
let g:cutthroat#yankring#command_P   = '<plug>(MyAwesomePASTEPlug)'
let g:cutthroat#yankring#command_v_p = '<plug>(MyAwesomevPastePlug)'
let g:cutthroat#yankring#command_v_P = '<plug>(MyAwesomevPASTEPlug)'
let g:cutthroat#yankring#command_gp  = '<plug>(MyAwesomegPastePlug)'
let g:cutthroat#yankring#command_gP  = '<plug>(MyAwesomegPASTEPlug)'

let g:cutthroat#yankring#allow_recursive_maps = v:true
" this defaults to v:false, it is necessary e.g. if you want to map to a <plug>:
"" A recursive mapping: nmap p <plug>(Foo)
"" A nonrecursive mapping: nmap p gp
```

## Cutthroat Cut Commands

*Cut* commands under the hood just do a yank, followed by the
"true deletion" command.  They imitate keep the previous behavior
of the vim commmands.

Cutthroat doesn't do any mappings automatically. Any mappings you
wish, you'll have to do yourself.

| internal mappings                 | usage case                                                      | suggested mappings
| --------------------------------- | --------------------------------------------------------------- | ------------------ |
| `<plug>(CutthroatDelete)`         | yank text selected by motion to selected register and delete it | `x`                |
| `<plug>(CutthroatDeleteLine)`     | yank current line to selected register and delete it            | `X`                |
| `<plug>(CutthroatDeleteToEOL)`    | yank till EOL to selected register and delete it                | `xx`               |
| `<plug>(CutthroatDeleteVisual)`   | yank visual area to selected register and delete it             | `x_v`              |
| `<plug>(CutthroatChange)`         | yank text selected by motion to selected register and change it | -                  |
| `<plug>(CutthroatChangeLine)`     | yank current line to selected register and change it            | -                  |
| `<plug>(CutthroatChangeToEOL)`    | yank till EOL to selected register and change it                | -                  |
| `<plug>(CutthroatChangeVisual)`   | yank visual area to selected register and change it             | -                  |
| `<plug>(CutthroatReplace)`        | replaces text selected by motion with selected register         | `gr`, `s`          |
| `<plug>(CutthroatReplaceLine)`    | replaces current line with selected register                    | `grr`, `ss`        |
| `<plug>(CutthroatReplaceToEOL)`   | replaces till EOL with selected register                        | `gR`, `S`          |
| `<plug>(CutthroatReplaceVisual)`  | replaces visual area with selected register                     | `gr_v`, `s_v`      |
| `<plug>(CutthroatExchange)`       | exchanges text selected by motion with selected register        | `s`                |
| `<plug>(CutthroatExchangeLine)`   | exchanges current line with selected register                   | `ss`               |
| `<plug>(CutthroatExchangeToEOL)`  | exchanges till EOL with selected register                       | `S`                |
| `<plug>(CutthroatExchangeVisual)` | exchanges visual area with selected register                    | `s_v`              |

An example config would be:

```vim
nmap x <plug>(CutthroatDelete)
nmap xx <plug>(CutthroatDeleteLine)
nmap X <plug>(CutthroatDeleteToEOL)
xmap x <plug>(CutthroatDeleteVisual)

nmap s <plug>(CutthroatReplace)
nmap ss <plug>(CutthroatReplaceLine)
nmap S <plug>(CutthroatReplaceToEOL)
xmap s <plug>(CutthroatReplaceVisual)
```

## Inspirations for this plugin

* [nelstroms specification](https://github.com/nelstrom/vim-cutlass)
* [nelstroms original article](http://vimcasts.org/blog/2013/11/registers-the-good-the-bad-and-the-ugly-parts/)
* [svermeulen](https://github.com/svermeulen)s plugins, including:
  * [vim-easyclip](https://github.com/svermeulen/vim-easyclip)
  * [vim-subversive](https://github.com/svermeulen/vim-subversive)
  * [vim-yoink](https://github.com/svermeulen/vim-yoink)
