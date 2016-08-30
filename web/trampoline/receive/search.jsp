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

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<jsp:useBean id="locationMgr" class="com.reeltrack.whlocations.WhLocationMgr" />
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" />
<% userLoginMgr.init(pageContext); %>
<% reelMgr.init(pageContext,dbResources); %>
<% locationMgr.init(pageContext,dbResources); %>
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
if(session.getAttribute("receive_search")!=null) {
    content = (Reel)session.getAttribute("receive_search");
}

if(request.getParameter(Reel.REEL_TAG_COLUMN) != null) {
    content.setReelTag(request.getParameter(Reel.REEL_TAG_COLUMN));
    content.setSearchOp(Reel.REEL_TAG_COLUMN, Reel.TRUE_PARTIAL);
}

if(request.getParameter(Reel.CABLE_DESCRIPTION_COLUMN) != null) {
    content.setCableDescription(request.getParameter(Reel.CABLE_DESCRIPTION_COLUMN));
    content.setSearchOp(Reel.CABLE_DESCRIPTION_COLUMN, Reel.TRUE_PARTIAL);
}

if(request.getParameter(Reel.CUSTOMER_PO_COLUMN) != null) {
    content.setCustomerPO(request.getParameter(Reel.CUSTOMER_PO_COLUMN));
    content.setSearchOp(Reel.CUSTOMER_PO_COLUMN, Reel.PARTIAL);
}

if(request.getParameter(Reel.CUSTOMER_PN_COLUMN) != null) {
    content.setCustomerPN(request.getParameter(Reel.CUSTOMER_PN_COLUMN));
    content.setSearchOp(Reel.CUSTOMER_PN_COLUMN, Reel.PARTIAL);
}

if(request.getParameter(Reel.TRACKING_PRO_COLUMN) != null) {
    content.setTrackingPRO(request.getParameter(Reel.TRACKING_PRO_COLUMN));
    content.setSearchOp(Reel.TRACKING_PRO_COLUMN, Reel.PARTIAL);
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

session.setAttribute("receive_search",content);

String column = Reel.REEL_TAG_COLUMN;
boolean ascending = true;
int count = reelMgr.searchOrderedAndShippedReelsCount(content, column, ascending);
int pages = (int)Math.ceil((double)count / howMany);
CompEntities contents = reelMgr.searchOrderedAndShippedReels(content, column, ascending, howMany, skip);

WhLocation location = new WhLocation();
location.setCustomerId(user.getCustomerId());
CompEntities locations = locationMgr.searchWhLocation(location, WhLocation.NAME_COLUMN, true);
String[] manufacturers = reelMgr.getManufacturers();

boolean dosearch = true;
String tempURL = "";
%>

<html:begin />
<admin:title heading="Reels" text="Mark as Received" />

<admin:subtitle text="Filter Reels" />
<admin:box_begin text="Filter Reels" name="Filter_Reels" open="false"/>
<form:begin_selfsubmit name="search" action="receive/search.jsp" />
    <% if(content.getCrId()!=0) { %>
		<form:textfield label="CRID #:" name="<%= Reel.CR_ID_COLUMN %>" value="<%= new Integer(content.getCrId()).toString() %>" />
	<% } else { %>
		<form:textfield label="CRID #:" name="<%= Reel.CR_ID_COLUMN %>" value="" />
	<% } %>
	<form:textfield label="Reel Tag:" name="<%= Reel.REEL_TAG_COLUMN %>" value="<%= content.getReelTag() %>" />
    <form:textfield label="Description:" name="<%= Reel.CABLE_DESCRIPTION_COLUMN %>" value="<%= content.getCableDescription() %>" />
    <% tempURL = user.getCustomerName() + " PO:"; %>
    <form:textfield label="<%= tempURL %>" name="<%= Reel.CUSTOMER_PO_COLUMN %>" value="<%= content.getCustomerPO() %>" />
    <% tempURL = user.getCustomerName() + " P/N:"; %>
    <form:textfield label="<%= tempURL %>" name="<%= Reel.CUSTOMER_PN_COLUMN %>" value="<%= content.getCustomerPN() %>" />
    <form:textfield label="Tracking PRO #:" name="<%= Reel.TRACKING_PRO_COLUMN %>" value="<%= content.getTrackingPRO() %>" />
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
<admin:box_begin color="silver" text="Reels" name="results" url="receive/search.jsp" pages="<%= Integer.toString(pages) %>" pageNum="<%= Integer.toString(pageNum) %>" />
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
            <form:begin submit="true" name="<%= toggleForm %>" action="receive/process.jsp" />
                <form:info label="Shipped<br />Date:" text="<%= content.getShippingDateString() %>" />
                <form:info label="Shipped Qty:" text="<%= new Integer(content.getShippedQuantity()).toString() %>" />
                <form:textfield label="Tracking PRO #:" name="<%= Reel.TRACKING_PRO_COLUMN %>" value="<%= content.getTrackingPRO() %>" />
                <form:textfield label="Packing List #:" name="<%= Reel.PACKING_LIST_COLUMN %>" value="<%= content.getPackingList() %>" />
                <form:textfield label="Steel Reel Serial #:" name="<%= Reel.STEEL_REEL_SERIAL_COLUMN %>" value="<%= content.getSteelReelSerial() %>" />
                <form:textfield pixelwidth="40" label="Received Qty:" name="<%= Reel.RECEIVED_QUANTITY_COLUMN %>" value="<%= new Integer(content.getReceivedQuantity()).toString() %>" />

                <% if(techData.getUsageTracking().equals(CableTechData.USAGE_FOOT_MARKERS)) { %>
                    <form:textfield pixelwidth="40" label="Orig Top Seq Mark:" name="<%= Reel.ORIG_TOP_FOOT_COLUMN %>" value="<%= new Integer(content.getOrigTopFoot()).toString() %>" />
                <% } %>

                <% if(techData.getUsageTracking().equals(CableTechData.USAGE_WEIGHT)) { %>
                    <form:textfield pixelwidth="40" label="Reel GWT:" name="<%= Reel.RECEIVED_WEIGHT_COLUMN %>" value="<%= new Integer(content.getReceivedWeight()).toString() %>" />
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
                        <form:option name="None" value="<%= Reel.RECEIVING_ISSUE_NONE %>" match="<%= content.getReceivingIssue() %>" />
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
                    <% tempURL = "reeltags/reeltag_image.jsp?" + Reel.PARAM + "=" + content.getId(); %>
                    <form:linkbutton url="<%= tempURL %>" name="GENERATE REEL TAG" newtab="true" />
                    <form:submit_inline button="save" waiting="true" name="Mark Received / Refused" action="mark_received" />
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

<%--
<% if(dosearch) { %>
    <% if(contents.howMany() > 0) { %>

        <admin:search_listing_pagination text="Reels Found" url="ordered/search.jsp"
                    pageIndex="<%= new Integer(pageNdx).toString() %>"
                    column="<%= column %>"
                    ascending="<%= new Boolean(ascending).toString() %>"
                    howMany="<%= new Integer(howMany).toString() %>"
                    skip="<%= new Integer(skip).toString() %>"
                    count="<%= new Integer(count).toString() %>"
                    search_params=""
                />

    <admin:box_begin color="false" />

    <listing:begin />
        <listing:header_begin />
            <listing:header_cell width="10" first="true" name="#" />
            <listing:header_cell name="Reel Tag | Desc." />
            <listing:header_cell width="120" name="Cust. PN | Mftr." />
            <listing:header_cell width="70" name="Order Qty" />
            <listing:header_cell width="100" name="St. Reel #" />
            <listing:header_cell width="110" name="Qty | Date | Car." />
            <listing:header_cell width="60" name=""  />
        <listing:header_end />
    <listing:end />
        <% for(int i=0; i<contents.howMany(); i++) { %>
        <% content = (Reel)contents.get(i); %>
        <form:begin name="<%= tempURL %>" action="shipping/process.jsp" />
        <listing:begin />
        <listing:row_begin row="<%= new Integer(i).toString() %>" />
            <listing:cell_begin  width="10"/>
                <%= new Integer(i+1).toString() %>
            <listing:cell_end />
            <listing:cell_begin />
                <%= content.getReelTag() %><br />
                <%= content.getCableDescription() %>
            <listing:cell_end />
            <listing:cell_begin  width="120"/>
                <%= content.getCustomerPN() %><br />
                <%= content.getManufacturer() %>
            <listing:cell_end />
            <listing:cell_begin width="70" />
                <%= content.getOrderedQuantity() %><br />
            <listing:cell_end />
            <listing:cell_begin width="100" />
                <%= content.getSteelReelSerial() %>
            <listing:cell_end />
            <listing:cell_begin width="110" />
                <input type="text" style="width:70px;margin-bottom:5px;" name="<%= Reel.SHIPPED_QUANTITY_COLUMN %>" value="<%= new Integer(content.getShippedQuantity()).toString() %>" /><br />
                <input type="text" style="width:70px;margin-bottom:5px;" id="<%= Reel.PROJECTED_SHIPPING_DATE_COLUMN %>" name="<%= Reel.PROJECTED_SHIPPING_DATE_COLUMN %>" value="<%= content.getProjectedShippingDateString() %>" class="input_date_picker" /><br />
                <form:select_begin name="<%= Reel.CARRIER_COLUMN %>" />
                    <form:option name="Carrier" value="" match="<%= content.getCarrier() %>" />
                    <% String[] carrierList  = content.getCarrierList(); %>
                    <% for(int x=0; x<carrierList.length; x++) { %>
                        <form:option name="<%= carrierList[x] %>" value="<%= carrierList[x] %>" match="<%= content.getCarrier() %>" />
                    <% } %>
                <form:select_end /><br />
            <listing:cell_end />
            <listing:cell_begin align="right" width="60"/>
                <% tempURL = "reels/edit.jsp?" +  Reel.PARAM + "=" + content.getId(); %>
                <form:linkbutton url="<%= tempURL %>" name="EDIT" /><br /><br />
                <% tempURL = "reels/edit.jsp?" +  Reel.PARAM + "=" + content.getId(); %>
                <form:hidden name="<%= Reel.PARAM %>" value="<%= Integer.toString(content.getId()) %>" />
                <form:submit_inline waiting="true" name="shipped" action="mark_shipped" />
            <listing:cell_end />
        <listing:row_end />
        <listing:end />
        <form:end />
        <% } %>
    <admin:box_end />
    <% } else { %>
    <admin:subtitle text="No Reels Found." />
    <% } %>
<% } %>
--%>

<admin:set_tabset url="receive/_tabset_default.jsp" thispage="search.jsp" />
<html:end />

<% dbResources.close(); %>
