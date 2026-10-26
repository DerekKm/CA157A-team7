
package samepage;

import java.io.IOException;
import java.util.Arrays;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session != null &&
                session.getAttribute("user_id") instanceof Integer) {

            response.sendRedirect(
                request.getContextPath() + "/index.jsp"
            );
            return;
        }

        request.getRequestDispatcher("/login.jsp")
            .forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String entered = request.getParameter("password");

        if (username == null || entered == null ||
                username.isBlank() ||
                username.length() > 45 ||
                entered.length() > 1024) {

            showError(request, response);
            return;
        }

        char[] password = entered.toCharArray();

        try {
            UserDAO.UserAccount account =
                userDAO.findByUsername(username.trim());

            if (account == null ||
                    !PasswordUtil.verifyPassword(
                        password, account.passwordHash())) {

                showError(request, response);
                return;
            }

            // Replace any previous session after login.
            HttpSession oldSession =
                request.getSession(false);

            if (oldSession != null) {
                oldSession.invalidate();
            }

            HttpSession session = request.getSession(true);

            session.setAttribute(
                "user_id", account.userId()
            );

            session.setAttribute(
                "username", account.username()
            );

            // Session expires after 30 minutes of inactivity.
            session.setMaxInactiveInterval(30 * 60);

            response.sendRedirect(
                request.getContextPath() + "/index.jsp"
            );

        } catch (Exception e) {
            throw new ServletException(
                "Login failed due to a server error.", e
            );
        } finally {
            Arrays.fill(password, '\0');
        }
    }

    private void showError(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute(
            "loginError", "Incorrect username or password."
        );

        request.getRequestDispatcher("/login.jsp")
            .forward(request, response);
    }
}
