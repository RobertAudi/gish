```
         _     _
    __ _(_)___| |__
   / _` | / __| '_ \
  | (_| | \__ \ | | |
   \__, |_|___/_| |_|
   |___/
               by Aziz Light

```

<dl>
  <dt>Gish</dt>
  <dd>A warrior/mage hybrid, generally using magical powers to enhance his or her abilities in melee. From the Githyanki word " 'gish", meaning 'skilled'.</dd>
</dl>

*(Reference: [Urban Dictionary](http://gish.urbanup.com/6946625))*

Requirements
------------

- Git
- Ruby 1.9+

Installation
------------

Clone the repository in your home directory (or anywhere else):

```
% git clone https://github.com/AzizLight/gish $HOME/.gish
```

### Shell functions

If you want to enable the shell functions, source the init script in your config file.

#### Fish

The Fish config file is typically in `$HOME/config/fish/config.fish`. Add that line to it:

```
. $HOME/.gish/init.fish
```

#### Bash or ZSH

Add this line to you `.bashrc` or `.zshrc`:

```
. $HOME/.gish/init.sh
```

Customization
-------------

The customizations are made on the shell through environment variables.

### `GISH_STATUS_MAX_CHANGES`

This environment variable represents the maximum number of changes that gish will display. If there are too many files in the `git status` output, gish will fall back to the native `git status` command, for performance reasons. If you experience lagging, try to lower the value of this variable. The default is `150`.

For Fish:

```
set -gx GISH_STATUS_MAX_CHANGES "150"
```

For Bash or ZSH:

```
export GISH_STATUS_MAX_CHANGES=150
```

Commands
--------

### `add`

*(Aliased to `ga`)*

Fuzzy `git add`.

#### Usage

```
> gish add [<option> ...] [<query> ...]
```

#### Options

- `-u` or `--untracked`
- `-t` or `--tracked`
- `-r` or `--from-root`
- `-g` or `--greedy`

### `status`

*(Aliased to `gs`)*

Better `git status`.

#### Usage

```
> gish status
```

Related
-------

- [SCM Breeze](https://github.com/ndbroadbent/scm_breeze)

Contributing
------------

1. Fork it.
2. Create a branch (`git checkout -b awesome-feature`)
3. Commit your changes (`git commit -am "Add AWESOME feature"`)
4. Push to the branch (`git push origin awesome-feature`)
5. Open a [Pull Request](https://github.com/AzizLight/gish/pulls)

### Guidelines

- The first line of a commit message should be:
    * Short
    * In the present tense
- The first line of a commit message **MUST NOT** end with a punctuation mark (i.e.: `.` or `!`)
- If the commit has a lot of changes (which should NOT happen by the way), add a description after the commit message containing a list of the changes (among other things).

License
-------

The MIT License (MIT)

Copyright (c) 2014 Aziz Light

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
