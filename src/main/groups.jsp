
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         session="false" %>
<%@ page import="java.util.List" %>
<%@ page import="samepage.GroupDAO.GroupInfo" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    String ctx = request.getContextPath();
    List<GroupInfo> groups =
        (List<GroupInfo>) request.getAttribute("groups");

    HttpSession activeSession = request.getSession(false);
    String csrf = (String)
        activeSession.getAttribute("groupCsrfToken");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>My Groups — SamePage</title>

    <link rel="stylesheet"
          href="<%= ctx %>/css/styles.css">

    <style>
        .group-main {
            min-height: 80vh;
            padding: 65px 0 100px;
        }

        .group-main h1 {
            font-size: 44px;
            margin-bottom: 12px;
        }

        .group-intro {
            color: var(--muted);
            margin-bottom: 35px;
        }

        .group-grid {
            display: grid;
            grid-template-columns:
                repeat(auto-fill, minmax(260px, 1fr));
            gap: 20px;
        }

        .group-card,
        .group-create {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 15px;
            padding: 25px;
        }

        .group-card h2 {
            font-size: 21px;
            margin-bottom: 10px;
        }

        .group-card p {
            color: var(--muted);
            margin-bottom: 16px;
        }

        .group-card a {
            color: var(--accent);
            font-weight: 700;
        }

        .group-create {
            margin-top: 40px;
            max-width: 700px;
        }

        .group-create h2 {
            margin-bottom: 12px;
        }

        .group-create label {
            display: block;
            margin: 16px 0 7px;
        }

        .group-create input,
        .group-create textarea {
            width: 100%;
            padding: 12px;
            background: var(--surface-2);
            color: var(--text);
            border: 1px solid var(--border);
            border-radius: 9px;
            font: inherit;
        }

        .group-create textarea {
            min-height: 90px;
            resize: vertical;
        }

        .group-create button {
            margin-top: 18px;
        }

        .group-empty {
            padding: 25px;
            color: var(--muted);
            border: 1px dashed var(--border);
            border-radius: 12px;
        }
    </style>
</head>

<body class="sp-page">

    <!-- NAVIGATION -->
    <header class="sp-header">
        <div class="sp-shell sp-nav">

            <a class="sp-brand"
               href="<%= ctx %>/index.jsp">
                <span class="sp-brand-mark">S</span>
                SamePage<span class="sp-brand-dot">.</span>
            </a>

            <nav class="sp-links">
                <a href="<%= ctx %>/index.jsp">Home</a>
                <a href="<%= ctx %>/media">Browse</a>
                <a href="<%= ctx %>/groups">Groups</a>
                <a href="<%= ctx %>/friends">Friends</a>
            </nav>

            <!-- TOP-RIGHT ACCOUNT BUTTONS -->
            <div class="sp-account">

                <a class="sp-btn sp-btn-outline"
                   href="<%= ctx %>/my-list">
                    My List
                </a>

                <form action="<%= ctx %>/logout"
                      method="post">
                    <button class="sp-btn sp-btn-small"
                            type="submit">
                        Log Out
                    </button>
                </form>

            </div>

        </div>
    </header>

    <!-- GROUPS PAGE -->
    <main class="group-main">
        <div class="sp-shell">

            <p class="sp-kicker">SHARED STORIES</p>
            <h1>My Groups.</h1>

            <p class="group-intro">
                Manage your groups and explore shared media.
            </p>

            <!-- EXISTING GROUPS -->
            <% if (groups == null || groups.isEmpty()) { %>

                <p class="group-empty">
                    You are not part of any groups yet.
                    Create your first group below.
                </p>

            <% } else { %>

                <div class="group-grid">

                    <% for (GroupInfo group : groups) { %>

                        <article class="group-card">

                            <h2>
                                <%= escapeHtml(group.name()) %>
                            </h2>

                            <p>
                                <%= escapeHtml(group.description()) %>
                            </p>

                            <a href="<%= ctx %>/groups?groupId=<%= group.groupId() %>">
                                View Shared Media
                            </a>

                        </article>

                    <% } %>

                </div>

            <% } %>

            <!-- CREATE GROUP -->
            <section class="group-create">

                <h2>Create a New Group</h2>

                <p>
                    Create a group to share shows,
                    movies, anime, and books.
                </p>

                <form action="<%= ctx %>/groups"
                      method="post">

                    <input type="hidden"
                           name="csrfToken"
                           value="<%= escapeHtml(csrf) %>">

                    <input type="hidden"
                           name="action"
                           value="create">

                    <label for="groupName">
                        Group Name
                    </label>

                    <input id="groupName"
                           type="text"
                           name="name"
                           maxlength="45"
                           required>

                    <label for="groupDescription">
                        Description
                    </label>

                    <textarea id="groupDescription"
                              name="description"
                              maxlength="200"></textarea>

                    <button class="sp-btn"
                            type="submit">
                        Create Group
                    </button>

                </form>

            </section>

        </div>
    </main>

    <footer class="sp-footer">
        <div class="sp-shell sp-footer-inner">
            <span class="sp-brand">SamePage.</span>
            <span>© 2026 SamePage · CS157A Team 7</span>
        </div>
    </footer>

</body>
</html>
