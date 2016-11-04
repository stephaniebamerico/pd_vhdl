#!/bin/bash

## ------------------------------------------------------------------------
## UFPR, BCC, ci210 - laboratorio somadores       Roberto Hexsel, 31ago2016
## ------------------------------------------------------------------------

## ESTE ARQUIVO NAO DEVE SER ALTERADO


# set -x

# se passar um argumento para script, executa gtkwave
if [ $# = 1 ] ; then WAVE="sim"
else WAVE=
fi


sim=multiplicador
simulador=tb_${sim}
src="packageWires aux somador ${sim} ${simulador}"
visual=v_${sim}.vcd


# compila simulador
rm -f $simulador $visual
ghdl --clean
for F in ${src} ; do
    ghdl -a --ieee=standard ${F}.vhd || exit 1
done

ghdl -e --ieee=standard ${simulador}  || exit 1
if [ -x ./${simulador} ] ; then
	./${simulador} --ieee-asserts=disable --stop-time=500ns \
            --vcd=${visual} 
        # executa gtkwave sob demanda
	test -z $WAVE  ||  gtkwave -O /dev/null ${visual} m.sav 
fi

