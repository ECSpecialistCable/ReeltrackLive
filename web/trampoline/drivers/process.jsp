<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.utilities.forms.multipart.MultipartRequest"%>
<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.drivers.*" %>
<%@ page import="java.io.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>
<jsp:useBean id="driverMgr" class="com.reeltrack.drivers.DriverMgr" scope="request"/>
<% securityMgr.init(dbResources); %>
<% driverMgr.init(pageContext,dbResources); %>
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

Driver contentUpload = new Driver();

int contid = 0;
if(request.getParameter(Driver.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(Driver.PARAM));
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
    if(multipart.getParameter(Driver.PARAM)!=null) {
        contid = Integer.parseInt(multipart.getParameter(Driver.PARAM));
    }
}

if(action.equals("import")) {	
	int customerID = Integer.parseInt(multipart.getParameter(Driver.CUSTOMER_ID_COLUMN));
	File excel = multipart.getFile("excel_upload");
	driverMgr.addDriversFromExcel(customerID, excel, basePath);
    redirect = request.getContextPath() + "/trampoline/" + "drivers/search.jsp";
}

if(action.equals("create")) {
    Driver content = new Driver();
    content.setCustomerId(Integer.parseInt(request.getParameter(Driver.CUSTOMER_ID_COLUMN)));
    content.setName(request.getParameter(Driver.NAME_COLUMN));
    content.setStatus(Driver.STATUS_ACTIVE);
    contid = driverMgr.addDriver(content);
    redirect = request.getContextPath() + "/trampoline/" + "drivers/search.jsp";
}

if(action.equals("delete")) {
    Driver content = new Driver();
    content.setId(contid);
    driverMgr.deleteDriver(content, basePath);
    redirect = request.getContextPath() + "/trampoline/" + "drivers/search.jsp";
} 
%>

<% dbResources.close(); %>
<notifier:set_message text="<%= notifier %>" />		
<admin:ajax_redirect redirect="<%= redirect %>" />