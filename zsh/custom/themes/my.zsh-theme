#!/usr/bin/env zsh

. ~/.dotfiles/bash/git-prompt.sh

autoload -U colors && colors

function __user_and_host {
    local host="$(hostname -s)"
    local user="$(id -un)"
    local self_user="bradenw"
    local g_laptop_name="bradenw-macbookpro"

    local user_printed=""
    if [[ "$user" == "root" ]]; then
        user_printed="%{$fg_no_bold[red]%}$user"
    elif [[ "$user" != "$self_user" ]]; then
        user_printed="%{$fg_bold[white]%}$user"
    fi
    local host_printed="%{$fg_bold[white]%}$host"
    if [[ "$host" == "$g_laptop_name" ]]; then
        host_printed="%{$fg_bold[black]%}g-mbp"
    fi
    echo -n "$user_printed%{$fg_no_bold[black]%}@$host_printed"
}

function __working_dir {
    PWD=$(pwd)

    # If path is subdirectory of home, replace home path with ~
    HOME=$(cd ~ && pwd)
    PWD=${PWD/#"$HOME"/"~"}
    echo -n "%{$fg_bold[white]%}${PWD}"
}

function __git_branch_exported {
    local git_branch=$1
    git log -n 1 --format=%d | grep "origin/$git_branch" &> /dev/null && echo -n "1"
}

function __git_branch {
    local git_branch=$(__git_ps1 "%s")
    if [ -n "$git_branch" ]; then
        local color="%{$fg_no_bold[blue]%}"
        if [ -n "$(git status --porcelain)" ]; then
            color="%{$fg_no_bold[red]%}"
        elif [ -z "$(__git_branch_exported $git_branch)" ]; then
            color="%{$fg_no_bold[yellow]%}"
        fi
        echo -n " $color$git_branch"
    fi
    echo -n ""
}

function __prompt_command {
    local vi_mode_color="%{$fg_bold[black]%}"
    if [[ "$KEYMAP" == "main" ]]; then
        vi_mode_color="%{$fg_no_bold[green]%}"
    elif [[ "$KEYMAP" == "vicmd" ]]; then
        vi_mode_color="%{$fg_bold[black]%}"
    fi

    echo
    echo -n "%{$fg_no_bold[black]%}/ $vi_mode_color//"
    echo -n " %{$fg_bold[black]%}$(date +%T)"
    echo -n " $(__user_and_host) $(__working_dir)$(__git_branch)"
    echo -n "%{$fg_no_bold[black]%} /"
    echo

    echo " $vi_mode_color// %{$fg_no_bold[black]%}~> %{$reset_color%}"
}

PROMPT="$(__prompt_command)"

function zle-line-init zle-keymap-select {
    PROMPT="$(__prompt_command)"
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
