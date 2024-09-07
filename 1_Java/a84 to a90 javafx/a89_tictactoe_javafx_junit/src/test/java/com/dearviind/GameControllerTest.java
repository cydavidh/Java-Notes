package com.dearviind;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.BeforeEach;

public class GameControllerTest {
    private GameController gameController;

    @BeforeEach
    public void setUp() {
        gameController = new GameController(message -> {
        });
        // Assuming the GameController constructor takes a Consumer<String> for updating UI messages
    }

    public void testHorizontalWin() {
        // Simulate a horizontal win for player X
        gameController.handleCellClick(0, 0); // X
        gameController.handleCellClick(1, 0); // O
        gameController.handleCellClick(0, 1); // X
        gameController.handleCellClick(1, 1); // O
        gameController.handleCellClick(0, 2); // X wins

        assertTrue(gameController.getBoard().checkWin(), "Game should be won by X");
    }

    @Test
    public void testVerticalWin() {
        // Simulate a vertical win for player O
        gameController.handleCellClick(0, 0); // X
        gameController.handleCellClick(0, 1); // O
        gameController.handleCellClick(1, 0); // X
        gameController.handleCellClick(1, 1); // O
        gameController.handleCellClick(2, 2); // X
        gameController.handleCellClick(2, 1); // O wins

        assertTrue(gameController.getBoard().checkWin(), "Game should be won by O");
    }

    @Test
    public void testDraw() {
        // Simulate a draw
        gameController.handleCellClick(0, 0); // X
        gameController.handleCellClick(0, 1); // O
        gameController.handleCellClick(0, 2); // X
        gameController.handleCellClick(1, 1); // O
        gameController.handleCellClick(1, 0); // X
        gameController.handleCellClick(2, 0); // O
        gameController.handleCellClick(1, 2); // X
        gameController.handleCellClick(2, 2); // O
        gameController.handleCellClick(2, 1); // X

        assertTrue(gameController.getBoard().checkDraw(), "Game should be a draw");
    }

    // More tests...
}
