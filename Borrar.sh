#!/usr/bin/env bash
archivo="$1"

if ! test -f "$archivo" ; then
	echo "Ingresa un archivo." >&2
	exit 1
fi

if test "$2"; then
	echo "Ingresa solo un parametro." >&2
	exit 1
fi

if ! test -d ~/.bin ; then
	mkdir ~/.bin
	mv "$archivo" ~/.bin
	else
	mv "$archivo" ~/.bin
fi
