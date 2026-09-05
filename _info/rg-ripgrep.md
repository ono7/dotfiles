## install on container RHEL

```vim

if executable('rg')
  let &grepprg = 'rg --vimgrep --no-heading --smart-case --pcre2'
  let &grepformat = '%f:%l:%c:%m'
endif

" this is the best part of my config
function! Rg(args) abort
  " escape the | properly, :Rg -uu 'from (?!ansible|pytest)\w+ import'
  let l:pattern = substitute(a:args, '|', '\\|', 'g')
  execute "silent! grep!" l:pattern
  copen
endfunction

command! -nargs=+ -complete=file Rg call Rg(<q-args>)

```

# Add global bypass to dnf configuration

```bash
echo "sslverify=0" >> /etc/dnf/dnf.conf
```

# Install EPEL repository and ripgrep RH10

```bash
microdnf install -y [https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm](https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm)
microdnf install -y ripgrep



```

## install when tools are missing / tar etc

```bash
# Download binary directly

# Extract with Python standard library
curl -kLO https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz
python3 -c "import tarfile; tarfile.open('ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz').extractall('.')"
mv ripgrep-14.1.1-x86_64-unknown-linux-musl/rg /usr/local/bin/

# Move binary to PATH and cleanup
mv ripgrep-14.1.1-x86_64-unknown-linux-musl/rg /usr/local/bin/
rm -rf ripgrep-14.1.1*

```

## curl and untar linux prebuilt

`curl -L https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz | tar xzv`
