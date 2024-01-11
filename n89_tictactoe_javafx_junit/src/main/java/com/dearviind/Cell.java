package com.dearviind;

public class Cell {
    private Symbol symbol;

    public Cell() {
        this.symbol = null;
    }

    public void setSymbol(Symbol symbol) {
        if (this.symbol == null) {
            this.symbol = symbol;
        }
    }

    public Symbol getSymbol() {
        return this.symbol;
    }

    public boolean isEmpty() {
        return this.symbol == null;
    }

    public void resetCell() {
        this.symbol = null;
    }
}
