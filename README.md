My .emacs, .zshrc, .vimrc...

Setup Guide
=================

    git clone --recursive https://github.com/dengzhp/dotfiles.git

.emacs
-----------

```
cd /path/to/dotfiles/vendor/
wget http://ourcomments.org/Emacs/DL/elisp/nxhtml/zip/nxhtml-2.08-100425.zip
unzip nxhtml-2.08-100425.zip
```

* mac

```
brew install emacs --cocoa
```

```
ln -s /path/to/dotfiles/mac/.emacs ~/.emacs
ln -s /path/to/dotfiles/mac/.emacs.d  ~/.emacs.d
```

* linux

```
ln -s /path/to/dotfiles/linux/.emacs ~/.emacs
ln -s /path/to/dotfiles/linux/.emacs.d  ~/.emacs.d
```


.zshrc
----------

```
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
```

* mac

```
ln -s /path/to/dotfiles/mac/.zshrc ~/.zshrc
```

* linux

```
ln -s /path/to/dotfiles/linux/.zshrc ~/.zshrc
```


.vimrc
----------

```
ln -s /path/to/dotfiles/.vimrc ~/.vimrc
```
