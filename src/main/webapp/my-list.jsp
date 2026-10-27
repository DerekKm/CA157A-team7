
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         session="false" %>
<%@ page import="java.util.List" %>
<%@ page import="samepage.Track" %>

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

    List<Track> tracks =
        (List<Track>) request.getAttribute("tracks");

    int total = tracks == null ? 0 : tracks.size();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>My List — SamePage</title>

    <link rel="stylesheet"
          href="<%= ctx %>/css/styles.css">

    <style>
        .library-main {
            padding: 65px 0 100px;
            min-height: 80vh;
        }

        .library-heading {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            margin-bottom: 35px;
        }

        .library-heading h1 {
            font-size: clamp(32px, 4vw, 48px);
            letter-spacing: -1.5px;
            margin: 8px 0;
        }

        .library-heading p:not(.sp-kicker) {
            color: var(--muted);
        }

        .library-count {
            background: var(--surface-2);
            border: 1px solid var(--border);
            color: var(--accent);
            border-radius: 25px;
            padding: 10px 18px;
            font-size: 13px;
            font-weight: 700;
            white-space: nowrap;
        }

        .library-grid {
            display: grid;
            grid-template-columns:
                repeat(auto-fill, minmax(300px, 1fr));
            gap: 22px;
        }

        .library-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 26px;
            transition: border-color 0.2s;
        }

        .library-card:hover {
            border-color: #50638b;
        }

        .library-type {
            display: inline-block;
            background: #263553;
            color: var(--accent);
            padding: 5px 11px;
            border-radius: 6px;
            font-size: 11px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 16px;
        }

        .library-card h2 {
            font-size: 23px;
            margin-bottom: 12px;
        }

        .library-status {
            font-size: 13px;
            color: var(--muted);
            padding-bottom: 20px;
            border-bottom: 1px solid var(--border);
        }

        .library-status strong {
            color: var(--text);
        }

        .library-progress-title {
            font-size: 14px;
            font-weight: 700;
            margin: 22px 0 14px;
        }

        .library-fields {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }

        .library-field label {
            display: block;
            font-size: 12px;
            color: var(--muted);
            margin-bottom: 8px;
        }

        .library-field input {
            width: 100%;
            padding: 12px;
            background: #0b1424;
            color: var(--text);
            border: 1px solid #3a4b67;
            border-radius: 9px;
            outline: none;
        }

        .library-field input:focus {
            border-color: var(--accent);
        }

        .library-save {
            width: 100%;
            margin-top: 18px;
        }

        .library-remove-form {
            margin-top: 12px;
        }

        .library-remove {
            width: 100%;
            background: transparent;
            border: 1px solid #704252;
            color: #f4a5b2;
            padding: 11px;
            border-radius: 9px;
            cursor: pointer;
            font-weight: 700;
        }

        .library-remove:hover {
            background: rgba(212, 67, 86, 0.12);
            border-color: #e38295;
        }

        .library-empty {
            text-align: center;
            padding: 70px 25px;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 16px;
        }

        .library-empty h2 {
            margin-bottom: 10px;
        }

        .library-empty p {
            color: var(--muted);
            margin-bottom: 25px;
        }

        @media (max-width: 650px) {
            .library-heading {
                align-items: flex-start;
                flex-direction: column;
            }

            .library-grid {
                grid-template-columns: 1fr;
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

    <!-- PERSONAL LIBRARY -->
    <main class="library-main">
        <div class="sp-shell">

            <div class="library-heading">
                <div>
                    <p class="sp-kicker">YOUR SAMEPAGE</p>
                    <h1>My Library.</h1>
                    <p>
                        Your stories, your progress.
                        All in one place.
                    </p>
                </div>

                <span class="library-count">
                    <%= total %> Saved <%= total == 1
                        ? "Title" : "Titles" %>
                </span>
            </div>

            <% if (total == 0) { %>

                <div class="library-empty">
                    <h2>Your library is empty.</h2>

                    <p>
                        Discover something new and
                        add it to your personal list.
                    </p>

                    <a class="sp-btn"
                       href="<%= ctx %>/media">
                        Explore Catalog
                    </a>
                </div>

            <% } else { %>

                <div class="library-grid">

                    <% for (Track track : tracks) { %>

                        <article class="library-card">

                            <span class="library-type">
                                <%= escapeHtml(
                                    track.getMediaType()) %>
                            </span>

                            <h2>
                                <%= escapeHtml(
                                    track.getTitle()) %>
                            </h2>

                            <p class="library-status">
                                <strong>Status:</strong>
                                <%= track.getStatus() == null
                                    || track.getStatus().isBlank()
                                    ? "Not set"
                                    : escapeHtml(
                                        track.getStatus()) %>
                            </p>

                            <h3 class="library-progress-title">
                                Update Progress
                            </h3>

                            <!-- UPDATE PROGRESS -->
                            <form
                                action="<%= ctx %>/tracks/update"
                                method="post">

                                <input
                                    type="hidden"
                                    name="mediaId"
                                    value="<%= track.getMediaId() %>">

                                <div class="library-fields">

                                    <div class="library-field">
                                        <label>Season</label>

                                        <input
                                            type="number"
                                            name="season"
                                            min="0"
                                            value="<%= track.getCurrentSeason() %>"
                                            required>
                                    </div>

                                    <div class="library-field">
                                        <label>Episode / Chapter</label>

                                        <input
                                            type="number"
                                            name="unit"
                                            min="0"
                                            value="<%= track.getCurrentUnit() %>"
                                            required>
                                    </div>

                                </div>

                                <button
                                    class="sp-btn library-save"
                                    type="submit">
                                    Save Progress
                                </button>
                            </form>

                            <!-- REMOVE MEDIA -->
                            <form
                                class="library-remove-form"
                                action="<%= ctx %>/tracks/remove"
                                method="post">

                                <input
                                    type="hidden"
                                    name="mediaId"
                                    value="<%= track.getMediaId() %>">

                                <button
                                    class="library-remove"
                                    type="submit">
                                    Remove from My List
                                </button>

                            </form>

                        </article>

                    <% } %>

                </div>

            <% } %>

        </div>
    </main>

    <!-- FOOTER -->
    <footer class="sp-footer">
        <div class="sp-shell sp-footer-inner">
            <span class="sp-brand">SamePage.</span>
            <span>© 2026 SamePage · CS157A Team 7</span>
        </div>
    </footer>

</body>
</html>
