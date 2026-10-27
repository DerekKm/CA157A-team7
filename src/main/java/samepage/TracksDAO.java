package samepage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TracksDAO {

    public boolean addMedia(int userId, int mediaId)  throws SQLException, ClassNotFoundException{

        try {

            
        	Connection con = DatabaseCon.getConnection();
        	String sql = "SELECT media_id, owner_id"
        			  + " FROM Tracks"
        			  + " WHERE (Tracks.owner_id = ? AND media_id = ? );";
        	PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setInt(2, mediaId);

            ResultSet rs = stmt.executeQuery();
            if(rs.next()) {
            	// Error Duplicate found.
            	return false;
            }
            
            sql = "INSERT INTO Tracks (media_id, owner_id, current_unit, current_season)"
            	+ "VALUES (?, ?, 0, 0)";
            stmt = con.prepareStatement(sql);
            stmt.setInt(1, mediaId);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
            
            return true;

        } catch (SQLException e) {
            throw(e);
        } catch(ClassNotFoundException e) {
        	throw(e);
        }

    }

    public List<Track> getUserMedia(int userId) {

        List<Track> tracks = new ArrayList<>();

        try {


        	Connection con = DatabaseCon.getConnection();
            String sql = "SELECT t.*, m.media_id, m.media_type, m.title" 
            		  + " FROM Tracks t JOIN Media m ON t.media_id = m.media_id"
            		  + " WHERE owner_id = ?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
           
            while(rs.next()) {
            	
                Track track = new Track();

                track.setMediaId(rs.getInt("media_id"));
                track.setTitle(rs.getString("title"));
                track.setMediaType(rs.getString("media_type"));
                track.setStatus(rs.getString("status"));
                track.setCurrentSeason(rs.getInt("current_season"));
                track.setCurrentUnit(rs.getInt("current_unit"));

                tracks.add(track);
                
            }

            

        } catch (Exception e) {
            e.printStackTrace();
        }

        return tracks;
    }

    public boolean updateProgress(
            int userId,
            int mediaId,
            int season,
            int unit) {

        try {

          
        	Connection con = DatabaseCon.getConnection();
            String sql = "UPDATE Tracks"
            		+   " SET current_season = ?, current_unit = ?" 
            		+   " WHERE owner_id = ? AND media_id = ?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, season);
            stmt.setInt(2, unit);
            stmt.setInt(3, userId);
            stmt.setInt(4, mediaId);
            stmt.executeUpdate();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean removeMedia(
            int userId,
            int mediaId) {

        try {

        	Connection con = DatabaseCon.getConnection();
            String sql = "DELETE FROM Tracks"
               		+    " WHERE owner_id = ? AND media_id = ?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setInt(2, mediaId);
            stmt.executeUpdate();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}