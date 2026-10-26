package samepage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
//imports above

public class UserDAO {

    //represents one account returned by database
    public record UserAccount(
        int userId,
        String username,
        String passwordHash
    ) {}

    public UserAccount findByUsername(String username)
            throws SQLException, ClassNotFoundException {
    	
    	//this is the sql query which is compiled as servlet and passed to be executed on database
        String sql = 
            "SELECT user_id, username, password_hash " +
            "FROM `user` WHERE username = ?";
        //We select the userid username and password from the user table
        
        try (
            Connection con = DatabaseCon.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return new UserAccount(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("password_hash")
                    );
                }
            }
        }

        return null;
    }
}
