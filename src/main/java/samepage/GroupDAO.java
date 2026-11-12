package samepage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class GroupDAO {

    public record GroupInfo(
        int groupId,
        String name,
        String description
    ) {}

    // Find groups owned by or containing the user.
    public List<GroupInfo> getGroupsForUser(int userId)
            throws SQLException, ClassNotFoundException {

        String sql = """
            SELECT g.group_id, g.name, g.description
            FROM mediagroup g
            WHERE g.owner_id = ?
               OR g.group_id IN (
                   SELECT gm.group_id
                   FROM groupmembership gm
                   WHERE gm.user_id = ?
               )
            ORDER BY g.name
            """;

        List<GroupInfo> groups = new ArrayList<>();

        try (Connection con = DatabaseCon.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    groups.add(new GroupInfo(
                        rs.getInt("group_id"),
                        rs.getString("name"),
                        rs.getString("description")
                    ));
                }
            }
        }

        return groups;
    }

    // Only return groups this user is allowed to view.
    public GroupInfo getGroupForUser(int userId, int groupId)
            throws SQLException, ClassNotFoundException {

        String sql = """
            SELECT g.group_id, g.name, g.description
            FROM mediagroup g
            WHERE g.group_id = ?
              AND (
                  g.owner_id = ?
                  OR g.group_id IN (
                      SELECT gm.group_id
                      FROM groupmembership gm
                      WHERE gm.user_id = ?
                  )
              )
            """;

        try (Connection con = DatabaseCon.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, groupId);
            ps.setInt(2, userId);
            ps.setInt(3, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new GroupInfo(
                        rs.getInt("group_id"),
                        rs.getString("name"),
                        rs.getString("description")
                    );
                }
            }
        }

        return null;
    }

    // Owners can edit their group.
    // Other members need a role with can_add_media = 1.
    public boolean canEditGroupMedia(int userId, int groupId)
            throws SQLException, ClassNotFoundException {

        String ownerSql = """
            SELECT owner_id
            FROM mediagroup
            WHERE group_id = ?
            """;

        String roleSql = """
            SELECT gr.can_add_media
            FROM groupmembership gm
            JOIN grouprole gr
              ON gm.group_id = gr.group_id
             AND gm.role_id = gr.role_id
            WHERE gm.group_id = ?
              AND gm.user_id = ?
            """;

        try (Connection con = DatabaseCon.getConnection()) {

            try (PreparedStatement ps =
                    con.prepareStatement(ownerSql)) {

                ps.setInt(1, groupId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        return false;
                    }

                    if (rs.getInt("owner_id") == userId) {
                        return true;
                    }
                }
            }

            try (PreparedStatement ps =
                    con.prepareStatement(roleSql)) {

                ps.setInt(1, groupId);
                ps.setInt(2, userId);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        if (rs.getBoolean("can_add_media")) {
                            return true;
                        }
                    }
                }
            }
        }

        return false;
    }

    // Find media currently shared with a group.
    public List<Media> getGroupMedia(int groupId)
            throws SQLException, ClassNotFoundException {

        String sql = """
            SELECT m.*
            FROM media m
            JOIN shares s
              ON m.media_id = s.media_id
            WHERE s.group_id = ?
            ORDER BY m.title
            """;

        return loadMedia(sql, groupId);
    }

    // Find catalog titles not yet shared with this group.

public List<Media> getAvailableMedia(int groupId, String search)
        throws SQLException, ClassNotFoundException {

    boolean searching = search != null && !search.isBlank();

    String sql = """
        SELECT m.*
        FROM media m
        WHERE m.media_id NOT IN (
            SELECT s.media_id
            FROM shares s
            WHERE s.group_id = ?
        )
        """ +
        (searching ? """
            AND (
                m.title LIKE ?
                OR m.creator LIKE ?
                OR m.series LIKE ?
                OR m.media_type LIKE ?
            )
            """ : "") +
        """
        ORDER BY m.title
        """;

    List<Media> media = new ArrayList<>();

    try (Connection con = DatabaseCon.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, groupId);

        if (searching) {
            String pattern = "%" + search.trim() + "%";

            ps.setString(2, pattern);
            ps.setString(3, pattern);
            ps.setString(4, pattern);
            ps.setString(5, pattern);
        }

        // Show 5 initially, and up to 20 after searching.
        ps.setMaxRows(searching ? 20 : 5);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                media.add(new Media(
                    rs.getInt("media_id"),
                    rs.getString("title"),
                    rs.getString("media_type"),
                    rs.getString("creator"),
                    rs.getString("series"),
                    rs.getString("description"),
                    rs.getString("release_year"),
                    rs.getString("cover_image_url"),
                    rs.getInt("total_seasons")
                ));
            }
        }
    }

    return media;
}


    // Shared helper for reading Media objects.
    private List<Media> loadMedia(String sql, int groupId)
            throws SQLException, ClassNotFoundException {

        List<Media> media = new ArrayList<>();

        try (Connection con = DatabaseCon.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, groupId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Media item = new Media(
                        rs.getInt("media_id"),
                        rs.getString("title"),
                        rs.getString("media_type"),
                        rs.getString("creator"),
                        rs.getString("series"),
                        rs.getString("description"),
                        rs.getString("release_year"),
                        rs.getString("cover_image_url"),
                        rs.getInt("total_seasons")
                    );

                    media.add(item);
                }
            }
        }

        return media;
    }

    // Add a media title, avoiding duplicates.
    public boolean addMedia(int userId, int groupId, int mediaId)
            throws SQLException, ClassNotFoundException {

        if (!canEditGroupMedia(userId, groupId)) {
            return false;
        }

        String checkSql = """
            SELECT media_id
            FROM shares
            WHERE group_id = ?
              AND media_id = ?
            """;

        String insertSql = """
            INSERT INTO shares
                (group_id, media_id, added_at)
            VALUES (?, ?, ?)
            """;

        try (Connection con = DatabaseCon.getConnection()) {

            // Check whether the title is already shared.
            try (PreparedStatement ps =
                    con.prepareStatement(checkSql)) {

                ps.setInt(1, groupId);
                ps.setInt(2, mediaId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return false;
                    }
                }
            }

            // Insert only if it was not already present.
            try (PreparedStatement ps =
                    con.prepareStatement(insertSql)) {

                ps.setInt(1, groupId);
                ps.setInt(2, mediaId);
                ps.setTimestamp(3,
                    new Timestamp(System.currentTimeMillis()));

                return ps.executeUpdate() == 1;
            }
        }
    }

    // Remove a title from the group's media list.
    public boolean removeMedia(int userId, int groupId, int mediaId)
            throws SQLException, ClassNotFoundException {

        if (!canEditGroupMedia(userId, groupId)) {
            return false;
        }

        String sql = """
            DELETE FROM shares
            WHERE group_id = ?
              AND media_id = ?
            """;

        try (Connection con = DatabaseCon.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, groupId);
            ps.setInt(2, mediaId);

            return ps.executeUpdate() == 1;
        }
    }

    // Create a group, owner role, member role,
    // and owner membership.
    public int createGroup(
            int ownerId,
            String name,
            String description)
            throws SQLException, ClassNotFoundException {

        try (Connection con = DatabaseCon.getConnection()) {

            con.setAutoCommit(false);

            try {
                int groupId;

                // The supplied group_id is not AUTO_INCREMENT.
                // Use MAX to choose the next ID.
                String idSql = """
                    SELECT MAX(group_id)
                    FROM mediagroup
                    """;

                try (PreparedStatement ps =
                        con.prepareStatement(idSql);
                     ResultSet rs = ps.executeQuery()) {

                    rs.next();

                    // getInt returns 0 when MAX is NULL.
                    groupId = rs.getInt(1) + 1;
                }

                // Add the group.
                String groupSql = """
                    INSERT INTO mediagroup
                        (group_id, owner_id, description,
                         name, created_at)
                    VALUES (?, ?, ?, ?, ?)
                    """;

                try (PreparedStatement ps =
                        con.prepareStatement(groupSql)) {

                    ps.setInt(1, groupId);
                    ps.setInt(2, ownerId);
                    ps.setString(3, description);
                    ps.setString(4, name);
                    ps.setTimestamp(5,
                        new Timestamp(System.currentTimeMillis()));

                    ps.executeUpdate();
                }

                // Add default roles for the new group.
                String roleSql = """
                    INSERT INTO grouprole
                        (role_id, group_id, role_name,
                         can_add_media, can_create_threads,
                         can_moderate, can_manage_members,
                         can_post_announcements)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                    """;

                try (PreparedStatement ps =
                        con.prepareStatement(roleSql)) {

                    // Owner role.
                    ps.setInt(1, 1);
                    ps.setInt(2, groupId);
                    ps.setString(3, "Owner");

                    ps.setInt(4, 1);
                    ps.setInt(5, 1);
                    ps.setInt(6, 1);
                    ps.setInt(7, 1);
                    ps.setInt(8, 1);

                    ps.executeUpdate();

                    // Regular member role.
                    ps.setInt(1, 2);
                    ps.setInt(2, groupId);
                    ps.setString(3, "Member");

                    ps.setInt(4, 0);
                    ps.setInt(5, 1);
                    ps.setInt(6, 0);
                    ps.setInt(7, 0);
                    ps.setInt(8, 0);

                    ps.executeUpdate();
                }

                // Register the creator as an owner member.
                String memberSql = """
                    INSERT INTO groupmembership
                        (user_id, group_id, role_id, joined_at)
                    VALUES (?, ?, ?, ?)
                    """;

                try (PreparedStatement ps =
                        con.prepareStatement(memberSql)) {

                    ps.setInt(1, ownerId);
                    ps.setInt(2, groupId);
                    ps.setInt(3, 1);
                    ps.setTimestamp(4,
                        new Timestamp(System.currentTimeMillis()));

                    ps.executeUpdate();
                }

                con.commit();

                return groupId;

            } catch (SQLException | RuntimeException ex) {
                con.rollback();
                throw ex;

            } finally {
                con.setAutoCommit(true);
            }
        }
    }
}
