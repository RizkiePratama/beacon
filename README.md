# Beacon
A simple flexible popup dialog to run on X. forked from lighthouse project.

# What's the difference with the original project?
since the original project are no longer maintained, i'm here trying to continue maintain it's core feature as a new project and possibly adding more feature in teh future to suits my needs.
<p align="center">
  <img src="http://i.imgur.com/Z6W0Ube.gif" alt="demo"/>
  <br>
</p>


In the demo a hotkey is mapped to `beacon | sh` with `beaconrc` using `cmd.py`, which is included in `config/beacon/` and installed by `beacon-install`.
# Installation

Available in the AUR as [beacon-git](https://aur.archlinux.org/packages/beacon-git/).

Manual build
---

Build the binary.

    make

Install the binary.

    sudo make install

Create config files. (This is important!)

    beacon-install
    
You may also need to make all the `cmd` scripts executable.  (If you write your own script, be sure to make that exectuable as well.)

    chmod +x ~/.config/beacon/cmd*

Dependencies
---

Arch:

    libpth
    libx11
    libxcb
    cairo
    libxcb-xkb
    libxcb-xinerama

Ubuntu:

    libpth-dev
    libx11-dev
    libx11-xcb-dev
    libcairo2-dev
    libxcb-xkb-dev
    libxcb-xinerama0-dev
    libxcb-randr0-dev

NixOS:

    nixos.pkgs.xlibs.libX11
    nixos.pkgs.xlibs.libxcb
    nixos.pkgs.xlibs.libxproto
    nixos.pkgs.cairo

# How to use
Typically you'll want to map a hotkey to run

    beacon | sh

Lighthouse is a simple dialog that pipes whatever input you type into
the standard input of the executable specified by `cmd=[file]` in your
`beaconrc`. The standard output of that executable is then used to
generate the results.  A selected result (move with arrow keys to highlight
and then hit enter to select) will then have its `action`
printed to standard out (and in the case above, into the shell).

# Passing arguments to cmd

Lighthouse will pass any unrecognized arguments it gets on to the cmd handler.
The preferred way to pass arguments for your cmd handler to beacon is like this:

    beacon -- some-cmd-argument --some-cmd-option | sh

Using the GNU standard '--' to tell Lighthouse not to attempt to parse arguments beyond that point.
This is important, as it prevents Lighthouse from seeing `--some-cmd-option`,
attempting to recognize it as a beacon option,
and failing. It also means you can reuse option characters used by beacon for your cmd handler
(eg. '-c'), if you need to.

Syntax
---
The syntax of a result is simple.
`{ title | action }`or `{ title | action | description }`
The `title` is displayed in the results and the `action` is written to standard out
when that result is selected.  A common use case would therefore be
`beacon | sh` and `action` would be some shell command.  Run `beacon-install` and then
`beacon | sh` to see this in action.  The `title` will be `look! [input]` and the
`action` will be `[input]`, so you've effectively created a small one time shell prompt.
The description is a text displayed according to the highlighted selection.
To create multiple results simply chain them together: `{ title1 | action1 }{ title2 | action2 }`

* There is also image support in the form `{ %Ifile.png% <- an image! | feh file.png }`.
To use `%` as a character, escape it with `\%`.
Currently only PNG images are supported if the program is compiled without GDK
support.

* To go to the next line (in description window) use `%N`

* To draw a line in the description window (to separate it) `%L`

* To format your text in bold use `%B text... %`

* To center text/image `%C ... %`

Other ways to use beacon
---
Because everything is handled through standard in and out, you can use pretty much any
executable.  If you want to use a python file `~/.config/beacon/cmd.py`, simply point to it in `~/.config/beacon/beaconrc`
by making the line `cmd=~/.config/beacon/cmd.py`.  (Be sure to include `#!/usr/bin/python` at the top of your script!)  If you'd like some inspiration, check out the script in `config/beacon/cmd.py`.

Debugging your script
---
Run `beacon` in your terminal and look at the output.  If the script crahes you'll see its
standard error, and if it succeeds you'll see what beacon is outputting.  Check out
`config/beacon/cmd` for an example of a basic script and `config/beacon/cmd.py` for a
more complex script.

Note that any files being used by beacon, including images in the results, the command file and optional configuration files must escape certain characters: ` |, &, ;, <, >, (, ), {, }`.

Options
---
The `-c` command line flag will allow you to set a custom location for the configurations file.
An example would be `beacon -c ~/beaconrc2`.

If passing additional arguments to the cmd handler (see 'Passing arguments to cmd' above),
all options to beacon should come before the `--`.
For example `beacon -c ~/beaconrc2 -- some arguments for cmd handler`

Configuration file
---
Check out the sample `beaconrc` in `config/beacon`.  Copy it to your directory by
running `beacon-install`.

List of settings you can set in the configuration file:
- `font_name`
- `font_size`
- `desc_font_size`
- `horiz_padding`
- `cursor_padding`
- `height`
- `width`
- `x`
- `y`
- `max_height`
- `screen`
- `desktop`
- `backspace_exit`
- `cmd`
- `query_fg`, `query_bg`, `result_fg`, `result_bg`, `hightlight_fg`, `highlight_bg`
- `dock_mode` (i3 users must set it to 0)
- `desc_size` (size in pixel of the description window)
- `auto_center` (if set to 1, it center the window when the description is not
  expanded)
- `line_gap` (gap in the description window drawed with %N)

TODO
---
Add alignment, colors and other formatting features to the results syntax.

BUGS
---
The cursor doesn't actually move the text backwards, making it hard to edit longer strings
