<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         session="false" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    String ctx = request.getContextPath();

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

    <title>SamePage — Your Stories, Your Progress</title>

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
                <a href="#featured">Featured</a>
                <a href="#how-it-works">About</a>
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

    <main>

        <!-- HERO -->
        <section class="sp-hero">
            <div class="sp-shell sp-hero-grid">

                <div class="sp-hero-copy">

                    <div class="sp-eyebrow">
                        ONE PLACE FOR EVERY STORY
                    </div>

                    <h1>
                        Great stories.<br>
                        <span>Better together.</span>
                    </h1>

                    <p class="sp-lead">
                        Discover what to watch or read next.
                        Build your personal library, track
                        your progress, and stay on the
                        SamePage with friends.
                    </p>

                    <!-- PUBLIC SEARCH BAR -->
                    <form class="sp-search"
                          action="<%= ctx %>/media"
                          method="get">

                        <input type="search"
                               name="q"
                               placeholder="Search shows, anime, films, books..."
                               aria-label="Search media">

                        <button type="submit">
                            Search
                        </button>

                    </form>

                    <!-- HERO BUTTONS -->
                    <div class="sp-hero-actions">

                        <a class="sp-btn"
                           href="<%= ctx %>/media">
                            Explore Catalog
                        </a>

                        <% if (loggedIn) { %>

                            <a class="sp-btn sp-btn-outline"
                               href="<%= ctx %>/my-list">
                                View My List
                            </a>

                        <% } else { %>

                            <a class="sp-btn sp-btn-outline"
                               href="<%= ctx %>/login">
                                Start Tracking
                            </a>

                        <% } %>

                    </div>

                    <!-- ONLY SHOW THIS TO GUESTS -->
                    <% if (!loggedIn) { %>

                        <p class="sp-hero-note">
                            Browse freely. Sign in when you're
                            ready to save your progress.
                        </p>

                    <% } %>

                </div>

                <!-- DISCOVERY PREVIEW -->
                <div class="sp-preview">

                    <div class="sp-preview-heading">
                        <div>
                            <span class="sp-mini-label">
                                DISCOVER
                            </span>
                            <h2>Your next obsession</h2>
                        </div>

                        <span class="sp-live-dot"></span>
                    </div>

                    <a class="sp-preview-item"
                       href="<%= ctx %>/media?q=Star+Odyssey">

                        <div class="sp-mini-cover sp-cover-space">
                            SO
                        </div>

                        <div>
                            <strong>Star Odyssey</strong>
                            <span>Series · Sci-Fi · 2022</span>
                        </div>

                        <span class="sp-item-arrow">›</span>
                    </a>

                    <a class="sp-preview-item"
                       href="<%= ctx %>/media?q=Blade+Spirits">

                        <div class="sp-mini-cover sp-cover-blade">
                            BS
                        </div>

                        <div>
                            <strong>Blade Spirits</strong>
                            <span>Anime · Fantasy · 2021</span>
                        </div>

                        <span class="sp-item-arrow">›</span>
                    </a>

                    <a class="sp-preview-item"
                       href="<%= ctx %>/media?q=Kingdom+of+Ash">

                        <div class="sp-mini-cover sp-cover-ash">
                            KA
                        </div>

                        <div>
                            <strong>Kingdom of Ash</strong>
                            <span>Series · Drama · 2020</span>
                        </div>

                        <span class="sp-item-arrow">›</span>
                    </a>

                    <div class="sp-preview-bottom">
                        Your watchlist starts with one story.
                    </div>

                </div>

            </div>
        </section>

        <!-- FEATURED MEDIA -->
        <section id="featured" class="sp-section">
            <div class="sp-shell">

                <div class="sp-section-header">

                    <div>
                        <p class="sp-kicker">
                            EXPLORE THE CATALOG
                        </p>

                        <h2>Featured stories</h2>

                        <p>
                            A little inspiration for your
                            next watch or read.
                        </p>
                    </div>

                    <a class="sp-text-link"
                       href="<%= ctx %>/media">
                        View all media →
                    </a>

                </div>

                <div class="sp-featured-grid">

                    <!-- STAR ODYSSEY -->
                    <a class="sp-featured-card"
                       href="<%= ctx %>/media?q=Star+Odyssey">

                        <div class="sp-featured-cover sp-cover-space">
                            <span>SCI-FI</span>
                            <b>SO</b>
                        </div>

                        <div class="sp-card-detail">
                            <h3>Star Odyssey</h3>
                            <p>Series · 2022</p>
                        </div>

                    </a>

                    <!-- BLADE SPIRITS -->
                    <a class="sp-featured-card"
                       href="<%= ctx %>/media?q=Blade+Spirits">

                        <div class="sp-featured-cover sp-cover-blade">
                            <span>ANIME</span>
                            <b>BS</b>
                        </div>

                        <div class="sp-card-detail">
                            <h3>Blade Spirits</h3>
                            <p>Anime · 2021</p>
                        </div>

                    </a>

                    <!-- KINGDOM OF ASH -->
                    <a class="sp-featured-card"
                       href="<%= ctx %>/media?q=Kingdom+of+Ash">

                        <div class="sp-featured-cover sp-cover-ash">
                            <span>FANTASY</span>
                            <b>KA</b>
                        </div>

                        <div class="sp-card-detail">
                            <h3>Kingdom of Ash</h3>
                            <p>Series · 2020</p>
                        </div>

                    </a>

                    <!-- NIGHTFALL -->
                    <a class="sp-featured-card"
                       href="<%= ctx %>/media?q=Nightfall">

                        <div class="sp-featured-cover sp-cover-night">
                            <span>HORROR</span>
                            <b>NF</b>
                        </div>

                        <div class="sp-card-detail">
                            <h3>Nightfall</h3>
                            <p>Series · 2022</p>
                        </div>

                    </a>

                </div>
            </div>
        </section>

        <!-- DYNAMIC SECTION:
             DIFFERENT FOR GUESTS AND LOGGED-IN USERS -->

        <section id="how-it-works"
                 class="sp-section sp-section-muted">

            <div class="sp-shell">

                <% if (loggedIn) { %>

                    <!-- LOGGED-IN HOMEPAGE -->

                    <div class="sp-section-header">
                        <div>
                            <p class="sp-kicker">
                                YOUR SAMEPAGE
                            </p>

                            <h2>
                                Pick up where you left off.
                            </h2>

                            <p>
                                Your library, your progress,
                                all in one place.
                            </p>
                        </div>
                    </div>

                    <div class="sp-feature-grid">

                        <!-- EXPLORE -->
                        <a class="sp-feature sp-feature-link"
                           href="<%= ctx %>/media">

                            <span class="sp-feature-number">
                                01
                            </span>

                            <h3>Continue Exploring →</h3>

                            <p>
                                Find your next favorite show,
                                anime, movie, or book.
                            </p>

                        </a>

                        <!-- PERSONAL LIBRARY -->
                        <a class="sp-feature sp-feature-link"
                           href="<%= ctx %>/my-list">

                            <span class="sp-feature-number">
                                02
                            </span>

                            <h3>My Library →</h3>

                            <p>
                                View all the stories you've
                                added to your personal list.
                            </p>

                        </a>

                        <!-- PROGRESS -->
                        <a class="sp-feature sp-feature-link"
                           href="<%= ctx %>/my-list">

                            <span class="sp-feature-number">
                                03
                            </span>

                            <h3>Update Progress →</h3>

                            <p>
                                Update the episode, season,
                                or chapter you're currently on.
                            </p>

                        </a>

                    </div>

                <% } else { %>

                    <!-- PUBLIC HOMEPAGE -->

                    <div class="sp-section-header">
                        <div>
                            <p class="sp-kicker">
                                WHY SAMEPAGE?
                            </p>

                            <h2>
                                Everything in one place.
                            </h2>

                            <p>
                                From discovery to your final
                                episode, keep track of it all.
                            </p>
                        </div>
                    </div>

                    <div class="sp-feature-grid">

                        <div class="sp-feature">

                            <span class="sp-feature-number">
                                01
                            </span>

                            <h3>Discover</h3>

                            <p>
                                Browse series, anime, movies,
                                and books in one catalog.
                            </p>

                        </div>

                        <div class="sp-feature">

                            <span class="sp-feature-number">
                                02
                            </span>

                            <h3>Track</h3>

                            <p>
                                Save media to your own list
                                and update your progress.
                            </p>

                        </div>

                        <div class="sp-feature">

                            <span class="sp-feature-number">
                                03
                            </span>

                            <h3>Connect</h3>

                            <p>
                                Share your journey with groups
                                and stay in sync with friends.
                            </p>

                        </div>

                    </div>

                <% } %>

            </div>

        </section>

        <!-- FINAL CALL TO ACTION -->
        <section class="sp-cta">
            <div class="sp-shell sp-cta-inner">

                <div>
                    <p class="sp-kicker">
                        YOUR NEXT CHAPTER
                    </p>

                    <h2>
                        Every story starts somewhere.
                    </h2>

                    <p>
                        Browse the catalog or sign in
                        to start your personal library.
                    </p>
                </div>

                <a class="sp-btn"
                   href="<%= ctx %><%= loggedIn ? "/my-list" : "/login" %>">

                    <%= loggedIn
                        ? "Go to My List"
                        : "Get Started" %>

                </a>

            </div>
        </section>

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
