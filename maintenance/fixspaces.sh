#!/bin/bash

vim -c 	'
	" Squeeze repeated white spaces
	g/^[^%]/s/  \+/ /gc
	" Insert whitespace between [.,!?,;:] and letter
	g/^[^%]/s/\([.,!?,;:]\)\([a-zA-Z]\)/\1 \2/gc
	" Remove whitespace between letter and [.,!?,;:]
	g/^[^%]/s/\([a-zA-Z]\) \([.,!?,;:]\)/\1\2/gc
	" Add whitespace between letter and [(]
	g/^[^%]/s/\([a-zA-Z]\)\([(]\)/\1 \2/gc
	" Add whitespace between [)] and letter
	g/^[^%]/s/\([)]\)\([a-zA-Z]\)/\1 \2/gc
	wq
	' $1
