import Games


class Main:
    winner = ""

    def menu(self):
        print("""
        ______________
        |1) Vs player|
        |2) Vs AI    |
        |3) test     |  
        |____________|
        """)
        input1 = input("")
        if input1 == "1":
            game = Games.Game()
            game.player_turn(True)
            print(game.get_winner(), "Wins!!")
        if input1 == "2":
            difficulty = 5
            while (difficulty < 1) | (difficulty > 3):
                try:
                    print("""
                    ____________________________
                    | What difficulty?         |
                    | 1) Easy                  |
                    | 2) Medium                |
                    | 3) Hard                  |
                    |__________________________| 
                    """)
                    difficulty = int(input(""))
                except ValueError:
                    difficulty = 5
            game = Games.Game()
            input1 = "random"
            while (input1 != "y") & (input1 != "n"):
                print("""
                ______________________________
                | should player go first? y/n|
                |____________________________|""")
                input1 = input("")
            difficulty = difficulty * 2 - 1
            if input1 == "y":
                game.AI_turn(True, difficulty)
            if input1 == "n":
                game.place_piece(3, False)
                game.display_board()
                game.AI_turn(True, difficulty)

    def set_winner(self, winner):
        self.winner = winner


Main = Main()
Main.menu()