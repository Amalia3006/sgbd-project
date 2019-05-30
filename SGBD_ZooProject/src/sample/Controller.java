package sample;

import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.Region;
import javafx.stage.Stage;

import java.io.IOException;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.stream.Stream;

public class Controller {
    private Connection con;

    @FXML
    private DatePicker data_program_ghizi;
    @FXML
    private TextField text_luna;
    @FXML
    private TextField text_nr_bilet;
    @FXML
    private ComboBox<String> lista_opt_ghizi;

    @FXML
    private TextField firstname;
    @FXML
    private TextField lastname;
    @FXML
    private TextField address;
    @FXML
    private TextField data_nastere;
    @FXML
    private TextField nr_telefon;
    @FXML
    private TextField guidWanted;
    @FXML
    private TextField ticket_type;
    @FXML
    private TextField data_program_ghizi_nou;
    @FXML
    private TextField TICKET;
    @FXML
    private TextField VISITDATE;
    @FXML
    private TextField GUIDEWANTED;
    @FXML
    private TextField ID_DE_CAUTARE;


    //aici se face conexiunea cu bd
    public Controller() {

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
        } catch (ClassNotFoundException e) {
//            e.printStackTrace();
            System.out.print(e);

            return;
        }

        try {
            con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "ZOOPROJECT", "ZOOPROJECT");
        } catch (SQLException e) {
//            e.printStackTrace();
            System.out.print(e);

            return;
        }

        System.out.println("Connected to SQL");

    }

    //pg noua
    public void moveNextZOOKEEPERS(javafx.event.ActionEvent actionEvent) throws IOException {
        Parent trecereZooKeepers = FXMLLoader.load(getClass().getResource("ZooKeepersOption.fxml"));

        Scene zooKeepersOp = new Scene(trecereZooKeepers);
        Stage window = new Stage();
        window.setTitle("ZooKeepersOptions");
        window.setScene(zooKeepersOp);
        window.show();
    }

    //pg noua
    public void moveNextGuides(javafx.event.ActionEvent actionEvent) throws IOException {
        Parent trecereGuides = FXMLLoader.load(getClass().getResource("GuidesOption.fxml"));

        Scene guidesOp = new Scene(trecereGuides);
        Stage window = new Stage();
        window.setTitle("GuidesOptions");
        window.setScene(guidesOp);
        window.show();
    }

    //pg noua
    public void moveNextTickets(javafx.event.ActionEvent actionEvent) throws IOException {
        Parent trecereTickets = FXMLLoader.load(getClass().getResource("TicketsOption.fxml"));

        Scene ticketsOp = new Scene(trecereTickets);
        Stage window = new Stage();
        window.setTitle("TicketsOptions");
        window.setScene(ticketsOp);
        window.show();
    }

    //pg noua
    public void moveNewVisitator(javafx.event.ActionEvent actionEvent) throws IOException {
        Parent trecereNew = FXMLLoader.load(getClass().getResource("NewVisitator.fxml"));

        Scene newVisitatorOp = new Scene(trecereNew);
        Stage window = new Stage();
        window.setTitle("Bilet vizitator nou");
        window.setScene(newVisitatorOp);
        window.show();
    }

    //pg noua
    public void moveOldVisitator(javafx.event.ActionEvent actionEvent) throws IOException {
        Parent trecereOld = FXMLLoader.load(getClass().getResource("OldVisitator.fxml"));

        Scene oldVisitatorOp = new Scene(trecereOld);
        Stage window = new Stage();
        window.setTitle("Bilet vizitator");
        window.setScene(oldVisitatorOp);
        window.show();
    }

    //pg noua
    public void backToTicketsOptions(javafx.event.ActionEvent actionEvent) throws IOException {
        Parent backTickets = FXMLLoader.load(getClass().getResource("TicketsOption.fxml"));

        Scene backTicketsOp = new Scene(backTickets);
        Stage window = new Stage();
        window.setTitle("TicketsOptions");
        window.setScene(backTicketsOp);
        window.show();
    }

    //afiseaza lista cu toti ghizii
    @FXML
    void lista_ghizi(MouseEvent event) {
        try {
            CallableStatement myCall = con.prepareCall("{call get_lista_ghizi}");
            myCall.executeUpdate();
        } catch (SQLException e) {
            //e.printStackTrace();
            System.out.print(e);
        }

    }

    //afiseaza lista cu toti ghicii dintr o anumita data
    @FXML
    void lista_ghizi_data(MouseEvent event) {
        //NU MERGE
        try {
            CallableStatement myCall = con.prepareCall("{call get_guides_program_on_a_day(?)}");
            myCall.setDate(1, Date.valueOf(data_program_ghizi.getValue()));
            myCall.executeUpdate();
        } catch (SQLException e) {
            //e.printStackTrace();
            System.out.print(e);
        }

    }

    //avem statistici vizitatori
    @FXML
    void statistici_vizitatori(MouseEvent event) {
        try {
            CallableStatement myCall = con.prepareCall("{call statistici_vizitatori(?)}");
            myCall.setInt(1, Integer.parseInt(text_luna.getText()));
            con.createStatement().executeUpdate("begin dbms_output.enable(); end;");
            myCall.executeUpdate();

            try (CallableStatement call = con.prepareCall(
                    "declare "
                            + "  num integer := 1000;"
                            + "begin "
                            + "  dbms_output.get_lines(?, num);"
                            + "end;"
            )) {
                call.registerOutParameter(1, Types.ARRAY,
                        "DBMSOUTPUT_LINESARRAY");
                call.execute();

                Array array = null;
                try {
                    StringBuilder rezultat = new StringBuilder();
                    array = call.getArray(1);
                    Stream.of((Object[]) array.getArray())
                            .forEach(rezultat::append);
                    Alert alert = new Alert(Alert.AlertType.INFORMATION, rezultat.toString(), ButtonType.OK);
                    alert.getDialogPane().setMinHeight(Region.USE_PREF_SIZE);
                    alert.show();
                } finally {
                    if (array != null)
                        array.free();
                }
            }
        } catch (SQLException e) {
            //e.printStackTrace();
            System.out.print(e);
        }
    }

    //lista totala de vizitatori
    @FXML
    void get_lista_vizitatori_totala(MouseEvent event) {

        try {
            CallableStatement myCall = con.prepareCall("{call get_lista_vizitatori_totala}");
            myCall.executeUpdate();
        } catch (SQLException e) {
            //e.printStackTrace();
            System.out.print(e);
        }
    }

    //dau nr bilet zice daca e ok sau nu
    @FXML
    void checkAge(MouseEvent event) {
        try {
            CallableStatement myCall = con.prepareCall("{call checkAge(?)}");
            myCall.setInt(1, Integer.parseInt(text_nr_bilet.getText()));
            con.createStatement().executeUpdate("begin dbms_output.enable(); end;");
            myCall.executeUpdate();
            try (CallableStatement call = con.prepareCall(
                    "declare "
                            + "  num integer := 1000;"
                            + "begin "
                            + "  dbms_output.get_lines(?, num);"
                            + "end;"
            )) {
                call.registerOutParameter(1, Types.ARRAY,
                        "DBMSOUTPUT_LINESARRAY");
                call.execute();

                Array array = null;
                try {
                    StringBuilder rezultat = new StringBuilder();
                    array = call.getArray(1);
                    Stream.of((Object[]) array.getArray())
                            .forEach(rezultat::append);
                    Alert alert = new Alert(Alert.AlertType.INFORMATION, rezultat.toString(), ButtonType.OK);
                    alert.getDialogPane().setMinHeight(Region.USE_PREF_SIZE);
                    alert.show();
                } finally {
                    if (array != null)
                        array.free();
                }
            }

        } catch (SQLException e) {
            //e.printStackTrace();
            System.out.print(e);
        }
    }

    //excel cu zookeepers
    @FXML
    void get_lista_keepers(MouseEvent event) {
        try {
            CallableStatement myCall = con.prepareCall("{call get_lista_keepers}");
            myCall.executeUpdate();
        } catch (SQLException e) {
            //e.printStackTrace();
            System.out.print(e);
        }
    }

    //statistici angajati
    @FXML
    void employees_statistics(MouseEvent event) {
        try {
            CallableStatement myCall = con.prepareCall("{call employees_statistics}");
            con.createStatement().executeUpdate("begin dbms_output.enable(); end;");
            myCall.executeUpdate();
            try (CallableStatement call = con.prepareCall(
                    "declare "
                            + "  num integer := 1000;"
                            + "begin "
                            + "  dbms_output.get_lines(?, num);"
                            + "end;"
            )) {
                call.registerOutParameter(1, Types.ARRAY,
                        "DBMSOUTPUT_LINESARRAY");
                call.execute();
                Array array = null;
                try {
                    StringBuilder rezultat = new StringBuilder();
                    array = call.getArray(1);
                    Stream.of((Object[]) array.getArray())
                            .forEach(rezultat::append);
                    Alert alert = new Alert(Alert.AlertType.INFORMATION, rezultat.toString(), ButtonType.OK);
                    alert.getDialogPane().setMinHeight(Region.USE_PREF_SIZE);
                    alert.show();
                } finally {
                    if (array != null)
                        array.free();
                }
            }
        } catch (SQLException e) {
            //e.printStackTrace();
            System.out.print(e);
        }
    }

    // insereaza persoana noua in baza de date
    @FXML
    void insert_persoana(MouseEvent event) {
        try {
            Statement s = con.createStatement();
            String querryInsert = "insert into PERSONS (FIRST_NAME, LAST_NAME, ADDRESS, DATE_OF_BIRTH, PHONE_NUMBER ) " +
                    "values ('" + firstname.getText() + "', '" + lastname.getText() + "', '" + address.getText() + "', to_date('" + data_nastere.getText() + "'), '" + nr_telefon.getText() + "')";
            s.executeUpdate(querryInsert);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            Statement stm = con.createStatement();
            String query = "select giveTicket(to_date('" + data_nastere.getText() + "')) from dual";
            ResultSet rezultatStm = stm.executeQuery(query);
            if (rezultatStm.next())
                ticket_type.setText(rezultatStm.getString(1));
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    //eliberare bilet pers noua
    @FXML
    void elibereaza_bilet(MouseEvent event) {
        try {
            int ticket_d;
            Statement s = con.createStatement();
            String querryInsert = "select person_id from persons where first_name= '" + firstname.getText() + "'and last_name = '" + lastname.getText() + "' and address= '" + address.getText() + "'and date_of_birth = to_date( '" + data_nastere.getText() + "')and phone_number = '" + nr_telefon.getText() + "'";
            ResultSet res = s.executeQuery(querryInsert);
            int pers_id = 0;
            if (res.next()) {
                pers_id = res.getInt(1);
            }
            if (ticket_type.getText().equals("copil/student")) {
                ticket_d = 1;
            } else if (ticket_type.getText().equals("normal")) {
                ticket_d = 2;
            } else ticket_d = 3;

            Statement s2 = con.createStatement();
            String query = "insert into VISITORS (TICKET_DETAILS_ID, VISITOR_ID, VISIT_DATE, GUIDE_ASSIGNED_ID) values (" + ticket_d + "," + pers_id + ", to_date('"
                    + data_program_ghizi_nou.getText() + "')," + guidWanted.getText() + ")";
                System.out.println(query);
            s2.executeQuery(query);

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    //cautare dupa id daca exista in baza de date
    @FXML
    void cautare_dupa_id(MouseEvent event) {
        // merge vezi poate schimbi afisarea
        try {
            Statement stm = con.createStatement();
            String query = "  select * from persons where person_id = '" + ID_DE_CAUTARE.getText() + "'";
            ResultSet resultSet = stm.executeQuery(query);
//            System.out.println(query);
            if (resultSet.next()){
                System.out.println(resultSet.getInt(1));
                System.out.println(resultSet.getString(2));
                System.out.println(resultSet.getString(3));
                System.out.println(resultSet.getString(4));
                System.out.println(resultSet.getDate(5));
                System.out.println(resultSet.getString(6));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            Statement stm = con.createStatement();
                String query = "select giveTicketName(" + ID_DE_CAUTARE.getText()+ ") from dual";
                ResultSet rezultatStm = stm.executeQuery(query);
                if (rezultatStm.next())
                    TICKET.setText(rezultatStm.getString(1));

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    //eliberare bilet care e deja in baza de date
    @FXML
    void eliberare_bilet_old_visitor(MouseEvent event) {
        try {
            int ticket_d;
            if (TICKET.getText().equals("copil/student")) {
                ticket_d = 1;
            } else if (TICKET.getText().equals("normal")) {
                ticket_d = 2;
            } else ticket_d = 3;

            Statement s2 = con.createStatement();
            String query2 = "insert into VISITORS (TICKET_DETAILS_ID, VISITOR_ID, VISIT_DATE, GUIDE_ASSIGNED_ID) values (" + ticket_d + "," + ID_DE_CAUTARE.getText() + ", to_date('"
                    + VISITDATE.getText() + "')," + GUIDEWANTED.getText() + ")";
               System.out.println(query2);
            s2.executeQuery(query2);

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }



}
