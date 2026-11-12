package samepage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class FriendshipDAO {

    public record UserSearchResult(int userId, String username, String displayName) {}

    // Search by username or display name. Don't offer people who already have
    // an accepted friendship or an outstanding request with this user.
    public List<UserSearchResult> searchUsers(int currentUserId, String search)
            throws SQLException, ClassNotFoundException {
        List<UserSearchResult> users = new ArrayList<>();
        if (search == null || search.isBlank()) return users;

        String sql = """
            SELECT u.user_id, u.username, u.display_name
            FROM `user` u
            WHERE u.user_id <> ?
              AND (u.username LIKE ? OR u.display_name LIKE ?)
              AND u.user_id NOT IN (
                  SELECT b.friend_id FROM befriends b
                  WHERE b.user_id = ? AND b.status IN ('pending', 'accepted')
              )
              AND u.user_id NOT IN (
                  SELECT b.user_id FROM befriends b
                  WHERE b.friend_id = ? AND b.status IN ('pending', 'accepted')
              )
            ORDER BY u.username
            """;

        try (Connection con = DatabaseCon.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, currentUserId);
            String pattern = "%" + search.trim() + "%";
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            ps.setInt(4, currentUserId);
            ps.setInt(5, currentUserId);
            ps.setMaxRows(10);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(new UserSearchResult(rs.getInt("user_id"),
                            rs.getString("username"), rs.getString("display_name")));
                }
            }
        }
        return users;
    }

    public List<Friendship> getPendingRequests(int currentUserId)
            throws SQLException, ClassNotFoundException {
        String sql = """
            SELECT b.user_id, b.friend_id, b.status,
                   b.requested_at, b.responded_at, u.username
            FROM befriends b JOIN `user` u ON u.user_id = b.user_id
            WHERE b.friend_id = ? AND b.status = 'pending'
            ORDER BY b.requested_at DESC
            """;
        return loadFriendships(sql, currentUserId);
    }

    public List<Friendship> getOutgoingRequests(int currentUserId)
            throws SQLException, ClassNotFoundException {
        String sql = """
            SELECT b.user_id, b.friend_id, b.status,
                   b.requested_at, b.responded_at, u.username
            FROM befriends b JOIN `user` u ON u.user_id = b.friend_id
            WHERE b.user_id = ? AND b.status = 'pending'
            ORDER BY b.requested_at DESC
            """;
        return loadFriendships(sql, currentUserId);
    }

    public List<Friendship> getFriends(int currentUserId)
            throws SQLException, ClassNotFoundException {
        String sql = """
            SELECT b.user_id, b.friend_id, b.status,
                   b.requested_at, b.responded_at, u.username
            FROM befriends b
            JOIN `user` u ON
                 (b.user_id = ? AND u.user_id = b.friend_id)
              OR (b.friend_id = ? AND u.user_id = b.user_id)
            WHERE b.status = 'accepted'
            ORDER BY u.username
            """;
        List<Friendship> result = new ArrayList<>();
        try (Connection con = DatabaseCon.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, currentUserId);
            ps.setInt(2, currentUserId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) result.add(readFriendship(rs));
            }
        }
        return result;
    }

    private List<Friendship> loadFriendships(String sql, int currentUserId)
            throws SQLException, ClassNotFoundException {
        List<Friendship> result = new ArrayList<>();
        try (Connection con = DatabaseCon.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, currentUserId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) result.add(readFriendship(rs));
            }
        }
        return result;
    }

    private Friendship readFriendship(ResultSet rs) throws SQLException {
        Friendship f = new Friendship();
        f.setRequesterId(rs.getInt("user_id"));
        f.setAddresseeId(rs.getInt("friend_id"));
        f.setStatus(rs.getString("status"));
        f.setUsername(rs.getString("username"));
        f.setRequestedAt(rs.getTimestamp("requested_at"));
        f.setRespondedAt(rs.getTimestamp("responded_at"));
        return f;
    }

    public boolean sendRequest(int currentUserId, int targetUserId)
            throws SQLException, ClassNotFoundException {
        if (currentUserId <= 0 || targetUserId <= 0 || currentUserId == targetUserId)
            return false;

        String findSql = """
            SELECT user_id, friend_id, status
            FROM befriends
            WHERE (user_id = ? AND friend_id = ?)
               OR (user_id = ? AND friend_id = ?)
            """;
        String insertSql = """
            INSERT INTO befriends (user_id, friend_id, status, requested_at)
            VALUES (?, ?, 'pending', ?)
            """;
        String retrySql = """
            UPDATE befriends
            SET user_id = ?, friend_id = ?, status = 'pending',
                requested_at = ?, responded_at = NULL
            WHERE user_id = ? AND friend_id = ?
              AND status IN ('rejected', 'declined')
            """;
        try (Connection con = DatabaseCon.getConnection()) {
            // Check that the recipient exists.
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT user_id FROM `user` WHERE user_id = ?")) {
                ps.setInt(1, targetUserId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) return false;
                }
            }

            try (PreparedStatement ps = con.prepareStatement(findSql)) {
                ps.setInt(1, currentUserId);
                ps.setInt(2, targetUserId);
                ps.setInt(3, targetUserId);
                ps.setInt(4, currentUserId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String status = rs.getString("status");
                        if (!"declined".equalsIgnoreCase(status)
                                && !"rejected".equalsIgnoreCase(status)) return false;

                        int oldSender = rs.getInt("user_id");
                        int oldRecipient = rs.getInt("friend_id");
                        try (PreparedStatement retry = con.prepareStatement(retrySql)) {
                            retry.setInt(1, currentUserId);
                            retry.setInt(2, targetUserId);
                            retry.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
                            retry.setInt(4, oldSender);
                            retry.setInt(5, oldRecipient);
                            return retry.executeUpdate() == 1;
                        }
                    }
                }
            }

            try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                ps.setInt(1, currentUserId);
                ps.setInt(2, targetUserId);
                ps.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
                return ps.executeUpdate() == 1;
            }
        }
    }

    public boolean acceptRequest(int requesterId, int currentUserId)
            throws SQLException, ClassNotFoundException {
        String sql = """
            UPDATE befriends
            SET status = 'accepted', responded_at = ?
            WHERE user_id = ? AND friend_id = ? AND status = 'pending'
            """;
        try (Connection con = DatabaseCon.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            ps.setInt(2, requesterId);
            ps.setInt(3, currentUserId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean rejectRequest(int requesterId, int currentUserId)
            throws SQLException, ClassNotFoundException {
        String sql = """
            UPDATE befriends
            SET status = 'declined', responded_at = ?
            WHERE user_id = ? AND friend_id = ? AND status = 'pending'
            """;
        try (Connection con = DatabaseCon.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            ps.setInt(2, requesterId);
            ps.setInt(3, currentUserId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean removeFriend(int currentUserId, int otherUserId)
            throws SQLException, ClassNotFoundException {
        String sql = """
            DELETE FROM befriends
            WHERE status = 'accepted' AND (
                  (user_id = ? AND friend_id = ?)
               OR (user_id = ? AND friend_id = ?)
            )
            """;
        try (Connection con = DatabaseCon.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, currentUserId);
            ps.setInt(2, otherUserId);
            ps.setInt(3, otherUserId);
            ps.setInt(4, currentUserId);
            return ps.executeUpdate() > 0;
        }
    }
}
