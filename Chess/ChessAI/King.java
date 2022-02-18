import java.util.Arrays;
import java.util.List;

public class King extends Piece{
    boolean first_move = true;
    public King(int x, int y, boolean is_white, ChessBoard board) {
        super(x, y, is_white, board);
    }
    int direction;
    @Override
    void setWhite_img_file_path() {
        this.white_img_file_path = "untitled/images/WhiteKing.png";
    }

    @Override
    void setBlack_img_file_path() {
        this.black_img_file_path = "untitled/images/BlackKing.png";
    }

    @Override
    void update_move_list() {
        int OldX = getCoord()[0];
        int OldY = getCoord()[1];

        int[][] dir = {{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 0}, {0, 1}, {1, -1}, {1, 0}, {1, 1}};
        for (int[] i : dir) {
                try {
                    if (board.board_string[OldX +i[0]][OldY + i[1]].equals("|__|")) {
                       add_legal_move(new int[]{OldX + i[0], OldY + i[1]});
                    } else if (board.board_string[OldX + i[0]][OldY + i[1]].charAt(1) == getOppColour()) {
                        add_legal_move(new int[]{OldX + i[0], OldY + i[1]});
                    }
                } catch (ArrayIndexOutOfBoundsException ignore) {
        }

    }
        int x =OldX;
        int x_iterate=1;
        if((first_move)&&(!in_check(this, new int[]{OldX, OldY}))){
            for(int i1 = 0; i1<2; i1++) {
                while (true) {
                    x+= x_iterate;
                    try {
                        if ((board.board_label[x][OldY] instanceof Rook) &&
                                ((Rook) board.board_label[x][OldY]).first_move) {
                            if((!in_check(this, new int[]{OldX+x_iterate, OldY}))&&
                                    (!in_check(this, new int[]{OldX + x_iterate * 2, OldY}))) {
                                add_legal_move(new int[]{OldX + x_iterate * 2, OldY});
                            }
                        }
                        else if (!board.board_string[x][OldY].equals("|__|")) {
                            break;
                        }
                    } catch (ArrayIndexOutOfBoundsException ignore) {
                        break;
                    }
                }
                x=OldX;
                x_iterate = -1;
            }
        }
    }
    boolean in_check(Piece piece, int[] move){
        int OldX;
        int OldY;
        if(piece == this){
            OldX = move[0];
            OldY = move[1];
        }
        else {

            OldX = getCoord()[0];
            OldY = getCoord()[1];
        }
        String[][] local_board = board.board_string;
        String taken_piece = local_board[move[0]][move[1]];
        local_board[piece.getCoord()[0]][piece.getCoord()[1]] = "|__|";
        local_board[move[0]][move[1]] = piece.getPiece();
        // Knight check
        String OppKnight = "|"+getOppColour()+"n|";
        int[][] dir = {{-2,-1}, {-2,1},{-1,2},{-1,-2},{1,-2}, {1, 2}, {2, -1}, {2,1}};
        for(int[] i : dir){
            try {
                if (local_board[OldX + i[0]][OldY + i[1]].equals(OppKnight)) {
                    System.out.println("knight check");
                    local_board[piece.getCoord()[0]][piece.getCoord()[1]] = piece.getPiece();
                    local_board[move[0]][move[1]] = "|__|";
                    return true;
                }
            }
            catch(ArrayIndexOutOfBoundsException ignored){}
        }
        String[] potential_pieces = {"|"+getOppColour()+"b|", "|"+getOppColour()+"q|"};
        List<String>  list  = Arrays.asList(potential_pieces);
        int j;
        int x;
        int y;
        // Diagonal and edge adjacent checks
        dir = new int[][]{{-1, -1}, {-1, 1}, {1, -1}, {1, 1}};
        for(int l= 0; l<2; l++) {
            for (int[] i : dir) {
                j = 0;
                while (true) {
                   // board.display_board();
                    j++;
                    x = j * i[0];
                    y = j * i[1];
                    //System.out.print(x +" "); System.out.println(y);
                    try {
                        if (list.contains(local_board[OldX + x][OldY + y])) {
                            System.out.println("check");
                            local_board[piece.getCoord()[0]][piece.getCoord()[1]] = piece.getPiece();
                            local_board[move[0]][move[1]] = taken_piece;
                            return true;
                        } else if (!local_board[OldX + x][OldY + y].equals("|__|")) {
                            break;
                        }
                    } catch (ArrayIndexOutOfBoundsException ignore) {
                        break;
                    }
                }
            }
            dir = new int[][]{{-1,0},{0,1},{1,0},{0,-1}};
            potential_pieces = new String[]{"|"+getOppColour()+"r|", "|"+getOppColour()+"q|", "|"};
            list = Arrays.asList(potential_pieces);

        }

        //checks that only occure within one square
        dir = new int[][]{{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 0}, {0, 1}, {1, -1}, {1, 0}, {1, 1}};
        String potential_piece_str = "|" + getOppColour() + "k|";
        for(j = 0; j<2; j++) {
            for (int[] i : dir) {
                try {
                    if (local_board[OldX + i[0]][OldY + i[1]].equals(potential_piece_str)) {
                        System.out.println("single square check");
                        local_board[piece.getCoord()[0]][piece.getCoord()[1]] = piece.getPiece();
                        local_board[move[0]][move[1]] = taken_piece;
                        return true;
                    }

                } catch (ArrayIndexOutOfBoundsException ignore) {}
            }
            potential_piece_str = "|" + getOppColour() + "p|";
            dir = new int[][]{{1, direction}, {-1,direction}};

        }
        local_board[piece.getCoord()[0]][piece.getCoord()[1]] = piece.getPiece();
        local_board[move[0]][move[1]] = taken_piece;
        return false;

    }

    @Override
    public void status_update(int x, int y) {
        first_move = false;
        if(x==getCoord()[0]+2){
            board.board_label[7][getCoord()[1]].status_update(x-1, y);
            board.add_piece(board.board_label[7][getCoord()[1]],x-1,y);
        }
        else if(x==getCoord()[0]-2){
            board.board_label[7][getCoord()[1]].status_update(x+1, y);
            board.add_piece(board.board_label[0][getCoord()[1]], x+1, y);
        }
    }

    @Override
    void init_piece(boolean is_white) {
        if(is_white){
            setPiece("|wk|");
            direction = 1;
        }
        else {
            setPiece("|bk|");
            direction = -1;
        }
    }
    public void setDirection(){
        direction = direction*-1;
    }
}
