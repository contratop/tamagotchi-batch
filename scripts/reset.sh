#!/bin/bash
TAMAGOTCHI_DIRECTORY=`dirname $0`/..
SCRIPT_DIRECTORY="$TAMAGOTCHI_DIRECTORY/scripts"
DATA_DIRECTORY="$TAMAGOTCHI_DIRECTORY/data"
source "$TAMAGOTCHI_DIRECTORY/functions/common.sh"

echo Reiniciando tamagotchi…
rm -Rf $DATA_DIRECTORY
if [ $? -eq 0 ]
then
    echo OK !
else
    echo_error "El archivo no ha sido eliminado."
    exit 42
fi