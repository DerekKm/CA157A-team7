package samepage;

import java.io.IOException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;



@WebServlet("/acceptFriendRequest")
public class AcceptFriendRequestServlet
        extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        int requesterId =
            Integer.parseInt(
                request.getParameter("requesterId")
            );

        int myId =
            (Integer) request.getSession()
                             .getAttribute("userId");

        FriendshipDAO dao =
            new FriendshipDAO();

        dao.acceptRequest(
            requesterId,
            myId
        );

        response.sendRedirect("friends");
    }
}