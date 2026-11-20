package samepage;

import java.sql.SQLException;

import jakarta.servlet.annotation.WebServlet;

@WebServlet("/rejectFriendRequest")
public class RejectFriendRequestServlet
        extends FriendActionServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected String run(int actorId, int targetId)
            throws SQLException, ClassNotFoundException {

        // The signed-in user is the addressee of the
        // request and the target user sent it.
        boolean rejected =
            new FriendshipDAO()
                .rejectRequest(targetId, actorId);

        return rejected ? "rejected" : "missing";
    }
}
