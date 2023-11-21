<%@page import="com.monumental.trampoline.utilities.forms.multipart.MultipartRequest"%>
<%@page import="java.io.File"%>
<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*"%>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" />
<% securityMgr.init(dbResources); %>
<% reelMgr.init(pageContext,dbResources); %>
<% CompProperties props = new CompProperties(); %>

<% 
String basePath = pageContext.getServletContext().getRealPath("/");
String notifier = "";
String redirect = request.getHeader("referer");
String action = "";
MultipartRequest multipart = null;
Reel content = new Reel();

if(request.getParameter("submit_action") != null) {
    action = request.getParameter("submit_action");
}

int contid = 0;
if(request.getParameter(Reel.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(Reel.PARAM));
} else {
	if(action == null || action.equals("")) {
		String uploadDir = basePath + content.getComponentUploadDirectory()  + "/";
		File createDir = new File(uploadDir);
		if(!createDir.exists()) {
			createDir.mkdirs();
		}
		multipart = new MultipartRequest(request,uploadDir,104857600);
		if(multipart.getParameter("submit_action")!=null) {
			action = multipart.getParameter("submit_action");
		}
		if(multipart.getParameter(Reel.PARAM)!=null) {
			contid = Integer.parseInt(multipart.getParameter(Reel.PARAM));
		}
	}
}

if(action.equals("import")) {
    String jobCode = multipart.getParameter(Reel.JOB_CODE_COLUMN);
    File file = multipart.getFile("circuit_file");
    reelMgr.importCircuitsFromExcel(jobCode, file, basePath);
    redirect = request.getContextPath() + "/trampoline/" + "import_circuits/search.jsp";
}

%>
<% dbResources.close(); %>
<notifier:set_message text="<%= notifier %>" />		
<admin:ajax_redirect redirect="<%= redirect %>" />