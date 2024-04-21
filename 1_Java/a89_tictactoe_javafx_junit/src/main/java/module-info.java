module com.dearviind {
    requires javafx.controls;
    requires javafx.fxml;

    opens com.dearviind to javafx.fxml;
    exports com.dearviind;
}
