
## sway config for keyboard

keyboard settings for z13 gen2 using sway

this will also setup the keyboard repeat rate for faster response

```
# Configure your main keyboard specifically
input "1:1:AT_Translated_Set_2_keyboard" {
    xkb_layout us
    xkb_variant colemak
    xkb_options caps:escape,altwin:ctrl_alt_win,ctrl:swap_ralt_rctl
    repeat_delay 150
    repeat_rate 50
}

input "6058:20564:ThinkPad_Extra_Buttons" {
    xkb_layout us
    xkb_variant colemak
    xkb_options caps:escape,altwin:ctrl_alt_win,ctrl:swap_ralt_rctl
    repeat_delay 150
    repeat_rate 50
}

```
