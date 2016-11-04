#!/bin/bash

## -------------------------------------------------------------------------
## UFPR, BCC, ci210 2015-2 laboratorio estrutural, Roberto Hexsel, 28jul2015
## -------------------------------------------------------------------------

## ESTE ARQUIVO NAO PODE SER ALTERADO


# set -x

# se passar um argumento para script, executa gtkwave
if [ $# = 1 ] ; then WAVE="sim"
else WAVE=
fi


sim=estrut
src="packageWires aux ${sim} tb_${sim}"
simulador=tb_${sim}
visual=v_${sim}.vcd


# compila simulador
rm -f log.txt $simulador $visual work-obj93.cf
ghdl --clean
for F in ${src} ; do
    ghdl -a --ieee=standard -fexplicit ${F}.vhd  || exit 1
done

ghdl -e --ieee=standard -fexplicit ${simulador}  || exit 1

if [ -x ./${simulador} ] ; then
    ./${simulador} --ieee-asserts=disable --stop-time=250ns \
        --vcd=${visual} 
        # executa gtkwave sob demanda
    test -z $WAVE  ||  gtkwave -O /dev/null ${visual} v.sav 
fi

