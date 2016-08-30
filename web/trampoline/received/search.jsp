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
    session.setAttribute("received/search.jsp", pageNum);
} else {
    if(session.getAttribute("received/search.jsp") != null) {
        pageNum = (Integer)session.getAttribute("received/search.jsp");
    }
}

int skip = (pageNum-1) * howMany;

if(request.getParameter("skip") != null) {
    skip = Integer.parseInt(request.getParameter("skip"));
}

Reel content = new Reel();
if(session.getAttribute("received_search")!=null) {
    content = (Reel)session.getAttribute("received_search");
}

if(request.getParameter(Reel.CR_ID_COLUMN) != null) {
    if(request.getParameter(Reel.CR_ID_COLUMN).equals("")) {
        content.getData().removeValue(Reel.CR_ID_COLUMN);
    } else {
        content.setCrId(Integer.parseInt(request.getParameter(Reel.CR_ID_COLUMN)));
        content.setSearchOp(Reel.CR_ID_COLUMN, Reel.EQ);
    }
}

if(request.getParameter(Reel.REEL_TAG_COLUMN) != null) {
    content.setReelTag(request.getParameter(Reel.REEL_TAG_COLUMN));
    content.setSearchOp(Reel.REEL_TAG_COLUMN, Reel.TRUE_PARTIAL);
}

if(request.getParameter(Reel.PACKING_LIST_COLUMN) != null) {
    content.setPackingList(request.getParameter(Reel.PACKING_LIST_COLUMN));
    content.setSearchOp(Reel.PACKING_LIST_COLUMN, Reel.TRUE_PARTIAL);
}

if(request.getParameter(Reel.TRACKING_PRO_COLUMN) != null) {
    content.setTrackingPRO(request.getParameter(Reel.TRACKING_PRO_COLUMN));
    content.setSearchOp(Reel.TRACKING_PRO_COLUMN, Reel.TRUE_PARTIAL);
}

if(request.getParameter(Reel.CABLE_DESCRIPTION_COLUMN) != null) {
    content.setCableDescription(request.getParameter(Reel.CABLE_DESCRIPTION_COLUMN));
    content.setSearchOp(Reel.CABLE_DESCRIPTION_COLUMN, Reel.WHOLE);
}

if(request.getParameter(Reel.CUSTOMER_PO_COLUMN) != null) {
    content.setCustomerPO(request.getParameter(Reel.CUSTOMER_PO_COLUMN));
    content.setSearchOp(Reel.CUSTOMER_PO_COLUMN, Reel.PARTIAL);
}

if(request.getParameter(Reel.CUSTOMER_PN_COLUMN) != null) {
    content.setCustomerPN(request.getParameter(Reel.CUSTOMER_PN_COLUMN));
    content.setSearchOp(Reel.CUSTOMER_PN_COLUMN, Reel.PARTIAL);
}

if(request.getParameter(Reel.MANUFACTURER_COLUMN) != null) {
    content.setManufacturer(request.getParameter(Reel.MANUFACTURER_COLUMN));
    content.setSearchOp(Reel.MANUFACTURER_COLUMN, Reel.EQ);
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

if(request.getParameter(Reel.ORDNO_COLUMN) != null) {
    content.setOrdNo(request.getParameter(Reel.ORDNO_COLUMN));
    content.setSearchOp(Reel.ORDNO_COLUMN, Reel.TRUE_PARTIAL);
}

session.setAttribute("received_search",content);

String column = Reel.CR_ID_COLUMN;
boolean ascending = true;
if(request.getParameter("column")!=null) {
    column = request.getParameter("column");
}
if(request.getParameter("ascending")!=null) {
    if(request.getParameter("ascending").equals("true")) {
        ascending = true;
    } else {
        ascending = false;
    }
}
int count = reelMgr.searchAllReceivedReelsCount(content, column, ascending);
int pages = (int)Math.ceil((double)count / howMany);
CompEntities contents = reelMgr.searchAllReceivedReels(content, column, ascending, howMany, skip);
String[] manufacturers = reelMgr.getManufacturers();
String[] volts = reelMgr.getPnVolts();
String[] gauges = reelMgr.getPnGauges();
String[] conductors = reelMgr.getPnConductors();

boolean dosearch = true;
String tempURL = "";
%>

<% dbResources.close(); %>
<html:begin />
<admin:title heading="Reels" text="All Received" />

<admin:subtitle text="Search" />
    <admin:box_begin text="Search Reels"   name="Search" open="false"/>
    <form:begin_selfsubmit name="search" action="received/search.jsp" />
        <%
        tempURL = "";
        if(content.getCrId()!=0) tempURL = new Integer(content.getCrId()).toString();
        %>
        <form:textfield label="CRID #:" name="<%= Reel.CR_ID_COLUMN %>" value="<%= tempURL %>" />
        <form:textfield label="Reel Tag:" name="<%= Reel.REEL_TAG_COLUMN %>" value="<%= content.getReelTag() %>" />
        <form:textfield label="Packing List #:" name="<%= Reel.PACKING_LIST_COLUMN %>" value="<%= content.getPackingList() %>" />
        <form:textfield label="Tracking PRO #:" name="<%= Reel.TRACKING_PRO_COLUMN %>" value="<%= content.getTrackingPRO() %>" />
        <form:textfield label="Description:" name="<%= Reel.CABLE_DESCRIPTION_COLUMN %>" value="<%= content.getCableDescription() %>" />
        <form:textfield label="ECS PO:" name="<%= Reel.ORDNO_COLUMN %>" value="<%= content.getOrdNo() %>" />
        <% tempURL = user.getCustomerName() + " PO:"; %>
        <form:textfield label="<%= tempURL %>" name="<%= Reel.CUSTOMER_PO_COLUMN %>" value="<%= content.getCustomerPO() %>" />
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
        <form:row_begin />
            <form:label name="" label="" />
            <form:buttonset_begin align="left" padding="0"/>
                <form:submit_inline button="submit" waiting="true" name="SEARCH" action="test" />
                <form:clearform_inline name="search"/>
            <form:buttonset_end />
        <form:row_end />
    <form:end />
    <admin:box_end />

<% if(dosearch) { %>
    <% if(contents.howMany() > 0) { %>
    <admin:box_begin text="Reels" name="results" url="received/search.jsp" pages="<%= Integer.toString(pages) %>" pageNum="<%= Integer.toString(pageNum) %>" />

    <listing:begin />
        <listing:header_begin />
			<listing:header_cell width="55" first="true" name="CRID #" column="<%= Reel.CR_ID_COLUMN %>" ascending="<%= new Boolean(ascending).toString() %>" match="<%= column %>" url="received/search.jsp" />
            <listing:header_cell name="Reel Tag" column="<%= Reel.REEL_TAG_COLUMN %>" ascending="<%= new Boolean(ascending).toString() %>" match="<%= column %>" url="received/search.jsp" />
            <listing:header_cell name="Cable Description" column="<%= Reel.CABLE_DESCRIPTION_COLUMN %>" ascending="<%= new Boolean(ascending).toString() %>" match="<%= column %>" url="received/search.jsp" />
            <listing:header_cell width="75" name="Status" column="<%= Reel.STATUS_COLUMN %>" ascending="<%= new Boolean(ascending).toString() %>" match="<%= column %>" url="received/search.jsp" />
            <listing:header_cell width="40" name=""  />
        <listing:header_end />
        <% for(int i=0; i<contents.howMany(); i++) { %>
        <% content = (Reel)contents.get(i); %>
        <listing:row_begin row="<%= new Integer(i).toString() %>" />
            <listing:cell_begin />
                <%= content.getCrId() %>
            <listing:cell_end />
            <listing:cell_begin />
                <%= content.getReelTag() %>
            <listing:cell_end />
            <listing:cell_begin />
                <%= content.getCableDescription() %>
            <listing:cell_end />
            <listing:cell_begin />
                <%= content.getStatus() %>
            <listing:cell_end />
            <listing:cell_begin align="right"/>
                <% tempURL = "reels/status.jsp?" +  Reel.PARAM + "=" + content.getId(); %>
                <form:linkbutton url="<%= tempURL %>" name="REEL PAGE" />
            <listing:cell_end />
        <listing:row_end />
        <% } %>
    <listing:end />
    <admin:box_end />
    <% } else { %>
    <admin:subtitle text="No Reels Found." />
    <% } %>
<% } %>

<admin:set_tabset url="received/_tabset_default.jsp" thispage="search.jsp" />
<html:end />
