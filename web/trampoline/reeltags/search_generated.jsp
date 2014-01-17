<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Enumeration"%>
<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.monumental.trampoline.security.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.reeltrack.users.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" />
<% userLoginMgr.init(pageContext); %>
<% reelMgr.init(pageContext,dbResources); %>
<% 
RTUser user = (RTUser)userLoginMgr.getUser();

if(request.getParameter("submit_action")!=null && request.getParameter("submit_action").equals("clear_generated_tags")) {
	reelMgr.clearReelTags();
}

Reel content = new Reel();
content.setHasReelTagFile("y");
CompEntities contents = reelMgr.searchReels(content, Reel.CR_ID_COLUMN, true, 0, 0);

boolean dosearch = true;
String tempURL = "";
%>

<% dbResources.close(); %>
<html:begin />
<admin:title text="Generated Reel Tags" />


<% if(dosearch) { %>
    <% if(contents.howMany() > 0) { %>
	<admin:subtitle text="Clear Generated Reel Tags"/>
	<admin:box_begin/>
		<form:begin_selfsubmit name="clear_generated_tags" action="reeltags/search_generated.jsp" />
			<form:row_begin/>
				<form:buttonset_begin padding="0" align="right"/>
                <form:submit_inline button="submit" waiting="true" name="clear" action="clear_generated_tags" />
				<form:buttonset_end/>
			<form:row_end/>
		<form:end />
	<admin:box_end />

    <admin:box_begin color="false" />
   
    <listing:begin />
        <listing:header_begin />
            <listing:header_cell width="50" first="true" name="CRID #" />
            <listing:header_cell name="Reel Tag" />
            <listing:header_cell name="Cable Description" />
            <listing:header_cell name="" width="75"/>
        <listing:header_end />
        <% for(int i=0; i<contents.howMany(); i++) { %>
        <% content = (Reel)contents.get(i); %>
        <listing:row_begin row="<%= new Integer(i).toString() %>" />
            <listing:cell_begin />
                <%= content.getCrId() %>
            <listing:cell_end />
            <listing:cell_begin />
                <%= content.getReelTag() %>
            <listing:cell_end />
            <listing:cell_begin />
                <%= content.getCableDescription() %>
            <listing:cell_end />
            <listing:cell_begin />
                <% tempURL = content.getReelTagDirectory() + "/" + content.getReelTagFile(); %>
                <form:linkbutton url="<%= tempURL %>" name="PRINT" newtab="true" />
            <listing:cell_end />
        <listing:row_end />
        <% } %>
    <listing:end />
    <admin:box_end />
    <% } else { %>
    <admin:subtitle text="No Reels Found." />
    <% } %>
<% } %>

<admin:set_tabset url="reeltags/_tabset_default.jsp" thispage="search_generated.jsp" />
<html:end />    