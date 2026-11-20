package samepage;

import java.sql.SQLException;

import jakarta.servlet.annotation.WebServlet;

@WebServlet("/removeFriend")
public class RemoveFriendServlet
        extends FriendActionServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected String run(int actorId, int targetId)
            throws SQLException, ClassNotFoundException {

        boolean removed =
            new FriendshipDAO()
                .removeFriend(actorId, targetId);

        return removed ? "removed" : "missing";
    }
}
