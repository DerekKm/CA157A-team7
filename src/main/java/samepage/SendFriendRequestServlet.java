package samepage;

import java.sql.SQLException;

import jakarta.servlet.annotation.WebServlet;

@WebServlet("/sendFriendRequest")
public class SendFriendRequestServlet
        extends FriendActionServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected String run(int actorId, int targetId)
            throws SQLException, ClassNotFoundException {

        if (actorId == targetId) {
            return "self";
        }

        boolean sent =
            new FriendshipDAO()
                .sendRequest(actorId, targetId);

        return sent ? "sent" : "exists";
    }
}
