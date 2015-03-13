<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.monumental.trampoline.utilities.text.*" %>
<%@ page import="java.net.*" %>

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
<h1 style="text-align:right;padding-right:50px;">Reel Page</h1>
<% tempURL = content.getCrId() + " : " + content.getReelTag() + " : " + content.getCableDescription() + " : " + content.getStatus(); %>
<h1 style="padding-bottom:0px;"><%= tempURL %></h1>
<p style="padding-left:0px;padding-bottom:20px;">CRID : ReelTag : Cust P/N : Status</p>
<notifier:show_message />

<% if(canEdit) { %>
<admin:subtitle text="Unique ID" />
<admin:box_begin />
    <form:begin submit="<%= new Boolean(false).toString() %>" name="edit" action="reels/process.jsp" />
		<form:textfield label="Unique ID:" name="<%= Reel.UNIQUE_ID_COLUMN %>" value="<%= new Integer(content.getUniqueId()).toString() %>" />
		<form:row_begin />
			<form:label name="" label="" />
			<form:buttonset_begin align="left" padding="0"/>
				<% if(canEdit) { %>
				<form:submit_inline button="save" waiting="true" name="save" action="update_unique_id" />
				<% } %>
			<form:buttonset_end />
		<form:row_end />
        <form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />
    <form:end />
<admin:box_end />
<% } %>

<admin:subtitle text="ECS Invoice" />
<admin:box_begin />
    <form:begin submit="<%= new Boolean(false).toString() %>" name="edit" action="reels/process.jsp" />
        <% if(!canEdit) { %>
            <form:info label="Customer PO:" text="<%= content.getCustomerPO() %>" />
            <form:info label="Invoice #:" text="<%= content.getInvoiceNum() %>" />
            <form:info label="Invoice Date:" text="<%= content.getInvoiceDateString() %>" />       
        <% } else { %>
            <form:info label="ECS PO:" text="<%= content.getOrdNo() %>" />
            <form:textfield label="Customer PO:" name="<%= Reel.CUSTOMER_PO_COLUMN %>" value="<%= content.getCustomerPO() %>" />
            <form:textfield label="Invoice #:" name="<%= Reel.INVOICE_NUM_COLUMN %>" value="<%= content.getInvoiceNum() %>" />
            <form:date_picker start="01/01/2014" name="<%= Reel.INVOICE_DATE_COLUMN %>" value="<%= content.getInvoiceDateString() %>" label="Invoice Date:" />
            <form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />
            <form:row_begin />
                <form:label name="" label="" />
                <form:buttonset_begin align="left" padding="0"/>
                    <% if(canEdit) { %>
                    <form:submit_inline button="save" waiting="true" name="save" action="update_reel_invoice" />
                    <% } %>
                <form:buttonset_end />
            <form:row_end />
        <% } %>
    <form:end />
<admin:box_end />

<admin:subtitle text="Reel Data" />
<admin:box_begin />
    <form:begin_multipart submit="<%= new Boolean(canEdit).toString() %>" name="edit" action="reels/process.jsp" />
        <form:info label="CTR #:" text="<%= content.getCTRNumber() %>" />
        <form:info label="CTR Date:" text="<%= content.getCTRDateString() %>" />
        <form:info label="CTR Posted:" text="<%= content.getCTRSentString() %>" />
        <% if(canEdit) { %>
		<form:file name="<%= Reel.CTR_FILE_COLUMN %>" label="CTR File:" />
        <% } %>
        <% if(content.getCTRFile() != null && !content.getCTRFile().equals("")) { %>
            <form:row_begin />
            <form:label label="Download CTR:"  />
            <form:content_begin />
                    <% tempURL = request.getContextPath() + content.getCompEntityDirectory() + "/" + URLEncoder.encode(content.getCTRFile()); %>
                    <admin:link external="true" text="[Download]" url="<%= tempURL %>" />      
                <form:content_end />
            <form:row_end />
            <% if(canEdit) { %>
            <form:row_begin />
            <form:label label="Delete CTR:"  />
            <form:content_begin />
                    <% String tempUrl = "reels/process.jsp?submit_action=delete_ctr&" + Reel.PARAM + "=" + content.getId(); %>
                    <form:linkbutton warning="true" url="<%= tempUrl %>" process="true" name="DELETE" />    
                <form:content_end />
            <form:row_end />
            <% } %>
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