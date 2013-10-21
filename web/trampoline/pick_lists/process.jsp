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
<% securityMgr.init(dbResources); %>
<% picklistMgr.init(pageContext,dbResources); %>
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


if(action.equals("create")) {
    PickList content = new PickList();
    content.setName(request.getParameter(PickList.NAME_COLUMN));
    contid = picklistMgr.addPickList(content);

    redirect = request.getContextPath() + "/trampoline/" + "pick_lists/search.jsp";
}


if(action.equals("update")) {
    PickList content = new PickList();
    content.setId(contid);
    content.setName(request.getParameter(PickList.NAME_COLUMN));
    content.setForeman(request.getParameter(PickList.FOREMAN_COLUMN));
    picklistMgr.updatePickList(content);
    redirect = request.getContextPath() + "/trampoline/" + "pick_lists/edit.jsp?" + PickList.PARAM + "=" + contid ;
}

if(action.equals("add_reel")) {
    Reel content = new Reel();
    content.setId(Integer.parseInt(request.getParameter(Reel.PARAM)));
    content.setPickListId(contid);
    picklistMgr.updateReelForPickList(content);
    redirect = request.getContextPath() + "/trampoline/" + "pick_lists/edit.jsp?" + PickList.PARAM + "=" + contid ;
}

if(action.equals("delete_reel")) {
    Reel content = new Reel();
    content.setId(Integer.parseInt(request.getParameter(Reel.PARAM)));
    content.setPickListId(0);
    picklistMgr.updateReelForPickList(content);
    redirect = request.getContextPath() + "/trampoline/" + "pick_lists/edit.jsp?" + PickList.PARAM + "=" + contid ;
}

/*
if(action.equals("update_shipping")) {
    Reel content = new Reel();
    content.setId(contid);
    content.setCarrier(request.getParameter(Reel.CARRIER_COLUMN));
    content.setTrackingPRO(request.getParameter(Reel.TRACKING_PRO_COLUMN));
    content.setPackingList(request.getParameter(Reel.PACKING_LIST_COLUMN));
    if(request.getParameter(Reel.PROJECTED_SHIPPING_DATE_COLUMN)!=null && !request.getParameter(Reel.PROJECTED_SHIPPING_DATE_COLUMN).equals("")) {
        content.setProjectedShippingDateString(request.getParameter(Reel.PROJECTED_SHIPPING_DATE_COLUMN));
    }
    reelMgr.updateReelShippingInfo(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/edit.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("update_receiving")) {
    Reel content = new Reel();
    content.setId(contid);
    content.setReceivingIssue(request.getParameter(Reel.RECEIVING_ISSUE_COLUMN));
    content.setReceivingNote(request.getParameter(Reel.RECEIVING_NOTE_COLUMN));
    content.setReceivingDisposition(request.getParameter(Reel.RECEIVING_DISPOSITION_COLUMN));
    reelMgr.updateReelReceivingInfo(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/edit.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("update_quantity")) {
    Reel content = new Reel();
    content.setId(contid);
    content.setShippedQuantity(Integer.parseInt(request.getParameter(Reel.SHIPPED_QUANTITY_COLUMN)));
    content.setReceivedQuantity(Integer.parseInt(request.getParameter(Reel.RECEIVED_QUANTITY_COLUMN)));
    content.setTopFoot(Integer.parseInt(request.getParameter(Reel.TOP_FOOT_COLUMN)));
    reelMgr.updateReelQuantity(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/quantity.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("record_pull")) {
    Reel content = new Reel();
    content.setId(contid);
    content.setTempPullAmount(Integer.parseInt(request.getParameter("pulled_quantity")));
    content.setTopFoot(Integer.parseInt(request.getParameter(Reel.TOP_FOOT_COLUMN)));
    reelMgr.updateReelPull(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/quantity.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("add_circuit")) {
    ReelCircuit content = new ReelCircuit();
    content.setReelId(contid);
    content.setLength(Integer.parseInt(request.getParameter(ReelCircuit.LENGTH_COLUMN)));
    content.setName(request.getParameter(ReelCircuit.NAME_COLUMN));
    reelMgr.addReelCircuit(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/circuits.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("update_circuit")) {
    ReelCircuit content = new ReelCircuit();
    content.setId(Integer.parseInt(request.getParameter(ReelCircuit.PARAM)));
    if(request.getParameter(ReelCircuit.IS_PULLED_COLUMN)!=null) {
        content.setIsPulled("y");
    } else {
        content.setIsPulled("n");
    }
    reelMgr.updateReelCircuit(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/circuits.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("delete_circuit")) {
    ReelCircuit content = new ReelCircuit();
    content.setId(Integer.parseInt(request.getParameter(ReelCircuit.PARAM)));
    reelMgr.deleteReelCircuit(content,basePath);
    redirect = request.getContextPath() + "/trampoline/" + "reels/circuits.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("add_note")) {
    ReelNote note = new ReelNote();
    note.setReelId(contid);
    note.setNote(request.getParameter(ReelNote.NOTE_COLUMN));
    reelMgr.addReelNote(note);
    redirect = request.getContextPath() + "/trampoline/" + "reels/notes.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("add_issue")) {
    ReelIssue issue = new ReelIssue();
    issue.setReelId(contid);
    issue.setDescription(request.getParameter(ReelIssue.DESCRIPTION_COLUMN));
    issue.setIssueLog(request.getParameter(ReelIssue.ISSUE_LOG_COLUMN));
    reelMgr.addReelIssue(issue);
    redirect = request.getContextPath() + "/trampoline/" + "reels/issues.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("update_issue")) {
    ReelIssue issue = new ReelIssue();
    issue.setId(Integer.parseInt(request.getParameter(ReelIssue.PARAM)));
    if(request.getParameter(ReelIssue.IS_RESOLVED_COLUMN)!=null) {
        issue.setIsResolved("y");
    } else {
        issue.setIsResolved("n");
    }
    issue.setIssueLog(request.getParameter(ReelIssue.ISSUE_LOG_COLUMN));
    reelMgr.updateReelIssue(issue);
    redirect = request.getContextPath() + "/trampoline/" + "reels/issues.jsp?" + Reel.PARAM + "=" + contid ;
}
*/
%>
<% dbResources.close(); %>
<notifier:set_message text="<%= notifier %>" />		
<admin:ajax_redirect redirect="<%= redirect %>" />