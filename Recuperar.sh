#!/usr/bin/env bash
archivo="$1"

if ! test "$archivo"; then
	echo "Ingresa un archivo para recuperar." >&2
	exit 1
fi

if test "$2"; then
	echo "No ingreses más de un parámetro." >&2
	exit 1
fi

if test -d ~/.bin ; then
	if ! test -f "$archivo" ; then
		mv ~/.bin/"$archivo" .
	else
		echo "No existe ningún archivo llamado $archivo en la papelera"
	fi
	else
	echo "No existe una papelera de la cual recuperar ese archivo"
fi
