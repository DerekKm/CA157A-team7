<%@ page contentType="text/html;charset=UTF-8" %>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Friends - SamePage</title>

    <link rel="stylesheet" href="styles.css">
</head>

<body class="sp-page">

<div class="sp-shell">

    <section class="sp-section">

        <div class="sp-section-header">
            <div>
                <p class="sp-kicker">SOCIAL</p>
                <h2>Friends</h2>
                <p>Manage your friendships and requests.</p>
            </div>
        </div>

        <!-- Pending Requests -->

        <h3 style="margin-bottom:20px;">Pending Requests</h3>

        <c:choose>

            <c:when test="${empty requests}">
                <div class="sp-feature">
                    <p>No pending requests.</p>
                </div>
            </c:when>

            <c:otherwise>

                <div class="sp-feature-grid">

                    <c:forEach var="r" items="${requests}">

                        <div class="sp-feature">

                            <h3>User ${r.requesterId}</h3>

                            <p>Status: ${r.status}</p>

                            <br>

                            <form action="friend-action"
                                  method="post">

                                <input type="hidden"
                                       name="friendId"
                                       value="${r.requesterId}">

                                <button class="sp-btn sp-btn-small"
                                        type="submit"
                                        name="action"
                                        value="accept">

                                    Accept

                                </button>

                            </form>

                            <form action="friend-action"
                                  method="post"
                                  style="display:inline;">

                                <input type="hidden"
                                       name="friendId"
                                       value="${r.requesterId}">

                                <button class="sp-btn sp-btn-outline sp-btn-small"
                                        type="submit"
                                        name="action"
                                        value="reject">

                                    Reject

                                </button>

                            </form>

                        </div>

                    </c:forEach>

                </div>

            </c:otherwise>

        </c:choose>

        <br><br>

        <!-- Friends List -->

        <h3 style="margin-bottom:20px;">My Friends</h3>

        <c:choose>

            <c:when test="${empty friends}">

                <div class="sp-feature">
                    <p>You have no friends yet.</p>
                </div>

            </c:when>

            <c:otherwise>

                <div class="sp-feature-grid">

                    <c:forEach var="f"
                               items="${friends}">

                        <div class="sp-feature">

                            <h3>

                                User
                                ${f.requesterId}

                            </h3>

                            <p>
                                Friends since:
                                ${f.respondedAt}
                            </p>

                            <br>

                            <form action="friend-action"
                                  method="post">

                                <input type="hidden"
                                       name="friendId"
                                       value="${f.requesterId}">

                                <button class="sp-btn sp-btn-outline sp-btn-small"
                                        type="submit"
                                        name="action"
                                        value="remove">

                                    Remove Friend

                                </button>

                            </form>

                        </div>

                    </c:forEach>

                </div>

            </c:otherwise>

        </c:choose>

    </section>

</div>

</body>
</html>