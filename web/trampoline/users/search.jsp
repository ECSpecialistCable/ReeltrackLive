<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.monumental.trampoline.security.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.monumental.trampoline.security.SecurityMgr" scope="request"/>
<jsp:useBean id="userLoginMgr" class="com.monumental.trampoline.security.UserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% securityMgr.init(dbResources); %>
<%
User user = userLoginMgr.getUser();
boolean canAdmin = false;
boolean canDelete = false;
try { canAdmin = user.getGroup().getPermission(new User()).getAdmin(); } catch (Exception e) {}
try { canDelete = user.getGroup().getPermission(new User()).getDelete(); } catch (Exception e) {}
%>
<% 
User content = new User();
CompEntities contents = new CompEntities();
%>
<%  
contents = securityMgr.getUsers(content, false);
contents.sortByMethodName("getLname",true);

String tempUrl; //var for url expression
%>	


<% dbResources.close(); %>
<html:begin />
<admin:title text="Users" />

<% if(contents.howMany() > 0) { %>
    <admin:subtitle text="Current Users" />
    <admin:box_begin color="false" />
        <listing:begin />
            <listing:header_begin />
                <listing:header_cell first="true" width="200" name="Name" />
                <listing:header_cell width="150" name="Username" />
                <listing:header_cell width="100" name="Status" />
                <listing:header_cell name="" />
            <listing:header_end />
            <% for(int i=0; i<contents.howMany(); i++) { %>
            <% content = (User)contents.get(i); %>
            <listing:row_begin row="<%= new Integer(i).toString() %>" />
                <listing:cell_begin />
                    <% tempUrl = "users/edit.jsp?" +  User.PARAM + "=" + content.getId(); %>
                    <form:linkbutton url="<%= tempUrl %>" name="<%= content.getName() %>" />
                <listing:cell_end />
                <listing:cell_begin />
                    <%= content.getUsername() %>
                <listing:cell_end />
                <listing:cell_begin />
                    <%= content.getStatus() %>
                <listing:cell_end />
                <listing:cell_begin align="right"/>
                    <% if(canAdmin || content.getId()==user.getId()) { %>
                        <% tempUrl = "users/edit.jsp?" +  User.PARAM + "=" + content.getId(); %>
                        <form:linkbutton url="<%= tempUrl %>" name="[Edit]" />
                    <% } %>
                    <% if(canDelete) { %>
                        <% tempUrl = "users/process.jsp?submit_action=delete&" + User.PARAM + "=" + content.getId(); %>
                        <form:linkbutton warning="true" url="<%= tempUrl %>" process="true" name="[Delete]" />
                    <% } %>
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