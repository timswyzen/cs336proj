<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="ISO-8859-1">
<title>Travelio</title>
<style>

h5 {
	color: light-gray;
}

div {
	margin: auto;
	width: 50%;
	border: 3px solid white;
	padding: 10px;
	text-align: center;
}

body {
	background: linear-gradient(-45deg, #207561, #589167, #a0cc78);
	background-size: 400% 400%;
	animation: gradientBG 12s ease infinite;
	color: white;
	text-align: center;
		font: 15px verdana, sans-serif;
}

@
keyframes gradientBG { 0% {
	background-position: 0% 50%;
}
50%
{
background-position
:
 
100%
50%;
}
100%
{
background-position
:
 
0%
50%;
}
}
</style>
</head>
<body>
	<%
		if (session.getAttribute("username") != null) {
			String site = new String("search.jsp");
			response.setStatus(response.SC_MOVED_TEMPORARILY);
			response.setHeader("Location", site);
		}
	%>
	<h1>Travelio</h1>
	<h5>Created By: Tim Swyzen, Elaine Zheng, Clarissa Hwang, and
		Melanie Wong</h5>
		<h5>01:198:3636 Fall 2019</h5>
	
	<div>
		<form action="login.jsp" method="post">
			<table>
				<tr>
					<td>Username:</td>
					<td><input name="username" type="text" /></td>
				</tr>
				<tr>
					<td>Password:</td>
					<td><input name="password" type="text" /></td>
				</tr>
				<tr>
					<td><input type="submit" value="Log in" name="login" /></td>
					<td><input type="submit" value="Register" name="register"></td>
				</tr>

			</table>
		</form>
	</div>
</body>
</html>