```

# use short for github
gpg --list-keys --keyid-format SHORT
  [keyboxd]
  ---------
  pub   rsa4096/21C63BA5 <<< THIS IS THE PUB KEY

#################### delete a key #################

gpg --delete-key YOUR_KEY_ID

################# setup git #####################

gpg --full-generate-key
gpg --list-keys --keyid-format SHORT
git config --global user.signingkey YOUR_KEY_ID

# export key to github
gpg --armor --export YOUR_KEY_ID

######### backing ###########
gpg --export-secret-key --armor YOUR_KEY_ID > private.key
gpg --export --armor YOUR_KEY_ID > public.key

############### import ################
gpg --import private.key
gpg --import public.key
# set trust level
gpg --edit-key YOUR_KEY_ID

# update gitconfig
git config --global user.signingkey YOUR_KEY_ID
git config --global commit.gpgsign true
```
