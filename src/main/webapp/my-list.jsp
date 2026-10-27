<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="samepage.Track" %>

<html>
<head>
    <title>My List</title>
</head>
<body>

<h1>My Media List</h1>

<%
List<Track> tracks =
        (List<Track>)request.getAttribute("tracks");
%>

<table border="1">

<tr>
    <th>Title</th>
    <th>Type</th>
    <th>Status</th>
    <th>Season</th>
    <th>Unit</th>
    <th>Update</th>
    <th>Remove</th>
</tr>

<%
for(Track track : tracks) {
%>

<tr>

<td><%= track.getTitle() %></td>

<td><%= track.getMediaType() %></td>

<td><%= track.getStatus() %></td>

<td><%= track.getCurrentSeason() %></td>

<td><%= track.getCurrentUnit() %></td>

<td>

<form action="tracks/update"
      method="post">

    <input type="hidden"
           name="mediaId"
           value="<%= track.getMediaId() %>">

    <input type="number"
           name="season"
           value="<%= track.getCurrentSeason() %>">

    <input type="number"
           name="unit"
           value="<%= track.getCurrentUnit() %>">

    <button type="submit">
        Save
    </button>

</form>

</td>

<td>

<form action="tracks/remove"
      method="post">

    <input type="hidden"
           name="mediaId"
           value="<%= track.getMediaId() %>">

    <button type="submit">
        Remove
    </button>

</form>

</td>

</tr>

<%
}
%>

</table>

</body>
</html>