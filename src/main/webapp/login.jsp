
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         session="false" %>

<%
    String ctx = request.getContextPath();

    boolean loginFailed =
        request.getAttribute("loginError") != null;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Log In — SamePage</title>

    <link rel="stylesheet"
          href="<%= ctx %>/css/styles.css">
</head>

<body class="sp-page">

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
            </nav>

        </div>
    </header>

    <main class="sp-auth-layout">

        <section class="sp-auth-intro">
            <p class="sp-kicker">WELCOME BACK</p>

            <h1>
                Pick up right<br>
                <span>where you left off.</span>
            </h1>

            <p>
                Your stories, your progress, your library.
                Log in to keep everything organized
                in one place.
            </p>

            <div class="sp-auth-quote">
                Discover freely.
                Track personally.
                Stay on the SamePage.
            </div>
        </section>

        <section class="sp-auth-card">

            <div class="sp-auth-top">
                <div class="sp-brand-mark">S</div>

                <h2>Welcome back</h2>

                <p>
                    Enter your account information
                    to continue.
                </p>
            </div>

            <% if (loginFailed) { %>

                <div class="sp-alert" role="alert">
                    Incorrect username or password.
                    Please try again.
                </div>

            <% } %>

            <form action="<%= ctx %>/login"
                  method="post"
                  class="sp-login-form">

                <label for="username">
                    Username
                </label>

                <input
                    type="text"
                    id="username"
                    name="username"
                    placeholder="Enter your username"
                    maxlength="45"
                    autocomplete="username"
                    required>

                <label for="password">
                    Password
                </label>

                <input
                    type="password"
                    id="password"
                    name="password"
                    placeholder="Enter your password"
                    autocomplete="current-password"
                    required>

                <button class="sp-btn sp-login-submit"
                        type="submit">
                    Log In
                </button>

            </form>

            <div class="sp-auth-bottom">
                <p>
                    Just looking around?
                    <a href="<%= ctx %>/media">
                        Browse the catalog
                    </a>
                </p>
            </div>

        </section>
    </main>

    <footer class="sp-footer">
        <div class="sp-shell sp-footer-inner">
            <span class="sp-brand">SamePage.</span>
            <span>© 2026 SamePage · CS157A Team 7</span>
        </div>
    </footer>

</body>
</html>
