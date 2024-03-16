board=(" " " " " " " " " " " " " " " " " ")

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

intro() {
    echo "Welcome to tic-tac-toe, players!"
    echo "Choose the sign, and remember,"
    echo "player with X starts the game:"
    echo "RULES:"
    echo "To play, please type, when prompted, a number from 0-8 to place your sign"
    echo "Positions of numbers go from left to right and from top to bottom"
    echo "the board looks like this:"
    display_board
    echo "First player begins the game with X"
    echo "Would you like to start? Press Y when ready:"
    while true; do
        read choice
    if [ "$choice" == "Y" ]; then
        echo "Start!"
        play
    else
        echo "Invalid input. Please re-enter."
    fi
    done
}

turn() {
    read -p "Enter your turn (0-8): " number
    if [[ "$number" =~ ^[0-8]$ && "${board[$number]}" == " " ]]; then
        if (( player == 1 )); then
            board[$number]="X"
        else
            board[$number]="O"
        fi
        player=$((3 - player))  # Switch player between 1 and 2
        echo "Turn recorded!"
    else
        echo "Invalid input. Please re-enter."
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

play() {
    local player=1
    while true; do
        display_board
        turn
        check_winner
    done
}

intro
