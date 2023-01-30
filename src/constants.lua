MAP = 7925976

GAME_WIDTH = 10
GAME_HEIGHT = 20

ACTUAL_BLOCK_SIZE = math.floor(400 / (GAME_HEIGHT * 1.25))
BLOCK_SIZE = ACTUAL_BLOCK_SIZE - 8

enum = {
    textArea = {
        HELP = 1,
        START_GAME = 2,
        GAME_BACKGROUND = 3,
        BACKGROUND_NEXT_PIECE = 4,
        NEXT_PIECE_TEXT = 5,
        GAME_INFO = 6,
        TETRIS_LOGO = 7,

        NEXT_PIECE_BLOCK_START = 50,
        CURRENT_PIECE_BLOCK_START = 100,
        GAME_BLOCK_START = 200
    },
    key = {
        LEFT = 0,
        UP = 1,
        RIGHT = 2,
        DOWN = 3,
        SPACE = 32
    }
}