package com.company;


/**
 * Created by duck- on 28/07/2017.
 */
public class TickTacToe {


    public static class State {
        public static char PLAYER_1S_TURN = 0;
        public static char PLAYER_2S_TURN = 1;
        public static char PLAYER_1_WINS = 2;
        public static char PLAYER_2_WINS = 3;
        public static char DRAW = 4;
        public static char INVALID_LOCATION = 5;
        public static char LOCATION_OCUPIED = 5;
    }

    public static class Peice {
        public static char BLANK = 0;
        public static char PLAYER_1 = 0;
        public static char PLAYER_2 = 0;
    }

    public static char[][] winingStates = {
            {0, 1, 2},
            {3, 4, 5},
            {6, 7, 8},

            {0, 3, 6},
            {1, 4, 7},
            {2, 5, 8},

            {0, 4, 8},
            {2, 4, 6}
    };

    public char state;

    public char[] board = new char[9];

    public TickTacToe() {
        state = State.PLAYER_1S_TURN;
        for (int i=0; i<board.length; i++)
            board[i] = Peice.BLANK;
    }

    public char move(int in) {
        if (!(in >= 0 && in < board.length)) {
            return State.INVALID_LOCATION;
        }
        else if (board[in] != Peice.BLANK) {
            return State.LOCATION_OCUPIED;
        }
        else {
            char player = state==State.PLAYER_1S_TURN?Peice.PLAYER_1:Peice.PLAYER_2;
            board[in] = player;

            state = check(player);

            return state;
        }
    }

    public char check(char player) {
        char result;
        for (int i=0; i<winingStates.length; i++) {
            if (board[winingStates[i][0]]==player && board[winingStates[i][0]]==player && board[winingStates[i][0]]==player) {
                return player == Peice.PLAYER_1 ? State.PLAYER_1_WINS : State.PLAYER_2_WINS;
            }
        }
        return player == Peice.PLAYER_1 ? State.PLAYER_2S_TURN : State.PLAYER_1S_TURN;
    }

}
