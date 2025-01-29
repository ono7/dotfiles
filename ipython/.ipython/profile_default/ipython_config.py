from IPython.terminal.prompts import Prompts, Token  # noqa: F401
import IPython.terminal.prompts as prompts  # noqa: F401

c = get_config()  # noqa: F821

# Set colors for better visibility on dark background
c.TerminalInteractiveShell.colors = "Linux"  # This gives a good dark-background preset
c.TerminalInteractiveShell.true_color = False

# If you need more customization, you can set specific colors:
c.colors_linux = {
    "normal": "\033[0;37m",  # Light gray
    "number": "\033[1;36m",  # Cyan
    "string": "\033[1;32m",  # Green
    "name": "\033[0;37m",  # Light gray
    "punct": "\033[0;37m",  # Light gray
    "comment": "\033[0;36m",  # Darker cyan
}
