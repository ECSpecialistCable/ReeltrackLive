<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.utilities.forms.multipart.MultipartRequest"%>
<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.foremans.*" %>
<%@ page import="java.io.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>
<jsp:useBean id="foremanMgr" class="com.reeltrack.foremans.ForemanMgr" scope="request"/>
<% securityMgr.init(dbResources); %>
<% foremanMgr.init(pageContext,dbResources); %>
<% CompProperties props = new CompProperties(); %>

<% 
MultipartRequest multipart = null;
String basePath = pageContext.getServletContext().getRealPath("/");
String notifier = "";
String redirect = request.getHeader("referer");
String action = "";
if(request.getParameter("submit_action") != null) {
    action = request.getParameter("submit_action");
}

Foreman contentUpload = new Foreman();

int contid = 0;
if(request.getParameter(Foreman.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(Foreman.PARAM));
} else {
    String uploadDir = basePath + contentUpload.getComponentUploadDirectory()  + "/";
    File createDir = new File(uploadDir);
    if(!createDir.exists()) {
        createDir.mkdirs();
    }
    multipart = new MultipartRequest(request,uploadDir,330240000);
    if(multipart.getParameter("submit_action")!=null) {
        action = multipart.getParameter("submit_action");
    }
    if(multipart.getParameter(Foreman.PARAM)!=null) {
        contid = Integer.parseInt(multipart.getParameter(Foreman.PARAM));
    }
}


if(action.equals("import")) {	
	int customerID = Integer.parseInt(multipart.getParameter(Foreman.CUSTOMER_ID_COLUMN));
	File excel = multipart.getFile("excel_upload");
	foremanMgr.addForemansFromExcel(customerID, excel, basePath);
    redirect = request.getContextPath() + "/trampoline/" + "foremans/search.jsp";
}

if(action.equals("create")) {
    Foreman content = new Foreman();
    content.setCustomerId(Integer.parseInt(request.getParameter(Foreman.CUSTOMER_ID_COLUMN)));
    content.setName(request.getParameter(Foreman.NAME_COLUMN));
    content.setStatus(Foreman.STATUS_ACTIVE);
    contid = foremanMgr.addForeman(content);
    redirect = request.getContextPath() + "/trampoline/" + "foremans/search.jsp";
}

if(action.equals("update")) {
    Foreman content = new Foreman();
    content.setId(contid);
    content.setName(request.getParameter(Foreman.NAME_COLUMN));
    foremanMgr.updateForeman(content);
    redirect = request.getContextPath() + "/trampoline/" + "foremans/search.jsp";
}

if(action.equals("delete")) {
    Foreman content = new Foreman();
    content.setId(contid);
    foremanMgr.deleteForeman(content, basePath);
    redirect = request.getContextPath() + "/trampoline/" + "foremans/search.jsp";
} 
%>

<% dbResources.close(); %>
<notifier:set_message text="<%= notifier %>" />		
<admin:ajax_redirect redirect="<%= redirect %>" />