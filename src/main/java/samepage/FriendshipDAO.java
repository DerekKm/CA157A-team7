package samepage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FriendshipDAO {

    // Send a friend request from requesterId to addresseeId.
    // Returns false when the request must not be sent:
    // a user cannot befriend themselves, and an
    // existing relationship blocks a second request.
    public boolean sendRequest(int requesterId, int addresseeId)
            throws SQLException, ClassNotFoundException {

        if (requesterId == addresseeId) {
            return false;
        }

        try (Connection con = DatabaseCon.getConnection()) {

            // Checking if the users are already friends.
            String sql = "SELECT user_id, friend_id "
            		+ "FROM befriends "
            		+ "WHERE ((user_id = ? AND friend_id = ?) OR (friend_id = ? AND user_id = ?)) AND status <> \'rejected\'";

            try (PreparedStatement stmt =
                    con.prepareStatement(sql)) {

                stmt.setInt(1, requesterId);
                stmt.setInt(2, addresseeId);
                stmt.setInt(3, requesterId);
                stmt.setInt(4, addresseeId);

                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        // Error Duplicate found. Already friends.
                        return false;
                    }
                }
            }

            // Sending request
            String insertSql = "INSERT INTO befriends (user_id, friend_id, status, requested_at) "
            		+ "VALUES (?, ?, \'pending\', CURRENT_TIMESTAMP) ";

            try (PreparedStatement stmt =
                    con.prepareStatement(insertSql)) {

                stmt.setInt(1, requesterId);
                stmt.setInt(2, addresseeId);
                stmt.executeUpdate();
            }

            return true;

        }
    }

    // Accept a pending request. The row is located by
    // its requester and its addressee, so only the user
    // the request was sent to can accept it.
    public boolean acceptRequest(int requesterId, int addresseeId)
            throws SQLException, ClassNotFoundException {

        String sql = "UPDATE Befriends "
        		+ "SET status = \'accepted\', responded_at = CURRENT_TIMESTAMP "
        		+ "WHERE user_id = ? AND friend_id = ? ";

        try (Connection con = DatabaseCon.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, requesterId);
            stmt.setInt(2, addresseeId);

            return stmt.executeUpdate() == 1;

        }
    }

    // Decline a pending request. Only the addressee
    // of the request can decline it.
    public boolean rejectRequest(int requesterId, int addresseeId)
            throws SQLException, ClassNotFoundException {

        String sql = "UPDATE Befriends "
        		+ "SET status = \'rejected\', responded_at = CURRENT_TIMESTAMP "
        		+ "WHERE user_id = ? AND friend_id = ? ";

        try (Connection con = DatabaseCon.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, requesterId);
            stmt.setInt(2, addresseeId);

            return stmt.executeUpdate() == 1;

        }
    }

    // Remove a friend. The relationship is deleted in
    // either direction.
    public boolean removeFriend(int userId, int friendId)
            throws SQLException, ClassNotFoundException {

        String sql = "DELETE FROM Befriends "
        		+ "WHERE (user_id = ? AND friend_id = ?) OR (friend_id = ? AND user_id = ?)";

        try (Connection con = DatabaseCon.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, friendId);
            stmt.setInt(3, userId);
            stmt.setInt(4, friendId);

            return stmt.executeUpdate() == 1;

        }
    }

    // Requests waiting for this user to respond.
    public List<Friendship> getPendingRequests(int addresseeId)
            throws SQLException, ClassNotFoundException {

        String sql = "SELECT * "
        		+ "FROM Befriends "
        		+ "WHERE friend_id = ? AND status = \'pending\' ";

        List<Friendship> requests = new ArrayList<>();

        try (Connection con = DatabaseCon.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, addresseeId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    requests.add(readFriendship(rs));
                }
            }
        }

        return requests;
    }

    // Accepted friendships that involve this user in
    // either direction.
    public List<Friendship> getFriends(int userId)
            throws SQLException, ClassNotFoundException {

        String sql = "SELECT * "
        		+ "FROM Befriends "
        		+ "WHERE (friend_id = ? OR user_id = ?) AND status = \'accepted\'";

        List<Friendship> friends = new ArrayList<>();

        try (Connection con = DatabaseCon.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    friends.add(readFriendship(rs));
                }
            }
        }

        return friends;
    }

    // Map one row onto a Friendship. The row keeps the
    // requester in user_id and the addressee in friend_id.
    private Friendship readFriendship(ResultSet rs)
            throws SQLException {

        Friendship f = new Friendship();

        f.setRequesterId(
                rs.getInt("user_id"));

        f.setAddresseeId(
                rs.getInt("friend_id"));

        f.setStatus(
                rs.getString("status"));

        f.setRequestedAt(
        	    rs.getTimestamp("requested_at"));

        f.setRespondedAt(
                rs.getTimestamp("responded_at"));

        return f;
    }
}
