#!/usr/bin/env bash
BACKUP_DIR=bak
RC=$(basename $(pwd))
SELF=$(basename $0)

operation=install

while getopts "?hu" opt; do
  case $opt in
    ?|h)
      echo Usage: $(basename $0) [-h] [-u]
      echo
      echo "-h    help"
      echo "-u    uninstall instead of installing"
      exit
      ;;
    u)
      operation=uninstall
      ;;
  esac
done

function install()
{
  file=$1
  link=$2
  link_to=$3
  backup=$4
  if [ "$(readlink $link)" == "$link_to" ] ; then
    echo "Keeping $file"
    continue
  elif [ -e "$link" ] ; then
    if [ ! -e "$backup" ] ; then
      echo "BACKUP .$file"
      mkdir -p "$BACKUP_DIR"
      mv "$link" "$backup"
    else
      echo "WARNING: wanted to backup $link but $BACKUP_DIR/$file already exists"
      continue
    fi
  fi
  echo "Installing $file symlink"
  ln -s "$link_to" "$link"
}

function uninstall()
{
  file=$1
  link=$2
  link_to=$3
  backup=$4
  if [ "$(readlink $link)" == "$link_to" ] ; then
    echo "Removing $file symlink"
    rm "$link"
  fi
}

for file in * ; do
  case "$file" in
    "$BACKUP_DIR"|"Readme.*"|"$SELF")
      continue
      ;;
    *)
      link="../.$file"
      link_to="$RC/$file"
      backup="$BACKUP_DIR/$file"
      $operation $file $link $link_to $backup
      ;;
  esac
done
