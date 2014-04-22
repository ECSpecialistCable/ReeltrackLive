<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.reeltrack.whlocations.*" %>
<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.drivers.*" %>
<%@ page import="com.reeltrack.foremans.*" %>
<%@ page import="com.reeltrack.customers.*" %>
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
<jsp:useBean id="customerMgr" class="com.reeltrack.customers.CustomerMgr" />
<jsp:useBean id="driverMgr" class="com.reeltrack.drivers.DriverMgr" scope="request"/>
<jsp:useBean id="foremanMgr" class="com.reeltrack.foremans.ForemanMgr" scope="request"/>
<jsp:useBean id="picklistMgr" class="com.reeltrack.picklists.PickListMgr" />
<% userLoginMgr.init(pageContext); %>
<% reelMgr.init(pageContext,dbResources); %>
<% locationMgr.init(pageContext,dbResources); %>
<% customerMgr.init(pageContext,dbResources); %>
<% driverMgr.init(pageContext,dbResources); %>
<% foremanMgr.init(pageContext,dbResources); %>
<% picklistMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
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

Customer customer = new Customer();
customer.setId(user.getCustomerId());
customer = customerMgr.getCustomer(customer);

CustomerJob job = new CustomerJob();
job.setId(user.getJobId());
job = customerMgr.getCustomerJob(job);

WhLocation location = new WhLocation();
location.setCustomerId(user.getCustomerId());
CompEntities locations = locationMgr.searchWhLocation(location, WhLocation.NAME_COLUMN, true);

Driver driver = new Driver();
driver.setCustomerId(user.getCustomerId());
CompEntities drivers = driverMgr.searchDriver(driver, Driver.NAME_COLUMN, true);

Foreman foreman = new Foreman();
foreman.setCustomerId(user.getCustomerId());
CompEntities foremans = foremanMgr.searchForeman(foreman, Foreman.NAME_COLUMN, true);

PickList picklist = new PickList();
if(content.getPickListId()!=0) {
    picklist.setId(content.getPickListId());
    picklist = (PickList)picklistMgr.getPickList(picklist);
}

Reel rtReel = (Reel)session.getAttribute("RT");
Reel plReel = (Reel)session.getAttribute("PL");
boolean reelsMatch = false;
if(rtReel!=null && plReel!=null) {
	if(rtReel.getId() == plReel.getId() && rtReel.getId() == content.getId() && rtReel.getJobCode().equals(content.getJobCode())) {
		//if(content.getStatus().equals(Reel.STATUS_IN_WHAREHOUSE) ) {
			reelsMatch = true;
		//}
	}
}

String tempURL; //var for url expression
%>
<%
boolean canEdit = false;
if(user.isUserType(RTUser.USER_TYPE_ECS)) {
    canEdit = true;
}
//canEdit = false;

String[] carrierList = reelMgr.getCarriers();
%>

<% dbResources.close(); %>

<html:begin />
<% tempURL = content.getCrId() + " : " + content.getReelTag() + " : " + content.getCableDescription() + " : " + content.getStatus(); %>
<admin:title text="<%= tempURL %>" />
<notifier:show_message />

<% if(canEdit) { %>
	<admin:box_begin />
		<form:begin submit="true" name="delete_reel" action="reels/process.jsp" />
	        <form:row_begin />
				<form:label name="" label="Delete Reel:" />
		        <form:content_begin />
					<% tempURL = "reels/process.jsp?submit_action=delete_reel&" + Reel.PARAM + "=" + content.getId(); %>
					<form:linkbutton warning="true" url="<%= tempURL %>" process="true" name="Delete" />
	        <form:content_end />
        <form:row_end />
		<form:end />
	<admin:box_end />
<% } %>

<% if(rtReel!=null || plReel!=null) { %>
<admin:subtitle text="Scanned Reel" />
<admin:box_begin />
    <form:begin submit="false" name="nothing" action="#" />
<% if(rtReel!=null) { %>
	<form:info label="Reel Tag:" text="<%= rtReel.getReelTag() %>" />
	<form:info label="CRID:" text="<%= Integer.toString(rtReel.getCrId()) %>" />
<% } %>
<% if(plReel!=null) { %>
	<form:info label="Pick List:" text="<%= plReel.getReelTag() %>" />
	<form:info label="CRID:" text="<%= Integer.toString(plReel.getCrId()) %>" />
<% } %>
<form:end />
<admin:box_end />
<% } %>

<% if(content.getStatus().equals(Reel.STATUS_ORDERED)) { %>
<admin:subtitle text="Mark Reel as Shipped" />
<admin:box_begin />
	<form:begin submit="true" name="stage" action="reels/process.jsp" />
        <form:info label="Ordered Qty:" text="<%= new Integer(content.getOrderedQuantity()).toString() %>" />
		<form:textfield pixelwidth="40" label="Shipped Qty:" name="<%= Reel.SHIPPED_QUANTITY_COLUMN %>" value="<%= new Integer(content.getShippedQuantity()).toString() %>" />
        <% if(canEdit) { %>
            <form:date_picker name="<%= Reel.PROJECTED_SHIPPING_DATE_COLUMN %>" value="<%= content.getProjectedShippingDateString() %>" label="Projected Shipping<br />Date:" />
            <form:date_picker name="<%= Reel.SHIPPING_DATE_COLUMN %>" value="<%= content.getShippingDateString() %>" label="Shipped<br />Date:" />
        <% } else { %>
            <form:info label="Projected Shipping<br />Date:" text="<%= content.getProjectedShippingDateString() %>" />
            <form:info label="Shipped<br />Date:" text="<%= content.getShippingDateString() %>" />
        <% } %>
        <form:row_begin />
        <form:label name="" label="Carrier:" />
        <form:content_begin />
        <form:select_begin name="<%= Reel.CARRIER_COLUMN %>" />
            <form:option name="None" value="" match="<%= content.getCarrier() %>" />
            <% //String[] carrierList  = content.getCarrierList(); %>
            <% for(int x=0; x<carrierList.length; x++) { %>
                <form:option name="<%= carrierList[x] %>" value="<%= carrierList[x] %>" match="<%= content.getCarrier() %>" />
            <% } %>
        <form:select_end />
        <form:content_end />
        <form:row_end />
        <form:textfield label="Other Carrier:" name="other_carrier" />
        <form:textfield label="Tracking PRO #:" name="<%= Reel.TRACKING_PRO_COLUMN %>" value="<%= content.getTrackingPRO() %>" />
        <form:textfield label="Packing List #:" name="<%= Reel.PACKING_LIST_COLUMN %>" value="<%= content.getPackingList() %>" />        
        <form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(content.getId()).toString() %>" />
        <form:row_begin />
		<form:label name="" label="" />
		<form:buttonset_begin align="left" padding="0"/>
			<form:submit_inline button="save" waiting="true" name="Mark Shipped" action="mark_shipped" />
		<form:buttonset_end />
		<form:row_end />
    <form:end />
<admin:box_end />
<% } %>

<% if(content.getStatus().equals(Reel.STATUS_ORDERED) || content.getStatus().equals(Reel.STATUS_SHIPPED)) { %>
<admin:subtitle text="Mark Reel as Received" />
        <admin:box_begin />
            <form:begin submit="true" name="receive" action="reels/process.jsp" />
                <form:info label="Shipped<br />Date:" text="<%= content.getShippingDateString() %>" />
                <form:info label="Shipped Qty:" text="<%= new Integer(content.getShippedQuantity()).toString() %>" />
                <form:textfield label="Tracking PRO #:" name="<%= Reel.TRACKING_PRO_COLUMN %>" value="<%= content.getTrackingPRO() %>" />
                <form:textfield label="Packing List #:" name="<%= Reel.PACKING_LIST_COLUMN %>" value="<%= content.getPackingList() %>" />
                <form:textfield label="Steel Reel Serial #:" name="<%= Reel.STEEL_REEL_SERIAL_COLUMN %>" value="<%= content.getSteelReelSerial() %>" />
                <form:textfield pixelwidth="40" label="Received Qty:" name="<%= Reel.RECEIVED_QUANTITY_COLUMN %>" value="<%= new Integer(content.getReceivedQuantity()).toString() %>" />
                <%--
                <form:textfield pixelwidth="40" label="Bottom Ft:" name="<%= Reel.BOTTOM_FOOT_COLUMN %>" value="<%= new Integer(content.getBottomFoot()).toString() %>" />
                <form:row_end />
                <form:row_begin />
                    <form:label name="" label="Bottom Foot Not Visible?:" />
                    <form:content_begin />      
                    <form:checkbox label="" name="<%= Reel.BOTTOM_FOOT_NOT_VISIBLE_COLUMN %>" value="y" match="<%= content.getBottomFootNotVisible() %>" />       
                    <form:content_end />                
                <form:row_end />
                --%>

                <% if(techData.getUsageTracking().equals(CableTechData.USAGE_FOOT_MARKERS)) { %>
                    <form:textfield pixelwidth="40" label="Orig Top Ft:" name="<%= Reel.ORIG_TOP_FOOT_COLUMN %>" value="<%= new Integer(content.getOrigTopFoot()).toString() %>" />
                <% } %>

                <% if(techData.getUsageTracking().equals(CableTechData.USAGE_WEIGHT)) { %>
                    <form:textfield pixelwidth="40" label="Received lbs:" name="<%= Reel.RECEIVED_WEIGHT_COLUMN %>" value="<%= new Integer(content.getReceivedWeight()).toString() %>" />
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
	                    <% String[] dispList  = content.getDispositionList(); %>
	                    <% for(int x=0; x<dispList.length; x++) { %>
	                        <form:option name="<%= dispList[x] %>" value="<%= dispList[x] %>" match="<%= content.getReceivingDisposition() %>" />
	                    <% } %>
	                <form:select_end />
	                <form:content_end />
                <form:row_end />
                <form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(content.getId()).toString() %>" />        
                <form:row_begin />
                <form:label name="" label="" />
                <form:buttonset_begin align="left" padding="0"/>
                    <form:submit_inline button="save" waiting="true" name="Mark Received / Refused" action="mark_received" />
                <form:buttonset_end />
                <form:row_end />
            <form:end />
        <admin:box_end />
<% } %>

<%
boolean showStageAndCheckout = true;
if(job.getScansMustMatch().equals("y") && !reelsMatch) {
    showStageAndCheckout = false;
}
%>
<% if(showStageAndCheckout) { %>
    <% if(content.getStatus().equals(Reel.STATUS_IN_WHAREHOUSE)) { %>
    <admin:subtitle text="Stage Reel" />
    <admin:box_begin />
    	<form:begin submit="true" name="stage" action="reels/process.jsp" />
				<% if(picklist.getId()!=0) { %>
					<form:info label="Pick List:" text="<%= picklist.getName() %>" />
				<% } %>
                <form:row_begin />
                    <form:label name="" label="Checked OUT to:" />
                    <form:content_begin />
                    <form:select_begin name="<%= PickList.FOREMAN_COLUMN %>" />
                        <form:option name="None" value="" match="<%= picklist.getForeman() %>" />
                        <% for(int f=0; f<foremans.howMany(); f++) { %>
                            <% foreman = (Foreman)foremans.get(f); %>
                            <form:option name="<%= foreman.getName() %>" value="<%= foreman.getName() %>" match="<%= picklist.getForeman() %>" />
                        <% } %>
                    <form:select_end />
                    <form:content_end />
                <form:row_end />
                <form:row_begin />
                    <form:label name="" label="Driver:" />
                    <form:content_begin />
                    <form:select_begin name="<%= PickList.DRIVER_COLUMN %>" />
                        <form:option name="None" value="" match="<%= picklist.getDriver() %>" />
                        <% for(int f=0; f<drivers.howMany(); f++) { %>
                            <% driver = (Driver)drivers.get(f); %>
                            <form:option name="<%= driver.getName() %>" value="<%= driver.getName() %>" match="<%= picklist.getDriver() %>" />
                        <% } %>
                    <form:select_end />
                    <form:content_end />
                <form:row_end />
                <form:hidden name="<%= PickList.PARAM %>" value="<%= new Integer(picklist.getId()).toString() %>" />
            
            <form:info label="On Reel Qty:" text="<%= new Integer(content.getOnReelQuantity()).toString() %>" />
            <% if(techData.getUsageTracking().equals(CableTechData.USAGE_FOOT_MARKERS)) { %>
                <form:textfield label="Top Foot #:" pixelwidth="40" name="<%= Reel.TOP_FOOT_COLUMN %>" value="<%= new Integer(content.getTopFoot()).toString() %>" />
            <% } %>
            <% if(techData.getUsageTracking().equals(CableTechData.USAGE_WEIGHT)) { %>
                <form:textfield label="Current lbs:" pixelwidth="40" name="<%= Reel.CURRENT_WEIGHT_COLUMN %>" value="<%= new Integer(content.getCurrentWeight()).toString() %>" />
            <% } %>
            <form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(content.getId()).toString() %>" />
            <form:row_begin />
    		<form:label name="" label="" />
    		<form:buttonset_begin align="left" padding="0"/>
    			<form:submit_inline button="save" waiting="true" name="STAGE" action="mark_staged" />
    		<form:buttonset_end />
    		<form:row_end />
        <form:end />
    <admin:box_end />
    <% } %>

    <% if(content.getStatus().equals(Reel.STATUS_IN_WHAREHOUSE) || content.getStatus().equals(Reel.STATUS_STAGED)) { %>
    <admin:subtitle text="Check OUT Reel" />
    <admin:box_begin />
    	<form:begin submit="true" name="checkout" action="reels/process.jsp" />
				<% if(picklist.getId()!=0) { %>
					<form:info label="Pick List:" text="<%= picklist.getName() %>" />
				<% } %>
                <form:row_begin />
                    <form:label name="" label="Checked OUT to:" />
                    <form:content_begin />
                    <form:select_begin name="<%= PickList.FOREMAN_COLUMN %>" />
                        <form:option name="None" value="" match="<%= picklist.getForeman() %>" />
                        <% for(int f=0; f<foremans.howMany(); f++) { %>
                            <% foreman = (Foreman)foremans.get(f); %>
                            <form:option name="<%= foreman.getName() %>" value="<%= foreman.getName() %>" match="<%= picklist.getForeman() %>" />
                        <% } %>
                    <form:select_end />
                    <form:content_end />
                <form:row_end />
                <form:row_begin />
                    <form:label name="" label="Driver:" />
                    <form:content_begin />
                    <form:select_begin name="<%= PickList.DRIVER_COLUMN %>" />
                        <form:option name="None" value="" match="<%= picklist.getDriver() %>" />
                        <% for(int f=0; f<drivers.howMany(); f++) { %>
                            <% driver = (Driver)drivers.get(f); %>
                            <form:option name="<%= driver.getName() %>" value="<%= driver.getName() %>" match="<%= picklist.getDriver() %>" />
                        <% } %>
                    <form:select_end />
                    <form:content_end />
                <form:row_end />
                <form:hidden name="<%= PickList.PARAM %>" value="<%= new Integer(picklist.getId()).toString() %>" />
            <form:info label="On Reel Qty:" text="<%= new Integer(content.getOnReelQuantity()).toString() %>" />
            
            <% if(techData.getUsageTracking().equals(CableTechData.USAGE_FOOT_MARKERS)) { %>
                <form:textfield label="Top Foot #:" pixelwidth="40" name="<%= Reel.TOP_FOOT_COLUMN %>" value="<%= new Integer(content.getTopFoot()).toString() %>" />
            <% } %>
            <% if(techData.getUsageTracking().equals(CableTechData.USAGE_WEIGHT)) { %>
                <form:textfield label="Current lbs:" pixelwidth="40" name="<%= Reel.CURRENT_WEIGHT_COLUMN %>" value="<%= new Integer(content.getCurrentWeight()).toString() %>" />
            <% } %>

            <form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(content.getId()).toString() %>" />
            <form:row_begin />
    		<form:label name="" label="" />
    		<form:buttonset_begin align="left" padding="0"/>
    			<form:submit_inline button="save" waiting="true" name="CHECKOUT" action="mark_checkedout" />
    		<form:buttonset_end />
    		<form:row_end />
        <form:end />
    <admin:box_end />
    <% } %>
<% } %>

<% if(content.getStatus().equals(Reel.STATUS_IN_WHAREHOUSE)) { %>
<admin:subtitle text="Mark Reel as Complete" />
<admin:box_begin />
	<form:begin submit="true" name="complete" action="reels/process.jsp" />
        <form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(content.getId()).toString() %>" />
        <form:row_begin />
		<form:label name="" label="" />
		<form:buttonset_begin align="left" padding="0"/>
			<form:submit_inline button="save" waiting="true" name="Mark Complete" action="mark_complete" />
		<form:buttonset_end />
		<form:row_end />
    <form:end />
<admin:box_end />
<% } %>

<% if(content.getStatus().equals(Reel.STATUS_COMPLETE)) { %>
<admin:subtitle text="Mark Reel as Scrapped" />
<admin:box_begin />
	<form:begin submit="true" name="scrapped" action="reels/process.jsp" />
        <form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(content.getId()).toString() %>" />
        <form:row_begin />
		<form:label name="" label="" />
		<form:buttonset_begin align="left" padding="0"/>
			<form:submit_inline button="save" waiting="true" name="Mark Scrapped" action="mark_scrapped" />
		<form:buttonset_end />
		<form:row_end />
    <form:end />
<admin:box_end />
<% } %>

<% if(content.getStatus().equals(Reel.STATUS_CHECKED_OUT)) { %>
<admin:subtitle text="Check IN Reel" />
<admin:box_begin />
	<form:begin submit="true" name="checkout" action="reels/process.jsp" />
		<% if(techData.getUsageTracking().equals(CableTechData.USAGE_FOOT_MARKERS)) { %>
            <form:textfield label="Top Foot #:" pixelwidth="40" name="<%= Reel.TOP_FOOT_COLUMN %>" value="<%= new Integer(content.getTopFoot()).toString() %>" />
        <% } %>
        <% if(techData.getUsageTracking().equals(CableTechData.USAGE_WEIGHT)) { %>
            <form:textfield label="Current lbs:" pixelwidth="40" name="<%= Reel.CURRENT_WEIGHT_COLUMN %>" value="<%= new Integer(content.getCurrentWeight()).toString() %>" />
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
        <form:row_begin />
        <form:label name="" label="Driver:" />
        <form:content_begin />
        <form:select_begin name="<%= Driver.PARAM %>" />
            <form:option name="None" value="None" />
            <% for(int x=0; x<drivers.howMany(); x++) { %>
                <% driver = (Driver)drivers.get(x); %>
                <form:option name="<%= driver.getName() %>" value="<%= driver.getName() %>" />
            <% } %>
        <form:select_end />
        <form:content_end />
        <form:row_end />
        <form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(content.getId()).toString() %>" />
        <form:row_begin />
		<form:label name="" label="" />
		<form:buttonset_begin align="left" padding="0"/>
			<form:submit_inline button="save" waiting="true" name="Mark Checked IN" action="mark_checkedin" />
		<form:buttonset_end />
		<form:row_end />
    <form:end />
<admin:box_end />
<% } %>


<admin:subtitle text="General Info" />
<admin:box_begin />
    <form:begin submit="true" name="edit" action="reels/process.jsp" />
        	<form:info label="Status:" text="<%= content.getStatus() %>" />
        	<form:info label="Warehouse<br />Location:" text="<%= content.getWharehouseLocation() %>" />
			<form:info label="Reel Type:" text="<%= content.getReelType() %>" />
			<form:info label="Reel Tag:" text="<%= content.getReelTag() %>" />
			<form:info label="Cable Description:" text="<%= content.getCableDescription() %>" />
			<form:info label="Customer P/N:" text="<%= content.getCustomerPN() %>" />
			<form:info label="ECS P/N:" text="<%= content.getEcsPN() %>" />
			<form:info label="Manufacturer:" text="<%= content.getManufacturer() %>" />
			<form:info label="Steel Reel Serial #:" text="<%= content.getSteelReelSerial() %>" />
			<form:info label="Received On:" text="<%= content.getReceivedOnDateString() %>" />
            <%--
            <% if(content.hasBottomFootNotVisible()) { %>
                <form:info label="Bottom Foot #:" text="Not Visible" />
            <% } else { %>
                <form:info label="Bottom Foot #:" text="<%= new Integer(content.getBottomFoot()).toString() %>" />
            <% } %>
            --%>

            <% if(techData.getUsageTracking().equals(CableTechData.USAGE_FOOT_MARKERS)) { %>
                <%--
                <form:textfield pixelwidth="40" label="Bottom Ft:" name="<%= Reel.BOTTOM_FOOT_COLUMN %>" value="<%= new Integer(content.getBottomFoot()).toString() %>" />
                <form:row_begin />
                    <form:label name="" label="Bottom Foot Not Visible?:" />
                    <form:content_begin />      
                    <form:checkbox label="" name="<%= Reel.BOTTOM_FOOT_NOT_VISIBLE_COLUMN %>" value="y" match="<%= content.getBottomFootNotVisible() %>" />       
                    <form:content_end />                
                <form:row_end />
                --%>
                <form:info label="Orig Top Foot #:" text="<%= new Integer(content.getOrigTopFoot()).toString() %>" />
                <form:info label="Top Foot #:" text="<%= new Integer(content.getTopFoot()).toString() %>" />
            <% } else if(techData.getUsageTracking().equals(CableTechData.USAGE_WEIGHT)) { %>
                <form:info label="Received lbs:" text="<%= new Integer(content.getReceivedWeight()).toString() %>" />
                <form:info label="Current lbs:" text="<%= new Integer(content.getCurrentWeight()).toString() %>" />
            <% } else if(techData.getUsageTracking().equals(CableTechData.USAGE_QUANTITY_PULLED)) { %>
                <form:info label="Cable Used Qty:" text="<%= new Integer(content.getCableUsedQuantity()).toString() %>" />
            <% } %>
            <form:info label="On Reel Qty:" text="<%= new Integer(content.getOnReelQuantity()).toString() %>" />
            
			<form:info label="Times Checked OUT:" text="<%= new Integer(content.getTimesCheckedOut()).toString() %>" />
			<form:info label="Times Checked IN:" text="<%= new Integer(content.getTimesCheckedIn()).toString() %>" />
			<form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />
            <form:row_begin />
                <form:label name="" label="" />
                <form:buttonset_begin align="left" padding="0"/>
                    <% tempURL = "reeltags/reeltag_image.jsp?" + Reel.PARAM + "=" + content.getId(); %>
                    <form:linkbutton url="<%= tempURL %>" name="GENERATE REEL TAG" newtab="true" />
                <form:buttonset_end />
            <form:row_end />
            <%-- if(!content.hasReelTagFile()) { --%>
                
            <%-- } --%>			
    <form:end />
<admin:box_end />

<admin:set_tabset url="reels/_tabset_manage.jsp" thispage="status.jsp" content_id_for_tabset="<%= contid %>"/>
<html:end />