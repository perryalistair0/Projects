import SuperClass


class Board(SuperClass.Super):
    def __init__(self, board):
        super().__init__()
        self.board = board
        self.test = []
        self.connections = []
        for x in range(7):
            line = []
            for y in range(6):
                line.append(0)
            self.test.append(line)

    def get_board(self):
        return self.board

    def board_score_new(self, x_turn, latest_move):
        if self.is_game_over(x_turn, latest_move):
            return 10000
        score = 0
        if x_turn:
            piece = "|x|"
        else:
            piece = "|o|"
        direction = [[0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
        for column in range(7):
            for row in range(6):
                if self.board[column][row] == piece:
                    if column == 3:
                        score += 4
                        self.test[column][row] += 1
                    for DIR in direction:
                        temp_score = 0
                        temp_column = column
                        temp_row = row
                        for i in range(3):
                            try:
                                temp_column += DIR[0]
                                temp_row += DIR[1]
                                if self.board[temp_column][temp_row] == piece:
                                    temp_score += 1
                                    self.test[column][row] += 1
                                elif self.board[temp_column][temp_row] != "|_|":
                                    break
                            except IndexError:
                                break
                        if temp_score == 1:
                            score += 2
                        elif temp_score >= 2:
                            score += 3
        return score

    def display_test(self):
        for y in range(6):
            for x in range(7):
                print(self.test[x][y], end="")
            print("")
        print(" ", end="")
        for i in range(7):
            print(i+1, " ", end="")
        print("")

    def clear_test(self):
        self.test = []
        for x in range(7):
            line = []
            for y in range(6):
                line.append(0)
            self.test.append(line)
