<%@page import="com.reeltrack.glossary.Glossary"%>
<%@page import="com.monumental.trampoline.datasources.DbResources"%>
<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.monumental.trampoline.component.CompEntities"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<jsp:useBean id="glossaryMgr" class="com.reeltrack.glossary.GlossaryMgr" />
<% userLoginMgr.init(pageContext); %>
<% glossaryMgr.init(pageContext,dbResources); %>

<%
RTUser user = (RTUser)userLoginMgr.getUser();

Glossary content = new Glossary();
content.setJobId(0);
content.setIsVideo("y");
CompEntities contents = glossaryMgr.searchGlossary(content, Glossary.NAME_COLUMN, true, 0, 0);
dbResources.close();
%>
<%
boolean canEdit = false;
if(user.isUserType(RTUser.USER_TYPE_ECS)) {
    canEdit = true;
}
%>


<html:begin />
<admin:title heading="ReelTrack Training" text="Videos"/>
<% if(canEdit) { %>
<admin:subtitle text="Add ReelTrack Training Video" />
<admin:box_begin text="Add ReelTrack Training Video" name="Add" />
    <form:begin submit="true" name="create_reeltrack_video" action="glossary/process.jsp" />

    		<form:textfield pixelwidth="300" name="<%= Glossary.NAME_COLUMN %>" label="Name:" />
    		<form:textfield pixelwidth="300" name="<%= Glossary.VIDEO_URL_COLUMN %>" label="URL:" />
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
						<form:submit_inline button="save" waiting="true" name="save" action="create_reeltrack_video" />
				<form:buttonset_end />
			<form:row_end />
    <form:end />
<admin:box_end />
<% } %>

<% if(contents.howMany() > 0) { %>
    <admin:subtitle text="ReelTrack Training Videos" />
    <admin:box_begin text="ReelTrack Training Videos" name="Videos" />
        <listing:begin />
            <listing:header_begin />
                <listing:header_cell first="true" name="Name" width="150" />
                <listing:header_cell name="Link" />
                <% if(canEdit) { %>
                <listing:header_cell width="120" name="" />
                <% } %>
            <listing:header_end />
            <% for(int i=0; i<contents.howMany(); i++) { %>
            <% content = (Glossary)contents.get(i); %>
            <listing:row_begin row="<%= new Integer(i).toString() %>" />
                <listing:cell_begin />
                    <%= content.getName() %>
                <listing:cell_end />
                <listing:cell_begin />
                    <a href="<%= content.getVideoURL() %>" target="_new"><%= content.getVideoURL() %></a>
                <listing:cell_end />
                <% if(canEdit) { %>
                <listing:cell_begin align="right"/>
                    <% String tempUrl = "glossary/edit.jsp?" +  Glossary.PARAM + "=" + content.getId(); %>
                    <form:linkbutton url="<%= tempUrl %>" name="EDIT" />
                    <% tempUrl = "glossary/process.jsp?submit_action=delete_reeltrack_video&" + Glossary.PARAM + "=" + content.getId(); %>
                    <form:linkbutton warning="true" url="<%= tempUrl %>" process="true" name="DELETE" />
                <listing:cell_end />
                <% } %>
            <listing:row_end />
            <% } %>
        <listing:end />
    <admin:box_end />
<% } else { %>
    <admin:subtitle text="No ReelTrack Training Videos." />
<% } %>

<admin:set_tabset url="glossary/_tabset_default.jsp" thispage="reeltrack_videos.jsp" />
<html:end />
