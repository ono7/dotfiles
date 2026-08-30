# ~/.ipython/profile_default/ipython_config.py

c = get_config()  # noqa: F821

# Keybindings: Emacs mode
c.TerminalInteractiveShell.editing_mode = "emacs"
c.TerminalInteractiveShell.prompt_includes_vi_mode = False
c.TerminalInteractiveShell.timeoutlen = 0.01

# Enable true color and use light background base
c.TerminalInteractiveShell.true_color = True
c.TerminalInteractiveShell.colors = "LightBG"

# Custom ANSI Color Scheme matching custom-paper light palette
# -------------------------------------------------------------------------
# normal / text   : #000000 (Pitch Black)       -> \033[38;2;0;0;0m
# keyword / error : #C4434B (Rust Red)          -> \033[38;2;196;67;75m
# string          : #4A6B53 (Olive Ink)         -> \033[38;2;74;107;83m
# comment         : #8C96A4 (Graphite Pencil)   -> \033[38;2;140;150;164m
# special / punct : #5C6A7B (Slate Dim)         -> \033[38;2;92;106;123m
# number / warn   : #996E14 (Warm Amber)        -> \033[38;2;153;110;20m
# -------------------------------------------------------------------------
c.colors_lightbg = {
    "normal": "\033[38;2;0;0;0m",  # Pitch black
    "number": "\033[38;2;153;110;20m",  # Amber / dark yellow
    "string": "\033[38;2;74;107;83m",  # Olive ink
    "name": "\033[38;2;0;0;0m",  # Pitch black
    "punct": "\033[38;2;92;106;123m",  # Slate dim
    "comment": "\033[38;2;140;150;164m",  # Graphite pencil
    "NoColor": "\033[38;2;0;0;0m",
}

# Completion settings
c.IPCompleter.use_jedi = True
c.IPCompleter.jedi_compute_type_timeout = 100
