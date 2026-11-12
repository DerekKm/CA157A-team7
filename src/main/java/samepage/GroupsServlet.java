package samepage;

import java.io.IOException;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/groups")
public class GroupsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final GroupDAO dao = new GroupDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
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

        int userId = (Integer) session.getAttribute("user_id");

        // Create a form token for this session.
        if (session.getAttribute("groupCsrfToken") == null) {
            session.setAttribute(
                "groupCsrfToken",
                UUID.randomUUID().toString()
            );
        }

        String idText = request.getParameter("groupId");

        try {
            // No group ID: show the user's groups.
            if (idText == null || idText.isBlank()) {

                request.setAttribute(
                    "groups",
                    dao.getGroupsForUser(userId)
                );

                request.getRequestDispatcher("/groups.jsp")
                       .forward(request, response);
                return;
            }

            // Group ID provided: show its shared media.
            int groupId = positiveId(idText);

            GroupDAO.GroupInfo group =
                dao.getGroupForUser(userId, groupId);

            if (group == null) {
                response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Group not found or access denied."
                );
                return;
            }

            boolean canEdit =
                dao.canEditGroupMedia(userId, groupId);

            request.setAttribute("group", group);
            request.setAttribute("canEdit", canEdit);

            request.setAttribute(
                "groupMedia",
                dao.getGroupMedia(groupId)
            );
            

			if (canEdit) {
			
			    String searchQuery = request.getParameter("search");
			
			    if (searchQuery == null) {
			        searchQuery = "";
			    }
			
			    searchQuery = searchQuery.trim();
			
			    if (searchQuery.length() > 100) {
			        searchQuery = searchQuery.substring(0, 100);
			    }
			
			    request.setAttribute("searchQuery", searchQuery);
			
			    request.setAttribute(
			        "availableMedia",
			        dao.getAvailableMedia(groupId, searchQuery)
			    );
			}


            request.getRequestDispatcher("/group-media.jsp")
                   .forward(request, response);

        } catch (IllegalArgumentException ex) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid group ID."
            );

        } catch (Exception ex) {

            throw new ServletException(
                "Unable to load groups.", ex
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null ||
                !(session.getAttribute("user_id")
                    instanceof Integer)) {

            response.sendRedirect(
                request.getContextPath() + "/login"
            );
            return;
        }

        String expectedToken =
            (String) session.getAttribute("groupCsrfToken");

        String submittedToken =
            request.getParameter("csrfToken");

        if (expectedToken == null ||
                !expectedToken.equals(submittedToken)) {

            response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Invalid form token."
            );
            return;
        }

        int userId =
            (Integer) session.getAttribute("user_id");

        String action = request.getParameter("action");

        try {
            // Create a new group.
            if ("create".equals(action)) {

                String name = request.getParameter("name");
                String description =
                    request.getParameter("description");

                name = name == null ? "" : name.trim();
                description = description == null
                    ? "" : description.trim();

                if (name.isEmpty() ||
                        name.length() > 45 ||
                        description.length() > 200) {

                    response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid group name or description."
                    );
                    return;
                }

                int groupId = dao.createGroup(
                    userId, name, description
                );

                response.sendRedirect(
                    request.getContextPath() +
                    "/groups?groupId=" + groupId
                );
                return;
            }

            // Only add and remove are valid here.
            if (!"add".equals(action) &&
                    !"remove".equals(action)) {

                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Unknown action."
                );
                return;
            }

            int groupId = positiveId(
                request.getParameter("groupId")
            );

            int mediaId = positiveId(
                request.getParameter("mediaId")
            );

            // Verify that this group is visible to the user.
            if (dao.getGroupForUser(userId, groupId) == null) {

                response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Group not found."
                );
                return;
            }

            // Only authorized users can change group media.
            if (!dao.canEditGroupMedia(userId, groupId)) {

                response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "You cannot edit this group's media."
                );
                return;
            }

            boolean changed;

            if ("add".equals(action)) {
                changed = dao.addMedia(
                    userId, groupId, mediaId
                );
            } else {
                changed = dao.removeMedia(
                    userId, groupId, mediaId
                );
            }

            String status;

            if ("add".equals(action)) {
                status = changed ? "added" : "already";
            } else {
                status = changed ? "removed" : "missing";
            }

            response.sendRedirect(
                request.getContextPath() +
                "/groups?groupId=" + groupId +
                "&status=" + status
            );

        } catch (IllegalArgumentException ex) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid ID."
            );

        } catch (Exception ex) {

            throw new ServletException(
                "Unable to change group media.", ex
            );
        }
    }

    // Check that IDs are positive integers.
    private int positiveId(String value) {

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
