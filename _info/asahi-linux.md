## wifi

`nmcli dev wifi con "ssid" password "password"`

## set colemak

- List
  `localectl list-keymaps | grep colemak`

- Set
  `sudo localectl set-keymap us-colemak`

or

`loadkeys us-colemoak`

or permanently with

localectl set-keymap colemak
In X11, you can set it with

`setxkbmap -layout colemak`

or permanently by adding that line to your .xinitrc file. Apparently, you can also do

`localectl set-x11-keymap colemak`

## temp set escape to capslock

`sudo echo "keycode 58 = Escape" | sudo loadkeys -`

## quickly set fonts bigger on virtual console (no gui)

setfont -d

## install fonts on fedora

`sudo dnf search font | grep console`
`sudo dnf install terminus-fonts-console`

## permanet fonts for console

```bash
# /etc/vconsole.conf
# add this for fedora

KEYMAP=us-colemak
FONT=ter-132n
FONT_MAP=8859-2
XKBVARIANT=colemak
```
