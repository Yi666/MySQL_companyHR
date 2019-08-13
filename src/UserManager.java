import java.sql.*;

public class UserManager {

    public static void main(String[] args) {
        String jdbcURL = "jdbc:mysql://localhost:3306/new_schema";
        String username = "root";
        String password = "LIUYIliuyi61";

        String name1 = "name1";
        String password1 = "password1";
        String email1 = "email@com";
        String fullname1 = "fullname1";

        try {
            Connection connection = DriverManager.getConnection(jdbcURL, username, password);

            //INSERT

/*            String sql = "INSERT INTO users (username, password, email, fullname)" +
                    " VALUES (?, ?, ?, ?)";

            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1,name1);
            statement.setString(2,password1);
            statement.setString(3,email1);
            statement.setString(4,fullname1);

            int rows = statement.executeUpdate();

            if (rows>0) {
                System.out.println("new user inserted");
            }


*/


            //READ

/*            String checkResult = "SELECT * FROM users";
            Statement statementResult = connection.createStatement();
            ResultSet result = statementResult.executeQuery(checkResult);

            while (result.next()) {
                int userId = result.getInt("user_id");

                System.out.println(userId);
            }

*/

            //UPDATE

/*            String sql = "UPDATE users SET password = 'YI' WHERE username = 'name1';";
            Statement statement = connection.createStatement();

            int rows = statement.executeUpdate(sql);

            if (rows > 0) {
                System.out.println("password updated");
            }
*/

            //DELETE
            String sql = "DELETE FROM users WHERE username = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1,"name1");

            int rows = statement.executeUpdate();

            if (rows > 0) {
                System.out.println("delete succeeded");
            }





            connection.close();;

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
