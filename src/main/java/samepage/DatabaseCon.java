package samepage;

import java.sql.*;

//Repeated from class demo (3 tier architecture)
public class DatabaseCon {

    private static final String db = "SamePage";
    private static final String user = "root";

    //enter password here (can change this to accept an environment variable later)
    private static final String password = "password";
    
    public static Connection getConnection()
            throws SQLException, ClassNotFoundException {

    	java.sql.Connection con;

        //Load MySQL JDBC driver
        Class.forName("com.mysql.jdbc.Driver");

        //Connect to MySQL Server (simply checks connection to mysql server doesnt open a database yet)
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/?autoReconnect=true&useSSL=false",
            user,
            password
        );

        System.out.println(
            db + " MySQL server connection successfully opened."
        );

        return con;
    }
}