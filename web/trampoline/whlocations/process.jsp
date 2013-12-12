<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.whlocations.*" %>
<%@ page import="com.monumental.trampoline.utilities.forms.multipart.*" %>
<%@ page import="java.io.File" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>
<jsp:useBean id="whlocationMgr" class="com.reeltrack.whlocations.WhLocationMgr" scope="request"/>
<% securityMgr.init(dbResources); %>
<% whlocationMgr.init(pageContext,dbResources); %>
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

WhLocation contentUpload = new WhLocation();

int contid = 0;
if(request.getParameter(WhLocation.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(WhLocation.PARAM));
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
    if(multipart.getParameter(WhLocation.PARAM)!=null) {
        contid = Integer.parseInt(multipart.getParameter(WhLocation.PARAM));
    }
}

if(action.equals("create")) {
    WhLocation content = new WhLocation();
    content.setCustomerId(Integer.parseInt(request.getParameter(WhLocation.CUSTOMER_ID_COLUMN)));
    content.setName(request.getParameter(WhLocation.NAME_COLUMN));
    content.setStatus(WhLocation.STATUS_ACTIVE);
    contid = whlocationMgr.addWhLocation(content);
    redirect = request.getContextPath() + "/trampoline/" + "whlocations/search.jsp";
}

if(action.equals("import")) {
    WhLocation content = new WhLocation();
    content.setCustomerId(Integer.parseInt(multipart.getParameter(WhLocation.CUSTOMER_ID_COLUMN)));
    File file = multipart.getFile("location_file");
    whlocationMgr.importLocations(content, file);
    redirect = request.getContextPath() + "/trampoline/" + "whlocations/search.jsp";
} 

if(action.equals("delete")) {
    WhLocation content = new WhLocation();
    content.setId(contid);
    whlocationMgr.deleteWhLocation(content, basePath);
    redirect = request.getContextPath() + "/trampoline/" + "whlocations/search.jsp";
} 
%>

<% dbResources.close(); %>
<notifier:set_message text="<%= notifier %>" />		
<admin:ajax_redirect redirect="<%= redirect %>" />