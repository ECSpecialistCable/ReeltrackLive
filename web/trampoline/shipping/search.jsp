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
if(session.getAttribute("shipping_search")!=null) {
    content = (Reel)session.getAttribute("shipping_search");
}

if(request.getParameter("clear") != null) {
    session.setAttribute("trackingNum","");
    session.setAttribute("packingNum","");
    session.setAttribute("carrierName","");
    session.setAttribute("shippingDate","");
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

if(request.getParameter(Reel.CR_ID_COLUMN) != null) {
    if(request.getParameter(Reel.CR_ID_COLUMN).equals("")) {
        content.getData().removeValue(Reel.CR_ID_COLUMN);
    } else {
        content.setCrId(Integer.parseInt(request.getParameter(Reel.CR_ID_COLUMN)));
        content.setSearchOp(Reel.CR_ID_COLUMN, Reel.EQ);
    }
}

session.setAttribute("shipping_search",content);

String trackingNum = "";
String packingNum = "";
String carrierName = "";
String shippingDate = "";
if(request.getParameter("action") != null) {
    trackingNum = request.getParameter("trackingNum");
    session.setAttribute("trackingNum",trackingNum);
    packingNum = request.getParameter("packingNum");
    session.setAttribute("packingNum",packingNum);
	carrierName = request.getParameter("carrierName");
    session.setAttribute("carrierName",carrierName);
    shippingDate = request.getParameter("shippingDate");
    session.setAttribute("shippingDate",shippingDate);
}
if(session.getAttribute("trackingNum")!=null) {
    trackingNum = (String)session.getAttribute("trackingNum");
}
if(session.getAttribute("packingNum")!=null) {
    packingNum = (String)session.getAttribute("packingNum");
}
if(session.getAttribute("carrierName")!=null) {
    carrierName = (String)session.getAttribute("carrierName");
}
if(session.getAttribute("shippingDate")!=null) {
    shippingDate = (String)session.getAttribute("shippingDate");
}

//if vendor
if(request.getParameter(Reel.ORDNO_COLUMN) != null) {
    content.setOrdNo(request.getParameter(Reel.ORDNO_COLUMN));
    content.setSearchOp(Reel.ORDNO_COLUMN, Reel.PARTIAL);
}

if(request.getParameter(Reel.PN_VOLT_COLUMN) != null) {
    content.setPnVolt(request.getParameter(Reel.PN_VOLT_COLUMN));
    content.setSearchOp(Reel.PN_VOLT_COLUMN, Reel.EQ);
}

if(request.getParameter(Reel.PN_GAUGE_COLUMN) != null) {
    content.setPnGauge(request.getParameter(Reel.PN_GAUGE_COLUMN));
    content.setSearchOp(Reel.PN_GAUGE_COLUMN, Reel.EQ);
}

if(request.getParameter(Reel.PN_CONDUCTOR_COLUMN) != null) {
    content.setPnConductor(request.getParameter(Reel.PN_CONDUCTOR_COLUMN));
    content.setSearchOp(Reel.PN_CONDUCTOR_COLUMN, Reel.EQ);
}

if(user.isUserType(RTUser.USER_TYPE_VENDOR)) {
    //content.setVendorCode(user.getVendorCode());
    content.setVendorCode("");
}

String column = Reel.REEL_TAG_COLUMN;
boolean ascending = true;
int count = reelMgr.searchReelsCount(content, column, ascending);
int pages = (int)Math.ceil((double)count / howMany);
CompEntities contents = reelMgr.searchReels(content, column, ascending, howMany, skip);
String[] manufacturers = reelMgr.getManufacturers();
String[] carrierList = reelMgr.getCarriers();
String[] volts = reelMgr.getPnVolts();
String[] gauges = reelMgr.getPnGauges();
String[] conductors = reelMgr.getPnConductors();

boolean dosearch = true;
String tempURL = "";

boolean canEdit = false;
if(user.isUserType(RTUser.USER_TYPE_ECS)) {
    canEdit = true;
}
%>

<% dbResources.close(); %>
<html:begin />
<admin:title heading="Reels" text="Mark as Shipped" />

<admin:subtitle text="Filter Reels" />
<admin:box_begin text="Filter Reels" name="Filter_Reels" open="false"/>
<form:begin_selfsubmit name="search" action="shipping/search.jsp" />
<% if(user.isUserType(RTUser.USER_TYPE_VENDOR)) { %>
            <form:textfield label="ECS PO#:" name="<%= Reel.ORDNO_COLUMN %>" value="<%= content.getOrdNo() %>" />
            <form:row_begin />
            <form:label name="" label="Voltage:" />
            <form:content_begin />
            <form:select_begin name="<%= Reel.PN_VOLT_COLUMN %>" />
                <form:option name="Any" value="" match="<%= content.getPnVolt() %>" />
                <% for(int x=0; x<volts.length; x++) { %>
                    <% tempURL = volts[x] + " (" + Reel.convertPnVolt(volts[x]) + ")"; %>
                    <form:option name="<%= tempURL %>" value="<%= volts[x] %>" match="<%= content.getPnVolt() %>" />
                <% } %>
            <form:select_end />
            <form:content_end />
            <form:row_end />
            <form:row_begin />
            <form:label name="" label="Gauge:" />
            <form:content_begin />
            <form:select_begin name="<%= Reel.PN_GAUGE_COLUMN %>" />
                <form:option name="Any" value="" match="<%= content.getPnGauge() %>" />
                <% for(int x=0; x<gauges.length; x++) { %>
                    <% tempURL = gauges[x] + " (" + Reel.convertPnGauge(gauges[x]) + ")"; %>
                    <form:option name="<%= tempURL %>" value="<%= gauges[x] %>" match="<%= content.getPnGauge() %>" />
                <% } %>
            <form:select_end />
            <form:content_end />
            <form:row_end />
            <form:row_begin />
            <form:label name="" label="Conductor Count:" />
            <form:content_begin />
            <form:select_begin name="<%= Reel.PN_CONDUCTOR_COLUMN %>" />
                <form:option name="Any" value="" match="<%= content.getPnConductor() %>" />
                <% for(int x=0; x<conductors.length; x++) { %>
                    <form:option name="<%= conductors[x] %>" value="<%= conductors[x] %>" match="<%= content.getPnConductor() %>" />
                <% } %>
            <form:select_end />
            <form:content_end />
            <form:row_end />
            <form:textfield label="Reel Tag:" name="<%= Reel.REEL_TAG_COLUMN %>" value="<%= content.getReelTag() %>" />
            <form:hidden name="<%= RTUser.VENDOR_CODE_COLUMN %>" value="<%= user.getVendorCode() %>" />
        <% } else { %>
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
    <% } %>
    <form:row_begin />
        <form:label name="" label="" />
        <form:buttonset_begin align="left" padding="0"/>
            <form:submit_inline button="submit" waiting="true" name="search" action="test" />
        <form:buttonset_end />
    <form:row_end />
<form:end />
<admin:box_end />

<admin:subtitle text="Mark Reels" />
<admin:box_begin text="Mark Reels" name="Mark_Reels" />
<form:begin_selfsubmit name="search" action="shipping/search.jsp" />
	<%--<% if(!cridNum.equals("")) { %>
		<form:textfield label="CRID #:" name="cridNum" value="<%= cridNum + "" %>" />
	<% } else { %>
		<form:textfield label="CRID #:" name="cridNum" value="<%= "" %>" />
	<% } %>--%>
    <form:textfield label="Tracking PRO #:" name="trackingNum" value="<%= trackingNum %>" />
    <form:textfield label="BOL/PL #:" name="packingNum" value="<%= packingNum %>" />
    <form:row_begin />
        <form:label name="" label="Carrier:" />
        <form:content_begin />
        <form:select_begin name="carrierName" />
            <form:option name="None" value="" match="<%= carrierName %>"/>
            <% for(int x=0; x<carrierList.length; x++) { %>
                <form:option name="<%= carrierList[x] %>" value="<%= carrierList[x] %>" match="<%= carrierName %>"/>
            <% } %>
        <form:select_end />
        <form:content_end />
    <form:row_end />
    <form:date_picker name="shippingDate" value="<%= shippingDate %>" label="Shipped Date:" />
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

<admin:box_begin color="silver" text="Reels" name="results" url="shipping/search.jsp" pages="<%= Integer.toString(pages) %>" pageNum="<%= Integer.toString(pageNum) %>" />
<admin:box_end />
    <% for(int i=0; i<contents.howMany(); i++) { %>
        <% content = (Reel)contents.get(i); %>
        <% tempURL = new Integer(i+1).toString() + ". " + content.getReelTag() + " (" + content.getCableDescription() + ")"; %>
        <% String toggleTarget = "toggleReelship" + content.getId(); %>
        <% String toggleID = "reelship" + content.getId(); %>
        <% String toggleForm = "reelFormship" + content.getId(); %>

        <%--
        <admin:box_begin color="false" />
        <listing:begin id="<%= toggleID %>" toggleTarget="<%= toggleTarget %>" toggleOpen="false"/>
        <listing:row_begin />
            <listing:cell_begin  width="50"/>
                <%= content.getCrId() %>
            <listing:cell_end />
            <listing:cell_begin  width="200"/>
                <%= content.getReelTag() %>
            <listing:cell_end />
            <listing:cell_begin />
                <%= content.getCableDescription() %>
            <listing:cell_end />
        <listing:row_end />
        <listing:end />
        <admin:box_end />
        --%>
        <%
        String reelName = content.getCrId() + " : " + content.getReelTag() + " : " + content.getCableDescription();
        String reelId = "reel" + content.getCrId();
        %>
        <admin:box_begin open="false" text="<%= reelName %>" name="<%= reelId %>"/>
            <form:begin submit="true" name="<%= toggleForm %>" action="shipping/process.jsp" />
            <%--<form class=" " title="" onsubmit="" action="shipping/process.jsp" target="_blank" method="post" name="<%= toggleForm %>" id="<%= toggleForm %>">
            <table border="0" cellspacing="0" cellpadding="0">
            --%>
                <form:info label="Ordered Qty:" text="<%= new Integer(content.getOrderedQuantity()).toString() %>" />
                <form:hidden name="<%= Reel.ORDERED_QUANTITY_COLUMN %>" value="<%= new Integer(content.getOrderedQuantity()).toString() %>" />
                <form:textfield pixelwidth="40" label="Shipped Qty:" name="<%= Reel.SHIPPED_QUANTITY_COLUMN %>" value="<%= new Integer(content.getShippedQuantity()).toString() %>" />
                <form:row_begin />
                <form:label name="" label="" />
                <form:content_begin />
                    <form:checkbox label="Set Shipping Quantity to Ordered Quantity" name="ordered_to_shipping" value="y" />
                <form:content_end />
                <form:row_end />
                <% if(canEdit) { %>
                    <form:date_picker name="<%= Reel.PROJECTED_SHIPPING_DATE_COLUMN %>" value="<%= content.getProjectedShippingDateString() %>" label="Projected Shipping<br />Date:" />
                    <% if(shippingDate.equals("")) shippingDate = content.getShippingDateString(); %>
                    <form:date_picker name="<%= Reel.SHIPPING_DATE_COLUMN %>" value="<%= shippingDate %>" label="Shipped<br />Date:" />
                <% } else { %>
                    <form:info label="Projected Shipping<br />Date:" text="<%= content.getProjectedShippingDateString() %>" />
                    <form:info label="Shipped<br />Date:" text="<%= content.getShippingDateString() %>" />
                <% } %>
                <% if(carrierName.equals("")) carrierName = content.getCarrier(); %>
                <form:row_begin />
                <form:label name="" label="Carrier:" />
                <form:content_begin />
                <form:select_begin name="<%= Reel.CARRIER_COLUMN %>" />
                    <form:option name="None" value="" match="<%= carrierName %>" />
                    <% //String[] carrierList  = content.getCarrierList(); %>
                    <% for(int x=0; x<carrierList.length; x++) { %>
                        <form:option name="<%= carrierList[x] %>" value="<%= carrierList[x] %>" match="<%= carrierName %>" />
                    <% } %>
                <form:select_end />
                <form:content_end />
                <form:row_end />
                <form:textfield label="Other Carrier:" name="other_carrier" />
                <% if(trackingNum.equals("")) trackingNum = content.getTrackingPRO(); %>
                <form:textfield label="Tracking PRO #:" name="<%= Reel.TRACKING_PRO_COLUMN %>" value="<%= trackingNum %>" />
                <% if(packingNum.equals("")) packingNum = content.getPackingList(); %>
                <form:textfield label="Packing List #:" name="<%= Reel.PACKING_LIST_COLUMN %>" value="<%= packingNum %>" />
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
<% if(request.getParameter(Reel.PARAM) != null) { %>
        <Script>
            openTag(<%= request.getParameter(Reel.PARAM) %>);
        </script>
<% } %>
<html:end />
