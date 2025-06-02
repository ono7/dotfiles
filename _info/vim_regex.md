# look arounds, vim look arounds affect the previous capture group only

Negative look behind, find all occurrences of AnsibleFilterError that do not
have raise before them

```
/\v(raise\s+)@<!AnsibleFilterError
```

```

remove duplicate adjacent lines
:g/^\(.*\)$\n\1$/d


  Positive lookahead: \@=
  Negative lookahead: \@!
      /\v.*parent":\s+(null)@!  -- do not match any lines that contain null after parent":
  Positive lookbehind: \@<=
  Negative lookbehind: \@<!



regex removes blanks at end of line

    :\s*$:: (: is deliminator)

or (to avoid acting on all lines):

    s:\s\+$::)

delete blank lines:
   :g/^$/ d

reduce multiple blank lines to a single blank
    :g/^$/,/./-j
```

# non greedy matches and include new lines `\_`

```
    /\vdef\zs\_.{-}\zeend

```

this matches

```
def
  ... < matches
end
```
