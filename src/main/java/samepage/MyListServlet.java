package samepage;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

public class MyListServlet extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
                session.getAttribute("user_id") == null) {

            response.sendRedirect("login");
            return;
        }

        int userId =
                (Integer) session.getAttribute("user_id");

        TracksDAO dao = new TracksDAO();

        List<Track> tracks =
                dao.getUserMedia(userId);

        request.setAttribute("tracks", tracks);

        request.getRequestDispatcher(
                "/my-list.jsp")
                .forward(request, response);
    }
}