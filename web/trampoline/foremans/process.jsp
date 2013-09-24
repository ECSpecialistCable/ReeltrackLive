<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.foremans.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>
<jsp:useBean id="foremanMgr" class="com.reeltrack.foremans.ForemanMgr" scope="request"/>
<% securityMgr.init(dbResources); %>
<% foremanMgr.init(pageContext,dbResources); %>
<% CompProperties props = new CompProperties(); %>

<% 
String basePath = pageContext.getServletContext().getRealPath("/");
String notifier = "";
String redirect = request.getHeader("referer");
String action = "";
if(request.getParameter("submit_action") != null) {
    action = request.getParameter("submit_action");
}

int contid = 0;
if(request.getParameter(Foreman.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(Foreman.PARAM));
}

if(action.equals("create")) {
    Foreman content = new Foreman();
    content.setCustomerId(Integer.parseInt(request.getParameter(Foreman.CUSTOMER_ID_COLUMN)));
    content.setName(request.getParameter(Foreman.NAME_COLUMN));
    content.setStatus(Foreman.STATUS_ACTIVE);
    contid = foremanMgr.addForeman(content);
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