<%@page import="com.reeltrack.reels.CableTechData"%>
<%@page import="com.reeltrack.customers.CustomerJob"%>
<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.Reel"%>
<%@ page import="java.net.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="cabinetMgr" class="com.reeltrack.file_cabinets.FileCabinetMgr" scope="request"/>
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" />
<% userLoginMgr.init(pageContext); %>
<% reelMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<%
boolean canEdit = false;
if(user.isUserType(RTUser.USER_TYPE_ECS) || user.isUserType(RTUser.USER_TYPE_MANAGEMENT)) {
    canEdit = true;
}

CompEntities contents = reelMgr.getReelsDataForBOM(user.getJobCode());


boolean canSubmit = true;
if(user.isUserType(RTUser.USER_TYPE_INVENTORY)) {
    canSubmit = false;
}
String bomFile = null;
if(request.getParameter("bom")!=null) {
    bomFile = request.getParameter("bom");
}
String dataSheets = null;
if(request.getParameter("dataSheets")!=null) {
    dataSheets = request.getParameter("dataSheets");
}

String tempUrl =""; //var for url expression
%>
<% dbResources.close(); %>
<html:begin />
<admin:title heading="Bill of Materials / Set Quantity Tracking / QRC Verification" text="" />

<% if(canSubmit) { %>
<%--
<admin:subtitle text="Upload File" />
<admin:box_begin />
	<form:begin_multipart submit="true" name="upload_bom_pdf" action="bill_of_materials/process.jsp" />
			<form:file label="File:" name="<%= CustomerJob.BOM_PDF_COLUMN %>" />
            <form:row_begin />
                <form:label name="" label="" />
                <form:buttonset_begin align="left" padding="0"/>
                        <form:submit_inline button="save" waiting="true" name="save" action="upload_bom_pdf" />
                <form:buttonset_end />
            <form:row_end />
			<form:hidden name="<%= CustomerJob.PARAM %>" value="<%= Integer.toString(user.getJobId()) %>" />
    <form:end />
<admin:box_end />
--%>
<admin:subtitle text="Bill of Materials" />
<admin:box_begin text="Bill of Materials" name="Bill_of_Materials" />
    <form:begin submit="true" name="upload_bom_pdf" action="bill_of_materials/process.jsp" />
            <% if(bomFile!=null) { %>
            <form:row_begin />
                <form:label name="" label="BOM Download:" />
                <form:buttonset_begin align="left" padding="0"/>
                        <a href="/reports/<%= bomFile %>">[Download]</a>
                <form:buttonset_end />
            <form:row_end />
            <% } else { %>
            <form:row_begin />
                <form:label name="" label="Generate BOM:" />
                <form:buttonset_begin align="left" padding="0"/>
                        <form:submit_inline button="save" waiting="true" name="SUBMIT" action="upload_bom_pdf" />
                <form:buttonset_end />
            <form:row_end />
            <form:hidden name="job_code" value="<%= user.getJobCode() %>" />
            <% } %>
    <form:end />

    <form:begin submit="true" name="upload_bom_pdf" action="bill_of_materials/process.jsp" />
            <% if(dataSheets!=null) { %>
            <form:row_begin />
                <form:label name="" label="Download Datasheets:" />
                <form:buttonset_begin align="left" padding="0"/>
                        <a href="/reports/<%= dataSheets %>">[Download]</a>
                <form:buttonset_end />
            <form:row_end />
            <% } else { %>
            <form:row_begin />
                <form:label name="" label="Download Datasheets:" />
                <form:buttonset_begin align="left" padding="0"/>
                        <form:submit_inline button="save" waiting="true" name="SUBMIT" action="zip_datasheets" />
                <form:buttonset_end />
            <form:row_end />
            <form:hidden name="job_code" value="<%= user.getJobCode() %>" />
            <% } %>
    <form:end />
<admin:box_end />
<% } %>

<% if(contents.howMany() > 0) { %>
    <admin:subtitle text="Customer Part Numbers" />
    <admin:box_begin text="Customer Part Numbers" name="Customer_Part_Numbers" />
        <listing:begin />
            <listing:header_begin />
                <listing:header_cell first="true" name="Cust P/n" />
                <listing:header_cell name="Description" />
                <listing:header_cell name="Qty Ordered" />
                <listing:header_cell name="# Reels" />
                <listing:header_cell name="Qty Tracking" />
                <listing:header_cell name="QRC Verification" />
                <listing:header_cell width="100" name="Data Sheet" />
                <listing:header_cell width="100" name="" />
            <listing:header_end />
            <% for(int i=0; i<contents.howMany(); i++) { %>
            <% Reel content = (Reel)contents.get(i); %>
            <% CableTechData techData = (CableTechData)content.getCompEntity(CableTechData.PARAM); %>
            <listing:row_begin row="<%= new Integer(i).toString() %>" />
                <listing:cell_begin />
                    <%= content.getCustomerPN() %>
                <listing:cell_end />
				<listing:cell_begin />
                    <%= content.getCableDescription() %>
                <listing:cell_end />
                <listing:cell_begin />
                    <%= content.getReelsOrderedForBOM() %>
                <listing:cell_end />
				<listing:cell_begin />
                    <%= content.getReelsCountForBOM() %>
                <listing:cell_end />
                <listing:cell_begin />
					<form:begin_inline submit="<%= new Boolean(canSubmit).toString() %>" action="bill_of_materials/process.jsp" name="update_usage_tracking" />
					   <% if(techData.getUsageTracking().equals("") || canEdit) { %>
							<form:select_begin onchange="submitInline(this.form);" name="<%= CableTechData.USAGE_TRACKING_COLUMN %>" />
						<% } else { %>
							<form:select_begin name="<%= CableTechData.USAGE_TRACKING_COLUMN %>" />
						<% } %>
							<form:option name="" value="" match="<%= techData.getUsageTracking() %>" />
							<form:option name="foot markers" value="<%= CableTechData.USAGE_FOOT_MARKERS %>" match="<%= techData.getUsageTracking() %>" />
							<form:option name="weight" value="<%= CableTechData.USAGE_WEIGHT %>" match="<%= techData.getUsageTracking() %>" />
							<form:option name="quantity pulled" value="<%= CableTechData.USAGE_QUANTITY_PULLED %>" match="<%= techData.getUsageTracking() %>" />
						<form:select_end />
						<form:hidden name="<%= Reel.PARAM %>" value="<%= Integer.toString(content.getId()) %>" />
						<form:hidden name="<%= CustomerJob.PARAM %>" value="<%= Integer.toString(user.getJobId()) %>" />
						<form:hidden name="submit_action" value="update_usage_tracking" />
					<form:end_inline />
                <listing:cell_end />
                <listing:cell_begin />
                    <form:begin_inline submit="<%= new Boolean(canSubmit).toString() %>" action="bill_of_materials/process.jsp" name="update_qrc_tracking" />
                       <% if(canEdit) { %>
                            <form:checkbox onchange="submitInline(this.form);" label="" name="<%= CableTechData.QRC_TRACKING_COLUMN %>" value="y" match="<%= techData.getQRCTracking() %>" />
                        <% } else { %>
                            <form:checkbox label="" name="<%= CableTechData.QRC_TRACKING_COLUMN %>" value="y" match="<%= techData.getQRCTracking() %>" />
                        <% } %>
                        <form:hidden name="<%= Reel.PARAM %>" value="<%= Integer.toString(content.getId()) %>" />
                        <form:hidden name="<%= CustomerJob.PARAM %>" value="<%= Integer.toString(user.getJobId()) %>" />
                        <form:hidden name="submit_action" value="update_qrc_tracking" />
                    <form:end_inline />
                <listing:cell_end />
				<listing:cell_begin />
					<form:begin_multipart_inline  action="bill_of_materials/process.jsp" name="upload_data_sheet" />
						<% if(canEdit || canSubmit) { %>
							<form:file_inline urldescription="false" name="<%= CableTechData.DATA_SHEET_FILE_COLUMN %>" label="" /><br />
			                <form:submit_inline  button="save" waiting="true" name="save" action="upload_data_sheet" />
						<% } %>
						<form:hidden name="<%= Reel.PARAM %>" value="<%= Integer.toString(content.getId()) %>" />
						<form:hidden name="<%= CustomerJob.PARAM %>" value="<%= Integer.toString(user.getJobId()) %>" />
					<form:end />
				<listing:cell_end />
				<listing:cell_begin />
					<% if(!techData.getDataSheetFile().equals("")) { %>
						<% String tempURL = request.getContextPath() + techData.getCompEntityDirectory() + "/" + URLEncoder.encode(techData.getDataSheetFile()); %>
						<form:linkbutton name="download" url="<%= tempURL %>" tooltip="download data sheet"/>
					<% } %>
				<listing:cell_end />

            <listing:row_end />
            <% } %>
        <listing:end />
    <admin:box_end />
<% } else { %>
    <admin:subtitle text="There are no part numbers." />
<% } %>
<admin:set_tabset url="bill_of_materials/_tabset_default.jsp" thispage="search.jsp" />
<html:end />
