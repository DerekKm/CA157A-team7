package samepage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class FriendshipDAO {

    public boolean sendRequest(
            int userId,
            int friendId) {

        try {
        	
        	if(friendId == userId) {
        		//Error: No friending yourself.
        		return false;
        	}
            Connection con =
                    DatabaseCon.getConnection();
            //Checking if the users are already friends.
            String sql = "SELECT user_id, friend_id "
            		+ "FROM befriends "
            		+ "WHERE ((user_id = ? AND friend_id = ?) OR (friend_id = ? AND user_id = ?)) AND status <> \'rejected\'";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, userId);
      		stmt.setInt(2, friendId);
      		stmt.setInt(3, userId);
       		stmt.setInt(4, friendId);
      		
      		ResultSet rs = stmt.executeQuery();
      		if(rs.next()) {
      			// Error Duplicate found. Already friends.
      			return false;
      		}
      		
      		// Sending request
      		sql = "INSERT INTO befriends (user_id, friend_id, status, requested_at) "
      				+ "VALUES (?, ?, \'pending\', CURRENT_TIMESTAMP) ";
      		stmt = con.prepareStatement(sql);
            stmt.setInt(1, userId);
      		stmt.setInt(2, friendId);
      		stmt.executeUpdate();
            return true;

        } catch(Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean acceptRequest(
            int userId,
            int friendId) {

        try {

            Connection con =
                    DatabaseCon.getConnection();

      		String sql = "UPDATE Befriends "
      				+ "SET status = \'accepted\', responded_at = CURRENT_TIMESTAMP "
      				+ "WHERE user_id = ? AND friend_id = ? ";
      		PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, userId);
      		stmt.setInt(2, friendId);
      		stmt.executeUpdate();
           
            return true;

        } catch(Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean rejectRequest(
            int userId,
            int friendId) {

        try {

            Connection con =
                    DatabaseCon.getConnection();

            String sql = "UPDATE Befriends "
      				+ "SET status = \'rejected\', responded_at = CURRENT_TIMESTAMP "
      				+ "WHERE user_id = ? AND friend_id = ? ";
      		PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, userId);
      		stmt.setInt(2, friendId);
      		stmt.executeUpdate();
            return true;

        } catch(Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean removeFriend(
            int userId,
            int friendId) {

        try {

            Connection con =
                    DatabaseCon.getConnection();
            String sql = "DELETE FROM Befriends "
      				+ "WHERE (user_id = ? AND friend_id = ?) OR (friend_id = ? AND user_id = ?)";
      		PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, userId);
      		stmt.setInt(2, friendId);
      		stmt.setInt(3, userId);
      		stmt.setInt(4, friendId);
      		stmt.executeUpdate();
           
            

            return true;

        } catch(Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Friendship> getPendingRequests(
            int friendId) {

        List<Friendship> requests =
                new ArrayList<>();

        try {

            Connection con =
                    DatabaseCon.getConnection();

            String sql = "SELECT * "
            		+ "FROM Befriends "
            		+ "WHERE friend_id = ? AND status = \'pending\' ";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, friendId);

            ResultSet rs = stmt.executeQuery();
            
            while(rs.next()) {

                Friendship f =
                        new Friendship();

                f.setAddresseeId(
                        rs.getInt("user_id"));

                f.setRequesterId(
                        rs.getInt("friend_id"));

                f.setStatus(
                        rs.getString("status"));
                
                f.setRequestedAt(
                	    rs.getTimestamp("requested_at"));
                	    
                f.setRespondedAt(
                    rs.getTimestamp("responded_at"));
                
                requests.add(f);
            }

        } catch(Exception e) {
            e.printStackTrace();
        }

        return requests;
    }

    public List<Friendship> getFriends(
            int friendId) {

        List<Friendship> friends =
                new ArrayList<>();

        try {

            Connection con =
                    DatabaseCon.getConnection();

            String sql = "SELECT * "
            		+ "FROM Befriends "
            		+ "WHERE (friend_id = ? OR user_id = ?) AND status = \'accepted\'";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, friendId);
            stmt.setInt(2, friendId);

            ResultSet rs = stmt.executeQuery();

            while(rs.next()) {

                Friendship f =
                        new Friendship();

                f.setAddresseeId(
                        rs.getInt("user_id"));

                f.setRequesterId(
                        rs.getInt("friend_id"));

                f.setStatus(
                        rs.getString("status"));
                
                f.setRequestedAt(
                	    rs.getTimestamp("requested_at"));
                	    
                	f.setRespondedAt(
                	    rs.getTimestamp("responded_at"));

                friends.add(f);
            }

        } catch(Exception e) {
            e.printStackTrace();
        }

        return friends;
    }
}