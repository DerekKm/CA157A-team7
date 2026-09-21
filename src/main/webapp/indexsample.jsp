<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import = "samepage.DatabaseCon" %>

<!--  follows the same code structure from class 3 tier architecture examples -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SamePage</title> <!-- title of page -->
</head>
<body>
	<h1>SamePage</h1> 
    <p>Three-tier architecture test</p>
	<!--  simply checks if it can connect to mysql server on our computers -->
	<%
	    try (Connection con = DatabaseCon.getConnection()) {
	        out.println("Database Connected");
	    } catch (Exception e) {
	        out.println("Database Not Connected");
	        System.out.println(e.getMessage());
	    }
	%>
</body>
</html>