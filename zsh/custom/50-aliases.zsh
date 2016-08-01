# Ubuntu needs --color=auto, OSX prints an error message every time
if [[ "$(ls --color=auto > /dev/null 2>&1 && echo $?)" == "0" ]]; then
    alias ls='ls -aGF --color=auto'
    alias ll='ls -lha --color=auto'
    alias grep='grep --color=auto'
else
    alias ls='ls -aGF'
    alias ll='ls -lha'
fi

alias ag="ag --color-match \"0;35\" --color-path \"0;32\""

alias gbl="git branch --list"
alias gco="git checkout"
function gfr {
  git fetch && git rebase origin/master
}

alias chrome="google-chrome"
# Open chrome with a separate profile
alias chrome-isolated="google-chrome --user-data-dir=$HOME/.config/google-chrome/Profile\ 1/"
# Open chrome with a seperate profile, takes a proxy host/port as an argument
function chrome-isolated-proxy() {
  local proxy_server="$1"
  chrome-isolated --proxy-server="http=${proxy_server}"
}

alias clipboard="xsel --clipboard"

# mkdir, cd into it
mkcd() {
  mkdir -p "$*"
  cd "$*"
}

function slice() {
  if [[ $# != '3' ]]; then
    echo "Show a slice of a file by line number."
    echo "Usage:"
    echo "  slice [file] [start] [end]"
    echo
    echo "  e.g. slice file.txt 5 12"
    return
  fi
  local file=$1
  local start=$2
  local end=$3

  head -n $end $file | tail -n $(expr $end - $start)
}

function colortest() {
  bgcolors=( 40 100 41 101 42 102 43 103 44 104 45 105 46 106 47 107 49 )
  fgcolors=( 30 90 31 91 32 92 33 93 34 94 35 95 36 96 37 97 39 )
  colornames=( "-BLK" "+BLK" "-RED" "+RED" "-GRN" "+GRN" "-YEL" "+YEL" "-BLU" "+BLU" "-MAG" "+MAG" "-CYN" "+CYN" "-WHT" "+WHT" " DEF" )
  for j in `seq 0 $(expr ${#bgcolors[@]} - 1)`; do
    printf "\e[0;${fgcolors[j]}m"" ${colornames[j]} "
    for i in `seq 0 $(expr ${#fgcolors[@]} - 1)`; do
      printf "\e[0;${fgcolors[i]};${bgcolors[j]}m"" ${colornames[i]} "
    done;
    printf "\e[0m\n"
  done
}

function screen-outer() {
  if [[ $# < 1 ]]; then
    echo "Usage:"
    echo "  screen-outer [name] [args...]"
    return
  fi
  local name=$1
  local args=${@:2}
  screen -S $name -e ^Xx $args
}

function screen-inner() {
  if [[ $# < 1 ]]; then
    echo "Usage:"
    echo "  screen-inner [name] [args...]"
    return
  fi
  local name=$1

  local outerName=`echo $STY | grep -Eo "\\.(.+?)" | grep -Eo "[^\\.]+"`
  local args=${@:2}
  # Set the title of the current screen window to the same as the inner screen
  echo -ne "\ek$name\e\\"
  screen -S "-${outerName}--${1}" -e ^Aa $args
}

function do_until_fail() {
  while true; do
    $@
    if [ $? -ne "0" ]; then
      break
    fi
  done
}
