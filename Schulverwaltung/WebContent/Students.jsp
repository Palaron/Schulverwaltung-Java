<%@page import="org.apache.catalina.Session"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@page import="Database.*" %>
    <%@page import="model.*" %>
    <%@page import="java.util.*" %>
    <%@page import="Elements.*" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Schülerverwaltung</title>
    <link rel="stylesheet" href="Styles/Themes/redmond/jquery-ui.css" />
    <script src="Scripts/jquery.js"></script>
    <script src="Scripts/jquery-ui.js"></script>
    <link rel="stylesheet" href="/resources/demos/style.css" />
    <script language="javascript" type="text/javascript" src="Scripts/Ajax.js"></script>
<script language="javascript" type="text/javascript" src="Scripts/Students.js"></script>
<link href="Styles/Default.css" rel="stylesheet" type="text/css"/>
</head>
<body>
<div id="dialog" title="Schüler" style="display: none; height: 100%; width: 100%">
   <iframe id="dialogTarget" style="height: 100%; width: 100%; border: none;"></iframe>
</div>
<% 
		try
		{
			LoginBean curLogin = (LoginBean)request.getSession().getAttribute("Login");
			curLogin.DoLogin();
			if(curLogin.getState() != LoginState.LoggedIn)
			{
				out.write("<script language='javascript' type='text/javascript'>document.location = 'Start.jsp';</script>"); 
			}
		}
		catch(Exception ex)
		{
			out.write(ex.getMessage());
			out.write("<script language='javascript' type='text/javascript'>document.location = 'Start.jsp';</script>");
		}
		String filter = request.getParameter("Filter") != null ? request.getParameter("Filter") : "";
		Boolean showDisabled = request.getParameter("ShowDisabled") != null ? 
							   Boolean.parseBoolean(request.getParameter("ShowDisabled")) : 
							   false;
%>
<form method="post" action="StudentServlet">
<input type="hidden" id="SortKey" name="SortKey" />
<center>
	<table>
		<tr>
			<td align="center">
				<img src="Images/logo.jpg" />
			</td>
		</tr>
		<tr>
			<td align="center">
				<div>
					<table>
						<tr>
							<td class="MenuItem"><a href="main.jsp">Start</a></td>
							<td class="SelectedMenuItem"><a href="Students.jsp">Schüler</a></td>
						</tr>
					</table>
				</div>
			</td>
		</tr>
		<tr>
			<td align="center" style="background: lightBlue; width: 100%; height: 400px">
				<div style="background: lightBlue; width: 100%;">
					<table style="width: 100%;">
						<tr>
							<td align="Left" >
								<label>Suchbegriff: </label>
							</td>
							<td align="Left">
								<input style="width: 300px" type="text" name="Filter" value="<%= filter %>"/>
							</td>
							<td align="Left"><input type="submit" value="Suchen"/></td>
							<td align="Left" valign="bottom"><input type="checkbox" id="ShowDisabled" name="ShowDisabled" value="true" <% if(showDisabled) out.write("checked=\"true\""); %>/></td>
							<td align="Left" valign="middle" style="width: 100%;">
								<label for="ShowDisabled"><nobr>Ausgeblendete anzeigen</nobr></label>
							</td>
							
							<td align="Right" >
								<input type="button" value="Neu" id="btnNew"/>
							</td>
							<td align="Right" >
								<input type="button" value="Löschen" id="btnDelete" onClick="deleteStudents();"/>
							</td>
						</tr>
					</table>
				</div>
				<br/>
				<div style="background: lightBlue; width: 100%; height: 100%; overflow: auto">
					<%
						LinkedList<Student> students = (LinkedList<Student>)request.getAttribute("Students");
						/* LinkedList<Student> students = new LinkedList();
						students.add(new Student().setId(2));*/
						out.write("	<table class=\"DetailList\" border=1>\n");
						out.write("		<thead style=\"background-color: white\">");
						out.write("			<tr>");
						out.write("				<td class=\"DetailHeader\">&nbsp;</td>");
						out.write("				<td class=\"DetailHeader\" onclick=\"SetSortKey(0)\">Id</td>");
						out.write("				<td class=\"DetailHeader\" onclick=\"SetSortKey(1)\">Vorname</td>");
						out.write("				<td class=\"DetailHeader\" onclick=\"SetSortKey(2)\">Nachname</td>");
						out.write("				<td class=\"DetailHeader\">&nbsp; </td>");
						out.write("			</tr>");
						out.write("		</thead>");
						out.write("		<tbody>");
						if(students.size() > 0)
						{
							for(Student student:students)
							{
								out.write("		<tr class=\"DetailEntry\" id=\"" + student.getId() + "\">\n");
								out.write("			<td style=\"width: 50px\"><input type=\"checkbox\" onclick=\"checkDeleteEnty(this);\"/></td>\n");
								out.write("			<td style=\"width: 100px\" onclick=\"openDetails=true;\">" + student.getId() + "</td>\n");
								out.write("			<td onclick=\"openDetails=true;\">" + student.getFirstname() + "</td>\n");
								out.write("			<td onclick=\"openDetails=true;\">" + student.getName() + "</td>\n");
								out.write("			<td style=\"width: 100%\" onclick=\"openDetails=true;\">&nbsp;</td>\n");
								out.write("		</tr>\n");
							}
						}
						out.write("		</tbody>");
						out.write("</table>\n");
					%>
				</div>
			</td>
		</tr>
	</table>
</form>
</center>
</body>
</html>