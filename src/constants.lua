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
        FULLSCREEN_BACKGROUND = 8,
        PAUSE = 9,
        PAUSE_RESUME_BUTTON = 10,
        UNPAUSE_TIMER = 11,
        HELP_CONTENT = 12,
        HELP_CLOSE = 13,
        HELP_TAB_DESCRIPTION = 14,
        HELP_TAB_KEYS = 15,

        NEXT_PIECE_BLOCK_START = 50,
        CURRENT_PIECE_BLOCK_START = 100,
        PREDICTION_BLOCK_START = 150,
        GAME_BLOCK_START = 200
    },
    key = {
        LEFT = 0,
        UP = 1,
        RIGHT = 2,
        DOWN = 3,
        SPACE = 32,
        ESC = 27,
        P = 80
    },
    helpTab = {
        CLOSED = 0,
        DESCRIPTION = 1,
        KEYS = 2
    }
}