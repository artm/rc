# vim:foldmethod=marker foldlevel=0
#
# Customization:
#
# ~/.bashrc.local_config is sourced after utility functions but before the
# actual initialization
#
# ~/.bashrc.local is sourced at the end of this file and can be used to
# override settings

# path manipulation utilities {{{
# find file in one of the given directories
# Usage:
#
#   find_file FILENAME DIR1 DIR2 ...
#
# exit codes:
# 0 - found
# 1 - not found
#
# in case of success prints path to file (DIR/FILENAME) to stdout
#
# Example:
#
#   FOO=$(find_file path.bash ~ ~/bin ~/bash) && echo FOUND $FOO || echo NOT FOUND
#
function find_file
{
  local FILE=$1
  shift
  while [ -n "$1" ] ; do
    local DIR=$1
    if [ -f "$DIR/$FILE" ] ; then
      echo $DIR/$FILE
      return 0
    fi
    shift
  done
  return 1
}

# leave only existing directories
# Usage:
#
#   filer_dirs DIR1 DIR2 ...
#
# prints a single line with colon separated list of existing directories to stdout
#
function filter_dirs
{
  local LIST=""
  while [ -n "$1" ] ; do
    if [ -d "$1" ] ; then
      if [ -z "$LIST" ] ; then
        LIST="$1"
      else
        LIST="$LIST:$1"
      fi
    fi
    shift
  done
  echo $LIST
}

# Extend dirlist list stored in given variable by existing directories from the
# rest of the arguments.
# Usage:
#
#   extend_dir_list [-a] PATH_VAR DIR1 DIR2 ...
#
# -a : append (default is to prepend)
# PATH_VAR is the name of the variable to extend

function extend_dir_list
{
  local mode=prepend
  if [ "$1" = "-a" ] ; then
    mode=append
    shift
  fi
  local VAR=$1
  shift
  local EXT="$(filter_dirs "$@")"
  if [ -n "$EXT" ] ; then
    if [ -z "${!VAR}" ] ; then
      eval "$VAR=\"$EXT\""
    else
      case $mode in
        prepend)
          eval "$VAR=\"$EXT:\$$VAR\""
          ;;
        append)
          eval "$VAR=\"\$$VAR:$EXT\""
          ;;
      esac
    fi
  fi
  export $VAR
}

# Source a bash file if it exists and is readable
function source_if_exists
{
  local file="$1"
  test -r "$file" && . "$file"
}
# }}}

# ansi colors {{{
function ansi {
  if [ -n "$1" ] ; then
    echo "\[\e[01;$1m\]"
  else
    echo "\[\e[00m\]"
  fi
}

black=30
red=31
green=32
yellow=33
blue=34
magenta=35
cyan=36
white=37
bright_black="30;1"
bright_red="31;1"
bright_green="32;1"
bright_yellow="33;1"
bright_blue="34;1"
bright_magenta="35;1"
bright_cyan="36;1"
bright_white="37;1"
# }}}

source_if_exists ~/.bashrc.local_config

# aliases {{{
alias ls="ls ${LS_COLOR_FLAG:---color=auto} -h"
alias ll="ls -l"
alias la="ls -A"
alias lla="ls -lA"

alias df="df -h"
alias du="du -h"

alias grep="grep --color=auto"

function have_exe
{
  which $1 > /dev/null 2>&1
}

if have_exe vim ; then
  alias vi=vim
  export EDITOR=vim
fi

have_exe gnome-open && alias open='gnome-open > /dev/null 2>&1'
have_exe ack-grep && alias ack='ack-grep'
# }}}

# less {{{
# J -- status column
# M -- long prompt
# Q -- quiet (no bell)
# R -- like 'raw' but only for ANSI colors
# S -- chop long lines
# i -- ignore case
export LESS="-JMQRSi"
# }}}

# PATH {{{
extend_dir_list PATH ~/bin
for bin in ~/rc/*/bin ; do
  if [ "$(basename $(dirname $bin))" = "bak" ] ; then continue ; fi
  extend_dir_list PATH $bin
done
# cabal/haskell (for pandoc)
extend_dir_list PATH ~/.cabal/bin

# python modules installed with ./setup.py install --user
extend_dir_list PATH ~/.local/bin
# }}}

# locale {{{
# software messages in American
export LANG="en_US.UTF-8"
# start week on Monday
export LC_TIME="en_GB.UTF-8"
# A4 in stead of Letter
export LC_PAPER="en_GB.UTF-8"
# mm in stead of Inches
export LC_MEASUREMENT="en_GB.UTF-8"
# }}}

# ruby specific {{{
export RI="--format ansi"
export CUCUMBER_COLORS="comment=magenta,bold:tag=magenta"
export RUBYOPT=rubygems
alias b="bundle exec"
have_exe rbenv && eval "$(rbenv init -)"
# }}}

# more colors in gnome-terminal {{{
if [ "$COLORTERM" == "gnome-terminal" ] ; then
  export TERM=xterm-256color
fi
# }}}

# command prompt {{{
if [ -n "$PS1" ] ; then
  function pretty_seconds
  {
    sec=$(($1 % 60))
    min=$(($1 / 60 % 60))
    hrs=$(($1 / 60 / 60))
    if [[ $hrs != 0 ]] ; then
      printf '%d:%02d:%02d' $hrs $min $sec
    elif [[ $min != 0 ]] ; then
      printf '%d:%02d' $min $sec
    else
      printf "$sec sec"
    fi
  }

  function rt_start
  {
    rt_start_time=${rt_start_time:-$SECONDS}
  }
  function rt_stop
  {
    [ -n "$rt_start_time" ] || return
    rt_elapsed=$(($SECONDS - $rt_start_time))
    if [ $rt_elapsed != '0' ] ; then
      echo
      echo "     Command: $last_command"
      echo "Elapsed time: $(pretty_seconds $rt_elapsed)"
    fi
    unset rt_start_time
  }

  # execute before each command
  function before_command
  {
    rt_start
    last_command=$this_command
    this_command=$BASH_COMMAND
  }
  trap before_command DEBUG

  # choose short or long prompt depending on whether user has issued a command
  SHORT_PS1="$ "
  LONG_PS1="
$(ansi $green)\u$(ansi)@$(ansi $magenta)\h$(ansi):$(ansi $blue)\w$(ansi)
\$ "
  function after_command
  {
    rt_stop
    if [ "$last_command" != "after_command" ] ; then
      export PS1="$LONG_PS1"
    else
      export PS1="$SHORT_PS1"
    fi
  }
  PROMPT_COMMAND=after_command

  export PS1="$LONG_PS1"
fi
# }}}

source_if_exists ~/.bashrc.local

# list tmux sessions {{{
if [ -n "$PS1" -a -z "$TMUX" ] ; then
  if have_exe tmux ; then
    if ! have_exe pgrep || pgrep tmux > /dev/null ; then
      echo "tmux sessions:"
      tmux list-sessions
    fi
  fi
fi
# }}}

# make sure ssh-agent works in tmux {{{
# borrowed from:
#
# http://robinwinslow.co.uk/2012/07/20/tmux-and-ssh-auto-login-with-ssh-agent-finally
#
if [ -z "$TMUX" ]; then
    # we're not in a tmux session

    if [ ! -z "$SSH_TTY" ]; then
        # We logged in via SSH

        # if ssh auth variable is missing
        if [ -z "$SSH_AUTH_SOCK" ]; then
            export SSH_AUTH_SOCK="$HOME/.ssh/.auth_socket"
        fi

        # if socket is available create the new auth session
        if [ ! -S "$SSH_AUTH_SOCK" ]; then
            `ssh-agent -a $SSH_AUTH_SOCK` > /dev/null 2>&1
            echo $SSH_AGENT_PID > $HOME/.ssh/.auth_pid
        fi

        # if agent isn't defined, recreate it from pid file
        if [ -z $SSH_AGENT_PID ]; then
            export SSH_AGENT_PID=`cat $HOME/.ssh/.auth_pid`
        fi

        # Add all default keys to ssh auth
        ssh-add 2>/dev/null

        # start tmux
        # tmux attach
    fi
fi
# }}}

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
