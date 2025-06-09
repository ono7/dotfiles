import IPython.terminal.prompts as prompts  # noqa: F401
from IPython.terminal.prompts import Prompts, Token  # noqa: F401

c = get_config()  # noqa

c.TerminalInteractiveShell.timeoutlen = 0.01  # 10ms timeout (or use 0.01 for 10ms)

c.TerminalInteractiveShell.colors = "Linux"  # This gives a good dark-background preset
c.TerminalInteractiveShell.true_color = True
c.TerminalInteractiveShell.editing_mode = "vi"

# Custom colors
c.colors_linux = {
    "normal": "\033[0;37m",  # Light gray
    "number": "\033[1;36m",  # Cyan
    "string": "\033[1;32m",  # Green
    "name": "\033[0;37m",  # Light gray
    "punct": "\033[0;37m",  # Light gray
    "comment": "\033[0;36m",  # Darker cyan
    "NoColor": "\033[0;37m",
}

# Show vi mode in prompt
c.TerminalInteractiveShell.prompt_includes_vi_mode = True

# Reduce completion delay
c.IPCompleter.use_jedi = True  # Keep Jedi for better completions
c.IPCompleter.jedi_compute_type_timeout = 100  # 100ms timeout for type inference
