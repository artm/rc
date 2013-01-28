#!/usr/bin/env bash
BACKUP_DIR=bak
RC=$(basename $(pwd))
SELF=$(basename $0)

for file in * ; do
  case $file in
    "$BACKUP_DIR"|"Readme.*"|"$SELF")
      continue
      ;;
    *)
      link="../.$file"
      if [ -L "$link" -a $(readlink $link) == "rc/$file" ] ; then
        # silently skip existing
        echo "Keeping $file"
        continue
      elif [ -e $link ] ; then
        if [ ! -e $BACKUP_DIR/$file ] ; then
          echo "BACKUP .$file"
          mkdir -b "$BACKUP_DIR"
          mv "$link" "$BACKUP_DIR/$file"
        else
          echo "WARNING: wanted to backup $link but $BACKUP_DIR/$file already exists"
          continue
        fi
      fi
      echo "Installing $file symlink"
      ln -s "$link" "rc/$file"
      ;;
  esac
done
