#!/usr/bin/env bash
BACKUP_DIR=bak
RC=$(basename $(pwd))
SELF=$(basename $0)

for file in * ; do
  case "$file" in
    "$BACKUP_DIR"|"Readme.*"|"$SELF")
      continue
      ;;
    *)
      link="../.$file"
      link_to="$RC/$file"
      if [ "$(readlink $link)" == "$link_to" ] ; then
        # silently skip existing
        echo "Keeping $file"
        continue
      elif [ -e $link ] ; then
        backup="$BACKUP_DIR/$file"
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
      ;;
  esac
done
