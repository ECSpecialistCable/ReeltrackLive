<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.monumental.trampoline.security.*" %>
<%@ page import="com.monumental.trampoline.content.*" %>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="loginMgr" class="com.monumental.trampoline.security.UserLoginMgr"/>
<jsp:useBean id="securityMgr" class="com.monumental.trampoline.security.SecurityMgr" />

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>

<% loginMgr.init(pageContext, dbResources); %>
<% securityMgr.init(dbResources); %>
<% loginMgr.onlyUsers( "/trampoline/admin/reload.jsp"); %>
<% CompProperties props = new CompProperties(); %>
<%

Group group = new Group();
int gid = 0;
if(request.getParameter(Group.PARAM)!=null) {
    gid = Integer.parseInt(request.getParameter(Group.PARAM));
}

String basePath = pageContext.getServletContext().getRealPath("/");
String action = request.getParameter("submit_action");
String redirect = request.getContextPath() + "/trampoline/" + "users/groups.jsp";
String notifier = "";

if(action!=null && action.equals("add")) {
    group.setName(request.getParameter(Group.NAME_COLUMN));
    gid = securityMgr.addGroup(group);
}

if(action!=null && action.equals("delete")) {
    group.setId(gid);
    securityMgr.deleteGroup(group,basePath);
}

if(action!=null && action.equals("add_permission")) {
    group.setId(gid);
    Permission permission = new Permission();
    if(request.getParameter(Permission.ADD_COLUMN)!=null) {
        permission.setAdd(true);
    }
    if(request.getParameter(Permission.EDIT_COLUMN)!=null) {
        permission.setEdit(true);
    }
    if(request.getParameter(Permission.ACTIVATE_COLUMN)!=null) {
        permission.setActivate(true);
    }
    if(request.getParameter(Permission.DELETE_COLUMN)!=null) {
        permission.setDelete(true);
    }
    if(request.getParameter(Permission.ADMIN_COLUMN)!=null) {
        permission.setAdmin(true);
    }
    permission.setComponentType(request.getParameter(Permission.COMPONENT_TYPE_COLUMN));
    securityMgr.addPermission(permission,group);
    redirect = request.getContextPath() + "/trampoline/" + "users/edit_group.jsp?" + Group.PARAM + "=" + gid;
//notifier = "Permission has been added.";
}

if(action!=null && action.equals("edit_permission")) {
    Permission permission = new Permission();
    if(request.getParameter(Permission.ADD_COLUMN)!=null) {
        permission.setAdd(true);
    } else {
        permission.setAdd(false);
    }
    if(request.getParameter(Permission.EDIT_COLUMN)!=null) {
        permission.setEdit(true);
    } else {
        permission.setEdit(false);
    }
    if(request.getParameter(Permission.ACTIVATE_COLUMN)!=null) {
        permission.setActivate(true);
    } else {
        permission.setActivate(false);
    }
    if(request.getParameter(Permission.DELETE_COLUMN)!=null) {
        permission.setDelete(true);
    } else {
        permission.setDelete(false);
    }
    if(request.getParameter(Permission.ADMIN_COLUMN)!=null) {
        permission.setAdmin(true);
    } else {
        permission.setAdmin(false);
    }
    permission.setId(Integer.parseInt(request.getParameter(Permission.PARAM)));
    securityMgr.updatePermission(permission);
    redirect = request.getContextPath() + "/trampoline/" + "users/edit_group.jsp?" + Group.PARAM + "=" + gid;
//notifier = "Permission has been updated.";
}

if(action!=null && action.equals("delete_permission")) {
    Permission permission = new Permission();
    permission.setId(Integer.parseInt(request.getParameter(Permission.PARAM)));
    securityMgr.deletePermission(permission,basePath);
    redirect = request.getContextPath() + "/trampoline/" + "users/edit_group.jsp?" + Group.PARAM + "=" + gid;
//notifier = "Permission has been deleted.";
}


dbResources.close();
%>
<notifier:set_message text="<%= notifier %>" />		
<admin:ajax_redirect redirect="<%= redirect %>" />