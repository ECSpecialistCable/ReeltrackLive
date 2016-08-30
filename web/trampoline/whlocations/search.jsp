<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.whlocations.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="whlocationMgr" class="com.reeltrack.whlocations.WhLocationMgr" scope="request"/>
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% whlocationMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<%
WhLocation content = new WhLocation();
content.setCustomerId(user.getCustomerId());
CompEntities contents = whlocationMgr.searchWhLocation(content, WhLocation.NAME_COLUMN, true);

String tempUrl =""; //var for url expression
%>
<% dbResources.close(); %>


<html:begin />
<admin:title heading="Warehouse Locations" text=""/>

<admin:subtitle text="Import Warehouse Locations" />
<admin:box_begin text="Import Warehouse Locations" name="Import" />
    <form:begin_multipart name="create" action="whlocations/process.jsp" />
            <form:file name="location_file" label="File:" />
            <form:hidden name="<%= WhLocation.CUSTOMER_ID_COLUMN %>" value="<%= new Integer(user.getCustomerId()).toString() %>" />
            <form:row_begin />
                <form:label name="" label="" />
                <form:buttonset_begin align="left" padding="0"/>
                        <form:submit_inline button="save" waiting="true" name="import" action="import" />
                <form:buttonset_end />
            <form:row_end />
            <form:row_begin/>
            <form:label label="Excel Template:" name=""/>
            <form:content_begin />
                <a href="/excel_examples/wh_import.xlsx">Download</a>
            <form:content_end />
            <form:row_end/>
    <form:end />
<admin:box_end />

<admin:subtitle text="Add Warehouse Location" />
<admin:box_begin text="Add Warehouse Location" name="Add" />
    <form:begin submit="true" name="create" action="whlocations/process.jsp" />
            <form:textfield name="<%= WhLocation.NAME_COLUMN %>" label="name:" />
            <form:hidden name="<%= WhLocation.CUSTOMER_ID_COLUMN %>" value="<%= new Integer(user.getCustomerId()).toString() %>" />
            <form:row_begin />
                <form:label name="" label="" />
                <form:buttonset_begin align="left" padding="0"/>
                        <form:submit_inline button="save" waiting="true" name="save" action="create" />
                <form:buttonset_end />
            <form:row_end />
    <form:end />
<admin:box_end />

<form:begin name="export_whlocation" action="../DownloadReportServlet" />
	<form:row_begin />
            <form:buttonset_begin align="left" padding="10"/>
                <form:submit_inline button="submit" waiting="true" name="Export To Excel" action="test" />
            <form:buttonset_end />
        <form:row_end />
		<form:hidden name="reportType" value="export_whlocation" />
		<form:hidden name="<%= RTUser.CUSTOMER_ID_COLUMN %>" value="<%= user.getCustomerId() %>" />
	<form:end />

<% if(contents.howMany() > 0) { %>
    <admin:subtitle text="Warehouse Locations" />
    <admin:box_begin text="Warehouse Locations" name="Warehouse_Locations" />
        <listing:begin />
            <listing:header_begin />
                <listing:header_cell first="true" name="Name" />
                <listing:header_cell width="100" name="" />
            <listing:header_end />
            <% for(int i=0; i<contents.howMany(); i++) { %>
            <% content = (WhLocation)contents.get(i); %>
            <listing:row_begin row="<%= new Integer(i).toString() %>" />
                <listing:cell_begin />
                    <%= content.getName() %>
                <listing:cell_end />
                <listing:cell_begin align="right"/>
                <% tempUrl = "whlocations/process.jsp?submit_action=delete&" + WhLocation.PARAM + "=" + content.getId(); %>
                <form:linkbutton warning="true" url="<%= tempUrl %>" process="true" name="DELETE" />
                <listing:cell_end />
            <listing:row_end />
            <% } %>
        <listing:end />
    <admin:box_end />
<% } else { %>
    <admin:subtitle text="There are no Warehouse Locations." />
<% } %>

<admin:set_tabset url="whlocations/_tabset_default.jsp" thispage="search.jsp" />
<html:end />
