<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.reeltrack.whlocations.*" %>
<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.picklists.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" />
<jsp:useBean id="locationMgr" class="com.reeltrack.whlocations.WhLocationMgr" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<jsp:useBean id="picklistMgr" class="com.reeltrack.picklists.PickListMgr" />
<% picklistMgr.init(pageContext,dbResources); %>
<% userLoginMgr.init(pageContext); %>
<% reelMgr.init(pageContext,dbResources); %>
<% locationMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<%
boolean canEdit = false;
boolean canEditRT = false;
if(user.isUserType(RTUser.USER_TYPE_ECS)) {
    canEdit = true;
}
if(user.isUserType(RTUser.USER_TYPE_MANAGEMENT)) {
	canEditRT = false;
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

CableTechData techData = reelMgr.getCableTechData(content);

WhLocation location = new WhLocation();
location.setCustomerId(user.getCustomerId());
CompEntities locations = locationMgr.searchWhLocation(location, WhLocation.NAME_COLUMN, true);

String[] carrierList = reelMgr.getCarriers();

String tempURL; //var for url expression

boolean canSubmit = true;
if(user.isUserType(RTUser.USER_TYPE_INVENTORY)) {
	canSubmit = false;
}

boolean canSubmitSR = true;
if(!user.isUserType(RTUser.USER_TYPE_ECS)) {
	canSubmitSR = false;
}
/*
if(!canSubmit) {
	canSubmitSR = false;
} else {
	if(!user.isUserType(RTUser.USER_TYPE_ECS)) {
		canSubmitSR = false;
		if(content.getStatus().equals(Reel.STATUS_ORDERED) || content.getStatus().equals(Reel.STATUS_SHIPPED)) {
			canSubmitSR = true;
		}
	}
}
*/
PickList picklist = new PickList();
if(content.getPickListId()!=0) {
    picklist.setId(content.getPickListId());
    picklist = (PickList)picklistMgr.getPickList(picklist);
}

%>
<% dbResources.close(); %>

<html:begin />

<%
tempURL = content.getCrId() + " : " + content.getReelTag() + " : " + content.getCableDescription() + " : " + content.getStatus();
if(content.getStatus().equals(Reel.STATUS_IN_WHAREHOUSE)) {
    tempURL = content.getCrId() + " : " + content.getReelTag() + " : " + content.getCableDescription() + " : " + content.getStatus() + " - " + content.getWharehouseLocation();
} else if(content.getStatus().equals(Reel.STATUS_CHECKED_OUT)) {
    tempURL = content.getCrId() + " : " + content.getReelTag() + " : " + content.getCableDescription() + " : " + content.getStatus() + " - " + picklist.getForeman();
}
%>
<notifier:show_message />

<admin:title heading="Reel Page" text="<span style='color:red;'>CRID: Reel Tag: Description: Status</span>" />
<h2 class="adminTitle"><%= tempURL %></h2>

<admin:subtitle text="General Info" />
<admin:box_begin text="General Info" name="General_Info"/>
    <form:begin submit="<%= new Boolean(canSubmit).toString() %>" name="edit" action="reels/process.jsp" />
    	<% if(canEdit) { %>
    		<form:row_begin />
	            <form:label name="" label="Status:" />
	            <form:content_begin />
	            <form:select_begin name="<%= Reel.STATUS_COLUMN %>" />
	                <% String[] statusList  = content.getStatusList(); %>
	                <% for(int x=0; x<statusList.length; x++) { %>
	                    <form:option name="<%= statusList[x] %>" value="<%= statusList[x] %>" match="<%= content.getStatus() %>" />
	                <% } %>
	            <form:select_end />
	            <form:content_end />
        	<form:row_end />
        <% } else { %>
        	<form:info label="Status:" text="<%= content.getStatus() %>" />
        <% } %>
        <% if(canEdit) { %>
        	<form:textfield label="CRID:" name="<%= Reel.CR_ID_COLUMN %>" value="<%= Integer.toString(content.getCrId()) %>" />
     	<% } %>
     		<form:row_begin />
	            <form:label name="" label="Warehouse<br />Location:" />
	            <form:content_begin />
	            <form:select_begin name="<%= Reel.WHAREHOUSE_LOCATION_COLUMN %>" />
	            	<form:option name="None" value="<%= WhLocation.LOCATION_NONE %>" match="<%= content.getWharehouseLocation() %>" />
	                <% for(int x=0; x<locations.howMany(); x++) { %>
	                	<% location = (WhLocation)locations.get(x); %>
	                    <form:option name="<%= location.getName() %>" value="<%= location.getName() %>" match="<%= content.getWharehouseLocation() %>" />
	                <% } %>
	            <form:select_end />
	            <form:content_end />
        	<form:row_end />
			<form:info label="Reel Type:" text="<%= content.getReelType() %>" />
			<% if(canEdit || canEditRT) { %>
				<form:textfield label="Reel Tag:" name="<%= Reel.REEL_TAG_COLUMN %>" value="<%= content.getReelTag() %>" />
			<% } else { %>
				<form:info label="Reel Tag:" text="<%= content.getReelTag() %>" />
			<% } %>
			<% if(canEdit) { %>
				<form:textfield label="Cable Description:" name="<%= Reel.CABLE_DESCRIPTION_COLUMN %>" value="<%= content.getCableDescription() %>" />
			<% } else { %>
				<form:info label="Cable Description:" text="<%= content.getCableDescription() %>" />
			<% } %>
			<% if(canEdit) { %>
				<form:textfield label="Customer P/N:" name="<%= Reel.CUSTOMER_PN_COLUMN %>" value="<%= content.getCustomerPN() %>" />
			<% } else { %>
				<form:info label="Customer P/N:" text="<%= content.getCustomerPN() %>" />
			<% } %>
			<%--
			<% if(canEdit) { %>
			<form:info label="ECS PO:" text="<%= content.getReceivedOnDateString() %>" />
			<% } %>
			--%>
			<form:info label="ECS P/N:" text="<%= content.getEcsPN() %>" />
			<% if(canEdit) { %>
				<form:textfield label="Manufacturer:" name="<%= Reel.MANUFACTURER_COLUMN %>" value="<%= content.getManufacturer() %>" />
			<% } else { %>
				<form:info label="Manufacturer:" text="<%= content.getManufacturer() %>" />
			<% } %>
			<%--
			<% if(canEdit) { %>
			<form:row_begin />
	            <form:label name="" label="Has Markers:" />
	            <form:content_begin />
	            <form:select_begin name="<%= Reel.HAS_REEL_MARKERS_COLUMN %>" />
	            	<form:option name="No" value="n" match="<%= content.getHasReelMarkers() %>" />
	            	<form:option name="Yes" value="y" match="<%= content.getHasReelMarkers() %>" />
	            <form:select_end />
	            <form:content_end />
        	<form:row_end />
        	<% } else { %>
        		<form:info label="Has Markers:" text="<%= content.getHasReelMarkers() %>" />
        	<% } %>
        	--%>
        	<% if(canEdit) { %>
				<% if(techData.getUsageTracking().equals(CableTechData.USAGE_FOOT_MARKERS)) { %>
					<form:textfield label="Orig Top Ft Mark:" pixelwidth="40" name="<%= Reel.ORIG_TOP_FOOT_COLUMN %>" value="<%= new Integer(content.getOrigTopFoot()).toString() %>" />
					<form:textfield label="Current Top Ft Mark:" pixelwidth="40" name="<%= Reel.TOP_FOOT_COLUMN %>" value="<%= new Integer(content.getTopFoot()).toString() %>" />
				<% } %>
			<% } else { %>
	            <% if(techData.getUsageTracking().equals(CableTechData.USAGE_FOOT_MARKERS)) { %>
					<form:info label="Orig Top Ft Mark:" text="<%= new Integer(content.getOrigTopFoot()).toString() %>" />
            		<form:info label="Current Top Ft Mark:" text="<%= new Integer(content.getTopFoot()).toString() %>" />
            	<% } %>
			<% } %>

			<form:textfield label="Steel Reel Serial #:" name="<%= Reel.STEEL_REEL_SERIAL_COLUMN %>" value="<%= content.getSteelReelSerial() %>" />
			<form:info label="Received On:" text="<%= content.getReceivedOnDateString() %>" />
			<form:info label="Times Checked OUT:" text="<%= new Integer(content.getTimesCheckedOut()).toString() %>" />
			<form:info label="Times Checked IN:" text="<%= new Integer(content.getTimesCheckedIn()).toString() %>" />
			<form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
					<% if(canEdit || canSubmit) { %>
					<form:submit_inline button="save" waiting="true" name="save" action="update" />
					<% } %>
				<form:buttonset_end />
			<form:row_end />
    <form:end />
<admin:box_end />

<admin:subtitle text="Shipping Info" />
<admin:box_begin text="Shipping Info" name="Shipping_Info" open="false" />
    <form:begin submit="<%= new Boolean(canSubmitSR).toString() %>" name="edit" action="reels/process.jsp" />
    		<form:row_begin />
	            <form:label name="" label="Carrier:" />
	            <form:content_begin />
	            <form:select_begin name="<%= Reel.CARRIER_COLUMN %>" />
	            	<form:option name="None" value="" match="<%= content.getCarrier() %>" />
	                <%--String[] carrierList  = content.getCarrierList(); --%>
	                <% for(int x=0; x<carrierList.length; x++) { %>
	                    <form:option name="<%= carrierList[x] %>" value="<%= carrierList[x] %>" match="<%= content.getCarrier() %>" />
	                <% } %>
	            <form:select_end />
	            <form:content_end />
        	<form:row_end />
			<form:textfield label="Other Carrier:" name="other_carrier" />
        	<form:textfield label="Tracking PRO #:" name="<%= Reel.TRACKING_PRO_COLUMN %>" value="<%= content.getTrackingPRO() %>" />
        	<form:textfield label="Packing List #:" name="<%= Reel.PACKING_LIST_COLUMN %>" value="<%= content.getPackingList() %>" />
        	<form:date_picker name="<%= Reel.PROJECTED_SHIPPING_DATE_COLUMN %>" value="<%= content.getProjectedShippingDateString() %>" label="Projected Shipping<br />Date:" />
        	<form:date_picker name="<%= Reel.SHIPPING_DATE_COLUMN %>" value="<%= content.getShippingDateString() %>" label="Shipped<br />Date:" />
			<form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
				<% if(canSubmitSR) { %>
					<form:submit_inline button="save" waiting="true" name="save" action="update_shipping" />
				<% } %>
				<form:buttonset_end />
			<form:row_end />
    <form:end />
<admin:box_end />

<admin:subtitle text="Receiving Info" />
<admin:box_begin text="Receiving Info" name="Receiving_Info" open="false" />
    <form:begin submit="<%= new Boolean(canSubmitSR).toString() %>" name="edit" action="reels/process.jsp" />
    		<form:row_begin />
	            <form:label name="" label="Issue:" />
	            <form:content_begin />
	            <form:select_begin name="<%= Reel.RECEIVING_ISSUE_COLUMN %>" />
	            	<form:option name="None" value="" match="<%= content.getReceivingIssue() %>" />
	                <% String[] issueList  = content.getReceivingIssueList(); %>
	                <% for(int x=0; x<issueList.length; x++) { %>
	                    <form:option name="<%= issueList[x] %>" value="<%= issueList[x] %>" match="<%= content.getReceivingIssue() %>" />
	                <% } %>
	            <form:select_end />
	            <form:content_end />
        	<form:row_end />
        	<form:textarea name="<%= Reel.RECEIVING_NOTE_COLUMN %>" rows="5" label="Note:" value="<%= content.getReceivingNote() %>" />
        	<form:row_begin />
	            <form:label name="" label="Disposition:" />
	            <form:content_begin />
	            <form:select_begin name="<%= Reel.RECEIVING_DISPOSITION_COLUMN %>" />
	            	<form:option name="None" value="" match="<%= content.getReceivingDisposition() %>" />
	                <% String[] dispList  = content.getDispositionList(); %>
	                <% for(int x=0; x<dispList.length; x++) { %>
	                    <form:option name="<%= dispList[x] %>" value="<%= dispList[x] %>" match="<%= content.getReceivingDisposition() %>" />
	                <% } %>
	            <form:select_end />
	            <form:content_end />
        	<form:row_end />
        	<form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
				<% if(canSubmitSR) { %>
					<form:submit_inline button="save" waiting="true" name="save" action="update_receiving" />
				<% } %>
				<form:buttonset_end />
			<form:row_end />
    <form:end />
<admin:box_end />

<admin:set_tabset url="reels/_tabset_manage.jsp" thispage="edit.jsp" content_id_for_tabset="<%= contid %>"/>
<html:end />
