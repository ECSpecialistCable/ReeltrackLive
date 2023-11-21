<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.monumental.trampoline.security.*" %>
<%@ page import="com.monumental.trampoline.content.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.monumental.trampoline.security.SecurityMgr" />
<jsp:useBean id="userLoginMgr" class="com.monumental.trampoline.security.UserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% securityMgr.init(dbResources); %>
<%
User user = userLoginMgr.getUser();
boolean canAdd = false;
boolean canDelete = false;
try { canAdd = user.getGroup().getPermission(new Group()).getAdd(); } catch (Exception e) {}
try { canDelete = user.getGroup().getPermission(new Group()).getEdit(); } catch (Exception e) {}
%>
<%
Group group = new Group();
CompEntities groups = securityMgr.getGroups(group, true, false);

String tempUrl; //var for url expression
%>

<% dbResources.close(); %>

<html:begin />
<admin:title text="Groups" />
<notifier:show_message />

<% if(canAdd) { %>
<admin:subtitle text="Create a New Group" />
<admin:box_begin />
    <form:begin name="create" action="users/process_groups.jsp" />
        <form:row_begin />
            <form:label name="" label="Name:" />
            <form:content_begin />
                <form:textfield_inline name="<%= Group.NAME_COLUMN %>" label="" />
                <form:buttonset_begin align="left" padding="0"/>
                    <form:submit_inline button="save" waiting="true" name="save" action="add" />
                <form:buttonset_end />
            <form:content_end />
        <form:row_end />
    <form:end />
<admin:box_end />
<% } %>

<% if(groups.howMany() > 0) { %>
    <admin:subtitle text="Current Groups" />
    <admin:box_begin color="false" />
        <listing:begin />
            <listing:header_begin />
                <listing:header_cell first="true" width="500" name="Name" />
                <listing:header_cell name="" />
            <listing:header_end />
            <% for(int i=0; i<groups.howMany(); i++) { %>
                <% group = (Group)groups.get(i); %>
                <listing:row_begin row="<%= new Integer(i).toString() %>" />
                    <listing:cell_begin />
                        <% tempUrl = "users/edit_group.jsp?" +  Group.PARAM + "=" + group.getId(); %>
                        <form:linkbutton url="<%= tempUrl %>" name="<%= group.getName() %>" />
                    <listing:cell_end />
                    <listing:cell_begin align="right"/>
                        <% tempUrl = "users/edit_group.jsp?" +  Group.PARAM + "=" + group.getId(); %>
                        <form:linkbutton url="<%= tempUrl %>" name="[Edit]" />
                        <% if(canDelete) { %>
                            <% tempUrl = "users/process_groups.jsp?submit_action=delete&" + Group.PARAM + "=" + group.getId(); %>
                            <form:linkbutton warning="true" url="<%= tempUrl %>" process="true" name="[Delete]" />
                        <% } %>
                    <listing:cell_end />
                <listing:row_end />	
            <% } %>
        <listing:end />
    <admin:box_end />
<% } else { %>
    <admin:subtitle text="There are no Groups." />
<% } %>

<admin:set_tabset url="users/_tabset_groups.jsp" thispage="groups.jsp" />
<html:end />