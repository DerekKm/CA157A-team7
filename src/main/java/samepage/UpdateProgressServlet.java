package samepage;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;

public class UpdateProgressServlet
        extends HttpServlet {

    @Override
    protected void doPost(
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

        int mediaId =
                Integer.parseInt(
                        request.getParameter("mediaId"));

        int season =
                Integer.parseInt(
                        request.getParameter("season"));

        int unit =
                Integer.parseInt(
                        request.getParameter("unit"));

        TracksDAO dao = new TracksDAO();

        dao.updateProgress(
                userId,
                mediaId,
                season,
                unit);

        response.sendRedirect("my-list");
    }
}