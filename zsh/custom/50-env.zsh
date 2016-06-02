export EDITOR=vim
export DIFF=vimdiff
export P4DIFF=vimdiff
export LSCOLORS=dxfxgxbxcxedabagacad
export LS_COLORS="di=33:ln=35:so=36:pi=31:ex=32:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=1;37;42:ow=0;43:"
export JAVA_HOME="/Library/Java/Home"

# If mvim is available, use that so YCM works.
if [[ -f /usr/local/Cellar/macvim/7.4-77/bin/mvim ]]; then
  alias vim="/usr/local/Cellar/macvim/7.4-77/bin/mvim -v"
fi

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
