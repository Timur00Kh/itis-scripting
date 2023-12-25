#!/bin/bash

draw_board(){
    clear
    echo "Ход: $STEP"
    D="-----------------"
    S="%s\n|%3s|%3s|%3s|%3s|\n"
    printf $S $D ${M[0]:-"."} ${M[1]:-"."} ${M[2]:-"."} ${M[3]:-"."}
    printf $S $D ${M[4]:-"."} ${M[5]:-"."} ${M[6]:-"."} ${M[7]:-"."}
    printf $S $D ${M[8]:-"."} ${M[9]:-"."} ${M[10]:-"."} ${M[11]:-"."}
    printf $S $D ${M[12]:-"."} ${M[13]:-"."} ${M[14]:-"."} ${M[15]:-"."}
    echo $D
    if (( ${#LEGAL_MOVEMENTS[@]} != 0 )); then
        echo "Неверный ход! Невозможно костяшку $INPUT_STRING передвинуть на пустую ячейку"
        echo "Можно выбрать: "
        for NUMBER in "${LEGAL_MOVEMENTS[@]}"
        do
          echo -n "$NUMBER "
        done
        echo ""
    fi
    LEGAL_MOVEMENTS=()
}

init_game(){
    M=()
    EMPTY=
    STEP=1
    RANDOM=$RANDOM
    for i in {1..15}
    do
        j=$(( RANDOM % 16 ))
        while [[ ${M[j]} != "" ]]
        do
            j=$(( RANDOM % 16 ))
        done
        M[j]=$i
    done
    for i in {0..15}
    do
        [[ ${M[i]} == "" ]] && EMPTY=$i
    done
    draw_board
}

exchange(){
    M[$EMPTY]=${M[$1]}
    M[$1]=""
    EMPTY=$1
}

quit_game(){
    while :
    do
        read -n 1 -s -p "Вы действительно хотите выйти [y/n]?"
        case $REPLY in
            y|Y) exit
            ;;
            n|N) return
            ;;
        esac
    done
}

check_win(){
    for i in {0..14}
    do
        if [ "${M[i]}" != "$(( $i + 1 ))" ]
        then
            return
        fi
    done
    echo "Вы собрали головоломку за $STEP ходов. Хотите сыграть еще раз [y/n]? "
    while :
    do
        read -n 1 -s
        case $REPLY in
            y|Y)
                init_game
                break
            ;;
            n|N) exit
            ;;
        esac
    done
}

start_game(){
while :
do
    STEP=$(($STEP+1))
    echo "Ваш ход (q - выход)"
    read INPUT_STRING
    if [[ $INPUT_STRING -eq "q" ]]; then
          quit_game
    fi
    for i in "${!M[@]}"; do
        if [ "${M[$i]}" -eq "$INPUT_STRING" ]; then
          case $((i - EMPTY)) in
            -1)
              DIRECTION="a"
              ;;
            1)
              DIRECTION="d"
              ;;
            -4)
              DIRECTION="w"
              ;;
            4)
              DIRECTION="s"
              ;;
            *)
              LEGAL_MOVEMENTS=()
              [ $((EMPTY-1)) -gt -1 ] && LEGAL_MOVEMENTS+=($((M[EMPTY-1])))
              [ $((EMPTY+1)) -lt 15 ] && LEGAL_MOVEMENTS+=($((M[EMPTY+1])))
              [ $((EMPTY-4)) -gt -1 ] && LEGAL_MOVEMENTS+=($((M[EMPTY-4])))
              [ $((EMPTY+4)) -lt 15 ] && LEGAL_MOVEMENTS+=($((M[EMPTY+4])))
              echo ""
            ;;
          esac
        fi
    done
    case $DIRECTION in
        s)
            [ $EMPTY -lt 12 ] && exchange $(( $EMPTY + 4 ))
        ;;
        d)
            COL=$(( $EMPTY % 4 ))
            [ $COL -lt 3 ] && exchange $(( $EMPTY + 1 ))
        ;;
        w)
            [ $EMPTY -gt 3 ] && exchange $(( $EMPTY - 4 ))
        ;;
        a)
            COL=$(( $EMPTY % 4 ))
            [ $COL -gt 0 ] && exchange $(( $EMPTY - 1 ))
        ;;
    esac
    draw_board
    check_win
done
}

init_game
start_game
