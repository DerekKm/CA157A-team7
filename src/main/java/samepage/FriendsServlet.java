package samepage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.Connection;

import java.io.IOException;

@WebServlet("/friends")
public class FriendsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId =
            (Integer) request.getSession()
                             .getAttribute("userId");

        FriendshipDAO dao =
            new FriendshipDAO(
            );

        request.setAttribute(
            "friends",
            dao.getFriends(userId)
        );

        request.setAttribute(
            "requests",
            dao.getPendingRequests(userId)
        );

        request.getRequestDispatcher(
            "friends.jsp"
        ).forward(request, response);
    }
}