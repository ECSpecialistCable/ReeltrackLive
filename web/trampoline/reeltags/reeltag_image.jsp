<%@ page language="java" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.reeltrack.utilities.HtmlToImageWriter"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% reelMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<%
String basePath = pageContext.getServletContext().getRealPath("/");

// Get the id
int contid = 0;
if(request.getParameter(Reel.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(Reel.PARAM));
} else {
    String param = "content_id_for_tabset";
    if(request.getParameter(param) != null) {
        contid = Integer.parseInt(request.getParameter(param));
    }
}

// Get the piece of content
Reel content = new Reel();
content.setId(contid);
reelMgr.generateQrCode(content);
content = (Reel)reelMgr.getReel(content);
CompEntities circuits = reelMgr.getReelCircuits(content);
CableTechData techData = reelMgr.getCableTechData(content);

SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy");
String dateString = df.format(new Date());

String tempURL; //var for url expression
HtmlToImageWriter writer = new HtmlToImageWriter(pageContext, dbResources);
writer.writeImage("http://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/trampoline/reeltags/reeltag.jsp?" + Reel.PARAM + "="+ content.getId(), basePath, content.getCompEntityDirectory()+"/");


%>
<% dbResources.close(); %>

<html>
<head>
<style type="text/css">

table {
	width: 800px;
	height: 400px;
	border: 1px solid;
	margin-bottom: 5px;
}

td {
	padding: 5px;
}

</style>
</head>
<body>
		
<% tempURL = "http://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + content.getCompEntityDirectory() + "/qr_img_generated.png" ; %>
<img src="<%= tempURL %>" />

</body>
</html>