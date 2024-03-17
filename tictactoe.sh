board=(" " " " " " " " " " " " " " " " " ")
player=1
input_msg="Invalid input. Please re-enter."
computer=0

win_combos=(
        "0 1 2" "3 4 5" "6 7 8"  # Rows
        "0 3 6" "1 4 7" "2 5 8"  # Columns
        "0 4 8" "2 4 6"          # Diagonals
    )

display_board() {
    echo " ${board[0]} | ${board[1]} | ${board[2]} "
    echo "-----------"
    echo " ${board[3]} | ${board[4]} | ${board[5]} "
    echo "-----------"
    echo " ${board[6]} | ${board[7]} | ${board[8]} "
}

save_game() {
    printf "%s\n" "${board[@]}" > saved_board.txt
    echo "$player" > mode.txt
    echo "$computer" >> mode.txt
}

load_game() {
    readarray -t board < saved_board.txt
    player=$(sed -n '1p' mode.txt)
    computer=$(sed -n '2p' mode.txt)
}

intro() {
    echo "Welcome to tic-tac-toe, players!"
    echo "Choose the sign, and remember,"
    echo "player with X starts the game:"
    echo "RULES:"
    echo "To play, please type, when prompted, a number from 0-8 to place your sign"
    echo "Positions of numbers go from left to right and from top to bottom"
    echo "the board looks like this:"
    display_board
    echo "To save the game, press S during your turn"
    echo "Would you like to start?"
    echo "Press 1 for a new game, Press 2 to load saved game, Press 3 for solo with Computer"
    while true; do
        read choice
    if [ "$choice" == "1" ]; then
        echo "Start!"
        play
    elif [[ "$choice" == "2" && -e saved_board.txt ]]; then
        load_game
        echo "Resume!"
        play
    elif [ "$choice" == "3" ]; then
        echo "Start with computer!"
        computer=1
        play
    else
        echo $input_msg
    fi
    done
}

turn() {
    read -p "Enter your turn (0-8): " number
    if [[ "$number" =~ ^[0-8]$ && "${board[$number]}" == " " ]]; then
        if [[ $computer == 1 ]]; then
            player=1
        fi
        if [[ $player == 1 ]]; then
            board[$number]="X"
        else
            board[$number]="O"
        fi
        player=$((3 - player))
    elif [ "$number" == "S" ]; then
        echo "Saving..."
        save_game
        echo "Done!"
        while true; do
            read -p "Would you like to continue? Y/N:  " decision
            if [[ "$decision" == "Y" ]]; then
                break
            elif [[ "$decision" == "N" ]]; then
                echo "Bye!"
                exit 0
            else 
               echo $input_msg
            fi
        done
    else
        echo $input_msg
        turn
    fi
}


check_winner() {
    for combo in "${win_combos[@]}"; do
        local cells=($combo)
        local symbol="${board[${cells[0]}]}"
        if [[ "${board[${cells[1]}]}" == "$symbol" && "${board[${cells[2]}]}" == "$symbol" && "$symbol" != " " ]]; then
            echo "Hooray! the winner is $symbol!"
            exit 0 
        fi
    done
    for cell in "${board[@]}"; do
        if [[ "$cell" == " " ]]; then
            return
        fi
    done
    echo "It's a draw!"
    exit 0
}

# Functions for computer play
get_empty_places() {
    empty_places=()
    for ((i = 0; i < ${#board[@]}; i++)); do
        if [[ "${board[$i]}" == " " ]]; then
            empty_places+=("$i")
        fi
    done
}

computer_moves() {
    get_empty_places
    if [[ ${#empty_places[@]} -gt 0 ]]; then
        random_index=$((RANDOM % ${#empty_places[@]}))
        selected_move=${empty_places[$random_index]}
        echo "Computer makes a move at position $selected_move"
        board[$selected_move]="O"
    else
        echo "No empty places available on the board."
    fi
}


play() {
    while true; do
        display_board
        turn
        if [[ "$computer" == 1 ]]; then
            computer_moves
        check_winner
        fi
    done
}

intro