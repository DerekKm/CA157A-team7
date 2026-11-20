<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         session="false" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="samepage.Friendship" %>

<%!
    // Escape text before inserting it into HTML.
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }

    // Turn the redirect status into a message for the user.
    private String statusMessage(String status) {
        if (status == null) return "";

        switch (status) {
            case "sent":
                return "Friend request sent.";
            case "exists":
                return "That request was not sent. You are already "
                     + "connected, or a request is already open.";
            case "self":
                return "You cannot send a request to yourself.";
            case "accepted":
                return "Friend request accepted.";
            case "rejected":
                return "Friend request declined.";
            case "removed":
                return "Friend removed.";
            case "missing":
                return "That request or friendship is no longer "
                     + "available.";
            case "invalid":
                return "That user id is not valid.";
            default:
                return "";
        }
    }
%>

<%
    String ctx = request.getContextPath();

    Integer currentUserId =
        (Integer) request.getAttribute("currentUserId");

    List<Friendship> friends =
        (List<Friendship>) request.getAttribute("friends");

    List<Friendship> requests =
        (List<Friendship>) request.getAttribute("requests");

    if (friends == null) {
        friends = new ArrayList<Friendship>();
    }

    if (requests == null) {
        requests = new ArrayList<Friendship>();
    }

    String message = statusMessage(
        (String) request.getAttribute("friendStatus"));
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Friends — SamePage</title>

    <link rel="stylesheet"
          href="<%= ctx %>/css/styles.css">
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

    <main class="sp-friends-page">

        <div class="sp-shell">

            <!-- PAGE HEADER -->
            <div class="sp-friends-header">

                <div class="sp-eyebrow">
                    SOCIAL
                </div>

                <h1>Friends</h1>

                <p>
                    Send requests, respond to other people, and keep
                    track of who you are reading and watching with.
                </p>

                <% if (currentUserId != null) { %>
                    <p class="sp-friend-meta">
                        You are signed in as User #<%= currentUserId %>.
                        Use a user id below to send a request.
                    </p>
                <% } %>

            </div>

            <% if (!message.isEmpty()) { %>
                <div class="sp-alert"><%= escapeHtml(message) %></div>
            <% } %>

            <!-- SEND A REQUEST -->
            <section class="sp-friends-section">

                <h2>Send a Friend Request</h2>

                <form class="sp-login-form"
                      action="<%= ctx %>/sendFriendRequest"
                      method="post">

                    <label for="friendId">
                        User ID
                    </label>

                    <input id="friendId"
                           type="number"
                           name="friendId"
                           min="1"
                           max="2147483647"
                           required>

                    <button class="sp-btn"
                            type="submit">
                        Send Request
                    </button>

                </form>

            </section>

            <!-- PENDING REQUESTS -->
            <section class="sp-friends-section">

                <h2>Pending Requests</h2>

                <% if (requests.isEmpty()) { %>

                    <div class="sp-empty">
                        No pending requests.
                    </div>

                <% } else { %>

                    <div class="sp-friends-grid">

                        <% for (Friendship r : requests) { %>

                            <% int requesterId = r.getRequesterId(); %>

                            <article class="sp-friend-card">

                                <div class="sp-friend-info">

                                    <span class="sp-friend-name">
                                        User #<%= requesterId %>
                                    </span>

                                    <span class="sp-friend-meta">
                                        Requested <%= r.getRequestedAt() %>
                                    </span>

                                </div>

                                <div class="sp-friend-actions">

                                    <form action="<%= ctx %>/acceptFriendRequest"
                                          method="post">

                                        <input type="hidden"
                                               name="friendId"
                                               value="<%= requesterId %>">

                                        <button class="sp-btn sp-btn-small sp-btn-success"
                                                type="submit">
                                            Accept
                                        </button>

                                    </form>

                                    <form action="<%= ctx %>/rejectFriendRequest"
                                          method="post">

                                        <input type="hidden"
                                               name="friendId"
                                               value="<%= requesterId %>">

                                        <button class="sp-btn sp-btn-small sp-btn-danger"
                                                type="submit">
                                            Decline
                                        </button>

                                    </form>

                                </div>

                            </article>

                        <% } %>

                    </div>

                <% } %>

            </section>

            <!-- FRIENDS -->
            <section class="sp-friends-section">

                <h2>My Friends</h2>

                <% if (friends.isEmpty()) { %>

                    <div class="sp-empty">
                        You have no friends yet.
                    </div>

                <% } else { %>

                    <div class="sp-friends-grid">

                        <% for (Friendship f : friends) { %>

                            <% int friendId =
                                   (f.getRequesterId() == currentUserId)
                                   ? f.getAddresseeId()
                                   : f.getRequesterId(); %>

                            <article class="sp-friend-card">

                                <div class="sp-friend-info">

                                    <span class="sp-friend-name">
                                        User #<%= friendId %>
                                    </span>

                                    <span class="sp-friend-meta">
                                        Friends since <%= f.getRespondedAt() %>
                                    </span>

                                </div>

                                <div class="sp-friend-actions">

                                    <form action="<%= ctx %>/removeFriend"
                                          method="post">

                                        <input type="hidden"
                                               name="friendId"
                                               value="<%= friendId %>">

                                        <button class="sp-btn sp-btn-small sp-btn-danger"
                                                type="submit">
                                            Remove
                                        </button>

                                    </form>

                                </div>

                            </article>

                        <% } %>

                    </div>

                <% } %>

            </section>

        </div>
    </main>

    <!-- FOOTER -->
    <footer class="sp-footer">

        <div class="sp-shell sp-footer-inner">

            <span class="sp-brand">
                SamePage.
            </span>

            <span>
                © 2026 SamePage · CS157A Team 7
            </span>

        </div>

    </footer>

</body>
</html>
