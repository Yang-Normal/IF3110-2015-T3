<%@ page language="java" contentType="text/html; charset=ISO-8859-1"  pageEncoding="ISO-8859-1"%>
<%@page import= "java.net.URL,javax.xml.namespace.QName,javax.xml.ws.Service" %>
<%@ page import="com.yangnormal.sstackex.*" %>
<%
	int uid = -999;
	if (request.getParameter("id")!=null) {
		URL url = new URL("http://localhost:8082/ws/stackexchange?wsdl");
		QName qname = new QName("http://ws.sstackex.yangnormal.com/", "WebServiceImplService");
		WebServiceImplService webService = new WebServiceImplService(url, qname);
		WebServiceInterface ws = webService.getWebServiceImplPort();
		int id = Integer.parseInt(request.getParameter("id"));
		Question q = ws.getQuestion(id);
		AnswerArray answerList = ws.getAnswerList(id);
		String token = request.getParameter("token");
		Cookie[] cookies = request.getCookies();
		for (int i=0;i<cookies.length;i++){
			if (cookies[i].getName().equals("token")){
				token = cookies[i].getValue();
			}
		}
		if (token != null){
			uid = ws.getUid(token);
		}

%>
<!DOCTYPE HTML>

	<html>
	<head>

		<title><% out.println(q.getTopic());%></title>
		<link href="https://fonts.googleapis.com/css?family=Raleway" rel="stylesheet" type="text/css">
		<link rel="stylesheet" type="text/css" href="css/style.css">
		</head>
		<body>
			<div class="container">
				<a class="homelink" href="index.jsp"><h1 id="title">My StackExchange</h1></a>
				<div class="content">
					<h2><% out.println(q.getTopic());%></h2>
					<hr>
					<div class="stackquestion">
						<div class="votes"><a href="vote.jsp?type=0&spin=1&id=<%out.println(id);%>"><div class="arrow-up" onclick=""></div></a><div id="votequestion"><% out.println(q.getVote());%></div><a href="vote.jsp?type=0&spin=-1&id=<%out.println(id);%>"><div class="arrow-down"  onclick=""></div></a></div>
						<div class="content"><% out.println(q.getContent());%></div>
						<% System.out.println(q.getUser().getId()); %>
						<%if (uid == q.getUser().getId()){%>
						<div class="detail">asked by <% out.println(q.getUser().getName()); %> <a class="linkname"></a> at <% out.println(q.getDate());%> | <a class="linkedit" href="editpost.jsp?id=<%out.println(q.getId());%>">edit</a> | <a class="linkdelete" onclick="" href="deletequestion.jsp?id=<%out.println(q.getId());%>">delete</a></div>
						<%} else {%>
						<div class="detail">asked by <% out.println(q.getUser().getName()); %> <a class="linkname"></a> at <% out.println(q.getDate());%></div>
						<%}%>
					</div>
					<br>
					<h2><% out.println(answerList.getItem().size());%> Answers</h2>
					<hr>
				<%
					for (Answer answer : answerList.getItem()) {
				%>
					<div class="stackanswer">
						<br>
						<div class="votes"><a href="vote.jsp?type=1&spin=1&id=<%out.println(answer.getId());%>"><div class="arrow-up" onclick=""></div></a><div id="voteanswer"><% out.println(answer.getVote()); %></div><a href="vote.jsp?type=1&spin=-1&id=<%out.println(answer.getId());%>"><div class="arrow-down" onclick=""></div></a></div>
						<div class="content"><% out.println(answer.getContent()); %></div>
						<div class="detail">answered by <% out.println(answer.getUser().getName()); %><a class="linkname"></a> at <% out.println(answer.getDate()); %> </div>
					</div>
					<br>
					<hr>
					<% } %>
				</div>
				<div class="content question">
					<h2 class="title2">Your Answer</h2>
					<hr>
					<form action="postanswer.jsp" method="post" onsubmit="">
					<textarea class="textarea", name="content", id="content" placeholder="Content" ></textarea>
					<br>
					<input type="hidden" id="id" name="id" value=<%out.println(id);%>>
					<input type="submit" id="post" value="Post">
					</form>	
				</div>
			</div>
			<script src="js/script.js"></script>
		</body>
	</html>

<%
	} else {
		response.sendRedirect("index.jsp");
	}
%>