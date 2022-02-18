import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.util.ArrayList;

public class ChessBoard {
    // adds all of the images file paths
    private final String white_bishop_path = "untitled/images/WhiteBishop.png";
    private final String white_knight_path = "untitled/images/WhiteKnight.png";
    private final String white_king_path = "untitled/images/WhiteKing.png";
    private final String white_pawn_path = "untitled/images/WhitePawn.png";
    private final String white_queen_path = "untitled/images/WhiteQueen.png";
    private final String white_rook_path = "untitled/images/WhiteRook.png";
    private final String black_bishop_path = "untitled/images/BlackBishop.png";
    private final String black_knight_path = "untitled/images/BlackKnight.png";
    private final String black_king_path = "untitled/images/BlackKing.png";
    private final String black_pawn_path = "untitled/images/BlackPawn.png";
    private final String black_queen_path = "untitled/images/BlackQueen.png";
    private final String black_rook_path = "untitled/images/BlackRook.png";

    private final JLabel contentPane = new JLabel();
    private boolean white_turn = true;
    private ArrayList<Piece> white_piece_list = new ArrayList<Piece>();
    private ArrayList<Piece> black_piece_list = new ArrayList<Piece>();

    public Piece[][] board_label = new Piece[8][8];
    public String[][] board_string = new String[8][8];
    private Piece selected_piece;
    private int[] old_coord = new int[2];
    public int turn_count = 0;
    public King white_king;
    public King black_king;

    public ChessBoard(String fen_code){
        for(int x = 0; x<8; x++){
            for(int y = 0; y<8; y++){
                board_string[x][y] = "|__|";
            }
        }
        make_frame(fen_code);
    }
    public void make_frame(String fen_code){
        // creates frame and contentPane, which adds the chess baord background
        JFrame frame = new JFrame();
        frame.setLayout(new BorderLayout());
        Icon icon = new ImageIcon("untitled/images/chess board.jpg");
        contentPane.setIcon(icon);
        contentPane.setLayout(null);
        frame.setContentPane(contentPane);

        // Checks what user is clicking on
        contentPane.addMouseListener(new MouseAdapter(){
            @Override
            public void mousePressed(MouseEvent e) {
// 79 71
                int XCoord = (e.getX()/79);
                int YCoord = (e.getY()/71);
                old_coord[0] = XCoord;
                old_coord[1] = YCoord;
                selected_piece = board_label[XCoord][YCoord];
                if ((selected_piece != null)&&(selected_piece.get_is_white() != white_turn)){
                    selected_piece = null;
                }
            }
        });
        // Keeps that piece on the mouse while being dragged
        contentPane.addMouseMotionListener(new MouseAdapter(){
            @Override
            public void mouseDragged(MouseEvent e) {

                if(selected_piece != null) {
                    selected_piece.getLabel().setLocation(Math.round(e.getX()-30), Math.round(e.getY())-30);
                }
            }
        });
        // drops piece in the square if it's a legal move
        contentPane.addMouseListener(new MouseAdapter(){
            @Override
            public void mouseReleased(MouseEvent e) {
                if(selected_piece != null) {
                     Point point = selected_piece.getLabel().getLocation();
                    // converts mouse coordinate to array coordinate
                    int NewX = (int) (Math.round(point.getX()+30) / 79);
                    int NewY = (int) (Math.round(point.getY()+30) / 71);
                    // if legal then it will remove the piece at that coordinate and replace it
                    // with the piece the user is holding
                    if(selected_piece.is_legal(NewX, NewY)) {
                        if ((board_label[NewX][NewY] != null) && !((NewX == old_coord[0]) && (NewY == old_coord[1]))) {
                            contentPane.remove(board_label[NewX][NewY].getLabel());
                        }
                        add_piece(selected_piece, NewX, NewY);
                        contentPane.repaint();
                        turn_count ++;
                        white_turn=!white_turn;
                        if(checkmate(white_turn)){
                            JOptionPane.showMessageDialog(null,  "Checkmate!");
                        }

                    }
                    // else it will just place it back
                    else{
                        add_piece(selected_piece, old_coord[0], old_coord[1]);
                    }
                }
            }
        });
        if(fen_code.equals(""))
        {
            add_normal_layout();
        }
        else{
            add_fen_layout(fen_code);
        }

        JButton flip_button = new JButton("flip");
        flip_button.setSize(75,30);
        flip_button.setLocation(280,580);
        flip_button.addActionListener(e -> {
            for(int x = 0; x<8; x++){
                for(int y = 0; y<4; y++){
                    Piece tempP = null;
                    String tempS = "|__|";
                    Piece tempP1 = null;
                    String tempS1 = "|__|";
                    if(board_label[x][y]!= null){
                        if(board_label[x][y] instanceof Pawn){
                            ((Pawn) board_label[x][y]).setDirection();
                        }
                        else if(board_label[x][y] instanceof King){
                            ((King) board_label[x][y]).setDirection();
                        }
                        tempP = board_label[x][y];
                        tempS = board_string[x][y];
                        board_label[x][y].getLabel().setLocation((7-x)*79,(7-y)*71);
                        board_label[x][y].setCoord(7-x, 7-y);
                    }
                    if(board_label[7-x][7-y] != null) {
                        if(board_label[7-x][7-y] instanceof Pawn){
                            ((Pawn) board_label[7-x][7-y]).setDirection();
                        }
                        else if(board_label[7-x][7-y] instanceof King){
                            ((King) board_label[7-x][7-y]).setDirection();
                        }
                        tempP1 = board_label[7 - x][7 - y];
                        tempS1 = board_string[7 - x][7 - y];
                        board_label[7-x][7-y].getLabel().setLocation(x * 79, y * 71);
                        board_label[7-x][7-y].setCoord(x,y);
                    }
                    board_label[7-x][7-y] = tempP;
                    board_string[7-x][7-y] = tempS;
                    board_label[x][y] = tempP1;
                    board_string[x][y] = tempS1;
                    contentPane.repaint();
                }
            }
            display_board();
        });
        contentPane.add(flip_button);

        frame.setVisible(true);
        frame.setResizable(true);
        frame.pack();
        frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    }
    public void add_fen_layout(String fen_code){

        int x=7;
        int y=7;

        int j = 0;
        for(int i=0; i<fen_code.length(); i++){
            j++;
            if(Character.isDigit(fen_code.charAt(i))){
                x -= Character.getNumericValue(fen_code.charAt(i));
                continue;
            }
            if(Character.isAlphabetic(fen_code.charAt(i))){
                create_fen_piece(fen_code.charAt(i), Character.isUpperCase(fen_code.charAt(i)), x, y);
                x--;
                continue;
            }
            if(fen_code.charAt(i) == '/'){
                x=7;
                y--;
            }
            if(fen_code.charAt(i)== ' '){
                break;
            }
        }
        if(Character.toLowerCase(fen_code.charAt(j)) == 'b'){
            white_turn = false;
        }
    }
    public void create_fen_piece(char letter, boolean is_white, int x, int y) {
        switch (Character.toLowerCase(letter)) {
            case 'p' -> new Pawn(x,y,is_white, this);
            case 'n' -> new Knight(x,y,is_white, this);
            case 'b' -> new Bishop(x,y,is_white,this);
            case 'r' -> new Rook(x,y,is_white,this);
            case 'q' -> new Queen(x,y,is_white,this);
            case 'k' -> {
                if(is_white) {
                    white_king = new King(x, y, true, this);
                }
                else{
                    black_king = new King(x,y,false,this);
                }
            }
        }
    }

    public void add_normal_layout(){
        // adds all of the piece objects
        new Rook(0,0, true, this);
        new Knight(1, 0, true, this);
        new Bishop(2,0,true, this);
        this.white_king = new King(3, 0, true, this);
        new Queen(4,0,true, this);
        new Bishop(5,0, true , this);
        new Knight(6,0, true, this);
        new Rook(7,0, true, this);
        for(int i=0; i<8; i++){
            new Pawn(i, 1, true, this);
        }

        new Rook(0,7, false, this);
        new Knight(1, 7, false, this);
        new Bishop(2,7,false, this);
        this.black_king = new King(3, 7, false, this);
        new Queen(4,7,false, this);
        new Bishop(5,7, false , this);
        new Knight(6,7, false, this);
        new Rook(7,7, false, this);
        for(int i=0; i<8; i++){
            new Pawn(i, 6, false, this);
        }

    }
    // prints out text board representation
    public void display_board(String[][] board){
        System.out.println();
        for(int y=0; y<8; y++){
            for(int x=0; x<8; x++){
                System.out.print(board[x][y]);
            }
            System.out.println();
        }
    }
    public void display_board(){
        this.display_board(board_string);
    }
    // remove piece from previous square then places it in
    // new square for both arrays and chessboard.
    public void add_piece(Piece piece, int x, int y){
        board_label[old_coord[0]][old_coord[1]] = null;
        board_label[x][y] = piece;
        board_string[old_coord[0]][old_coord[1]] = "|__|";
        board_string[x][y] = piece.getPiece();
        selected_piece.setCoord(x,y);
        piece.getLabel().setLocation(x*79, y*71);
        if(piece.get_is_white()){
            white_piece_list.add(piece);
        }
        else{
            black_piece_list.add(piece);
        }

    }

    public void remove_piece(int x, int y){
        try {
            contentPane.remove(board_label[x][y].getLabel());
        }
        catch (NullPointerException ignored){}
        board_label[x][y] = null;
        board_string[x][y] = "|__|";
    }
    // adds object to content pane, sets intial place and size
    public void init(Piece piece, int x, int y, String str_piece){
        contentPane.add(piece.getLabel());
        board_label[x][y] = piece;
        board_string[x][y] = str_piece;
        piece.getLabel().setLocation(x*79, y*71);
        piece.getLabel().setSize(75,75);
        if(piece.get_is_white()){
            white_piece_list.add(piece);
        }
        else{
            black_piece_list.add(piece);
        }
    }

    public void setSelected_piece(Piece selected_piece) {
        this.selected_piece = selected_piece;
    }
    // is white is for the player that might in check mate
    public boolean checkmate(boolean is_white){
        ArrayList<Piece> list;
        if(is_white){
            list = white_piece_list;
        }
        else{
            list = black_piece_list;
        }
        for(Piece piece : list){
            piece.clear_legal_list();
            piece.update_move_list();
            if(piece.get_legal_list_size() > 0){
                return false;
            }
        }
        return true;
    }
}


/*
To do:
Click outside of bounds, index bounds error
Make functional code
Window screen resizable
Make sure this enhanced switch statements
 are cross compatible with other java stuff.
 */