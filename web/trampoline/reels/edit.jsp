<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.reeltrack.whlocations.*" %>
<%@ page import="com.monumental.trampoline.component.*" %>

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
<% userLoginMgr.init(pageContext); %>
<% reelMgr.init(pageContext,dbResources); %>
<% locationMgr.init(pageContext,dbResources); %>
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

WhLocation location = new WhLocation();
location.setCustomerId(user.getCustomerId());
CompEntities locations = locationMgr.searchWhLocation(location, WhLocation.NAME_COLUMN, true);

String tempURL; //var for url expression
%>
<% dbResources.close(); %>

<html:begin />
<% tempURL = content.getCrId() + " : " + content.getReelTag() + " : " + content.getCableDescription() + " : " + content.getStatus(); %>
<admin:title text="<%= tempURL %>" />
<notifier:show_message />

<admin:subtitle text="General Info" />
<admin:box_begin />
    <form:begin submit="true" name="edit" action="reels/process.jsp" />
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
     		<form:row_begin />
	            <form:label name="" label="Wharehouse<br />Location:" />
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
			<form:info label="Reel Tag:" text="<%= content.getReelTag() %>" />
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
			<form:info label="ECS P/N:" text="<%= content.getEcsPN() %>" />
			<form:info label="Manufacturer:" text="<%= content.getManufacturer() %>" />
			<form:row_begin />
	            <form:label name="" label="Has Markers:" />
	            <form:content_begin />
	            <form:select_begin name="<%= Reel.HAS_REEL_MARKERS_COLUMN %>" />
	            	<form:option name="No" value="n" match="<%= content.getHasReelMarkers() %>" />
	            	<form:option name="Yes" value="y" match="<%= content.getHasReelMarkers() %>" />
	            <form:select_end />
	            <form:content_end />
        	<form:row_end />
			<form:info label="Steel Reel Serial #:" text="<%= content.getSteelReelSerial() %>" />
			<form:info label="Received On:" text="<%= content.getReceivedOnDateString() %>" />
			<form:info label="Times Checked OUT:" text="<%= new Integer(content.getTimesCheckedOut()).toString() %>" />
			<form:info label="Times Checked IN:" text="<%= new Integer(content.getTimesCheckedIn()).toString() %>" />
			<form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />			
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
					<form:submit_inline button="save" waiting="true" name="save" action="update" />
				<form:buttonset_end />
			<form:row_end />
    <form:end />
<admin:box_end />

<admin:subtitle text="Shipping Info" />
<admin:box_begin />
    <form:begin submit="true" name="edit" action="reels/process.jsp" />
    		<form:row_begin />
	            <form:label name="" label="Carrier:" />
	            <form:content_begin />
	            <form:select_begin name="<%= Reel.CARRIER_COLUMN %>" />
	            	<form:option name="None" value="" match="<%= content.getCarrier() %>" />
	                <% String[] carrierList  = content.getCarrierList(); %>
	                <% for(int x=0; x<carrierList.length; x++) { %>
	                    <form:option name="<%= carrierList[x] %>" value="<%= carrierList[x] %>" match="<%= content.getCarrier() %>" />
	                <% } %>
	            <form:select_end />
	            <form:content_end />
        	<form:row_end />
        	<form:textfield label="Tracking PRO #:" name="<%= Reel.TRACKING_PRO_COLUMN %>" value="<%= content.getTrackingPRO() %>" />
        	<form:textfield label="Packing List #:" name="<%= Reel.PACKING_LIST_COLUMN %>" value="<%= content.getPackingList() %>" />
        	<form:date_picker name="<%= Reel.PROJECTED_SHIPPING_DATE_COLUMN %>" value="<%= content.getProjectedShippingDateString() %>" label="Projected Shipping<br />Date:" />
			<form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />			
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
					<form:submit_inline button="save" waiting="true" name="save" action="update_shipping" />
				<form:buttonset_end />
			<form:row_end />
    <form:end />
<admin:box_end />

<admin:subtitle text="Receiving Info" />
<admin:box_begin />
    <form:begin submit="true" name="edit" action="reels/process.jsp" />
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
					<form:submit_inline button="save" waiting="true" name="save" action="update_receiving" />
				<form:buttonset_end />
			<form:row_end />
    <form:end />
<admin:box_end />

<admin:set_tabset url="reels/_tabset_manage.jsp" thispage="edit.jsp" content_id_for_tabset="<%= contid %>"/>
<html:end />