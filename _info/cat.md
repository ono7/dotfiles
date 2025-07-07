## cat command quickies

decodes a base64 string into a file, usefull for transfering remotely without ssh...

```sh
cat <<EOF | base64 -d >decoded.txt
<base64-data>
EOF<enter>
```
