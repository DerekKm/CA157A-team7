<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%@ page import="java.util.List" %>
<%@ page import="samepage.Friendship" %>
<%@ page import="samepage.FriendshipDAO.UserSearchResult" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>
<%
    String ctx = request.getContextPath();
    HttpSession activeSession = request.getSession(false);
    if (activeSession == null || !(activeSession.getAttribute("user_id") instanceof Integer)) {
        response.sendRedirect(ctx + "/login");
        return;
    }
    String csrf = (String) activeSession.getAttribute("friendsCsrfToken");
    String search = (String) request.getAttribute("search");
    if (search == null) search = "";

    List<Friendship> friends = (List<Friendship>) request.getAttribute("friends");
    List<Friendship> requests = (List<Friendship>) request.getAttribute("requests");
    List<Friendship> outgoing = (List<Friendship>) request.getAttribute("outgoing");
    List<UserSearchResult> searchResults =
            (List<UserSearchResult>) request.getAttribute("searchResults");

    String status = request.getParameter("status");
    String message = null;
    if ("sent".equals(status)) message = "Friend request sent.";
    if ("notSent".equals(status)) message = "Request could not be sent. You may already be connected.";
    if ("accepted".equals(status)) message = "Friend request accepted.";
    if ("notAccepted".equals(status)) message = "That request is no longer pending.";
    if ("rejected".equals(status)) message = "Friend request declined.";
    if ("notRejected".equals(status)) message = "That request is no longer pending.";
    if ("removed".equals(status)) message = "Friend removed.";
    if ("notRemoved".equals(status)) message = "That friendship was already removed.";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Friends — SamePage</title>
    <link rel="stylesheet" href="<%= ctx %>/css/styles.css">
</head>
<body class="sp-page">
    <header class="sp-header">
        <div class="sp-shell sp-nav">
            <a class="sp-brand" href="<%= ctx %>/index.jsp">
                <span class="sp-brand-mark">S</span>SamePage<span class="sp-brand-dot">.</span>
            </a>
            <nav class="sp-links">
                <a href="<%= ctx %>/index.jsp">Home</a>
                <a href="<%= ctx %>/media">Browse</a>
                <a href="<%= ctx %>/groups">Groups</a>
                <a href="<%= ctx %>/friends" aria-current="page">Friends</a>
            </nav>
            <div class="sp-account">
                <a class="sp-btn sp-btn-outline" href="<%= ctx %>/my-list">My List</a>
                <form action="<%= ctx %>/logout" method="post">
                    <button class="sp-btn sp-btn-small" type="submit">Log Out</button>
                </form>
            </div>
        </div>
    </header>

    <main class="sp-friends-page">
        <div class="sp-shell">
            <div class="sp-friends-header">
                <p class="sp-kicker">YOUR COMMUNITY</p>
                <h1>Friends.</h1>
                <p>Search for people, review requests, and manage your connections.</p>
            </div>

            <% if (message != null) { %>
                <p class="sp-friends-notice" role="status"><%= escapeHtml(message) %></p>
            <% } %>

            <section class="sp-friends-section" aria-labelledby="findFriendsHeading">
                <h2 id="findFriendsHeading">Find People</h2>
                <form class="sp-friends-search" action="<%= ctx %>/friends" method="get">
                    <input type="search" name="search" maxlength="45"
                           placeholder="Search by username or display name..."
                           value="<%= escapeHtml(search) %>" aria-label="Search users">
                    <button class="sp-btn" type="submit">Search</button>
                </form>
                <% if (!search.isBlank()) { %>
                    <% if (searchResults == null || searchResults.isEmpty()) { %>
                        <p class="sp-empty">No available users matched your search.</p>
                    <% } else { %>
                        <div class="sp-friends-grid">
                            <% for (UserSearchResult person : searchResults) { %>
                                <article class="sp-friend-card">
                                    <div class="sp-friend-info">
                                        <span class="sp-friend-name"><%= escapeHtml(person.username()) %></span>
                                        <% if (person.displayName() != null && !person.displayName().isBlank()) { %>
                                            <span class="sp-friend-meta"><%= escapeHtml(person.displayName()) %></span>
                                        <% } %>
                                    </div>
                                    <form action="<%= ctx %>/sendFriendRequest" method="post">
                                        <input type="hidden" name="csrfToken" value="<%= escapeHtml(csrf) %>">
                                        <input type="hidden" name="friendId" value="<%= person.userId() %>">
                                        <button class="sp-btn sp-btn-small" type="submit">Send Request</button>
                                    </form>
                                </article>
                            <% } %>
                        </div>
                    <% } %>
                <% } else { %>
                    <p class="sp-friends-hint">Type a name and press Search. Up to 10 users will appear.</p>
                <% } %>
            </section>

            <section class="sp-friends-section" aria-labelledby="pendingHeading">
                <h2 id="pendingHeading">Incoming Requests (<%= requests.size() %>)</h2>
                <% if (requests.isEmpty()) { %>
                    <p class="sp-empty">No pending friend requests.</p>
                <% } else { %>
                    <div class="sp-friends-grid">
                        <% for (Friendship f : requests) { %>
                            <article class="sp-friend-card">
                                <div class="sp-friend-info">
                                    <span class="sp-friend-name"><%= escapeHtml(f.getUsername()) %></span>
                                    <span class="sp-friend-meta">Wants to connect with you</span>
                                </div>
                                <div class="sp-friend-actions">
                                    <form action="<%= ctx %>/acceptFriendRequest" method="post">
                                        <input type="hidden" name="csrfToken" value="<%= escapeHtml(csrf) %>">
                                        <input type="hidden" name="requesterId" value="<%= f.getRequesterId() %>">
                                        <button class="sp-btn sp-btn-small sp-btn-success" type="submit">Accept</button>
                                    </form>
                                    <form action="<%= ctx %>/rejectFriendRequest" method="post">
                                        <input type="hidden" name="csrfToken" value="<%= escapeHtml(csrf) %>">
                                        <input type="hidden" name="requesterId" value="<%= f.getRequesterId() %>">
                                        <button class="sp-btn sp-btn-small sp-btn-outline" type="submit">Decline</button>
                                    </form>
                                </div>
                            </article>
                        <% } %>
                    </div>
                <% } %>
            </section>

            <section class="sp-friends-section" aria-labelledby="friendsHeading">
                <h2 id="friendsHeading">My Friends (<%= friends.size() %>)</h2>
                <% if (friends.isEmpty()) { %>
                    <p class="sp-empty">You haven't added any friends yet.</p>
                <% } else { %>
                    <div class="sp-friends-grid">
                        <% for (Friendship f : friends) {
                            int currentUserId = (Integer) activeSession.getAttribute("user_id");
                            int otherId = f.getRequesterId() == currentUserId
                                    ? f.getAddresseeId() : f.getRequesterId();
                        %>
                            <article class="sp-friend-card">
                                <div class="sp-friend-info">
                                    <span class="sp-friend-name"><%= escapeHtml(f.getUsername()) %></span>
                                    <% if (f.getRespondedAt() != null) { %>
                                        <span class="sp-friend-meta">Friends since <%= f.getRespondedAt().toLocalDateTime().toLocalDate() %></span>
                                    <% } %>
                                </div>
                                <form action="<%= ctx %>/removeFriend" method="post">
                                    <input type="hidden" name="csrfToken" value="<%= escapeHtml(csrf) %>">
                                    <input type="hidden" name="friendId" value="<%= otherId %>">
                                    <button class="sp-btn sp-btn-small sp-btn-outline" type="submit">Remove</button>
                                </form>
                            </article>
                        <% } %>
                    </div>
                <% } %>
            </section>

            <section class="sp-friends-section" aria-labelledby="sentHeading">
                <h2 id="sentHeading">Sent Requests (<%= outgoing.size() %>)</h2>
                <% if (outgoing.isEmpty()) { %>
                    <p class="sp-empty">No outgoing requests awaiting a response.</p>
                <% } else { %>
                    <div class="sp-friends-grid">
                        <% for (Friendship f : outgoing) { %>
                            <article class="sp-friend-card">
                                <div class="sp-friend-info">
                                    <span class="sp-friend-name"><%= escapeHtml(f.getUsername()) %></span>
                                    <span class="sp-friend-meta">Waiting for a response</span>
                                </div>
                                <span class="sp-friends-pill">Pending</span>
                            </article>
                        <% } %>
                    </div>
                <% } %>
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
