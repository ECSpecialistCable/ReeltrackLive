<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" scope="request"/>
<% securityMgr.init(dbResources); %>
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
if(request.getParameter(Reel.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(Reel.PARAM));
}

if(action.equals("mark_received")) {
    Reel content = new Reel();
    content.setId(contid);
    content.setTrackingPRO(request.getParameter(Reel.TRACKING_PRO_COLUMN));
    content.setPackingList(request.getParameter(Reel.PACKING_LIST_COLUMN));
    try {
    content.setShippedQuantity(Integer.parseInt(request.getParameter(Reel.SHIPPED_QUANTITY_COLUMN)));
    content.setReceivedQuantity(Integer.parseInt(request.getParameter(Reel.RECEIVED_QUANTITY_COLUMN)));
    content.setBottomFoot(Integer.parseInt(request.getParameter(Reel.BOTTOM_FOOT_COLUMN)));
    content.setTopFoot(Integer.parseInt(request.getParameter(Reel.TOP_FOOT_COLUMN)));
    } catch(Exception e) {}
    content.setWharehouseLocation(request.getParameter(Reel.WHAREHOUSE_LOCATION_COLUMN));
    content.setReceivingIssue(request.getParameter(Reel.RECEIVING_ISSUE_COLUMN));
    content.setReceivingNote(request.getParameter(Reel.RECEIVING_NOTE_COLUMN));
    content.setReceivingDisposition(request.getParameter(Reel.RECEIVING_DISPOSITION_COLUMN));
    reelMgr.markReelReceived(content);
    redirect = request.getContextPath() + "/trampoline/" + "receive/search.jsp";
}
%>
<% dbResources.close(); %>
<notifier:set_message text="<%= notifier %>" />		
<admin:ajax_redirect redirect="<%= redirect %>" />