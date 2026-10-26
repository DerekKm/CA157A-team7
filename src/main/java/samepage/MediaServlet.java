package samepage;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/media")
public class MediaServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private MediaDAO mediaDAO;

    @Override
    public void init() {
        mediaDAO = new MediaDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String searchText = request.getParameter("q");

        try {
            List<Media> mediaList = mediaDAO.searchMedia(searchText);

            request.setAttribute("mediaList", mediaList);
            request.setAttribute("searchText", searchText);

            RequestDispatcher dispatcher =
                    request.getRequestDispatcher("/catalog.jsp");

            dispatcher.forward(request, response);

        } catch (Exception exception) {
            throw new ServletException(
                    "Unable to load media catalog.",
                    exception
            );
        }
    }
}