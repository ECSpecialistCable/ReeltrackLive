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
String pageToGet = "http://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/trampoline/reeltags/reeltag.jsp?" + Reel.PARAM + "="+ content.getId();
boolean isRotate = true;
int width= 630;
int height= 330;
HtmlToImageWriter writer = new HtmlToImageWriter();
writer.init(pageContext, dbResources);
String[] tagFileNames = writer.writeImage(content, pageToGet, basePath, content.getReelTagDirectory() + "/", isRotate, width, height);

//HTMLToPdfToImageWriter writer = new HTMLToPdfToImageWriter(pageContext, dbResources);
//writer.writeImage("http://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/trampoline/reeltags/reeltag.jsp?" + Reel.PARAM + "="+ content.getId(),basePath, content.getCompEntityDirectory()+"/");

%>
<% dbResources.close(); %>

<html>
<head></head>
<body>

<% tempURL = "http://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + content.getReelTagDirectory() + "/"; %>
<!--<img alt="reeltag image" src="<%= tempURL %>" />-->
<script>
	window.location='<%= tempURL %><%= tagFileNames[0] %>';
    <% if(tagFileNames.length>1) { %>
        window.open('<%= tempURL %><%= tagFileNames[1] %>', '_blank');
    <% } %>
    <% if(tagFileNames.length>2) { %>
        window.open('<%= tempURL %><%= tagFileNames[2] %>', '_blank');
    <% } %>
    
    //window.blur();
    //window.focus();
</script>

</body>
</html>