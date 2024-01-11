package com.dearviind;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.geometry.Insets;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextArea;
import javafx.scene.layout.Border;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.FlowPane;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;
import javafx.scene.text.Font;
import javafx.stage.Stage;

import java.io.IOException;
import java.util.Arrays;
import java.util.function.Consumer;

/**
 * JavaFX App
 */
public class TicTacToeApplication extends Application {

    private GameController gameController;
    private Label statusText;
    private Button resetButton;
    private Button[][] buttons = new Button[3][3];


    @Override
    public void start(Stage window) {
        Consumer<String> onGameEnd = this::updateStatusText;
        gameController = new GameController(onGameEnd);

        BorderPane borderPane = new BorderPane();
        statusText = new Label("Turn: O");
        statusText.setFont(Font.font(40));
        borderPane.setTop(statusText);

        resetButton = new Button("Reset the Game");
        resetButton.setVisible(false);
        resetButton.setOnAction(e -> {
            gameController.resetGame();
            clearAllButtons();
            // Optionally, update other UI elements as needed
            statusText.setText("Turn: X"); // Reset the status text
        });
        borderPane.setBottom(resetButton);


        GridPane gridPane = createGrid();
        borderPane.setCenter(gridPane);
        gridPane.setHgap(10);
        gridPane.setVgap(10);
        gridPane.setPadding(new Insets(10));



        Scene scene = new Scene(borderPane);
        window.setScene(scene);
        window.show();
    }

    private void clearAllButtons() {
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                buttons[i][j].setText(""); // Clear the text of each button
            }
        }
    }

    private GridPane createGrid() {
        GridPane gridPane = new GridPane();

        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                Button button = new Button();
                button.setMinSize(100, 100);
                button.setFont(Font.font("Monospaced", 40));
                int finalRow = i;
                int finalCol = j;
                buttons[i][j] = button;
                button.setOnAction(e -> {
                    gameController.handleCellClick(finalRow, finalCol);
                    updateButtonBasedOnCell(button, gameController.getBoard().getCell(finalRow, finalCol));
                });
                gridPane.add(button, j, i);
            }
        }

        return gridPane;
    }

    private void updateButtonBasedOnCell(Button button, Cell cell) {
        if (!cell.isEmpty()) {
            button.setText(cell.getSymbol().toString());
        } else {
            button.setText("");
        }
    }

    private void updateStatusText(String message) {
        statusText.setText(message);
        if (message.equals("Winner: X") || message.equals("Winner: O") || message.equals("Draw!")) {
            resetButton.setVisible(true);
        } else {
            resetButton.setVisible(false);
        }

    }

    public static void main(String[] args) {
        launch(TicTacToeApplication.class);
    }

}
