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
    session.setAttribute("ordered/ordered.jsp", pageNum);
} else {
    if(session.getAttribute("ordered/ordered.jsp") != null) {
        pageNum = (Integer)session.getAttribute("ordered/ordered.jsp");
    }
}

int skip = (pageNum-1) * howMany;

if(request.getParameter("skip") != null) {
    skip = Integer.parseInt(request.getParameter("skip"));
}

Reel content = new Reel();
if(session.getAttribute("ordered_ordered")!=null) {
    content = (Reel)session.getAttribute("ordered_ordered");
}

content.setStatus(Reel.STATUS_ORDERED);

if(request.getParameter(Reel.CR_ID_COLUMN) != null) {
    if(request.getParameter(Reel.CR_ID_COLUMN).equals("")) {
        content.getData().removeValue(Reel.CR_ID_COLUMN);
    } else {
        content.setCrId(Integer.parseInt(request.getParameter(Reel.CR_ID_COLUMN)));
        content.setSearchOp(Reel.CR_ID_COLUMN, Reel.EQ);
    }
}

if(request.getParameter(Reel.UNIQUE_ID_COLUMN) != null) {
    if(request.getParameter(Reel.UNIQUE_ID_COLUMN).equals("")) {
        content.getData().removeValue(Reel.UNIQUE_ID_COLUMN);
    } else {
        content.setUniqueId(Integer.parseInt(request.getParameter(Reel.UNIQUE_ID_COLUMN)));
        content.setSearchOp(Reel.UNIQUE_ID_COLUMN, Reel.EQ);
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

if(request.getParameter(Reel.ORDNO_COLUMN) != null) {
    content.setOrdNo(request.getParameter(Reel.ORDNO_COLUMN));
    content.setSearchOp(Reel.ORDNO_COLUMN, Reel.TRUE_PARTIAL);
}

session.setAttribute("ordered_ordered",content);

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
int count = reelMgr.searchReelsCount(content, column, ascending);
int pages = (int)Math.ceil((double)count / howMany);
CompEntities contents = reelMgr.searchReels(content, column, ascending, howMany, skip);
String[] manufacturers = reelMgr.getManufacturers();

boolean dosearch = true;
String tempURL = "";
%>

<% dbResources.close(); %>
<html:begin />
<admin:title heading="Reels" text="Not Shipped" />

<admin:subtitle text="Search" />
    <admin:box_begin text="Search Reels" name="Search" open="false"/>
    <form:begin_selfsubmit name="search" action="ordered/ordered.jsp" />
        <% if(content.getCrId()!=0) tempURL = new Integer(content.getCrId()).toString(); %>
        <form:textfield label="CRID #:" name="<%= Reel.CR_ID_COLUMN %>" value="<%= tempURL %>" />
        <% if(content.getUniqueId()!=0) tempURL = new Integer(content.getUniqueId()).toString(); %>
        <form:textfield label="Unique ID #:" name="<%= Reel.UNIQUE_ID_COLUMN %>" value="<%= tempURL %>" />
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
    <admin:box_begin text="Reels" name="results" url="ordered/ordered.jsp" pages="<%= Integer.toString(pages) %>" pageNum="<%= Integer.toString(pageNum) %>" />

    <listing:begin />
        <listing:header_begin />
            <listing:header_cell width="55" first="true" name="CRID #" column="<%= Reel.CR_ID_COLUMN %>" ascending="<%= new Boolean(ascending).toString() %>" match="<%= column %>" url="ordered/ordered.jsp" />
            <listing:header_cell name="Reel Tag" column="<%= Reel.REEL_TAG_COLUMN %>" ascending="<%= new Boolean(ascending).toString() %>" match="<%= column %>" url="ordered/ordered.jsp" />
            <listing:header_cell name="Cable Description" column="<%= Reel.CABLE_DESCRIPTION_COLUMN %>" ascending="<%= new Boolean(ascending).toString() %>" match="<%= column %>" url="ordered/ordered.jsp" />
            <listing:header_cell width="100" name="Prj. Ship Date" column="<%= Reel.PROJECTED_SHIPPING_DATE_COLUMN %>" ascending="<%= new Boolean(ascending).toString() %>" match="<%= column %>" url="ordered/ordered.jsp" />
            <listing:header_cell width="75" name="Status" column="<%= Reel.STATUS_COLUMN %>" ascending="<%= new Boolean(ascending).toString() %>" match="<%= column %>" url="ordered/ordered.jsp" />
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
                <%= content.getProjectedShippingDateString() %>
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

<admin:set_tabset url="ordered/_tabset_default.jsp" thispage="ordered.jsp" />
<html:end />
