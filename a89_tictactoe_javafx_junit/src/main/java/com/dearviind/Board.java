package com.dearviind;

public class Board {
    private Cell[][] cells;

    public Board() {
        cells = new Cell[3][3]; // Initialize the array
        for (int row = 0; row < cells.length; row++) {
            for (int col = 0; col < cells[row].length; col++) {
                cells[row][col] = new Cell(); // Instantiate each Cell
            }
        }
    }

    public void updateCell(int row, int column, Symbol symbol) {
        if (cells[row][column].getSymbol() == null) {
            cells[row][column].setSymbol(symbol);
        }
    }

    public Cell getCell(int row, int column) {
        return cells[row][column];
    }



    public boolean checkWin() {
        // Check all win conditions (rows, columns, diagonals)
        return checkRowWin() || checkDiagonalWin() || checkColumnWin();
    }

    public boolean checkDraw() {
        // Check if all cells are filled and there's no winner
        for (int row = 0; row < 3; row++) {
            for (int column = 0; column < 3; column++) {
                if (cells[row][column].getSymbol() == null) {
                    return false;
                }
            }
        }
        return true;
    }

    private boolean checkRowWin() {
        // Check each row for a win
        for (int row = 0; row < 3; row++) {
            if (cells[row][0].getSymbol() != null &&
                    cells[row][0].getSymbol().equals(cells[row][1].getSymbol()) &&
                    cells[row][0].getSymbol().equals(cells[row][2].getSymbol())) {
                return true;
            }
        }
        return false;
    }

    private boolean checkColumnWin() {
        // Check each column for a win
        for (int column = 0; column < 3; column++) {
            if (cells[0][column].getSymbol() != null &&
                    cells[0][column].getSymbol().equals(cells[1][column].getSymbol()) &&
                    cells[0][column].getSymbol().equals(cells[2][column].getSymbol())) {
                return true;
            }
        }
        return false;

    }

    private boolean checkDiagonalWin() {
        boolean diagonal1 = cells[0][0].getSymbol() != null &&
                cells[0][0].getSymbol() == cells[1][1].getSymbol() &&
                cells[0][0].getSymbol() == cells[2][2].getSymbol();
        boolean diagonal2 = cells[0][2].getSymbol() != null &&
                cells[0][2].getSymbol() == cells[1][1].getSymbol() &&
                cells[0][2].getSymbol() == cells[2][0].getSymbol();

        return diagonal1 || diagonal2;
    }

    public void reset() {
        // Reset all cells for a new game
        for (int row = 0; row < 3; row++) {
            for (int column = 0; column < 3; column++) {
                cells[row][column].resetCell();
            }
        }
    }
}
