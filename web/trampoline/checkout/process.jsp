<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.picklists.*" %>
<%@ page import="com.reeltrack.reels.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>
<jsp:useBean id="picklistMgr" class="com.reeltrack.picklists.PickListMgr" scope="request"/>
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" scope="request"/>
<% securityMgr.init(dbResources); %>
<% picklistMgr.init(pageContext,dbResources); %>
<% reelMgr.init(pageContext,dbResources); %>
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
if(request.getParameter(PickList.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(PickList.PARAM));
}

if(action.equals("update_stage")) {
    PickList content = new PickList();
    content.setId(contid);
    content.setDriver(request.getParameter(PickList.DRIVER_COLUMN));
    content.setForeman(request.getParameter(PickList.FOREMAN_COLUMN));
    content.setStatus(request.getParameter(PickList.STATUS_COLUMN));
    picklistMgr.updatePickList(content);
    redirect = request.getContextPath() + "/trampoline/" + "checkout/stage.jsp?" + PickList.PARAM + "=" + contid ;
}

if(action.equals("mark_staged")) {
    Reel content = new Reel();
    content.setId(Integer.parseInt(request.getParameter(Reel.PARAM)));
    content.setTopFoot(Integer.parseInt(request.getParameter(Reel.TOP_FOOT_COLUMN)));
    reelMgr.markReelStaged(content);
    redirect = request.getContextPath() + "/trampoline/" + "checkout/stage.jsp?" + PickList.PARAM + "=" + contid ;
}

if(action.equals("mark_checkedout")) {
    Reel content = new Reel();
    content.setId(Integer.parseInt(request.getParameter(Reel.PARAM)));
    content.setTopFoot(Integer.parseInt(request.getParameter(Reel.TOP_FOOT_COLUMN)));
    reelMgr.markReelCheckedOut(content);
    redirect = request.getContextPath() + "/trampoline/" + "checkout/checkout.jsp?" + PickList.PARAM + "=" + contid ;
}
%>
<% dbResources.close(); %>
<notifier:set_message text="<%= notifier %>" />		
<admin:ajax_redirect redirect="<%= redirect %>" />