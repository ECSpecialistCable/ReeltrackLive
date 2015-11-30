<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.file_cabinets.*" %>
<%@ page import="com.reeltrack.file_cabinets.FileCabinet"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="cabinetMgr" class="com.reeltrack.file_cabinets.FileCabinetMgr" scope="request"/>
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% cabinetMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<%
boolean canEdit = false;
if(user.isUserType(RTUser.USER_TYPE_ECS) || user.isUserType(RTUser.USER_TYPE_MANAGEMENT)) {
    canEdit = true;
}

FileCabinet content = new FileCabinet();
content.setCustomerId(user.getCustomerId());
content.setJobId(-1);
CompEntities contents = cabinetMgr.searchFileCabinet(content, FileCabinet.TITLE_COLUMN, true, 0, 0);

String tempUrl =""; //var for url expression
%>
<% dbResources.close(); %>


<html:begin />
<admin:title text="Printer Information" />

<% if(canEdit) { %>
<admin:subtitle text="Add File" />
<admin:box_begin />
	<form:begin_multipart submit="true" name="create" action="file_cabinets/process.jsp" />
		<form:textfield name="<%= FileCabinet.TITLE_COLUMN %>" label="Title:" />
			<form:file label="File:" name="<%= FileCabinet.FILE_NAME_COLUMN %>" />
            <form:hidden name="<%= FileCabinet.CUSTOMER_ID_COLUMN %>" value="<%= new Integer(user.getCustomerId()).toString() %>" /> 
            <form:row_begin />
                <form:label name="" label="" />
                <form:buttonset_begin align="left" padding="0"/>
                        <form:submit_inline button="save" waiting="true" name="save" action="create_vendor" />
                <form:buttonset_end />
            <form:row_end />
    <form:end />
<admin:box_end />
<% } %>

<% if(contents.howMany() > 0) { %>
    <admin:subtitle text="Files" />
    <admin:box_begin color="false" />
        <listing:begin />
            <listing:header_begin />
                <listing:header_cell first="true" name="Title" />
                <listing:header_cell width="140" name="" />
            <listing:header_end />
            <% for(int i=0; i<contents.howMany(); i++) { %>
            <% content = (FileCabinet)contents.get(i); %>
            <listing:row_begin row="<%= new Integer(i).toString() %>" />
                <listing:cell_begin />
                    <%= content.getTitle() %>
                <listing:cell_end />
                <listing:cell_begin align="right"/>
				<% tempUrl = request.getContextPath() + content.getCompEntityDirectory() + "/" + content.getFileName(); %>
                <admin:link external="true" text="[Download]" url="<%= tempUrl %>" />
                <% if(canEdit) { %>
                <% tempUrl = "file_cabinets/process.jsp?submit_action=delete_vendor&" + FileCabinet.PARAM + "=" + content.getId(); %>
                <form:linkbutton warning="true" url="<%= tempUrl %>" process="true" name="DELETE" />
                <% } %>
                <listing:cell_end />
            <listing:row_end />
            <% } %>
        <listing:end />
    <admin:box_end />
<% } else { %>
    <admin:subtitle text="There are no files." />
<% } %>

<admin:set_tabset url="file_cabinets/_tabset_default.jsp" thispage="vendor.jsp" />
<html:end />