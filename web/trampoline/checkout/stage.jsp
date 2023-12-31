<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.reeltrack.picklists.*" %>
<%@ page import="com.reeltrack.foremans.*" %>
<%@ page import="com.reeltrack.drivers.*" %>
<%@ page import="com.monumental.trampoline.component.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="foremanMgr" class="com.reeltrack.foremans.ForemanMgr" scope="request"/>
<jsp:useBean id="driverMgr" class="com.reeltrack.drivers.DriverMgr" scope="request"/>
<jsp:useBean id="picklistMgr" class="com.reeltrack.picklists.PickListMgr" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" />
<% reelMgr.init(pageContext,dbResources); %>
<% userLoginMgr.init(pageContext); %>
<% foremanMgr.init(pageContext,dbResources); %>
<% driverMgr.init(pageContext,dbResources); %>
<% picklistMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<%
// Get the id
int contid = 0;
if(request.getParameter(PickList.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(PickList.PARAM));
} else {
    String param = "content_id_for_tabset";
    if(request.getParameter(param) != null) {
        contid = Integer.parseInt(request.getParameter(param));
    }
}

// Get the piece of content
PickList content = new PickList();
content.setId(contid);
content = (PickList)picklistMgr.getPickList(content);

Foreman foreman = new Foreman();
foreman.setCustomerId(user.getCustomerId());
CompEntities foremans = foremanMgr.searchForeman(foreman, Foreman.NAME_COLUMN, true);

Driver driver = new Driver();
driver.setCustomerId(user.getCustomerId());
CompEntities drivers = driverMgr.searchDriver(driver, Driver.NAME_COLUMN, true);

CompEntities circuits = picklistMgr.getReelCircuits();
CompEntities pickReels = picklistMgr.getReelsOnPickList(content);
pickReels.sortByMethodName("getPosition", true);

String tempURL; //var for url expression
%>

<html:begin />
<admin:title heading="Pick List" text="<%= content.getTitle() %>" />
<notifier:show_message />

<admin:subtitle text="General Info" />
<admin:box_begin text="General Info" name="General_Info" />
    <form:begin submit="true" name="edit" action="checkout/process.jsp" />
    		<form:row_begin />
	            <form:label name="" label="Checked OUT to:" />
	            <form:content_begin />
	            <form:select_begin name="<%= PickList.FOREMAN_COLUMN %>" />
	                <form:option name="None" value="" match="<%= content.getForeman() %>" />
	                <% for(int f=0; f<foremans.howMany(); f++) { %>
	                    <% foreman = (Foreman)foremans.get(f); %>
	                    <form:option name="<%= foreman.getName() %>" value="<%= foreman.getName() %>" match="<%= content.getForeman() %>" />
	                <% } %>
	            <form:select_end />
	            <form:content_end />
        	<form:row_end />
        	<form:row_begin />
	            <form:label name="" label="Driver:" />
	            <form:content_begin />
	            <form:select_begin name="<%= PickList.DRIVER_COLUMN %>" />
	                <form:option name="None" value="" match="<%= content.getDriver() %>" />
	                <% for(int f=0; f<drivers.howMany(); f++) { %>
	                    <% driver = (Driver)drivers.get(f); %>
	                    <form:option name="<%= driver.getName() %>" value="<%= driver.getName() %>" match="<%= content.getDriver() %>" />
	                <% } %>
	            <form:select_end />
	            <form:content_end />
        	<form:row_end />
        	<form:row_begin />
	            <form:label name="" label="Status:" />
	            <form:content_begin />
	            <form:select_begin name="<%= PickList.STATUS_COLUMN %>" />
	            	<form:option name="<%= PickList.STATUS_NEW %>" value="<%= PickList.STATUS_NEW %>" match="<%= content.getStatus() %>" />
	                <form:option name="<%= PickList.STATUS_PARTIAL_STAGED %>" value="<%= PickList.STATUS_PARTIAL_STAGED %>" match="<%= content.getStatus() %>" />
	                <form:option name="<%= PickList.STATUS_STAGED %>" value="<%= PickList.STATUS_STAGED %>" match="<%= content.getStatus() %>" />
	            <form:select_end />
	            <form:content_end />
        	<form:row_end />
			<form:hidden name="<%= PickList.PARAM %>" value="<%= new Integer(contid).toString() %>" />
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
					<form:submit_inline button="save" waiting="true" name="save" action="update_stage" />
				<form:buttonset_end />
			<form:row_end />
    <form:end />
<admin:box_end />

<% if(pickReels.howMany() > 0) { %>
	    <% for(int i=0; i<pickReels.howMany(); i++) { %>
	    <% Reel reel3 = (Reel)pickReels.get(i); %>
	    <% CableTechData techData = reelMgr.getCableTechData(reel3); %>
		<% String toggleTarget = "toggleReelstage" + reel3.getId(); %>
	    <% String toggleID = "reelstage" + reel3.getId(); %>
	    <% String toggleForm = "reelFormstage" + reel3.getId(); %>
	    <% String row = "0"; %>
	    <% if(reel3.getStatus().equals(Reel.STATUS_STAGED) || reel3.getStatus().equals(Reel.STATUS_CHECKED_OUT)) {
	    	row = "1";
	    	}
	    %>

        <%
        String reelName = reel3.getCrId() + " : " + reel3.getReelTag() + " : " + reel3.getCableDescription() + " (" + reel3.getWharehouseLocation() + " : " + reel3.getStatus() + ")";
        String reelId = "reel" + reel3.getCrId();
        %>

        <admin:box_begin open="false" text="<%= reelName %>" name="<%= reelId %>"/>
            <form:begin submit="true" name="<%= toggleForm %>" action="checkout/process.jsp" />
            	<form:info label="Reel Tag:" text="<%= reel3.getReelTag() %>" />
                <form:info label="Cable Description:" text="<%= reel3.getCableDescription() %>" />
                <form:info label="Customer P/N:" text="<%= reel3.getCustomerPN() %>" />
                <form:info label="Manufacturer:" text="<%= reel3.getManufacturer() %>" />
                <form:info label="Reel Type:" text="<%= reel3.getReelType() %>" />
                <form:info label="Quantity:" text="<%= new Integer(reel3.getOnReelQuantity()).toString() %>" />
                <% if(techData.getUsageTracking().equals(CableTechData.USAGE_FOOT_MARKERS)) { %>
	                <form:textfield label="Top Foot #:" pixelwidth="40" name="<%= Reel.TOP_FOOT_COLUMN %>" value="<%= new Integer(reel3.getTopFoot()).toString() %>" />
	            <% } %>
	            <% if(techData.getUsageTracking().equals(CableTechData.USAGE_WEIGHT)) { %>
	                <form:textfield label="Current lbs:" pixelwidth="40" name="<%= Reel.CURRENT_WEIGHT_COLUMN %>" value="<%= new Integer(reel3.getCurrentWeight()).toString() %>" />
	            <% } %>
                <form:hidden name="<%= PickList.PARAM %>" value="<%= new Integer(contid).toString() %>" />
                <form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(reel3.getId()).toString() %>" />
                <form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
					<form:submit_inline button="save" waiting="true" name="Mark Staged" action="mark_staged" />
                    <% tempURL = "reels/edit.jsp?" +  Reel.PARAM + "=" + reel3.getId(); %>
                    <form:linkbutton url="<%= tempURL %>" name="EDIT REEL" />
				<form:buttonset_end />
				<form:row_end />
            <form:end />
        <admin:box_end />

	    <% } %>
	<listing:end />
	<admin:box_end />
<% } else { %>
	<admin:subtitle text="No Reels On Pick List." />
<% } %>

<admin:set_tabset url="checkout/_tabset_stage.jsp" thispage="stage.jsp" content_id_for_tabset="<%= contid %>"/>
<html:end />
<% dbResources.close(); %>
