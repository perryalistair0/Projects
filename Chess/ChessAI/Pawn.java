import java.lang.*;
import java.util.HashMap;

public class Pawn extends Piece{
    boolean first_move = true;
    boolean en_passant = false;
    int en_passant_turn = 0;
    int direction;
    HashMap<int[], String> move_status = new HashMap<int[], String>();
    public Pawn(int x, int y, boolean is_white, ChessBoard board) {
        super(x, y, is_white, board);
    }

    @Override
    void setWhite_img_file_path() {
        this.white_img_file_path = "untitled/images/WhitePawn.png";
    }

    @Override
    void setBlack_img_file_path() {
        this.black_img_file_path = "untitled/images/BlackPawn.png";
    }

    public void update_move_list(){
        // adds moves to list of legal moves
        int OldX = getCoord()[0];
        int OldY = getCoord()[1];
        // adds forward moves
        if(board.board_string[OldX][OldY + direction].equals("|__|")){
            add_legal_move(new int[]{OldX, OldY+direction});
            if(first_move && board.board_string[OldX][OldY + direction*2].equals("|__|")){
                int[] temp = new int[]{OldX, OldY+direction*2};
                move_status.put(temp, "en passant");
                add_legal_move(temp);
            }
        }
        //adds taking moves
        if((OldX<7)&&(board.board_string[OldX+1][OldY+direction].charAt(1) == getOppColour())){
            add_legal_move(new int[]{OldX+1, OldY+direction});
        }
        if((OldX>0)&&(board.board_string[OldX-1][OldY+direction].charAt(1) == getOppColour())){
            add_legal_move(new int[]{OldX-1, OldY+direction});
        }
        //adds en passant moves
        if((OldX<7)&&(board.board_string[OldX+1][OldY+direction].charAt(1) != getAllyColour())){
            if(board.board_label[OldX+1][OldY] instanceof Pawn){
                if((((Pawn) board.board_label[OldX+1][OldY]).getEnPassant())&&
                        (((Pawn) board.board_label[OldX+1][OldY]).en_passant_turn == board.turn_count-1)){
                    add_legal_move(new int[]{OldX+1, OldY+direction});
                }
            }
        }
        if((OldX>0)&&(board.board_string[OldX-1][OldY+direction].charAt(1) != getAllyColour())){
            if(board.board_label[OldX-1][OldY] instanceof Pawn){

                if((((Pawn) board.board_label[OldX-1][OldY]).getEnPassant()) &&
                        (((Pawn) board.board_label[OldX-1][OldY]).en_passant_turn == board.turn_count-1)){
                    add_legal_move(new int[]{OldX-1, OldY+direction});

                }
            }
        }
    }

    @Override
    public void status_update(int x, int y) {
        en_passant =  y == getCoord()[1] + direction*2;
        if(en_passant){
            en_passant_turn = board.turn_count;
        }
        if((getCoord()[0]!=x)&&(getCoord()[1]+direction==y)
                &&(board.board_string[x][y].charAt(1)!= getOppColour())){
            board.remove_piece(x,y-direction);
        }
        first_move = false;
        if(y==7){
            board.remove_piece(getCoord()[0], getCoord()[1]);
            board.remove_piece(x,7);
            board.setSelected_piece(new Queen(getCoord()[0], getCoord()[1],
                    get_is_white(), board));
        }
        else if(y==0){
            board.remove_piece(getCoord()[0], getCoord()[1]);
            board.remove_piece(x, 7);
            board.setSelected_piece(new Queen(getCoord()[0],getCoord()[1],
                    get_is_white(), board));
        }
    }

    @Override
    void init_piece(boolean is_white) {
        if(is_white){
            setPiece("|wp|");
            direction = 1;
        }
        else{
            setPiece("|bp|");
            direction = -1;
        }
    }

    public boolean getEnPassant(){
        return en_passant;
    }

    public void setDirection() {
        this.direction = this.direction*-1;
    }
}
