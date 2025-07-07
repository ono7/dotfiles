# vim registers (:h registers)

`https://www.youtube.com/watch?v=I5QGlfbuCfs`

- `""` unnamed
- `"0` holds last yanked text
- `"1` holds last deleted text
- `a-z` are named registers and can store anything we want in them

* to override a register `:let @a='<c-r>a <edit>'` this will allow editing the
  register a contents, to clear it `let @a=''`

* anytime something is deleted registers 1-9 are populated once 9 is reached,
  register 1 is then overwritten etc.

* anything changed or yanked goes into the unnamed register and also int "0
* anything deleted goes into unnamed but also in "1
