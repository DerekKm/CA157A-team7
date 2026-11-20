package samepage;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Shared behaviour for the friend action endpoints:
// require a signed-in user, read the target user id,
// run one friendship action, and redirect back to the
// friends page with a status the page can display.
abstract class FriendActionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Perform the action as the signed-in user.
    // Return the status label used in the redirect.
    protected abstract String run(int actorId, int targetId)
            throws SQLException, ClassNotFoundException;

    @Override
    protected void doPost(HttpServletRequest request,
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

        int actorId =
            (Integer) session.getAttribute("user_id");

        int targetId;

        try {
            targetId = positiveId(
                request.getParameter("friendId"));
        } catch (IllegalArgumentException ex) {

            response.sendRedirect(
                request.getContextPath() +
                "/friends?status=invalid"
            );
            return;
        }

        try {
            String status = run(actorId, targetId);

            response.sendRedirect(
                request.getContextPath() +
                "/friends?status=" + status
            );

        } catch (Exception ex) {
            throw new ServletException(
                "Unable to complete the friend action.", ex
            );
        }
    }

    // Check that IDs are positive integers.
    private int positiveId(String value) {

        if (value == null) {
            throw new IllegalArgumentException(
                "ID must be positive."
            );
        }

        try {
            int id = Integer.parseInt(value);

            if (id > 0) {
                return id;
            }

        } catch (NumberFormatException ex) {
            // Invalid ID handled below.
        }

        throw new IllegalArgumentException(
            "ID must be positive."
        );
    }
}