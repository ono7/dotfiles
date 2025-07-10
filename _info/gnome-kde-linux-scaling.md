gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"

I'm already using Fractional Scaling on KDE, currently set at 1.10. It works
perfectly with KDE apps that I use, and while Firefox and Thunderbird have
initially blurry fonts, I edited their .desktop files to include a
MOZ_ENABLE_WAYLAND=1 in the command after 'Exec=' part and it works fine. I
don't use any other GTK apps so have no issues.
