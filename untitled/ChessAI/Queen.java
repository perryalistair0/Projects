public class Queen extends Piece {
    public Queen(int x, int y, boolean is_white, ChessBoard board) {
        super(x, y, is_white, board);
    }

    @Override
    void setWhite_img_file_path() {
        this.white_img_file_path = "untitled/images/WhiteQueen.png";
    }

    @Override
    void setBlack_img_file_path() {
        this.black_img_file_path = "untitled/images/BlackQueen.png";
    }

    @Override
    void update_move_list() {
        int OldX = getCoord()[0];
        int OldY = getCoord()[1];
        int j;
        int x;
        int y;

        int[][] dir = {{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 0}, {0, 1}, {1, -1}, {1, 0}, {1, 1}};
        for (int[] i : dir) {
            j = 0;
            while (true) {
                j++;
                x = j * i[0];
                y = j * i[1];
                try {
                    if (board.board_string[OldX + x][OldY + y].equals("|__|")) {
                        add_legal_move(new int[]{OldX + x, OldY + y});
                    } else if (board.board_string[OldX + x][OldY + y].charAt(1) == getOppColour()) {
                        add_legal_move(new int[]{OldX + x, OldY + y});
                        break;
                    } else {
                        break;
                    }
                } catch (ArrayIndexOutOfBoundsException ignore) {
                    break;
                }
            }
        }
    }
    @Override
    public void status_update(int x, int y) {

    }

    @Override
    void init_piece(boolean is_white) {
        if(get_is_white()){
            setPiece("|wq|");
        }
        else{
            setPiece("|bq|");
        }
    }
}
