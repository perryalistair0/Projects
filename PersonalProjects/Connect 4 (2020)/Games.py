import AI
import Potential_moves
import copy
import SuperClass


class Game(SuperClass.Super):
    board = []
    winner = ""

    def __init__(self):
        super().__init__()
        for x in range(7):
            line = []
            for y in range(6):
                line.append("|_|")
            self.board.append(line)
        self.display_board()

    def get_winner(self):
        return self.winner

    def get_board(self):
        return self.board

    def player_turn(self, x_turn):
        if x_turn:
            player = "x"
        else:
            player = "o"
        print("Which column,", player, "? 1-7")
        column = int(input("")) - 1
        self.place_piece(column, x_turn)
        score = Potential_moves.Board(self.board)
        print("X:", score.board_score_new(True, column))
        print("O:", score.board_score_new(False, column))
        self.display_board()
        if not self.is_game_over(x_turn, column):
            self.player_turn(not x_turn)
        self.winner = player

    def AI_turn(self, x_turn, difficulty):
        if x_turn:
            while True:
                print("which column? 1-7")
                try:
                    column = int(input("")) - 1
                    if self.place_piece(column, True):
                        break
                except ValueError:
                    pass
                except IndexError:
                    pass
            # self.display_board()
            # time.sleep(1)
        else:
            bot = AI.BOT(copy.deepcopy(self.board), x_turn)
            column = bot.min_max_algorithm(copy.deepcopy(self.board), x_turn, difficulty, False)
            print("column", column + 1)
            self.place_piece(column, False)
            self.display_board()
        if not self.is_game_over(x_turn, column):
            self.AI_turn(not x_turn, difficulty)
        else:
            print("The game is over")
