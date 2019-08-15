import java.math.BigDecimal;
import java.sql.*;

public class SportsComplexManager {

    public static void main(String[] args) throws SQLException {
        String jdbcURL = "jdbc:mysql://localhost:3306/sports_complex_management";
        String username = "root";
        String password = "LIUYIliuyi61";

        try {
            Connection connection = DriverManager.getConnection(jdbcURL, username, password);
            String sql = "INSERT INTO bookings (room_id, booked_date, booked_time, member_id, datetime_of_booking, payment_status) VALUES (?,?,?,?,?,?)";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1,"test");
            statement.setDate(2, Date.valueOf("2018-11-12"));
            statement.setTime(3,Time.valueOf("15:00:00"));
            statement.setString(4,"aaaaaaaaa");
            statement.setTimestamp(5,Timestamp.valueOf("2018-05-30 14:40:23"));
            statement.setString(6,"Paid");


            int rows = statement.executeUpdate();

            if (rows > 0) {
                System.out.println("insert succeed");
            }


        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
