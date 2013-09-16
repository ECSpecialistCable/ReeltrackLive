<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.security.*" %>
<%@ page import="com.monumental.trampoline.component.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.monumental.trampoline.security.SecurityMgr" />
<jsp:useBean id="userLoginMgr" class="com.monumental.trampoline.security.UserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% securityMgr.init(dbResources); %>
<%
User user = userLoginMgr.getUser();
boolean canEdit = false;
try { canEdit = user.getGroup().getPermission(new Group()).getEdit(); } catch (Exception e) {}
%>
<%
// Get the id
int contid = 0;
if(request.getParameter(Group.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(Group.PARAM));
} else {
    String param = "content_id_for_tabset";
    if(request.getParameter(param) != null) {
        contid = Integer.parseInt(request.getParameter(param));
    }
}

// Get the piece of content
Group group = new Group();
group.setId(contid);
group = securityMgr.getGroup(group, true, false);

CompEntities currentPermissions = new CompEntities();
currentPermissions = group.getCompEntities("permissions");

CompEntities types = new CompEntities();

types.add(new com.monumental.trampoline.security.User() );
types.add(new com.monumental.trampoline.security.Group() );
types.add(new com.kredible.profiles.Profile());
types.add(new com.kredible.projects.Project());
types.add(new com.kredible.reports.Report());
types.add(new com.kredible.grading.GradingCategory());
types.add(new com.kredible.grading.GradingTemplate());
types.add(new com.kredible.manualResponses.ManualResponseTemplate());
types.add(new com.kredible.pdfInserts.PdfInsertTemplate());
types.add(new com.kredible.liApiFields.LinkedInApiField());
types.add(new com.kredible.videoLinks.VideoLink());
types.add(new com.kredible.tokens.Token());

// Now remove any permissions that we currently have assigned
for(int i = 0; i < currentPermissions.howMany(); i++) { 
	Permission currentPermission = (Permission)currentPermissions.get(i);
	String currentLabel = ((CompEntity)Class.forName(currentPermission.getComponentType()).newInstance()).getTypeName();

	int position = types.findPos("getTypeName", currentLabel);
	if(position != -1) {
		types.remove(position);
	}
}

String tempUrl; //var for url expression
String tempLabel; //var for label expression
%>
<% dbResources.close(); %>

<html:begin />
<admin:title text="<%= group.getName() %>" />
<notifier:show_message />

<% if(canEdit) { %>
	<% if(types.howMany() > 0) { %>
		<admin:subtitle text="Add Group Permissions" />
		<admin:box_begin />
			<form:begin name="add_permission" action="users/process_groups.jsp" />
				<form:row_begin />
					<form:label name="" label="Module:" />
					<form:content_begin />
						<form:select_begin name="<%= Permission.COMPONENT_TYPE_COLUMN %>" label="Module Name" />
							<% CompEntity entity; %>
							<% while(types.hasNext()) { %>
								<% entity = (CompEntity)types.next(); %>
								<form:option name="<%= entity.getTypeName() %>" value="<%= entity.getType() %>" />
							<% } %>
						<form:select_end />
					<form:content_end />
				<form:row_end />
				<form:row_begin />
					<form:label name="" label="Permissions:" />
					<form:content_begin />
						<form:checkbox label="add" name="<%= Permission.ADD_COLUMN %>" value="<%= Permission.ADD_COLUMN %>" />
						&nbsp;<form:checkbox label="edit" name="<%= Permission.EDIT_COLUMN %>" value="<%= Permission.EDIT_COLUMN %>" />
						&nbsp;<form:checkbox label="activate" name="<%= Permission.ACTIVATE_COLUMN %>" value="<%= Permission.ACTIVATE_COLUMN %>" />
						&nbsp;<form:checkbox label="delete" name="<%= Permission.DELETE_COLUMN %>" value="<%= Permission.DELETE_COLUMN %>" />
						&nbsp;<form:checkbox label="admin" name="<%= Permission.ADMIN_COLUMN %>" value="<%= Permission.ADMIN_COLUMN %>" />
					<form:content_end />
				<form:row_end />
				<form:hidden name="<%= Group.PARAM %>" value="<%= new Integer(group.getId()).toString() %>" />
				<form:row_begin />
					<form:label name="" label="" />
					<form:buttonset_begin align="right" padding="0"/>
						<form:submit_inline button="save" waiting="true" name="save" action="add_permission" />
					<form:buttonset_end />
				<form:row_end />
				<form:end />
			<form:end />
		<admin:box_end />
	<% } %>
<% } %>

<admin:subtitle text="Edit Group Permissions" />


	<listing:begin />
  	  <listing:header_begin />
	        <listing:header_cell first="true" width="100" name="Module" />
	        <listing:header_cell width="300" name="Permissions" />
	    <listing:header_end />

    <% CompEntities permissions = new CompEntities(); %>
    <% permissions = group.getCompEntities("permissions"); %>
    <% Permission permission; %>
    <% for(int i = 0; i < permissions.howMany(); i++) { %>
        <% permission = (Permission)permissions.get(i); %>
		<listing:row_begin row="<%= new Integer(i).toString() %>" />
        	<listing:cell_begin />
                <% tempLabel = ((CompEntity)Class.forName(permission.getComponentType()).newInstance()).getTypeName() + ":"; %>
				<%= tempLabel %>
			<listing:cell_end />

        	<listing:cell_begin />
				<% String formName = i + "_edit_permission"; %>
        		<form:begin name="<%= formName %>" action="users/process_groups.jsp" />	
                    <form:checkbox label="add" name="<%= Permission.ADD_COLUMN %>" value="<%= new Boolean(true).toString() %>" match="<%= new Boolean(permission.getAdd()).toString() %>"/>
                    &nbsp;<form:checkbox label="edit" name="<%= Permission.EDIT_COLUMN %>" value="<%= new Boolean(true).toString() %>" match="<%= new Boolean(permission.getEdit()).toString() %>"/>
                    &nbsp;<form:checkbox label="activate" name="<%= Permission.ACTIVATE_COLUMN %>" value="<%= new Boolean(true).toString() %>" match="<%= new Boolean(permission.getActivate()).toString() %>"/>
                    &nbsp;<form:checkbox label="delete" name="<%= Permission.DELETE_COLUMN %>" value="<%= new Boolean(true).toString() %>" match="<%= new Boolean(permission.getDelete()).toString() %>"/>
                    &nbsp;<form:checkbox label="admin" name="<%= Permission.ADMIN_COLUMN %>" value="<%= new Boolean(true).toString() %>" match="<%= new Boolean(permission.getAdmin()).toString() %>"/>
                    <form:hidden name="<%= Permission.PARAM %>" value="<%= new Integer(permission.getId()).toString() %>" />
                    <form:hidden name="<%= Group.PARAM %>" value="<%= new Integer(group.getId()).toString() %>" />
                        <% if(canEdit) { %>
                            &nbsp;&nbsp;
                            <% tempUrl = "users/process_groups.jsp?submit_action=delete_permission&" + Permission.PARAM + "=" + permission.getId() + "&" + Group.PARAM + "=" + group.getId(); %>
                            <form:linkbutton warning="true" button="delete_off" waiting="true" url="<%= tempUrl %>" process="true" name="Delete" />
                            <form:submit_inline button="save" waiting="true" name="save" action="edit_permission" />
                        <% } %>
                <form:end />
            <listing:cell_end />
        <listing:row_end />
    <% } %>
	<listing:end />


<admin:set_tabset url="users/_tabset_manage_group.jsp" thispage="edit_group.jsp" content_id_for_tabset="<%= contid %>"/>
<html:end />