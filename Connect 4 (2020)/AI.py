import Potential_moves
import copy
import SuperClass


class BOT(SuperClass.Super):
    def __init__(self, board, x_turn):
        super().__init__()
        self.board = board
        self.x_turn = x_turn
        self.dictionary = {}
        self.hits = 0

    def min_max_algorithm(self, board, x_turn, tree_depth, test, current_depth=0, alpha=-100000, beta=100000):
        optimal_move = 10
        if x_turn:
            min_score = 1000000000000000
            for i in [3, 2, 4, 1, 5, 0, 6]:
                move = Potential_moves.Board(copy.deepcopy(board))
                if move.place_piece(i, x_turn):
                    board_string = ",".join(item for innerlist in move.get_board() for item in innerlist)
                    if move.is_game_over(x_turn, i):
                        score = -10000
                        if test:
                            print("max")
                            move.display_board()
                            print("score = ", score)
                    elif board_string in self.dictionary:
                        score = self.dictionary[board_string]
                    elif current_depth < tree_depth:
                        move.connections.append([i, ])
                        score = self.min_max_algorithm(copy.deepcopy(move.get_board()), not x_turn,
                                                       tree_depth, test, current_depth + 1, alpha, beta)
                        self.dictionary[board_string] = score
                    else:
                        score = move.board_score_new(False, i) - move.board_score_new(True, i)
                        if test:
                            print("min")
                            move.display_board()
                            print("score = ", score)
                    if score < min_score:
                        min_score = score
                        optimal_score = score
                        optimal_move = i
                    beta = min(beta, score)
                    if beta <= alpha:
                        break
            if test:
                print("min")
        else:
            max_score = -10000000000000000
            for i in [3, 2, 4, 1, 5, 0, 6]:
                move = Potential_moves.Board(copy.deepcopy(board))
                if move.place_piece(i, x_turn):
                    if current_depth == 0:
                        if move.is_game_over(x_turn, i):
                            return i
                    board_string = ",".join(item for innerlist in move.get_board() for item in innerlist)
                    if move.is_game_over(x_turn, i):
                        score = 10000
                        if test:
                            print("max")
                            move.display_board()
                            print("score = ", score)
                    elif board_string in self.dictionary:
                        score = self.dictionary[board_string]
                    elif current_depth < tree_depth:
                        score = self.min_max_algorithm(copy.deepcopy(move.get_board()), not x_turn,
                                                       tree_depth, test, current_depth + 1, alpha, beta)
                        self.dictionary[board_string] = score
                    else:
                        score = move.board_score_new(False, i) - move.board_score_new(True, i)
                        if test:
                            print("max")
                            move.display_board()
                            print("score = ", score)
                    if score > max_score:
                        optimal_move = i
                        max_score = score
                        optimal_score = score
                    alpha = max(alpha, score)
                    if beta <= alpha:
                        break

            if test:
                print("max")

        if test:
            print("current depth: ", current_depth)
            print("optimal move = ", optimal_move)
            print("Optimal score = ", optimal_score)
        if current_depth > 0:
            return optimal_score
        else:

            if optimal_score == -10000:
                if tree_depth >= 0:
                    move.display_board()
                    self.dictionary = {}
                    return self.min_max_algorithm(copy.deepcopy(board), x_turn, tree_depth-1, False)
                else:
                    return 1
            else:
                return optimal_move


