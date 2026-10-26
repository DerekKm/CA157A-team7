<%@ page import="java.util.List" %>
<%@ page import="samepage.Media" %>

<%
    List<Media> mediaList =
        (List<Media>) request.getAttribute("mediaList");

    String searchText =
        (String) request.getAttribute("searchText");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Media Catalog - SamePage</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f4f4f4;
        }

        h1 {
            color: #333;
        }

        .search-form {
            margin-bottom: 30px;
        }

        .search-form input {
            padding: 10px;
            width: 300px;
            font-size: 16px;
        }

        .search-form button,
        .add-button {
            padding: 10px 16px;
            background-color: #333;
            color: white;
            border: none;
            cursor: pointer;
        }

        .media-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .media-card {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
        }

        .media-card h2 {
            margin-top: 0;
            color: #222;
        }

        .media-card p {
            color: #555;
        }

        .add-button {
            margin-top: 10px;
        }
    </style>
</head>

<body>

    <h1>SamePage Media Catalog</h1>

    <form class="search-form"
          method="get"
          action="<%= request.getContextPath() %>/media">

        <input
            type="text"
            name="q"
            placeholder="Search by title"
            value="<%= searchText == null ? "" : searchText %>">

        <button type="submit">Search</button>
    </form>

    <div class="media-container">

        <%
            if (mediaList != null && !mediaList.isEmpty()) {
                for (Media media : mediaList) {
        %>

            <div class="media-card">
                <h2><%= media.getTitle() %></h2>

                <p>
                    <strong>Type:</strong>
                    <%= media.getMediaType() %>
                </p>

                <p>
                    <strong>Creator:</strong>
                    <%= media.getCreator() %>
                </p>

                <p>
                    <strong>Release Year:</strong>
                    <%= media.getReleaseYear() %>
                </p>

                <p>
                    <strong>Description:</strong>
                    <%= media.getDescription() %>
                </p>

                <p>
                    <strong>Total Seasons:</strong>
                    <%= media.getTotalSeasons() %>
                </p>

                <form method="post"
                      action="<%= request.getContextPath() %>/tracks/add">

                    <input
                        type="hidden"
                        name="mediaId"
                        value="<%= media.getMediaId() %>">

                    <button class="add-button" type="submit">
                        Add to My List
                    </button>
                </form>
            </div>

        <%
                }
            } else {
        %>

            <p>No media found.</p>

        <%
            }
        %>

    </div>

</body>
</html>