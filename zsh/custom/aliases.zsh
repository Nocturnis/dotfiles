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

alias chrome="google-chrome"
# Open chrome with a separate profile
alias chrome-isolated="google-chrome --user-data-dir=$HOME/.config/google-chrome/Profile\ 1/"
# Open chrome with a seperate profile, takes a proxy host/port as an argument
function chrome-isolated-proxy() {
  local proxy_server="$1"
  chrome-isolated --proxy-server="http=${proxy_server}"
}

# mkdir, cd into it
mkcd() {
  mkdir -p "$*"
  cd "$*"
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
