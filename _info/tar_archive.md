## curl and untar

`curl -L https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz | tar xzv`

## find only non binary files in linux

`find . -type f -exec grep -Iq . {} \; --print0 | tar -vczf /tmp/1.tgz -T -`

## tar only certain file extensions, keep using -o -name `"*.ext"` to add more

`find . -name "*.php" -o -name "*.html" | tar -vzcf /tmp/1.tgz -T -`

`find . -name "*.php" -o -name "*.html" | tar -vzcf /tmp/1.tgz -T -`

## rip grep results to vim, for easier filtering

rg "tmpFolderBaseName" --trim | vim
