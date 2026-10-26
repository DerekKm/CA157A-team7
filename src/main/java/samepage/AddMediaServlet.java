package samepage;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/tracks/add")
public class AddMediaServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // User is not logged in
        if (session == null ||
            session.getAttribute("user_id") == null) {

            response.sendRedirect(
                request.getContextPath() + "/login"
            );
            return;
        }

        try {
            int userId = (Integer) session.getAttribute("user_id");
            int mediaId = Integer.parseInt(
                request.getParameter("mediaId")
            );

            TracksDAO tracksDAO = new TracksDAO();
            tracksDAO.addMedia(userId, mediaId);

            response.sendRedirect(
                request.getContextPath() + "/my-list"
            );

        } catch (Exception exception) {
            throw new ServletException(
                "Unable to add media to the user's list.",
                exception
            );
        }
    }
}