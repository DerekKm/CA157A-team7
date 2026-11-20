package samepage;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/friends")
public class FriendsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
                !(session.getAttribute("user_id")
                    instanceof Integer)) {

            response.sendRedirect(
                request.getContextPath() + "/login"
            );
            return;
        }

        int userId =
            (Integer) session.getAttribute("user_id");

        try {
            FriendshipDAO dao = new FriendshipDAO();

            List<Friendship> friends =
                dao.getFriends(userId);

            List<Friendship> requests =
                dao.getPendingRequests(userId);

            request.setAttribute(
                "currentUserId", userId);

            request.setAttribute(
                "friends", friends);

            request.setAttribute(
                "requests", requests);

            request.setAttribute(
                "friendStatus",
                request.getParameter("status"));

            request.getRequestDispatcher("/friends.jsp")
                   .forward(request, response);

        } catch (Exception ex) {
            throw new ServletException(
                "Unable to load friends.", ex
            );
        }
    }
}
