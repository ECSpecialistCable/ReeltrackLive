<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.security.*" %>
<%@ page import="com.monumental.trampoline.component.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.monumental.trampoline.security.SecurityMgr" />
<jsp:useBean id="userLoginMgr" class="com.monumental.trampoline.security.UserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% securityMgr.init(dbResources); %>
<%
User user = userLoginMgr.getUser();
boolean canEdit = true;
try { canEdit = user.getGroup().getPermission(new User()).getEdit(); } catch (Exception e) {}
%>
<%
// Get the id
int contid = 0;
if(request.getParameter(User.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(User.PARAM));
} else {
    String param = "content_id_for_tabset";
    if(request.getParameter(param) != null) {
        contid = Integer.parseInt(request.getParameter(param));
    }
}

// Get the piece of content
User content = new User();
content.setId(contid);
content = securityMgr.getUser(content, true, false);

Group group = new Group();
Group currentGroup = content.getGroup();
CompEntities groups = securityMgr.getGroups(group, true, false);
%>
<% dbResources.close(); %>
<html:begin />
<admin:title text="<%= content.getName() %>" />
<notifier:show_message />

<admin:subtitle text="Edit User" />
<admin:box_begin />
    <form:begin submit="<%= new Boolean(canEdit).toString() %>" name="edit" action="users/process.jsp" />

			<form:textfield name="<%= User.FIRSTNAME_COLUMN %>" label="first name:" value="<%= content.getFname() %>" />
			<form:textfield name="<%= User.LASTNAME_COLUMN %>" label="last name:" value="<%= content.getLname() %>"/>
			<form:textfield name="<%= User.EMAIL_COLUMN %>" label="email:" value="<%= content.getEmail() %>"/>
			<form:textfield name="<%= User.USERNAME_COLUMN %>" label="username:" value="<%= content.getUsername() %>"/>
			<form:textfield name="<%= User.PASSWORD_COLUMN %>" label="password:" value="<%= content.getPassword() %>"/>
			<form:row_begin />
				<form:label name="" label="Status:" />
				<form:content_begin />
					<form:select_begin name="<%= User.STATUS_COLUMN %>" label="status" />
						<form:option match="<%= content.getStatus() %>" value="<%= User.STATUS_ACTIVE %>" name="active"/>
						<form:option match="<%= content.getStatus() %>" value="<%= User.STATUS_INACTIVE %>" name="inactive"/>
					<form:select_end />
				<form:content_end />
			<form:row_end />
			<%--
			<form:row_begin />
				<form:label name="" label="Group Assignment:" />
				<form:content_begin />
					<form:select_begin name="<%= Group.NAME_COLUMN %>" label="group" />
						<% for(int i=0; i<groups.howMany(); i++) { %>
							<% group = (Group)groups.get(i); %>
							<% if(currentGroup != null) { %>
								<form:option match="<%= new Integer(content.getGroup().getId()).toString() %>" value="<%= new Integer(group.getId()).toString() %>" name="<%= group.getName() %>"/>			        			    
							<% } else { %>
								<form:option value="<%= new Integer(group.getId()).toString() %>" name="<%= group.getName() %>"/>			        			    					
							<% } %>
						<% } %>
					<form:select_end />
				<form:content_end />
			<form:row_end />
			--%>
			<form:hidden name="<%= User.PARAM %>" value="<%= new Integer(contid).toString() %>" />			
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="right" padding="0"/>
					<form:linkbutton button="cancel_off" name="Cancel" url="users/search.jsp" />
					<% if(canEdit) { %>
						<form:submit_inline button="save" waiting="true" name="save" action="update" />
					<% } %>
				<form:buttonset_end />
			<form:row_end />

    <form:end />
<admin:box_end />


<admin:set_tabset url="users/_tabset_manage.jsp" thispage="edit.jsp" content_id_for_tabset="<%= contid %>"/>
<html:end />