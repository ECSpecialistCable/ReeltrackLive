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
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>
<jsp:useBean id="customerMgr" class="com.reeltrack.customers.CustomerMgr" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% securityMgr.init(dbResources); %>
<% customerMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<%
int contid = 0;
if(request.getParameter(Customer.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(Customer.PARAM));
} else {
    String param = "content_id_for_tabset";
    if(request.getParameter(param) != null) {
        contid = Integer.parseInt(request.getParameter(param));
    }
}

// Get the piece of content
Customer content = new Customer();
content.setId(contid);
content = (Customer)customerMgr.getCustomer(content);

// get User List
RTUser custUser = new RTUser();
custUser.setCustomerId(content.getId());
CompEntities users = securityMgr.getUsers(custUser, false);
users.sortByMethodName("getLname",true);
String tempUrl;
%>	


<% dbResources.close(); %>
<html:begin />
<admin:title text="Users" />

<admin:subtitle text="Add User" />
<admin:box_begin />
    <form:begin submit="true" name="create" action="customers/process.jsp" />

            <form:row_begin />
                <form:label name="" label="User Type:" />
                <form:content_begin />
                    <form:select_begin name="<%= RTUser.USER_TYPE_COLUMN %>" label="usertype" />
                        <form:option value="<%= RTUser.USER_TYPE_MANAGEMENT %>" name="Management"/>
                        <form:option value="<%= RTUser.USER_TYPE_STANDARD %>" name="Standard"/>
                    <form:select_end />
                <form:content_end />
            <form:row_end />
            <form:textfield name="<%= RTUser.FIRSTNAME_COLUMN %>" label="first name:" />
            <form:textfield name="<%= RTUser.LASTNAME_COLUMN %>" label="last name:" />
            <form:textfield name="<%= RTUser.EMAIL_COLUMN %>" label="email:" />
            <form:textfield name="<%= RTUser.USERNAME_COLUMN %>" label="username:" required="true" />
            <form:textfield name="<%= RTUser.PASSWORD_COLUMN %>" label="password:" required="true" />
            <form:hidden name="<%= Customer.PARAM %>" value="<%= content.getId() %>" />
            <form:row_begin />
                <form:label name="" label="" />
                <form:buttonset_begin align="right" padding="0"/>
                        <form:submit_inline button="save" waiting="true" name="save" action="add_user" />
                <form:buttonset_end />
            <form:row_end />
    <form:end />
<admin:box_end />

<% if(users.howMany() > 0) { %>
    <admin:subtitle text="Users" />
    <admin:box_begin color="false" />
        <listing:begin />
            <listing:header_begin />
                <listing:header_cell first="true" name="Name" />
                <listing:header_cell width="100" name="Type" />
                <listing:header_cell width="100" name="Status" />
                <listing:header_cell width="100" name="" />
            <listing:header_end />
            <% for(int i=0; i<users.howMany(); i++) { %>
            <% custUser = (RTUser)users.get(i); %>
            <listing:row_begin row="<%= new Integer(i).toString() %>" />
                <listing:cell_begin />
                    <% tempUrl = "customers/edit_user.jsp?" +  RTUser.PARAM + "=" + custUser.getId(); %>
                    <form:linkbutton url="<%= tempUrl %>" name="<%= custUser.getName() %>" />
                <listing:cell_end />
                <listing:cell_begin />
                    <%= custUser.getUserType() %>
                <listing:cell_end />
                <listing:cell_begin />
                    <%= custUser.getStatus() %>
                <listing:cell_end />
                <listing:cell_begin align="right"/>
                <% tempUrl = "customers/edit_user.jsp?" +  RTUser.PARAM + "=" + custUser.getId();%>
                <form:linkbutton url="<%= tempUrl %>" name="EDIT" />
                &nbsp;
                <% tempUrl = "customers/process.jsp?submit_action=delete_user&" + RTUser.PARAM + "=" + custUser.getId() + "&" + Customer.PARAM + "=" + content.getId(); %>
                <form:linkbutton warning="true" url="<%= tempUrl %>" process="true" name="DELETE" />
                <listing:cell_end />
            <listing:row_end />	
            <% } %>
        <listing:end />
    <admin:box_end />
<% } else { %>
    <admin:subtitle text="There are no Users assigned to this Customer." />
<% } %>

<admin:set_tabset url="customers/_tabset_manage.jsp" thispage="users.jsp" content_id_for_tabset="<%= contid %>"/>
<html:end />	