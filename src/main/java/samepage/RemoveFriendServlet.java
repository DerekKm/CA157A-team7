package samepage;

import java.io.IOException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/removeFriend")
public class RemoveFriendServlet
        extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        int friendId =
            Integer.parseInt(
                request.getParameter("friendId")
            );

        int userId =
            (Integer) request.getSession()
                             .getAttribute("userId");

        FriendshipDAO dao =
            new FriendshipDAO();

        dao.removeFriend(
            userId,
            friendId
        );

        response.sendRedirect("friends");
    }
}