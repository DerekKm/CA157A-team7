<!-- SamePage Home Page -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SamePage</title>

    <link rel="stylesheet" href="css/styles.css">
</head>

<body>

    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="logo">SamePage</div>

        <div class="nav-links">
            <a href="#">Home</a>
            <a href="#">Media</a>
            <a href="#">Groups</a>
            <a href="#">Log In</a>
        </div>
    </nav>


    <!-- Main Welcome Section -->
    <main>

        <section class="hero">
            <div class="hero-content">
                <p class="hero-label">WATCH. READ. STAY SYNCED.</p>

                <h1>Stay on the <span>SamePage.</span></h1>

                <p class="hero-description">
                    Track your progress, stay synced with friends,
                    and avoid spoilers along the way.
                </p>

                <div class="hero-buttons">
                    <a href="#" class="primary-button">Get Started</a>
                    <a href="#" class="secondary-button">Log In</a>
                </div>
            </div>
        </section>


        <!-- Currently Tracking -->
        <section class="tracking-section">

            <div class="section-heading">
                <p class="section-label">YOUR PROGRESS</p>
                <h2>Currently Tracking</h2>
                <p>Keep everything you're watching and reading in one place.</p>
            </div>

            <div class="tracking-grid">

                <div class="media-card">
                    <div class="media-icon">TV</div>

                    <div class="media-info">
                        <p class="media-type">TV SERIES</p>
                        <h3>Show #1</h3>
                        <p>Episode 28</p>

                        <div class="progress-bar">
                            <div class="progress progress-one"></div>
                        </div>

                        <span>70% complete</span>
                    </div>
                </div>


                <div class="media-card">
                    <div class="media-icon">TV</div>

                    <div class="media-info">
                        <p class="media-type">TV SERIES</p>
                        <h3>Show #2</h3>
                        <p>Episode 17</p>

                        <div class="progress-bar">
                            <div class="progress progress-two"></div>
                        </div>

                        <span>55% complete</span>
                    </div>
                </div>


                <div class="media-card">
                    <div class="media-icon">BOOK</div>

                    <div class="media-info">
                        <p class="media-type">BOOK</p>
                        <h3>Book #1</h3>
                        <p>Chapter 94</p>

                        <div class="progress-bar">
                            <div class="progress progress-three"></div>
                        </div>

                        <span>82% complete</span>
                    </div>
                </div>

            </div>
        </section>


        <!-- Features -->
        <section class="features">

            <div class="section-heading">
                <p class="section-label">WHY SAMEPAGE?</p>
                <h2>Everything you need to stay together.</h2>
            </div>

            <div class="feature-grid">

                <div class="feature-card">
                    <div class="feature-number">01</div>
                    <h3>Track Progress</h3>
                    <p>
                        Track episodes, chapters, movies, and books
                        so you always know where you left off.
                    </p>
                </div>

                <div class="feature-card">
                    <div class="feature-number">02</div>
                    <h3>Stay Together</h3>
                    <p>
                        See where your friends currently are in a series
                        and keep your group on the same page.
                    </p>
                </div>

                <div class="feature-card">
                    <div class="feature-number">03</div>
                    <h3>Avoid Spoilers</h3>
                    <p>
                        Keep discussions hidden beyond your current
                        progress so nothing gets spoiled.
                    </p>
                </div>

            </div>
        </section>


        <!-- Bottom Call to Action -->
        <section class="cta">
            <p>READY TO START?</p>
            <h2>Watching together just got easier.</h2>
            <a href="#" class="primary-button">Get Started</a>
        </section>

    </main>


    <!-- Footer -->
    <footer>
        <div class="footer-logo">SamePage</div>
        <p>&copy; 2026 Team 7</p>
    </footer>

</body>

</html>