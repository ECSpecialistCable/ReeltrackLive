<%@page import="com.monumental.trampoline.utilities.forms.multipart.MultipartRequest"%>
<%@page import="java.io.File"%>
<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.file_cabinets.FileCabinet"%>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>
<jsp:useBean id="cabinetMgr" class="com.reeltrack.file_cabinets.FileCabinetMgr" scope="request"/>
<% securityMgr.init(dbResources); %>
<% cabinetMgr.init(pageContext,dbResources); %>
<% CompProperties props = new CompProperties(); %>

<% 
String basePath = pageContext.getServletContext().getRealPath("/");
String notifier = "";
String redirect = request.getHeader("referer");
String action = "";
MultipartRequest multipart = null;
FileCabinet content = new FileCabinet();

if(request.getParameter("submit_action") != null) {
    action = request.getParameter("submit_action");
}

int contid = 0;
if(request.getParameter(FileCabinet.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(FileCabinet.PARAM));
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
		if(multipart.getParameter(FileCabinet.PARAM)!=null) {
			contid = Integer.parseInt(multipart.getParameter(FileCabinet.PARAM));
		}
	}
}


if(action.equals("create")) {
    content = new FileCabinet();
    content.setCustomerId(0);
    content.setTitle(multipart.getParameter(FileCabinet.TITLE_COLUMN));
    content.setStatus(FileCabinet.STATUS_ACTIVE);
    File file = multipart.getFile(FileCabinet.FILE_NAME_COLUMN);
	if(file!=null && !content.getTitle().equals("")) {
		int fileId = cabinetMgr.addFileCabinet(content, file, basePath);
	}

	//redirect = request.getContextPath() + "/trampoline/" + "users/edit.jsp?" + RTUser.PARAM + "=" + contid;
    redirect = request.getContextPath() + "/trampoline/" + "file_cabinets/search.jsp";
}

if(action.equals("create_customer")) {
    content = new FileCabinet();
    content.setCustomerId(Integer.parseInt(multipart.getParameter(FileCabinet.CUSTOMER_ID_COLUMN)));
    content.setTitle(multipart.getParameter(FileCabinet.TITLE_COLUMN));
    content.setStatus(FileCabinet.STATUS_ACTIVE);
    File file = multipart.getFile(FileCabinet.FILE_NAME_COLUMN);
	if(file!=null && !content.getTitle().equals("")) {
		int fileId = cabinetMgr.addFileCabinet(content, file, basePath);
	}

	//redirect = request.getContextPath() + "/trampoline/" + "users/edit.jsp?" + RTUser.PARAM + "=" + contid;
    redirect = request.getContextPath() + "/trampoline/" + "file_cabinets/customer.jsp";
}
%>
<% dbResources.close(); %>
<notifier:set_message text="<%= notifier %>" />		
<admin:ajax_redirect redirect="<%= redirect %>" />