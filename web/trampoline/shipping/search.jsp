<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Enumeration"%>
<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.monumental.trampoline.security.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.reeltrack.users.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" />
<% userLoginMgr.init(pageContext); %>
<% reelMgr.init(pageContext,dbResources); %>
<% 
RTUser user = (RTUser)userLoginMgr.getUser();

int howMany = 100;
int pageNdx = 1;
if(request.getParameter("pageIdx") != null) {
    pageNdx = Integer.parseInt(request.getParameter("pageIdx"));
}

int skip = (pageNdx-1) * howMany;
if(request.getParameter("skip") != null) {
    skip = Integer.parseInt(request.getParameter("skip"));
}

Reel content = new Reel();
if(session.getAttribute("shipping_search")!=null) {
    content = (Reel)session.getAttribute("shipping_search");
}

content.setStatus(Reel.STATUS_ORDERED);

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

session.setAttribute("shipping_search",content);

String trackingNum = "";
String packingNum = "";
if(request.getParameter("action") != null) {  
    trackingNum = request.getParameter("trackingNum");
    session.setAttribute("trackingNum",trackingNum);
    packingNum = request.getParameter("packingNum");
    session.setAttribute("packingNum",packingNum); 
}
if(session.getAttribute("trackingNum")!=null) {
    trackingNum = (String)session.getAttribute("trackingNum");
}
if(session.getAttribute("packingNum")!=null) {
    packingNum = (String)session.getAttribute("packingNum");
}

String column = Reel.REEL_TAG_COLUMN;
boolean ascending = true;
int count = reelMgr.searchReelsCount(content, column, ascending);
CompEntities contents = reelMgr.searchReels(content, column, ascending, howMany, skip);

boolean dosearch = true;
String tempURL = "";
%>

<% dbResources.close(); %>
<html:begin />
<admin:title text="Mark Reels as Shipped" />

<admin:subtitle text="Filter Reels" />
<admin:box_begin />
<form:begin_selfsubmit name="search" action="shipping/search.jsp" />
    <form:textfield label="Reel Tag:" name="<%= Reel.REEL_TAG_COLUMN %>" value="<%= content.getReelTag() %>" />
    <form:textfield label="Description:" name="<%= Reel.CABLE_DESCRIPTION_COLUMN %>" value="<%= content.getCableDescription() %>" />
    <form:textfield label="Customer PO:" name="<%= Reel.CUSTOMER_PO_COLUMN %>" value="<%= content.getCustomerPO() %>" />
    <form:textfield label="Customer P/N:" name="<%= Reel.CUSTOMER_PN_COLUMN %>" value="<%= content.getCustomerPN() %>" />
    <form:textfield label="Tracking PRO #:" name="<%= Reel.TRACKING_PRO_COLUMN %>" value="<%= content.getTrackingPRO() %>" />
    <form:row_begin />
        <form:label name="" label="Manufacturer:" />
        <form:content_begin />
        <form:select_begin name="<%= Reel.MANUFACTURER_COLUMN %>" />
            <form:option name="Any" value="" match="<%= content.getManufacturer() %>" />
            <% String[] manuList  = content.getManufacturerList(); %>
            <% for(int x=0; x<manuList.length; x++) { %>
                <form:option name="<%= manuList[x] %>" value="<%= manuList[x] %>" match="<%= content.getManufacturer() %>" />
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

<admin:subtitle text="Mark Reels" />
<admin:box_begin />
<form:begin_selfsubmit name="search" action="shipping/search.jsp" />
    <form:textfield label="Tracking PRO #:" name="trackingNum" value="<%= trackingNum %>" />
    <form:textfield label="Packing List #:" name="packingNum" value="<%= packingNum %>" />
    <form:hidden name="action" value="save" />
    <form:row_begin />
        <form:label name="" label="" />
        <form:buttonset_begin align="left" padding="0"/>
            <form:submit_inline button="submit" waiting="true" name="save" action="test" />
        <form:buttonset_end />
    <form:row_end />
<form:end />
<admin:box_end />

<% if(dosearch) { %>
<% if(contents.howMany() > 0) { %>
    <% for(int i=0; i<contents.howMany(); i++) { %>
        <% content = (Reel)contents.get(i); %>
        <% tempURL = new Integer(i+1).toString() + ": " + content.getReelTag() + " (" + content.getCableDescription() + ")"; %>
        <% String toggleTarget = "toggleReel" + content.getId(); %>
        <% String toggleID = "reel" + content.getId(); %>
        <% String toggleForm = "reelForm" + content.getId(); %>
        <admin:subtitle text="<%= tempURL %>" id="<%= toggleID %>" toggleTarget="<%= toggleTarget %>" toggleOpen="false"/>
        <%--
        <admin:box_begin color="false" />
        <listing:begin id="<%= toggleID %>" toggleTarget="<%= toggleTarget %>" toggleOpen="true"/>
        <listing:row_begin row="<%= new Integer(1).toString() %>" />
            <listing:cell_begin  width="10"/>
                <%= new Integer(10).toString() %>
            <listing:cell_end />
        <listing:row_end />   
        <listing:end />
        <admin:box_end />
        --%>
        <admin:box_begin toggleRecipient="<%= toggleTarget %>"/>
            <form:begin submit="true" name="<%= toggleForm %>" action="shipping/process.jsp" />
                <form:info label="Reel Tag:" text="<%= content.getReelTag() %>" />
                <form:info label="Cable Description:" text="<%= content.getCableDescription() %>" />
                <form:info label="Customer P/N:" text="<%= content.getCustomerPN() %>" />
                <form:info label="Manufacturer:" text="<%= content.getManufacturer() %>" />
                <form:info label="Ordered Qty:" text="<%= new Integer(content.getOrderedQuantity()).toString() %>" />
                <form:info label="Steel Reel Serial #:" text="<%= content.getSteelReelSerial() %>" />
                <form:textfield pixelwidth="40" label="Shipped Qty:" name="<%= Reel.SHIPPED_QUANTITY_COLUMN %>" value="<%= new Integer(content.getShippedQuantity()).toString() %>" />
                <form:date_picker name="<%= Reel.PROJECTED_SHIPPING_DATE_COLUMN %>" value="<%= content.getProjectedShippingDateString() %>" label="Projected Shipping<br />Date:" />
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
                <form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(content.getId()).toString() %>" />        
                <form:row_begin />
                <form:label name="" label="" />
                <form:buttonset_begin align="left" padding="0"/>
                    <% tempURL = "reels/edit.jsp?" +  Reel.PARAM + "=" + content.getId(); %>
                    <form:submit_inline waiting="true" name="Mark Shipped" action="mark_shipped" />
                    &nbsp;&nbsp;
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

<admin:set_tabset url="shipping/_tabset_default.jsp" thispage="search.jsp" />
<html:end />    