public class Rook extends Piece{
    boolean first_move=false;
    public Rook(int x, int y, boolean is_white, ChessBoard board) {
        super(x, y, is_white, board);
    }

    @Override
    void setWhite_img_file_path() {
        this.white_img_file_path = "untitled/images/WhiteRook.png";
    }

    @Override
    void setBlack_img_file_path() {
        this.black_img_file_path = "untitled/images/BlackRook.png";
    }


    @Override
    void update_move_list() {
        int OldX = getCoord()[0];
        int OldY = getCoord()[1];
        int j;
        int x;
        int y;

        int[][] dir = {{-1,0},{0,1},{1,0},{0,-1}};
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
        first_move = false;
    }

    @Override
    void init_piece(boolean is_white) {
        if(is_white){
            setPiece("|wr|");
        }
        else{
            setPiece("|br|");
        }
    }
    public void setFirst_move(boolean first_move){
        this.first_move = first_move;
    }
    public boolean get_first_move(){
        return first_move;
    }

}
