#!/bin/bash
TAMAGOTCHI_DIRECTORY=`dirname $0`/..
DATA_DIRECTORY="$TAMAGOTCHI_DIRECTORY/data"
TAMAGOTCHI_NAME=`cat $DATA_DIRECTORY/name`

# Permite usar las funciones sobre el estado de ánimo del tamagotchi
source "$TAMAGOTCHI_DIRECTORY/functions/mood.sh"

get_mood_value
echo $MOOD_VALUE | grep death > /dev/null
if [ $? -eq 0 ]
then
    echo ¡$TAMAGOTCHI_NAME ha muerto! 😇
    echo 'Puedes crear un nuevo tamagotchi con "./tamagotchi.sh --reset"'
    exit
fi

echo "[j] Jugar con $TAMAGOTCHI_NAME"
echo "[n] Alimentar a $TAMAGOTCHI_NAME"
echo "[c] Limpiar las caquitas de $TAMAGOTCHI_NAME"
echo "[s] Curar a $TAMAGOTCHI_NAME"
echo "[q] Salir"

# Salto de línea
echo

read -p "¿Qué quieres hacer? " INTERACTION

case $INTERACTION in
    [Jj])
        clear
        echo Estás jugando con $TAMAGOTCHI_NAME. 🦋

        get_current_value sad
        SAD_VALUE=$CURRENT_VALUE
        ((SAD_VALUE--))
        set_new_value sad $SAD_VALUE
        
        echo $TAMAGOTCHI_NAME está contento. 😊
        echo
        read -p "Presiona una tecla para continuar..."
        ;;
    [Nn])
        clear
        echo Estás alimentando a $TAMAGOTCHI_NAME. 🌭🍟🍰
        
        get_current_value hunger
        HUNGER_VALUE=$CURRENT_VALUE

        if [ $HUNGER_VALUE -le 0 ]
        then
            get_current_value disease
            DISEASE_VALUE=$CURRENT_VALUE
            ((DISEASE_VALUE++))
            set_new_value disease $DISEASE_VALUE

            echo ¡Has sobrealimentado a $TAMAGOTCHI_NAME! 🤢
        else
            ((HUNGER_VALUE--))
            set_new_value hunger $HUNGER_VALUE

            echo ¡$TAMAGOTCHI_NAME está saciado! 😬
        fi
        
        echo
        read -p "Presiona una tecla para continuar..."
        ;;
    [Cc])
        clear
        echo Estás limpiando a $TAMAGOTCHI_NAME. ✨
        
        get_current_value poop
        POOP_VALUE=$CURRENT_VALUE

        if [ $POOP_VALUE -le 0 ]
        then
            get_current_value sad
            SAD_VALUE=$CURRENT_VALUE
            ((SAD_VALUE++))
            set_new_value sad $SAD_VALUE

            echo "$TAMAGOTCHI_NAME ya estaba limpio, ¡se está molestando! 😤"
        else
            ((POOP_VALUE--))
            set_new_value poop $POOP_VALUE

            echo ¡$TAMAGOTCHI_NAME se siente más limpio! 😚
        fi
        
        echo
        read -p "Presiona una tecla para continuar..."
        ;;
    [Ss])
        clear
        echo Estás curando a $TAMAGOTCHI_NAME. 🚑
        
        get_current_value disease
        DISEASE_VALUE=$CURRENT_VALUE

        if [ $DISEASE_VALUE -le 0 ]
        then
            set_new_value disease 4
            set_new_value sad 5

            echo "$TAMAGOTCHI_NAME no estaba enfermo, ¡está teniendo una reacción al medicamento! 😱"
        else
            ((DISEASE_VALUE--))
            set_new_value disease $DISEASE_VALUE

            echo ¡$TAMAGOTCHI_NAME se siente mejor! 🤕
        fi
        
        echo
        read -p "Presiona una tecla para continuar..."
        ;;
    [Qq])
        echo ¡$TAMAGOTCHI_NAME está triste de verte ir! 👋
        exit
        ;;
esac

# Se reinicia el tamagotchi para actualizar su estado
$TAMAGOTCHI_DIRECTORY/tamagotchi.sh