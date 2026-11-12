package samepage;

import java.io.IOException;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/friends")
public class FriendsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final FriendshipDAO dao = new FriendshipDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !(session.getAttribute("user_id") instanceof Integer)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int userId = (Integer) session.getAttribute("user_id");
        if (session.getAttribute("friendsCsrfToken") == null) {
            session.setAttribute("friendsCsrfToken", UUID.randomUUID().toString());
        }
        String search = request.getParameter("search");
        search = search == null ? "" : search.trim();
        if (search.length() > 45) search = search.substring(0, 45);

        try {
            request.setAttribute("friends", dao.getFriends(userId));
            request.setAttribute("requests", dao.getPendingRequests(userId));
            request.setAttribute("outgoing", dao.getOutgoingRequests(userId));
            request.setAttribute("search", search);
            if (!search.isBlank()) {
                request.setAttribute("searchResults", dao.searchUsers(userId, search));
            }
            request.getRequestDispatcher("/friends.jsp").forward(request, response);
        } catch (Exception ex) {
            throw new ServletException("Could not load friends.", ex);
        }
    }
}
