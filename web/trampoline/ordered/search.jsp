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
int pageNdx = 1;
if(request.getParameter("pageIdx") != null) {
    pageNdx = Integer.parseInt(request.getParameter("pageIdx"));
}

int skip = (pageNdx-1) * howMany;
if(request.getParameter("skip") != null) {
    skip = Integer.parseInt(request.getParameter("skip"));
}

Reel content = new Reel();
if(session.getAttribute("ordered_search")!=null) {
    content = (Reel)session.getAttribute("ordered_search");
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

session.setAttribute("ordered_search",content);

String column = Reel.CR_ID_COLUMN;
boolean ascending = true;
int count = reelMgr.searchOrderedAndShippedReelsCount(content, column, ascending);
CompEntities contents = reelMgr.searchOrderedAndShippedReels(content, column, ascending, howMany, skip);
String[] manufacturers = reelMgr.getManufacturers();

boolean dosearch = true;
String tempURL = "";
%>

<% dbResources.close(); %>
<html:begin />
<admin:title text="All Ordered Reels" />

<admin:subtitle text="Search" />
    <admin:box_begin />
    <form:begin_selfsubmit name="search" action="ordered/search.jsp" />
        <%
        tempURL = "";
        if(content.getCrId()!=0) tempURL = new Integer(content.getCrId()).toString();
        %>
        <form:textfield label="CRID #:" name="<%= Reel.CR_ID_COLUMN %>" value="<%= tempURL %>" />
        <form:textfield label="Reel Tag:" name="<%= Reel.REEL_TAG_COLUMN %>" value="<%= content.getReelTag() %>" />
        <form:textfield label="Description:" name="<%= Reel.CABLE_DESCRIPTION_COLUMN %>" value="<%= content.getCableDescription() %>" />
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
                <form:submit_inline button="submit" waiting="true" name="search" action="test" />
                <form:clearform_inline name="search"/>
            <form:buttonset_end />
        <form:row_end />
    <form:end />
    <admin:box_end />

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
            <listing:header_cell width="45" first="true" name="CRID #" />
            <listing:header_cell name="Reel Tag" />
            <listing:header_cell name="Cable Description" />
            <listing:header_cell width="100" name="Prj. Ship Date" />
            <listing:header_cell width="75" name="Status" />
            <listing:header_cell width="40" name=""  />
        <listing:header_end />
        <% for(int i=0; i<contents.howMany(); i++) { %>
        <% content = (Reel)contents.get(i); %>
        <listing:row_begin row="<%= new Integer(i).toString() %>" />
            <listing:cell_begin />
                <%= Integer.toString(content.getCrId()) %>
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
                <% tempURL = "reels/edit.jsp?" +  Reel.PARAM + "=" + content.getId(); %>
                <form:linkbutton url="<%= tempURL %>" name="EDIT" />
            <listing:cell_end />
        <listing:row_end />
        <% } %>
    <listing:end />
    <admin:box_end />
    <% } else { %>
    <admin:subtitle text="No Reels Found." />
    <% } %>
<% } %>

<admin:set_tabset url="ordered/_tabset_default.jsp" thispage="search.jsp" />
<html:end />    