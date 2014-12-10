<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.monumental.trampoline.utilities.text.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
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

CompEntities logs = reelMgr.getReelLogs(content);
ReelLog log;

String tempURL; //var for url expression
%>
<% dbResources.close(); %>

<html:begin />
<h1 style="text-align:right;padding-right:50px;">Reel Page</h1>
<% tempURL = content.getCrId() + " : " + content.getReelTag() + " : " + content.getCableDescription() + " : " + content.getStatus(); %>
<h1 style="padding-bottom:0px;"><%= tempURL %></h1>
<p style="padding-left:0px;padding-bottom:20px;">CRID : ReelTag : Cust P/N : Status</p>
<notifier:show_message />

<% if(logs.howMany() > 0) { %>
    <admin:subtitle text="All Log Entries" />
    <admin:box_begin color="false" />
        <listing:begin />
        <listing:header_begin />
            <listing:header_cell width="75" first="true" name="Created" />
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