
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         session="false" %>
<%@ page import="java.util.List" %>
<%@ page import="samepage.GroupDAO.GroupInfo" %>
<%@ page import="samepage.Media" %>
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

    GroupInfo group =
        (GroupInfo) request.getAttribute("group");
    

	String searchQuery =
	    (String) request.getAttribute("searchQuery");
	
	if (searchQuery == null) {
	    searchQuery = "";
	}
	
	boolean searching = !searchQuery.isBlank();


    List<Media> groupMedia =
        (List<Media>) request.getAttribute("groupMedia");

    List<Media> availableMedia =
        (List<Media>) request.getAttribute("availableMedia");

    boolean canEdit =
        Boolean.TRUE.equals(request.getAttribute("canEdit"));

    HttpSession activeSession = request.getSession(false);

    String csrf = (String)
        activeSession.getAttribute("groupCsrfToken");

    String status = request.getParameter("status");
    String message = null;

    if ("added".equals(status)) {
        message = "Media added successfully.";
    }
    if ("already".equals(status)) {
        message = "This media is already shared or unavailable.";
    }
    if ("removed".equals(status)) {
        message = "Media removed successfully.";
    }
    if ("missing".equals(status)) {
        message = "Media was not found in the group.";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title><%= escapeHtml(group.name()) %> — SamePage</title>

    <link rel="stylesheet"
          href="<%= ctx %>/css/styles.css">

    <style>
        .gm-main {
            min-height: 80vh;
            padding: 65px 0 100px;
        }

        .gm-back {
            display: inline-block;
            color: var(--accent);
            margin-bottom: 25px;
            font-weight: 700;
        }

        .gm-main h1 {
            font-size: 44px;
            margin-bottom: 12px;
        }

        .gm-description,
        .gm-permission {
            color: var(--muted);
            margin-bottom: 22px;
        }

        .gm-notice {
            border: 1px solid var(--accent);
            border-radius: 9px;
            padding: 14px;
            margin-bottom: 24px;
        }

        .gm-editor {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 15px;
            padding: 25px;
            margin: 25px 0 40px;
        }

        .gm-editor h2 {
            margin-bottom: 16px;
        }

        .gm-search {
            width: 100%;
            padding: 14px;
            background: var(--surface-2);
            color: var(--text);
            border: 1px solid var(--border);
            border-radius: 9px;
            font: inherit;
            margin-bottom: 15px;
        }

        .gm-count {
            color: var(--muted);
            font-size: 14px;
            margin-bottom: 12px;
        }

        .gm-search-results {
            max-height: 370px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .gm-result {
            background: var(--surface-2);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 15px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
        }

        .gm-result[hidden] {
            display: none;
        }

        .gm-result h3 {
            font-size: 16px;
            margin-bottom: 5px;
        }

        .gm-meta {
            font-size: 13px;
            color: var(--muted);
        }

        .gm-result .sp-btn {
            padding: 10px 15px;
        }

        .gm-no-results {
            color: var(--muted);
            padding: 15px 0;
        }

        .gm-grid {
            display: grid;
            grid-template-columns:
                repeat(auto-fill, minmax(260px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .gm-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 15px;
            padding: 24px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .gm-card h3 {
            font-size: 20px;
        }

        .gm-card form {
            margin-top: auto;
            padding-top: 15px;
        }

        .gm-remove {
            background: transparent;
            color: #ffb2b2;
            border: 1px solid #865252;
            border-radius: 9px;
            padding: 10px 15px;
            cursor: pointer;
            font: inherit;
        }

        .gm-empty {
            color: var(--muted);
            padding: 25px;
            border: 1px dashed var(--border);
            border-radius: 12px;
        }

        @media (max-width: 600px) {
            .gm-result {
                align-items: flex-start;
                flex-direction: column;
            }
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

    <main class="gm-main">
        <div class="sp-shell">

            <a class="gm-back"
               href="<%= ctx %>/groups">
                ← Back to My Groups
            </a>

            <p class="sp-kicker">GROUP MEDIA</p>

            <h1>
                <%= escapeHtml(group.name()) %>
            </h1>

            <p class="gm-description">
                <%= escapeHtml(group.description()) %>
            </p>

            <p class="gm-permission">
                <% if (canEdit) { %>
                    You can add and remove shared media.
                <% } else { %>
                    You can view shared media,
                    but cannot edit this group's list.
                <% } %>
            </p>

            <!-- STATUS MESSAGE -->
            <% if (message != null) { %>
                <p class="gm-notice" role="status">
                    <%= escapeHtml(message) %>
                </p>
            <% } %>

            <!-- SEARCH AND ADD MEDIA -->
            
			<% if (canEdit) { %>
			
			    <section class="gm-editor">
			
			        <h2>Add Media to This Group</h2>
			
			        <!-- SEARCH FORM -->
			        <form action="<%= ctx %>/groups" method="get">
			
			            <input type="hidden"
			                   name="groupId"
			                   value="<%= group.groupId() %>">
			
			            <input
			                class="gm-search"
			                type="search"
			                name="search"
			                maxlength="100"
			                placeholder="Search title, creator, series, or type..."
			                value="<%= escapeHtml(searchQuery) %>">
			
			            <button class="sp-btn" type="submit">
			                Search
			            </button>
			
			        </form>
			
			        <p class="gm-count" style="margin-top: 18px;">
			
			            <% if (searching) { %>
			
			                Showing up to 20 matching titles.
			                Found <%= availableMedia.size() %> results.
			
			            <% } else { %>
			
			                Showing the first 5 available titles.
			                Search to find more.
			
			            <% } %>
			
			        </p>
			
			        <!-- SEARCH RESULTS -->
			        <% if (availableMedia == null ||
			               availableMedia.isEmpty()) { %>
			
			            <p class="gm-no-results">
			
			                <% if (searching) { %>
			                    No matching media found.
			                <% } else { %>
			                    No additional media available.
			                <% } %>
			
			            </p>
			
			        <% } else { %>
			
			            <div class="gm-search-results">
			
			                <% for (Media media : availableMedia) { %>
			
			                    <div class="gm-result">
			
			                        <div>
			                            <h3>
			                                <%= escapeHtml(media.getTitle()) %>
			                            </h3>
			
			                            <p class="gm-meta">
			                                <%= escapeHtml(media.getMediaType()) %>
			                                ·
			                                <%= escapeHtml(media.getCreator()) %>
			                            </p>
			                        </div>
			
			                        <!-- ADD MEDIA -->
			                        <form action="<%= ctx %>/groups"
			                              method="post">
			
			                            <input type="hidden"
			                                   name="csrfToken"
			                                   value="<%= escapeHtml(csrf) %>">
			
			                            <input type="hidden"
			                                   name="action"
			                                   value="add">
			
			                            <input type="hidden"
			                                   name="groupId"
			                                   value="<%= group.groupId() %>">
			
			                            <input type="hidden"
			                                   name="mediaId"
			                                   value="<%= media.getMediaId() %>">
			
			                            <button class="sp-btn" type="submit">
			                                + Add
			                            </button>
			
			                        </form>
			
			                    </div>
			
			                <% } %>
			
			            </div>
			
			        <% } %>
			
			    </section>
			
			<% } %>
            

            <!-- GROUP'S SHARED MEDIA -->
            <h2>
                Shared Media (<%= groupMedia.size() %>)
            </h2>

            <% if (groupMedia.isEmpty()) { %>

                <p class="gm-empty">
                    No media has been shared with this
                    group yet.
                </p>

            <% } else { %>

                <div class="gm-grid">

                    <% for (Media media : groupMedia) { %>

                        <article class="gm-card">

                            <h3>
                                <%= escapeHtml(media.getTitle()) %>
                            </h3>

                            <p class="gm-meta">
                                <%= escapeHtml(media.getMediaType()) %>
                                ·
                                <%= escapeHtml(media.getCreator()) %>
                            </p>

                            <p class="gm-meta">
                                <%= escapeHtml(media.getDescription()) %>
                            </p>

                            <% if (canEdit) { %>

                                <form action="<%= ctx %>/groups"
                                      method="post">

                                    <input type="hidden"
                                           name="csrfToken"
                                           value="<%= escapeHtml(csrf) %>">

                                    <input type="hidden"
                                           name="action"
                                           value="remove">

                                    <input type="hidden"
                                           name="groupId"
                                           value="<%= group.groupId() %>">

                                    <input type="hidden"
                                           name="mediaId"
                                           value="<%= media.getMediaId() %>">

                                    <button class="gm-remove"
                                            type="submit">
                                        Remove from Group
                                    </button>

                                </form>

                            <% } %>

                        </article>

                    <% } %>

                </div>

            <% } %>

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
