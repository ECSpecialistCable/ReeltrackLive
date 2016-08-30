<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Enumeration"%>
<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.monumental.trampoline.security.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.whlocations.*" %>
<%@ page import="com.reeltrack.drivers.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<jsp:useBean id="locationMgr" class="com.reeltrack.whlocations.WhLocationMgr" />
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" />
<jsp:useBean id="driverMgr" class="com.reeltrack.drivers.DriverMgr" scope="request"/>
<% userLoginMgr.init(pageContext); %>
<% reelMgr.init(pageContext,dbResources); %>
<% locationMgr.init(pageContext,dbResources); %>
<% driverMgr.init(pageContext,dbResources); %>
<%
RTUser user = (RTUser)userLoginMgr.getUser();

int howMany = 25;
int pageNum = 1;
if(request.getParameter("pageNum") != null) {
    pageNum = Integer.parseInt(request.getParameter("pageNum"));
    session.setAttribute("shipping/search.jsp", pageNum);
} else {
    if(session.getAttribute("shipping/search.jsp") != null) {
        pageNum = (Integer)session.getAttribute("shipping/search.jsp");
    }
}

int skip = (pageNum-1) * howMany;

if(request.getParameter("skip") != null) {
    skip = Integer.parseInt(request.getParameter("skip"));
}

Reel content = new Reel();
if(session.getAttribute("checkin_search")!=null) {
    content = (Reel)session.getAttribute("checkin_search");
}

content.setStatus(Reel.STATUS_CHECKED_OUT);

if(request.getParameter(Reel.REEL_TAG_COLUMN) != null) {
    content.setReelTag(request.getParameter(Reel.REEL_TAG_COLUMN));
    content.setSearchOp(Reel.REEL_TAG_COLUMN, Reel.TRUE_PARTIAL);
}

if(request.getParameter(Reel.CABLE_DESCRIPTION_COLUMN) != null) {
    content.setCableDescription(request.getParameter(Reel.CABLE_DESCRIPTION_COLUMN));
    content.setSearchOp(Reel.CABLE_DESCRIPTION_COLUMN, Reel.TRUE_PARTIAL);
}

if(request.getParameter(Reel.CUSTOMER_PN_COLUMN) != null) {
    content.setCustomerPN(request.getParameter(Reel.CUSTOMER_PN_COLUMN));
    content.setSearchOp(Reel.CUSTOMER_PN_COLUMN, Reel.PARTIAL);
}

if(request.getParameter(Reel.MANUFACTURER_COLUMN) != null) {
    content.setManufacturer(request.getParameter(Reel.MANUFACTURER_COLUMN));
    content.setSearchOp(Reel.MANUFACTURER_COLUMN, Reel.EQ);
}

if(request.getParameter(Reel.CR_ID_COLUMN) != null) {
    if(request.getParameter(Reel.CR_ID_COLUMN).equals("")) {
        content.getData().removeValue(Reel.CR_ID_COLUMN);
    } else {
        content.setCrId(Integer.parseInt(request.getParameter(Reel.CR_ID_COLUMN)));
        content.setSearchOp(Reel.CR_ID_COLUMN, Reel.EQ);
    }
}

session.setAttribute("checkin_search",content);

String column = Reel.REEL_TAG_COLUMN;
boolean ascending = true;
int count = reelMgr.searchReelsCount(content, column, ascending);
int pages = (int)Math.ceil((double)count / howMany);
CompEntities contents = reelMgr.searchReels(content, column, ascending, howMany, skip);

WhLocation location = new WhLocation();
location.setCustomerId(user.getCustomerId());
CompEntities locations = locationMgr.searchWhLocation(location, WhLocation.NAME_COLUMN, true);

Driver driver = new Driver();
driver.setCustomerId(user.getCustomerId());
CompEntities drivers = driverMgr.searchDriver(driver, Driver.NAME_COLUMN, true);

String[] manufacturers = reelMgr.getManufacturers();

boolean dosearch = true;
String tempURL = "";
%>

<html:begin />
<admin:title heading="Reels" text="Check IN Reels" />

<admin:subtitle text="Filter Reels" />
<admin:box_begin text="Filter Reels"  name="Filter_Reels" open="false"/>
<form:begin_selfsubmit name="search" action="checkin/search.jsp" />
    <% if(content.getCrId()!=0) { %>
		<form:textfield label="CRID #:" name="<%= Reel.CR_ID_COLUMN %>" value="<%= new Integer(content.getCrId()).toString() %>" />
	<% } else { %>
		<form:textfield label="CRID #:" name="<%= Reel.CR_ID_COLUMN %>" value="" />
	<% } %>
	<form:textfield label="Reel Tag:" name="<%= Reel.REEL_TAG_COLUMN %>" value="<%= content.getReelTag() %>" />
    <form:textfield label="Description:" name="<%= Reel.CABLE_DESCRIPTION_COLUMN %>" value="<%= content.getCableDescription() %>" />
    <% tempURL = user.getCustomerName() + " P/N:"; %>
    <form:textfield label="<%= tempURL %>" name="<%= Reel.CUSTOMER_PN_COLUMN %>" value="<%= content.getCustomerPN() %>" />
    <form:row_begin />
        <form:label name="" label="Manufacturer:" />
        <form:content_begin />
        <form:select_begin name="<%= Reel.MANUFACTURER_COLUMN %>" />
            <form:option name="Any" value="" match="<%= content.getManufacturer() %>" />
            <% for(int x=0; x<manufacturers.length; x++) { %>
                <form:option name="<%= manufacturers[x] %>" value="<%= manufacturers[x] %>" match="<%= content.getManufacturer() %>" />
            <% } %>
        <form:select_end />
        <form:content_end />
    <form:row_end />
    <form:row_begin />
        <form:label name="" label="" />
        <form:buttonset_begin align="left" padding="0"/>
            <form:submit_inline button="submit" waiting="true" name="search" action="test" />
        <form:buttonset_end />
    <form:row_end />
<form:end />
<admin:box_end />

<% if(dosearch) { %>
<% if(contents.howMany() > 0) { %>
<admin:box_begin color="silver" text="Reels" name="results" url="checkin/search.jsp" pages="<%= Integer.toString(pages) %>" pageNum="<%= Integer.toString(pageNum) %>" />
<admin:box_end />
    <% for(int i=0; i<contents.howMany(); i++) { %>
        <% content = (Reel)contents.get(i); %>
        <% CableTechData techData = reelMgr.getCableTechData(content); %>
        <% tempURL = new Integer(i+1).toString() + ". " + content.getReelTag() + " (" + content.getCableDescription() + ")"; %>
        <% String toggleTarget = "toggleReelrec" + content.getId(); %>
        <% String toggleID = "reelrec" + content.getId(); %>
        <% String toggleForm = "reelFormrec" + content.getId(); %>

        <%
        String reelName = content.getCrId() + " : " + content.getReelTag() + " : " + content.getCableDescription();
        String reelId = "reel" + content.getCrId();
        %>
        <admin:box_begin open="false" text="<%= reelName %>" name="<%= reelId %>"/>
            <form:begin submit="true" name="<%= toggleForm %>" action="checkin/process.jsp" />
                <form:info label="Reel Tag:" text="<%= content.getReelTag() %>" />
                <form:info label="Cable Description:" text="<%= content.getCableDescription() %>" />
                <form:info label="Customer P/N:" text="<%= content.getCustomerPN() %>" />
                <form:info label="Manufacturer:" text="<%= content.getManufacturer() %>" />
                <form:info label="Reel Type:" text="<%= content.getReelType() %>" />
                <form:info label="Quantity:" text="<%= new Integer(content.getOnReelQuantity()).toString() %>" />
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
                    <% tempURL = "reels/edit.jsp?" +  Reel.PARAM + "=" + content.getId(); %>
                    <form:linkbutton url="<%= tempURL %>" name="EDIT REEL" />
                <form:buttonset_end />
                <form:row_end />
            <form:end />
        <admin:box_end />

    <% } %>
<% } else { %>
    <admin:subtitle text="No Reels Found." />
<% } %>
<% } %>

<admin:set_tabset url="checkin/_tabset_default.jsp" thispage="search.jsp" />
<html:end />
<% dbResources.close(); %>
