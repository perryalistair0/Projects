class Super:
    board = []

    def __init__(self):
        pass

    def place_piece(self, column, x_turn):
        for i in range(6):
            if (self.board[column][i] == "|x|") | (self.board[column][i] == "|o|"):
                if i > 0:
                    if x_turn:
                        self.board[column][i - 1] = "|x|"
                    else:
                        self.board[column][i - 1] = "|o|"
                    return True
                else:
                    return False

        if x_turn:
            self.board[column][5] = "|x|"
            return True
        else:
            self.board[column][5] = "|o|"
            return True

    def display_board(self):
        for y in range(6):
            for x in range(7):
                print(self.board[x][y], end="")
            print("")
        print(" ", end="")
        for i in range(7):
            print(i + 1, " ", end="")
        print("")

    def is_game_over(self, x_turn, column):
        DIR = ""
        score = 0
        direction = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
        if x_turn:
            piece = "|x|"
        else:
            piece = "|o|"
        for i in range(6):
            score = 0
            if self.board[column][i] == piece:
                for j in direction:
                    try:
                        if self.board[column + j[0]][i + j[1]] == piece:
                            score += 1
                            DIR = j
                    except IndexError:
                        pass
                    if score > 0:

                        x = column + DIR[0]
                        y = i + DIR[1]
                        try:
                            while (self.board[x][y] == piece) & (x >= 0) & (y >= 0):
                                score += 1
                                x += DIR[0]
                                y += DIR[1]
                        except IndexError:
                            pass

                        x = column - DIR[0]
                        y = i - DIR[1]
                        try:
                            while (self.board[x][y] == piece) & (x >= 0) & (y >= 0):
                                score += 1
                                x -= DIR[0]
                                y -= DIR[1]
                        except IndexError:
                            pass
                    if score > 3:
                        return True
                    score = 0
        return False
