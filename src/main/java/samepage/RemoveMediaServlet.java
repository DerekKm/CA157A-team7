package samepage;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/tracks/remove")
public class RemoveMediaServlet
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

        	response.sendRedirect(
        		    request.getContextPath() + "/login"
        		);
            return;
        }

        int userId =
                (Integer) session.getAttribute("user_id");

        int mediaId =
                Integer.parseInt(
                        request.getParameter("mediaId"));

        TracksDAO dao = new TracksDAO();

        dao.removeMedia(userId, mediaId);

        response.sendRedirect(
        	    request.getContextPath() + "/my-list"
        	);
    }
}