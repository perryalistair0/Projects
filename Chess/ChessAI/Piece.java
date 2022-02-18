import javax.swing.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

abstract class Piece {
    private ImageIcon img;
    private JLabel label;
    private String Piece;
    private Character OppColour;
    private Character AllyColour;
    private boolean is_white;
    private List<int[]> legal_moves = new ArrayList<int[]>();
    private int XCoord;
    private int YCoord;
    private String status;
    public String white_img_file_path;
    public String black_img_file_path;
    ChessBoard board;


    public Piece(int x, int y, boolean is_white, ChessBoard board){
        if(is_white){
            OppColour = 'b';
            AllyColour = 'w';
            setWhite_img_file_path();
            this.img = new ImageIcon(white_img_file_path);
        }
        else{
            OppColour = 'w';
            AllyColour = 'b';
            setBlack_img_file_path();
            this.img = new ImageIcon(black_img_file_path);
        }
        this.label = new JLabel(img);
        this.board = board;
        this.is_white = is_white;
        this.XCoord = x;
        this.YCoord = y;

        init_piece(is_white);
        board.init(this, x, y, Piece);
    }
    public boolean is_legal(int NewX, int NewY){
        legal_moves.clear();
        update_move_list();
        int[] temp1 = {NewX, NewY};
        for(int[] temp : legal_moves){
            if(Arrays.equals(temp, temp1)){
                    status_update(NewX, NewY);
                    return true;
                }
            }
        return false;
    }
    abstract void setWhite_img_file_path();
    abstract void setBlack_img_file_path();
    public JLabel getLabel(){
        return label;
    }
    public String getPiece(){
        return Piece;
    }
    public void setPiece(String piece) {
        Piece = piece;
    }
    public char getOppColour(){
        return OppColour;
    }
    public char getAllyColour(){
        return AllyColour;
    }
    public void setCoord(int x, int y){
        this.XCoord = x;
        this.YCoord = y;
    }
    abstract void update_move_list();
    public int[] getCoord(){
        return new int[]{XCoord, YCoord};
    }
    public  void add_legal_move(int[] move){
        if((is_white)&&(!board.white_king.in_check(this, move))) {
            legal_moves.add(move);
        }
        else if((!is_white)&&(!board.black_king.in_check(this, move))){
            legal_moves.add(move);
        }
    }
    abstract void status_update(int x, int y);
    public boolean get_is_white(){
        return is_white;
    }
    abstract void init_piece(boolean is_white);
    public int get_legal_list_size(){
        return legal_moves.size();
    }
    public void clear_legal_list(){ legal_moves.clear();}
    public List <int[]> get_legal_list(){
        return legal_moves;
    }
}
