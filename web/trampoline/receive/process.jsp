<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.reeltrack.customers.Customer"%>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>

<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" scope="request"/>
<% securityMgr.init(dbResources); %>
<% userLoginMgr.init(pageContext); %>
<% reelMgr.init(pageContext,dbResources); %>
<% CompProperties props = new CompProperties(); %>

<% 
RTUser user = (RTUser)userLoginMgr.getUser();
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
    Reel reel = reelMgr.getReel(content);
    content.setTrackingPRO(request.getParameter(Reel.TRACKING_PRO_COLUMN));
    content.setPackingList(request.getParameter(Reel.PACKING_LIST_COLUMN));
    try {
    content.setShippedQuantity(Integer.parseInt(request.getParameter(Reel.SHIPPED_QUANTITY_COLUMN)));
    } catch(Exception e) {}
    try {
    content.setReceivedQuantity(Integer.parseInt(request.getParameter(Reel.RECEIVED_QUANTITY_COLUMN)));
    } catch(Exception e) {}
    try {
    content.setOrigTopFoot(Integer.parseInt(request.getParameter(Reel.ORIG_TOP_FOOT_COLUMN)));
    } catch(Exception e) {}
    try {
    content.setReceivedWeight(Integer.parseInt(request.getParameter(Reel.RECEIVED_WEIGHT_COLUMN)));
    } catch(Exception e) {}
    
    content.setWharehouseLocation(request.getParameter(Reel.WHAREHOUSE_LOCATION_COLUMN));
    content.setReceivingIssue(request.getParameter(Reel.RECEIVING_ISSUE_COLUMN));
    content.setReceivingNote(request.getParameter(Reel.RECEIVING_NOTE_COLUMN));
    content.setReceivingDisposition(request.getParameter(Reel.RECEIVING_DISPOSITION_COLUMN));

    if(content.getReceivingDisposition().equalsIgnoreCase(Reel.RECEIVING_DISPOSITION_REFUSED)) {
        Customer customer = reelMgr.getCustomerForReel(reel);
        String issueLog = reel.getEcsPN() + " manufactured by " + reel.getManufacturer()  + " on ECS PO " + reel.getOrdNo() + " with reel tag " + reel.getReelTag();
        issueLog += "Customer Reel ID# " + reel.getCrId() + " - " + reel.getCableDescription() + " with reel tag " + reel.getReelTag() + " was refused by " + user.getFname() + " " + user.getLname() + " with " + customer.getName() + " on " + user.getJobName() + " Project - " + user.getJobCode();

        ReelIssue issue = new ReelIssue();
        issue.setReelId(contid);
        issue.setDescription(content.getReceivingNote());
        issue.setIssueLog(issueLog);
        reelMgr.addReelIssue(issue);
    }
    reelMgr.markReelReceived(content);
    redirect = request.getContextPath() + "/trampoline/" + "receive/search.jsp";
}
%>
<% dbResources.close(); %>
<notifier:set_message text="<%= notifier %>" />		
<admin:ajax_redirect redirect="<%= redirect %>" />