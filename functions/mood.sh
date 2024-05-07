TAMAGOTCHI_DIRECTORY=`dirname $0`/..
DATA_DIRECTORY="$TAMAGOTCHI_DIRECTORY/data"

function get_current_value()
{
    local STAT_NAME=$1
    local STAT_FILE="$DATA_DIRECTORY/current_$STAT_NAME"

    CURRENT_VALUE=`cat $STAT_FILE`
}

function get_max_value()
{
    local STAT_NAME=$1
    local STAT_FILE="$DATA_DIRECTORY/max_$STAT_NAME"

    MAX_VALUE=`cat $STAT_FILE`
}

function set_new_value()
{
    local STAT_NAME=$1
    local STAT_FILE="$DATA_DIRECTORY/current_$STAT_NAME"
    local STAT_VALUE=$2
    
    get_max_value $STAT_NAME

    if [ $STAT_VALUE -lt 0 ]
    then
        STAT_VALUE=0
    elif [ $STAT_VALUE -gt $MAX_VALUE ]
    then
        STAT_VALUE=$MAX_VALUE
    fi

    # Mise à jour du fichier avec la nouvelle valeur
    echo $STAT_VALUE > $STAT_FILE
}


function get_mood_value()
{
    # Est-il mort de maladie ?
    get_current_value disease
    get_max_value disease
    if [ $CURRENT_VALUE -ge $MAX_VALUE ]
    then
        MOOD_VALUE='death_disease'

        return
    fi

    # Est-il mort de viellesse ?
    get_current_value age
    get_max_value age
    if [ $CURRENT_VALUE -ge $MAX_VALUE ]
    then
        MOOD_VALUE='death_age'

        return
    fi

    # Pour chaque mood par criticité, on vérifie si supérieur à 2
    for MOOD in disease poop hunger sad
    do
        get_current_value $MOOD

        if [ $CURRENT_VALUE -gt 2 ]
        then
            MOOD_VALUE=$MOOD
            return
        fi
    done

    # Sinon, c'est qu'il est heureux
    MOOD_VALUE='happy'
}

function get_mood_text()
{
    local MOOD_VALUE=$1

    case $MOOD_VALUE in
        death_disease)
            MOOD_TEXT="Fallecio por enfermedad. 🤮"
            ;;
        death_age)
            MOOD_TEXT="Murio de viejo. ☠️"
            ;;
        disease)
            MOOD_TEXT="Esta enfermo. 🤢"
            ;;
        poop)
            MOOD_TEXT="Esta sucio. 😳"
            ;;
        hunger)
            MOOD_TEXT="Tiene hambre. 🤤"
            ;;
        sad)
            MOOD_TEXT="Esta enfadado. 😡"
            ;;
        happy)
            MOOD_TEXT="Esta feliz! 🤗"
            ;;
    esac
}