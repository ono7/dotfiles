## lua regex oneliners

remove anthing that starts with a digit : followed by any number of spaces

```lua
title = title:gsub("^%d+:%s*", "")
```
