<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.drivers.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="driverMgr" class="com.reeltrack.drivers.DriverMgr" scope="request"/>
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% driverMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<% 
Driver content = new Driver();
content.setCustomerId(user.getCustomerId());
CompEntities contents = driverMgr.searchDriver(content, Driver.NAME_COLUMN, true);

String tempUrl =""; //var for url expression
%>	
<% dbResources.close(); %>


<html:begin />
<admin:title text="Drivers" />

<admin:subtitle text="Add Driver" />
<admin:box_begin />
    <form:begin submit="true" name="create" action="drivers/process.jsp" />
            <form:textfield name="<%= Driver.NAME_COLUMN %>" label="name:" />
            <form:hidden name="<%= Driver.CUSTOMER_ID_COLUMN %>" value="<%= new Integer(user.getCustomerId()).toString() %>" />
            <form:row_begin />
                <form:label name="" label="" />
                <form:buttonset_begin align="left" padding="0"/>
                        <form:submit_inline button="save" waiting="true" name="save" action="create" />
                <form:buttonset_end />
            <form:row_end />
    <form:end />
<admin:box_end />

<% if(contents.howMany() > 0) { %>
    <admin:subtitle text="Drivers" />
    <admin:box_begin color="false" />
        <listing:begin />
            <listing:header_begin />
                <listing:header_cell first="true" name="Name" />
                <listing:header_cell width="100" name="" />
            <listing:header_end />
            <% for(int i=0; i<contents.howMany(); i++) { %>
            <% content = (Driver)contents.get(i); %>
            <listing:row_begin row="<%= new Integer(i).toString() %>" />
                <listing:cell_begin />
                    <%= content.getName() %>
                <listing:cell_end />
                <listing:cell_begin align="right"/>
                <% tempUrl = "drivers/process.jsp?submit_action=delete&" + Driver.PARAM + "=" + content.getId(); %>
                <form:linkbutton warning="true" url="<%= tempUrl %>" process="true" name="DELETE" />
                <listing:cell_end />
            <listing:row_end />	
            <% } %>
        <listing:end />
    <admin:box_end />
<% } else { %>
    <admin:subtitle text="There are no Drivers." />
<% } %>

<admin:set_tabset url="drivers/_tabset_default.jsp" thispage="search.jsp" />
<html:end />	