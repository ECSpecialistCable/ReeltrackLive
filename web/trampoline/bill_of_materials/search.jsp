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
if(user.isUserType(RTUser.USER_TYPE_ECS)) {
    canEdit = true;
}

CompEntities contents = reelMgr.getReelsDataForBOM(user.getJobCode());

boolean canSubmit = true;
if(user.isUserType(RTUser.USER_TYPE_INVENTORY)) {
    canSubmit = false;
}

String tempUrl =""; //var for url expression
%>
<% dbResources.close(); %>
<html:begin />
<admin:title text="Bill of Materials" />

<% if(canSubmit) { %>
<admin:subtitle text="Uplaod File" />
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
<% } %>

<% if(contents.howMany() > 0) { %>
    <admin:subtitle text="Customer Part Numbers" />
    <admin:box_begin color="false" />
        <listing:begin />
            <listing:header_begin />
                <listing:header_cell first="true" name="Cust P/n" />
                <listing:header_cell name="Description" />
                <listing:header_cell width="50" name="Reels" />
                <listing:header_cell width="50" name="Qty" />
                <listing:header_cell width="100" name="Usage Tracking" />
                <listing:header_cell width="50" name="QRC" />
                <listing:header_cell width="100" colspan="2" name="Data Sheet" />
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
                    <%= content.getReelsCountForBOM() %>
                <listing:cell_end />
				<listing:cell_begin />
                    <%= content.getReelsOrderedForBOM() %>
                <listing:cell_end />
                <listing:cell_begin />
					<form:begin_inline submit="<%= new Boolean(canSubmit).toString() %>" action="bill_of_materials/process.jsp" name="update_usage_tracking" />
					   <% if(techData.getUsageTracking().equals("") || canEdit) { %>
							<form:select_begin onchange="test" name="<%= CableTechData.USAGE_TRACKING_COLUMN %>" />
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
                            <form:checkbox onclick="test" label="" name="<%= CableTechData.QRC_TRACKING_COLUMN %>" value="y" match="<%= techData.getQRCTracking() %>" />
                        <% } else { %>
                            <form:checkbox label="" name="<%= CableTechData.QRC_TRACKING_COLUMN %>" value="y" match="<%= techData.getQRCTracking() %>" />
                        <% } %>
                        <form:hidden name="<%= Reel.PARAM %>" value="<%= Integer.toString(content.getId()) %>" />
                        <form:hidden name="<%= CustomerJob.PARAM %>" value="<%= Integer.toString(user.getJobId()) %>" />
                        <form:hidden name="submit_action" value="update_qrc_tracking" />
                    <form:end_inline />
                <listing:cell_end />
				<listing:cell_begin />
					<form:begin_multipart  action="bill_of_materials/process.jsp" name="upload_data_sheet" />
						<% if(canEdit && canSubmit) { %>
							<form:file_inline urldescription="false" name="<%= CableTechData.DATA_SHEET_FILE_COLUMN %>" label="" />
			                <form:submit_inline  button="save" waiting="true" name="save" action="upload_data_sheet" />
						<% } %>						
						<form:hidden name="<%= Reel.PARAM %>" value="<%= Integer.toString(content.getId()) %>" />
						<form:hidden name="<%= CustomerJob.PARAM %>" value="<%= Integer.toString(user.getJobId()) %>" />
					<form:end />					
				<listing:cell_end />
				<listing:cell_begin />
					<% if(!techData.getDataSheetFile().equals("")) { %>
						<% String tempURL = request.getContextPath() + techData.getCompEntityDirectory() + "/" + URLEncoder.encode(techData.getDataSheetFile()); %>
						<admin:link external="true" text="[Download]" url="<%= tempURL %>" />
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