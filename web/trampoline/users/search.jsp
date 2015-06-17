<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% securityMgr.init(dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<% 
RTUser content = new RTUser();
content.setUserType(RTUser.USER_TYPE_ECS);
CompEntities contents = securityMgr.getUsers(content, false);
content.setUserType(RTUser.USER_TYPE_VENDOR);
contents.add(securityMgr.getUsers(content, false));
contents.sortByMethodName("getLname",true);
String tempUrl;
%>	


<% dbResources.close(); %>
<html:begin />
<admin:title text="Users" />

<% if(contents.howMany() > 0) { %>
    <admin:subtitle text="Current Users" />
    <admin:box_begin color="false" />
        <listing:begin />
            <listing:header_begin />
                <listing:header_cell first="true" name="Name" />
                <listing:header_cell width="50" name="Code" />
                <listing:header_cell width="100" name="Type" />
                <listing:header_cell width="75" name="Status" />
                <listing:header_cell width="110" name="" />
            <listing:header_end />
            <% for(int i=0; i<contents.howMany(); i++) { %>
            <% content = (RTUser)contents.get(i); %>
            <listing:row_begin row="<%= new Integer(i).toString() %>" />
                <listing:cell_begin />
                    <%= content.getName() %>
                <listing:cell_end />
                <listing:cell_begin />
                    <%= content.getVendorCode() %>
                <listing:cell_end />
                <listing:cell_begin />
                    <%= content.getUserType() %>
                <listing:cell_end />
                <listing:cell_begin />
                    <%= content.getStatus() %>
                <listing:cell_end />
                <listing:cell_begin align="right"/>
                <% tempUrl = "users/edit.jsp?" +  RTUser.PARAM + "=" + content.getId(); %>
                <form:linkbutton url="<%= tempUrl %>" name="EDIT" />
                <% tempUrl = "users/process.jsp?submit_action=delete&" + RTUser.PARAM + "=" + content.getId(); %>
                <form:linkbutton warning="true" url="<%= tempUrl %>" process="true" name="DELETE" />
                <listing:cell_end />
            <listing:row_end />	
            <% } %>
        <listing:end />
    <admin:box_end />
<% } else { %>
    <admin:subtitle text="There are no Users." />
<% } %>

<admin:set_tabset url="users/_tabset_default.jsp" thispage="search.jsp" />
<html:end />	