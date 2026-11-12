package samepage;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/rejectFriendRequest")
public class RejectFriendRequestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final FriendshipDAO dao = new FriendshipDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !(session.getAttribute("user_id") instanceof Integer)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String token = (String) session.getAttribute("friendsCsrfToken");
        if (token == null || !token.equals(request.getParameter("csrfToken"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid form token.");
            return;
        }

        int otherId;
        try {
            otherId = Integer.parseInt(request.getParameter("requesterId"));
            if (otherId <= 0) throw new NumberFormatException();
        } catch (NumberFormatException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID.");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        try {
            boolean changed = dao.rejectRequest(otherId, userId);
            response.sendRedirect(request.getContextPath() + "/friends?status="
                    + (changed ? "rejected" : "notRejected"));
        } catch (Exception ex) {
            throw new ServletException("Could not update friendship.", ex);
        }
    }
}
