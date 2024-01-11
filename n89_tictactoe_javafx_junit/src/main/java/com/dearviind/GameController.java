package com.dearviind;

import java.util.function.Consumer;

public class GameController {
    private Board board;
    private Symbol symbol;
    private Consumer<String> onGameEnd;

    public GameController(Consumer<String> onGameEnd) {
        this.board = new Board();
        this.symbol = Symbol.X; // X starts the game
        this.onGameEnd = onGameEnd;
    }

    public Symbol getSymbol() {
        return symbol;
    }

    public Board getBoard() {
        return board;
    }

    public void handleCellClick(int row, int col) {
        // Process the move
        // Check for win or draw
        // Switch players if the game continues
        if (board.getCell(row, col).getSymbol() == null) {
            board.updateCell(row, col, symbol);
            switchPlayer();
        }

        if (board.checkWin()) {
            onGameEnd.accept("Winner: " + symbol);
        } else if (board.checkDraw()) {
            onGameEnd.accept("Draw!");
        }

    }

    private void switchPlayer() {
        // Switch the current player
        this.symbol = (symbol == Symbol.X) ? Symbol.O : Symbol.X;
        onGameEnd.accept("Turn: " + this.symbol.toString());
    }

    public void resetGame() {
        board.reset();
        symbol = Symbol.X; // X starts the game
        // Reset UI for a new game
        onGameEnd.accept("Turn: X"); // Reset the status text

    }
}
