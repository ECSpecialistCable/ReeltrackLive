<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" scope="request"/>
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% reelMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<%
ReelIssue content = new ReelIssue();
CompEntities contents = reelMgr.getUnresolvedReelIssues(user.getJobCode());
String tempUrl;
%>


<% dbResources.close(); %>
<html:begin />
<admin:title heading="Issues" text="Unresolved" />

<% if(contents.howMany() > 0) { %>
    <admin:subtitle text="Issues" />
    <admin:box_begin text="Issues" name="Issues" />
        <listing:begin />
            <listing:header_begin />
                <listing:header_cell width="75" first="true" name="created" />
                <listing:header_cell width="110" name="Reel Tag" />
                <listing:header_cell width="30" name="CRID" />
                <listing:header_cell width="80" name="Cust P/N" />
                <listing:header_cell width="100" name="User Name" />
                <listing:header_cell name="Description" />
                <listing:header_cell width="50" name="" />
            <listing:header_end />
            <% for(int i=0; i<contents.howMany(); i++) { %>
            <%
            content = (ReelIssue)contents.get(i);
            Reel reel = (Reel)content.getCompEntity(Reel.PARAM);
            %>
            <listing:row_begin row="<%= new Integer(i).toString() %>" />
                <listing:cell_begin />
                    <%= content.getCreatedDateText() %>
                <listing:cell_end />
                <listing:cell_begin />
                    <%= reel.getReelTag() %>
                <listing:cell_end />
                <listing:cell_begin />
                    <%= reel.getCrId() %>
                <listing:cell_end />
                <listing:cell_begin />
                    <%= reel.getCustomerPN() %>
                <listing:cell_end />
                <listing:cell_begin />
                    <%= content.getCreatedBy() %>
                <listing:cell_end />
                <listing:cell_begin />
                    <%= content.getDescription() %>
                <listing:cell_end />
                <listing:cell_begin align="right"/>
                <% tempUrl = "reels/issues.jsp?" +  Reel.PARAM + "=" + content.getReelId(); %>
                <form:linkbutton url="<%= tempUrl %>" name="EDIT" />
                <listing:cell_end />
            <listing:row_end />
            <% } %>
        <listing:end />
    <admin:box_end />
<% } else { %>
    <admin:subtitle text="There are no Unresolved Issues." />
<% } %>

<admin:set_tabset url="issues/_tabset_default.jsp" thispage="search.jsp" />
<html:end />
