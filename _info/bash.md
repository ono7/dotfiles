# bash as shell

## arrays

Arrays in shell are created by parenthesis

```bash
files=(*.com)

# this might be problematic if files have spaces
for file in "${files[@]}"; do
  printf "%s\n" "$file"
done

readarray -t dirs < <(find ~/.dotfiles -type d)

# quote to prevent splitting
for dir in "${dirs[@]}"; do
  printf "%s\n" "$dir"
done
```

Print length of array
`echo ${#dirs[@]}`

# make bash completion case insensitive

```bash

# ~/.inputrc
set completion-ignore-case on

```

Process Substitution <(...):

- This syntax <(command) runs the command inside the parentheses and presents its output as a file-like object.
  It's often used to pass the output of a command to another command that expects a file input.

- In your specific example:

find ~/.dotfiles -type d: This command finds all directories within ~/.dotfiles
<(find ~/.dotfiles -type d): This runs the find command and makes its output available as if it were a file

- The readarray command:

readarray (also known as mapfile) reads lines from standard input into an array.
The -t option removes any trailing newlines from each line read.

- Putting it all together:

< <(...) redirects the output of the process substitution as input to readarray.
readarray then reads this input line by line into the array dirs.

## associative arrays (key value pairs)

must be declared with -A

`declare -A my_map`

```bash

#!/bin/bash

# Declare an associative array (must use -A)
declare -A my_map

# Add key-value pairs
my_map["name"]="John Doe"
my_map["age"]=30
my_map["city"]="New York"

# Iterating over keys
for key in "${!my_map[@]}"; do
    echo "$key: ${my_map[$key]}"
done

```

## bash and zsh goodies

`${var:-value}` Use var if set; otherwise, use value

`${var:=value}` - Use var if set; otherwise, use value and assign value to var.

`${var:?value}` - Use var if set; otherwise, print value and exit (if not
interactive). If value isn’t supplied, print the phrase parameter null or not set to stderr.

`${var:+value}` - Use value if var is set; otherwise, use nothing.

`${#var}` - Use the length of var.

`${#*}` - ,

`${#@}` - Use the number of positional parameters.

`${var#pattern}` - Use value of var after removing text matching pattern
from the left. Remove the shortest matching piece.

`${var##pattern}` - Same as #pattern, but remove the longest matching piece.
e.g. ${var##\*/} = remove the longest match for '/' returns file name only if var = /etc/test/test.tgz

`${var%pattern}` - Use value of var after removing text matching pattern from the
right. Remove the shortest matching piece.

`${var%%pattern}` - Same as %pattern, but remove the longest matching piece.

## uppercase/lowercase only work on bash zsh use `${var:u} and ${var:l}`

`${var^pattern}` - Convert the case of var to uppercase. The pattern is
evaluated as for filename matching. If the first letter of var’s value matches
the pattern, it is converted to uppercase. var can be _ or @, in which case the
positional parameters are modified. var can also be an array subscripted by _ or
@, in which case the substitution is applied to all the elements of the array.

`%{var^^pattern}` same as above but covers all characters
