<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.settings.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>
<jsp:useBean id="settingsMgr" class="com.reeltrack.settings.SettingsMgr" scope="request"/>
<% securityMgr.init(dbResources); %>
<% settingsMgr.init(pageContext,dbResources); %>
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
if(request.getParameter(Settings.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(Settings.PARAM));
}

if(action.equals("update")) {
    Settings content = new Settings();
    content.setId(Integer.parseInt(request.getParameter(Settings.PARAM)));
    content.setAutoPrintReelTags(request.getParameter(Settings.AUTO_PRINT_REEL_TAG_COLUMN));
    settingsMgr.updateSettings(content);
    redirect = request.getContextPath() + "/trampoline/" + "settings/search.jsp";
}
%>

<% dbResources.close(); %>
<notifier:set_message text="<%= notifier %>" />		
<admin:ajax_redirect redirect="<%= redirect %>" />