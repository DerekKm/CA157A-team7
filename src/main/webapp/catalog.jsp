
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         session="false" %>
<%@ page import="java.util.List" %>
<%@ page import="samepage.Media" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%!
    // Escape text before inserting it into HTML.
    private String escapeHtml(Object value) {
        if (value == null) return "";

        return String.valueOf(value)
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
    }
%>

<%
    String ctx = request.getContextPath();

    List<Media> mediaList =
        (List<Media>) request.getAttribute("mediaList");

    String searchText =
        (String) request.getAttribute("searchText");

    HttpSession activeSession = request.getSession(false);

    boolean loggedIn =
        activeSession != null &&
        activeSession.getAttribute("user_id") instanceof Integer;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Browse Media — SamePage</title>

    <!-- Reuse the homepage CSS -->
    <link rel="stylesheet"
          href="<%= ctx %>/css/styles.css">

    <!-- Catalog-specific styling -->
    <style>
        .catalog-main {
            padding: 65px 0 100px;
            min-height: 80vh;
        }

        .catalog-heading {
            margin-bottom: 30px;
        }

        .catalog-heading h1 {
            font-size: clamp(32px, 4vw, 48px);
            letter-spacing: -1.5px;
            margin: 8px 0;
        }

        .catalog-heading p:not(.sp-kicker) {
            color: var(--muted);
        }

        .catalog-search {
            display: flex;
            gap: 10px;
            max-width: 650px;
            margin-bottom: 40px;
        }

        .catalog-search input {
            flex: 1;
            min-width: 0;
            padding: 14px 18px;
            background: var(--surface);
            color: var(--text);
            border: 1px solid var(--border);
            border-radius: 10px;
            outline: none;
        }

        .catalog-search input:focus {
            border-color: var(--accent);
        }

        .catalog-search button {
            background: var(--accent);
            color: #091120;
            border: none;
            border-radius: 10px;
            padding: 12px 24px;
            font-weight: 700;
            cursor: pointer;
        }

        .catalog-results-heading {
            font-size: 20px;
            margin-bottom: 20px;
        }

        .media-container {
            display: grid;
            grid-template-columns:
                repeat(auto-fill, minmax(255px, 1fr));
            gap: 20px;
        }

        .media-card {
            display: flex;
            flex-direction: column;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 15px;
            padding: 24px;
            transition: transform 0.2s,
                        border-color 0.2s;
        }

        .media-card:hover {
            transform: translateY(-4px);
            border-color: #50638b;
        }

        .media-card h2 {
            color: var(--text);
            font-size: 21px;
            margin-bottom: 14px;
        }

        .media-card p {
            color: var(--muted);
            font-size: 13px;
            margin-bottom: 9px;
            line-height: 1.5;
        }

        .media-card strong {
            color: #dae3f5;
        }

        .media-type {
            display: inline-block;
            align-self: flex-start;
            padding: 5px 10px;
            background: #263553;
            color: var(--accent);
            border-radius: 6px;
            font-size: 11px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 16px;
        }

        .media-description {
            flex: 1;
            padding-top: 10px;
        }

        .add-button {
            background: var(--accent);
            color: #091120;
            border: none;
            border-radius: 9px;
            padding: 12px 16px;
            font-weight: 700;
            cursor: pointer;
            margin-top: 18px;
            width: 100%;
        }

        .add-button:hover {
            background: #acc2ff;
        }

        .login-to-add {
            display: block;
            text-align: center;
            background: transparent;
            color: var(--accent) !important;
            border: 1px solid var(--accent);
            border-radius: 9px;
            padding: 11px;
            font-size: 13px;
            font-weight: 700;
            margin-top: 18px;
        }

        .empty-results {
            color: var(--muted);
            background: var(--surface);
            border: 1px solid var(--border);
            padding: 30px;
            border-radius: 12px;
        }

        @media (max-width: 600px) {
            .catalog-search {
                flex-direction: column;
            }
        }
    </style>
</head>

<body class="sp-page">

    <!-- SAMEPAGE NAVIGATION -->
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
                <a href="<%= ctx %>/index.jsp#featured">
                    Featured
                </a>
            </nav>

            <div class="sp-account">

                <% if (loggedIn) { %>

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

                <% } else { %>

                    <a class="sp-login-link"
                       href="<%= ctx %>/login">
                        Log In
                    </a>

                    <a class="sp-btn sp-btn-small"
                       href="<%= ctx %>/login">
                        Get Started
                    </a>

                <% } %>

            </div>
        </div>
    </header>

    <!-- CATALOG -->
    <main class="catalog-main">
        <div class="sp-shell">

            <div class="catalog-heading">
                <p class="sp-kicker">DISCOVER MEDIA</p>

                <h1>Explore the catalog.</h1>

                <p>
                    Find your next favorite story.
                    Search shows, anime, films, and books.
                </p>
            </div>

            <!-- SEARCH -->
            <form class="catalog-search"
                  method="get"
                  action="<%= ctx %>/media">

                <input
                    type="search"
                    name="q"
                    placeholder="Search by title..."
                    value="<%= escapeHtml(searchText) %>"
                    aria-label="Search media">

                <button type="submit">
                    Search
                </button>
            </form>

            <h2 class="catalog-results-heading">
                <%= searchText != null &&
                    !searchText.isBlank()
                    ? "Search Results"
                    : "Browse All Media" %>
            </h2>

            <!-- DATABASE RESULTS -->
            <div class="media-container">

                <%
                    if (mediaList != null &&
                        !mediaList.isEmpty()) {

                        for (Media media : mediaList) {
                %>

                    <article class="media-card">

                        <span class="media-type">
                            <%= escapeHtml(
                                media.getMediaType()) %>
                        </span>

                        <h2>
                            <%= escapeHtml(
                                media.getTitle()) %>
                        </h2>

                        <p>
                            <strong>Creator:</strong>
                            <%= escapeHtml(
                                media.getCreator()) %>
                        </p>

                        <p>
                            <strong>Release Year:</strong>
                            <%= escapeHtml(
                                media.getReleaseYear()) %>
                        </p>

                        <p>
                            <strong>Total Seasons:</strong>
                            <%= media.getTotalSeasons() %>
                        </p>

                        <p class="media-description">
                            <%= escapeHtml(
                                media.getDescription()) %>
                        </p>

                        <% if (loggedIn) { %>

                            <form method="post"
                                  action="<%= ctx %>/tracks/add">

                                <input
                                    type="hidden"
                                    name="mediaId"
                                    value="<%= media.getMediaId() %>">

                                <button class="add-button"
                                        type="submit">
                                    + Add to My List
                                </button>
                            </form>

                        <% } else { %>

                            <a class="login-to-add"
                               href="<%= ctx %>/login">
                                Log In to Add
                            </a>

                        <% } %>

                    </article>

                <%
                        }
                    }
                %>

            </div>

            <% if (mediaList == null ||
                   mediaList.isEmpty()) { %>

                <div class="empty-results">
                    No media found. Try another search.
                </div>

            <% } %>

        </div>
    </main>

    <!-- FOOTER -->
    <footer class="sp-footer">
        <div class="sp-shell sp-footer-inner">

            <span class="sp-brand">SamePage.</span>

            <span>
                © 2026 SamePage · CS157A Team 7
            </span>

        </div>
    </footer>

</body>
</html>
