"""
Can't go upwards at begining
win condition
"""
# global variables are bad practice
import random
import msvcrt
while True:
    def print_maze(reallybigstring, player_x, player_y):
        for y in range(player_y-20,player_y+20):
            for x in range(player_x - 40, player_x+40):
                try:
                    if(x >= 0) & (y >= 0):
                        reallybigstring = reallybigstring + maze[y][x]
                    else:
                        reallybigstring = reallybigstring + " "
                except IndexError:
                    if not y > int(round(size/2, 0)):
                        reallybigstring = reallybigstring + " "
            reallybigstring = reallybigstring + "\n"
        print(reallybigstring)


    def create_maze(bx, tx, by, ty, x_intercept, y_intercept, oop):
        loop = 0
        # drawing two lines
        verticle_line = random.randint(bx+2, tx-2) # select where along the x axist the verticle line is placed

        while(maze[by][verticle_line] == " ") | (maze[ty][verticle_line] == " "):
            verticle_line = random.randint(bx+2, tx-2)
            if loop == 10:
                break

            loop = loop + 1
        loop = 0
        horizontal_line = random.randint(by+2,ty-2) # select where along the y axist the verticle line is placed
        while (maze[horizontal_line][bx] == " ") | (maze[horizontal_line][tx] == " "):
            horizontal_line = random.randint(by+2, ty-2)
            if loop == 10:
                break

            loop = loop + 1
        for i in range(by+(maze[by][verticle_line]==" "), by+ty-by-1-(maze[ty][verticle_line]==" ")):
            maze[i+1][verticle_line] = "|"
        for i in range(bx+(maze[horizontal_line][bx] == " "), bx+tx-bx-1-(maze[horizontal_line][tx] == " ")):
            if maze[horizontal_line][i+1] == "|":  # for getting the intercept of the two lines
                y_intercept = horizontal_line
                x_intercept = i+1
            maze[horizontal_line][i+1] = "-"
        # print_maze()
        # creates three gaps
        which_gap_list = [1, 2, 3, 4]  # for randomly choosing a gap
        which_gap = random.choice(which_gap_list)
        if which_gap != 1:
            gap_place = random.randint(y_intercept+1, ty-1)
            maze[gap_place][x_intercept] = " "
        if which_gap != 2:
            gap_place = random.randint(by+1, y_intercept-1)
            maze[gap_place][x_intercept] = " "
        if which_gap != 3:
            gap_place = random.randint(x_intercept+1, tx-1)
            maze[y_intercept][gap_place] = " "
        if which_gap != 4:
            gap_place = random.randint(bx+1,x_intercept-1)
            maze[y_intercept][gap_place] = " "

        if True:
            if ((tx - x_intercept) > 3) & ((ty - y_intercept) > 3):
                create_maze(x_intercept, tx, y_intercept, ty, 0, 0, loop)
            if((x_intercept - bx) > 3) & ((y_intercept - by) > 3):
                create_maze(bx, x_intercept, by, y_intercept, 0, 0, loop)
            if((tx-x_intercept) > 3) & ((y_intercept - by) > 3):
                create_maze(x_intercept, tx, by, y_intercept, 0, 0, loop)
            if((x_intercept-bx) > 3) & ((ty - y_intercept) > 3):
                create_maze(bx, x_intercept, y_intercept, ty, 0, 0, loop)


    # getting user input
    print("how big do you want your maze?(10 for easy. 50 for hard.) wasd to move")
    while True:
        try:
            size = (int(input()))*4
            if size > 36:
                print("here")
                break
            else:
                print("please put a value between 10 and 30")
        except ValueError:
            print("please input an integer")
    maze = []
    # creating the boarders
    topline = []

    for i in range(size):
        topline.append("█")
    maze.append(topline)
    for y in range(int(round(size/2, 0))):
        array=[]
        for x in range(size):
            if x == 0:
                array.append("█")
            elif x == size-1:

                array.append("█")
            else:
                array.append(" ")
            # array.append("|_|")
        maze.append(array)
    bottomline = []
    for i in range(size):
        bottomline.append("█")
    # bottomline.append(" _|")
    maze.append(bottomline)
    # creating maze
    # creates start and finish
    start = random.randint(1, size-1)
    finish = random.randint(1, size-1)
    maze[0][start] = " "
    maze[int(round(size/2, 0))+1][finish] = " "
    create_maze(0, size-1, 0, int(round(size/2, 0))+1, 0, 0, 0)
    # making it pretty
    for y in range(int(round(size/2, 0)+2)):
        for x in range(size):
            if maze[y][x] == "-":
                if(maze[y+1][x] == "|") & (maze[y-1][x] == "|"):
                    maze[y][x] = "┼"
                elif maze[y+1][x] == "|":
                    maze[y][x] = "┬"
                elif maze[y-1][x] == "|":
                    maze[y][x] = "┴"
                else:
                    maze[y][x] = "─"
    for y in range(int(round(size/2, 0)+2)):
        for x in range(size):
            if maze[y][x] == "|":
                if((maze[y][x+1] == "─") | (maze[y][x+1] == "┼") | (maze[y][x+1] == "┬") | (maze[y][x+1] == "┴")) & ((maze[y][x-1] == "─") | (maze[y][x-1] == "┼")|(maze[y][x-1] == "┬")|(maze[y][x-1] == "┴")):
                    maze[y][x]="┼"
                elif(maze[y][x+1] == "─") | (maze[y][x+1] == "┼") | (maze[y][x+1] == "┬") | (maze[y][x+1] == "┴"):
                    maze[y][x] = "├"
                elif(maze[y][x-1] == "─") | (maze[y][x-1] == "┼") | (maze[y][x-1] == "┬") | (maze[y][x-1] == "┴"):
                    maze[y][x] = "┤"
                else:
                    maze[y][x] = "│"


    # printing the maze
    # player movement
    print("wasd to move")
    player_x = start
    player_y = 0
    win = False
    while not win:
        maze[player_y][player_x] = "x"
        print_maze("", player_x, player_y)
        input_char = msvcrt.getch()
        maze[player_y][player_x] = " "
        if str(input_char).lower() == "b'w'":
            if maze[player_y-1][player_x] not in "│┤─┼├┬┴█":
                player_y -= 1
        if str(input_char).lower() == "b's'":
            try:
                if maze[player_y+1][player_x] not in "│┤─┼├┬┴█":
                    player_y += 1
            except IndexError:
                print("""
    
                                ├───────────────────────────────┤
                                │                               │ 
                                │ You have completed the maze!! │
                                │        Congratulations!       │ 
                                │                               │
                                ├───────────────────────────────┤
                                """)
                win = True
                input()
        if str(input_char).lower() == "b'a'":
            if maze[player_y][player_x-1] not in "│┤─┼├┬┴█":
                player_x -= 1
        if str(input_char).lower() == "b'd'":
            if maze[player_y][player_x+1] not in "│┤─┼├┬┴█":
                player_x += 1





