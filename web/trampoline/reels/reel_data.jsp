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
boolean canEdit = false;
if(user.isUserType(RTUser.USER_TYPE_ECS)) {
    canEdit = true;
}
%>
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

String tempURL; //var for url expression
%>
<% dbResources.close(); %>

<html:begin />
<% tempURL = content.getCrId() + " : " + content.getReelTag() + " : " + content.getCableDescription() + " : " + content.getStatus(); %>
<admin:title text="<%= tempURL %>" />
<notifier:show_message />

<admin:subtitle text="ECS Invoice" />
<admin:box_begin />
    <form:begin submit="<%= new Boolean(false).toString() %>" name="edit" action="reels/process.jsp" />
        <form:info label="Invoice #:" text="<%= content.getInvoiceNum() %>" />
        <form:info label="Invoice Date:" text="<%= content.getInvoiceDateString() %>" />
    <form:end />
<admin:box_end />

<admin:subtitle text="Reel Data" />
<admin:box_begin />
    <form:begin_multipart submit="<%= new Boolean(canEdit).toString() %>" name="edit" action="reels/process.jsp" />
        <form:info label="CTR #:" text="<%= content.getCTRNumber() %>" />
        <form:info label="CTR Date:" text="<%= content.getCTRDateString() %>" />
        <form:info label="CTR Sent:" text="<%= content.getCTRSentString() %>" />
        <% if(canEdit) { %>
		<form:file name="<%= Reel.CTR_FILE_COLUMN %>" label="CTR File:" />
        <% } %>
        <% if(content.getCTRFile() != null && !content.getCTRFile().equals("")) { %>
            <form:row_begin />
            <form:label label="Download CTR:"  />
            <form:content_begin />
                    <% tempURL = request.getContextPath() + content.getCompEntityDirectory() + "/" + content.getCTRFile(); %>
                    <admin:link external="true" text="[Download]" url="<%= tempURL %>" />      
                <form:content_end />
            <form:row_end />
        <% } %>
		<form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />			
		<form:row_begin />
			<form:label name="" label="" />
			<form:buttonset_begin align="left" padding="0"/>
                <% if(canEdit) { %>
				<form:submit_inline button="save" waiting="true" name="save" action="update_reel_data" />
                <% } %>
			<form:buttonset_end />
		<form:row_end />
    <form:end />
<admin:box_end />


<admin:set_tabset url="reels/_tabset_manage.jsp" thispage="reel_data.jsp" content_id_for_tabset="<%= contid %>"/>
<html:end />