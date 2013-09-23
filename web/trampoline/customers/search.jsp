<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.customers.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="customerMgr" class="com.reeltrack.customers.CustomerMgr" scope="request"/>
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% customerMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<% 
Customer content = new Customer();
CompEntities contents = customerMgr.searchCustomer(content, Customer.NAME_COLUMN, true);
String tempUrl; //var for url expression
%>	
<% dbResources.close(); %>


<html:begin />
<admin:title text="Customers" />

<% if(contents.howMany() > 0) { %>
    <admin:subtitle text="Customers" />
    <admin:box_begin color="false" />
        <listing:begin />
            <listing:header_begin />
                <listing:header_cell first="true" name="Name" />
                <listing:header_cell width="100" name="Status" />
                <listing:header_cell width="100" name="" />
            <listing:header_end />
            <% for(int i=0; i<contents.howMany(); i++) { %>
            <% content = (Customer)contents.get(i); %>
            <listing:row_begin row="<%= new Integer(i).toString() %>" />
                <listing:cell_begin />
                    <% tempUrl = "customers/edit.jsp?" +  Customer.PARAM + "=" + content.getId(); %>
                    <form:linkbutton url="<%= tempUrl %>" name="<%= content.getName() %>" />
                <listing:cell_end />
                <listing:cell_begin />
                    <%= content.getStatus() %>
                <listing:cell_end />
                <listing:cell_begin align="right"/>
                <% tempUrl = "customers/edit.jsp?" +  Customer.PARAM + "=" + content.getId(); %>
                <form:linkbutton url="<%= tempUrl %>" name="EDIT" />
                &nbsp;
                <% tempUrl = "customers/process.jsp?submit_action=delete&" + Customer.PARAM + "=" + content.getId(); %>
                <form:linkbutton warning="true" url="<%= tempUrl %>" process="true" name="DELETE" />
                <listing:cell_end />
            <listing:row_end />	
            <% } %>
        <listing:end />
    <admin:box_end />
<% } else { %>
    <admin:subtitle text="There are no Customers." />
<% } %>

<admin:set_tabset url="customers/_tabset_default.jsp" thispage="search.jsp" />
<html:end />	