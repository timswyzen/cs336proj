<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>
ul.h {
	list-style-type: none;
	margin: 0;
	padding: 0;
	overflow: hidden;
	background-color: #333;
	font: 15px verdana, sans-serif;
}

li.h {
	float: left;
}

li a.h {
	display: block;
	color: white;
	text-align: center;
	padding: 14px 16px;
	text-decoration: none;
}

/* Change the link color to #111 (black) on hover */
li a:hover.h {
	background-color: #111;
}

.active {
	background-color: #4CAF50;
	display: block;
	color: white;
	text-align: center;
	padding: 14px 16px;
	text-decoration: none;
}

.active:hover {
	background-color: #3d8b40;
}

.user {
	list-style-type: none;
	margin: 0;
	padding: 0;
	overflow: hidden;
	background-color: #333;
	font: 15px verdana, sans-serif;
	display: block;
	color: white;
	text-align: center;
	padding: 14px 16px;
	text-decoration: none;
}

body {
	font: normal 13px Arial, sans-serif;
}

.user-table {
    border: solid 1px #4CAF50;
    border-collapse: collapse;
    border-spacing: 0;
}
.user-table thead th {
    background-color: #4CAF50;
    border: solid 1px #4CAF50;
    color: white;
    padding: 10px;
    text-align: left;
    text-shadow: 1px 1px 1px #2E6A30;
}
.user-table tbody td {
    border: solid 1px #4CAF50;
    color: #333;
    padding: 10px;
    text-shadow: 1px 1px 1px #fff;
}



</style>
<meta charset="ISO-8859-1">
</head>
<body style="background-color: #f7f7f7">
	<ul class="h">
		<li class="h"><a href="search.jsp" class="h">Home</a></li>
		<li class="h"><a href="controlpanel.jsp" class="h">Control
				Panel</a></li>
		<li style="float: right" class="h"><a class="active"
			href="logout.jsp">Log out</a></li>
			<li class="user" style = "float: right">USER: <%=session.getAttribute("username")%></li>
	</ul>
</body>
</html>