package samepage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MediaDAO {

    public List<Media> searchMedia(String searchText)
            throws SQLException, ClassNotFoundException {

        List<Media> mediaList = new ArrayList<>();

        String sql;

        if (searchText == null || searchText.trim().isEmpty()) {
            sql = """
                  SELECT media_id, title, media_type, creator, series,
                         description, release_year, cover_image_url,
                         total_seasons
                  FROM media
                  ORDER BY title
                  """;
        } else {
            sql = """
                  SELECT media_id, title, media_type, creator, series,
                         description, release_year, cover_image_url,
                         total_seasons
                  FROM media
                  WHERE title LIKE ?
                  ORDER BY title
                  """;
        }

        try (Connection connection = DatabaseCon.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            if (searchText != null && !searchText.trim().isEmpty()) {
                statement.setString(1, "%" + searchText.trim() + "%");
            }

            try (ResultSet results = statement.executeQuery()) {

                while (results.next()) {
                    Media media = new Media(
                        results.getInt("media_id"),
                        results.getString("title"),
                        results.getString("media_type"),
                        results.getString("creator"),
                        results.getString("series"),
                        results.getString("description"),
                        results.getString("release_year"),
                        results.getString("cover_image_url"),
                        results.getInt("total_seasons")
                    );

                    mediaList.add(media);
                }
            }
        }

        return mediaList;
    }
}