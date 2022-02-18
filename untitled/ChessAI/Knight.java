public class Knight extends Piece {
    public Knight(int x, int y, boolean is_white, ChessBoard board) {
        super(x, y, is_white, board);
    }

    @Override
    void setWhite_img_file_path() {
        this.white_img_file_path = "untitled/images/WhiteKnight.png";
    }

    @Override
    void setBlack_img_file_path() {
        this.black_img_file_path = "untitled/images/BlackKnight.png";
    }


    @Override
    void update_move_list() {
        int OldX = getCoord()[0];
        int OldY = getCoord()[1];
        int[][] dir = {{-2,-1}, {-2,1},{-1,2},{-1,-2},{1,-2}, {1, 2}, {2, -1}, {2,1}};
        for(int[] i : dir){
            try {
                if (board.board_string[OldX + i[0]][OldY + i[1]].charAt(1) != getAllyColour()) {
                    add_legal_move(new int[]{OldX + i[0], OldY + i[1]});
                }
            }
            catch(ArrayIndexOutOfBoundsException ignored){}
            }
        }


    @Override
    public void status_update(int x, int y) {
    }

    @Override
    void init_piece(boolean is_white) {
        if(is_white){
            setPiece("|wn|");
        }
        else{
            setPiece("|bn|");
        }
    }
}
