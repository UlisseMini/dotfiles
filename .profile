export EDITOR=/usr/bin/nvim
export SHELL=/usr/bin/zsh

export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

export FZF_DEFAULT_COMMAND='rg --files'

export GOPATH="$HOME/go"
export CGO_ENABLED=0

export PATH="$PATH:$HOME/go/bin"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.yarn/bin:$PATH"
export PATH="$PATH:$HOME/.local/bin/"
export PATH="$PATH:$HOME/scripts"
export PATH="$PATH:$HOME/.local/share/gem/ruby/3.0.0/bin"
export PATH="$PATH:$HOME/anaconda3/bin"
export PATH="$PATH:$HOME/.luarocks/bin"
export PATH="$HOME/.elan/bin:$PATH" # lean prover

# swap caps and escape
setxkbmap -option caps:escape >/dev/null 2>&1

# ibus
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

