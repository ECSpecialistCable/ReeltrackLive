<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.monumental.trampoline.utilities.text.*" %>
<%@ page import="com.reeltrack.picklists.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<jsp:useBean id="picklistMgr" class="com.reeltrack.picklists.PickListMgr" />
<% picklistMgr.init(pageContext,dbResources); %>
<% userLoginMgr.init(pageContext); %>
<% reelMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<%
// Get the id
int contid = 0;
if(request.getParameter(Reel.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(Reel.PARAM));
} else {
    String param = "content_id_for_tabset";
    if(request.getParameter(param) != null) {
        contid = Integer.parseInt(request.getParameter(param));
    }
}

// Get the piece of content
Reel content = new Reel();
content.setId(contid);
content = (Reel)reelMgr.getReel(content);

PickList picklist = new PickList();
if(content.getPickListId()!=0) {
    picklist.setId(content.getPickListId());
    picklist = (PickList)picklistMgr.getPickList(picklist);
}

CompEntities logs = reelMgr.getReelLogs(content);
ReelLog log;

String alr = "";
if(request.getParameter("alr")!=null) {
    alr = request.getParameter("alr");
}

String tempURL; //var for url expression
%>
<% dbResources.close(); %>

<html:begin />
<%--
<h1 style="text-align:right;padding-right:50px;">Reel Page</h1>
<% tempURL = content.getCrId() + " : " + content.getReelTag() + " : " + content.getCableDescription() + " : " + content.getStatus(); %>
<h1 style="padding-bottom:0px;"><%= tempURL %></h1>
<p style="padding-left:0px;padding-bottom:20px;">CRID : ReelTag : Cust P/N : Status</p>
--%>
<notifier:show_message />

<%
tempURL = content.getCrId() + " : " + content.getReelTag() + " : " + content.getCableDescription() + " : " + content.getStatus();
if(content.getStatus().equals(Reel.STATUS_IN_WHAREHOUSE)) {
    tempURL = content.getCrId() + " : " + content.getReelTag() + " : " + content.getCableDescription() + " : " + content.getStatus() + " - " + content.getWharehouseLocation();
} else if(content.getStatus().equals(Reel.STATUS_CHECKED_OUT)) {
    tempURL = content.getCrId() + " : " + content.getReelTag() + " : " + content.getCableDescription() + " : " + content.getStatus() + " - " + picklist.getForeman();
}
%>
<admin:title heading="Reel Page" text="<span style='color:red;'>CRID: Reel Tag: Description: Status</span>" />
<h2 class="adminTitle"><%= tempURL %></h2>

<% if(logs.howMany() > 0) { %>
    <admin:subtitle text="Action Log" />
    <admin:box_begin text="Action Log" name="Action_Log" open="true" />
    <form:begin name="action_log_report" action="reels/process.jsp" />
        <%if(alr.equals("true")) { %>
            <form:row_begin />
                <form:label name="" label="" />
                <form:buttonset_begin align="left" padding="0"/>
                        <% String url = request.getContextPath() + "/reports/" + "action_log_report.xls"; %>
                        <a target="_blank" href="<%= url %>"><%= "[Download]" %></a>
                <form:buttonset_end />
            <form:row_end />
        <% } %>
        <form:row_begin />
            <form:label name="" label="" />
            <form:buttonset_begin align="left" padding="0"/>
                <form:submit_inline button="submit" waiting="false" name="submit" action="action_log_report" />
            <form:buttonset_end />
        <form:row_end />
        <form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />
    <form:end />
    <admin:box_end />

    <admin:subtitle text="All Log Entries" />
    <admin:box_begin text="All Log Entries" name="log-entries" color="false" />
        <listing:begin />
        <listing:header_begin />
            <listing:header_cell setWidth="150" first="true" name="Created" />
            <listing:header_cell width="100" name="By User" />
            <listing:header_cell width="75" name="Cur Qty" />
            <listing:header_cell width="75" name="Top #" />
            <listing:header_cell name="Log Entry" />
        <listing:header_end />
        <% for(int i=0; i<logs.howMany(); i++) { %>
        <% log = (ReelLog)logs.get(i); %>
        <listing:row_begin row="<%= new Integer(i).toString() %>" />
            <listing:cell_begin />
                <%= log.getCreatedDateText() %><br /><%= log.getCreatedTime() %>
            <listing:cell_end />
            <listing:cell_begin />
                <%= log.getCreatedBy() %>
            <listing:cell_end />
            <listing:cell_begin />
                <%= log.getOnReelQuantity() %>
            <listing:cell_end />
            <listing:cell_begin />
                <%= log.getTopFoot() %>
            <listing:cell_end />
            <listing:cell_begin />
                <%= TextParser.addBreakTags(log.getNote()) %>
            <listing:cell_end />
        <listing:row_end />
        <% } %>
    <listing:end />
    <admin:box_end />
<% } else { %>
    <admin:subtitle text="There are no log entries." />
<% } %>

<admin:set_tabset url="reels/_tabset_manage.jsp" thispage="log.jsp" content_id_for_tabset="<%= contid %>"/>
<html:end />
