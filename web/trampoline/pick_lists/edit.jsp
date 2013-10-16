<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.reeltrack.picklists.*" %>
<%@ page import="com.reeltrack.foremans.*" %>
<%@ page import="com.monumental.trampoline.component.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="foremanMgr" class="com.reeltrack.foremans.ForemanMgr" scope="request"/>
<jsp:useBean id="picklistMgr" class="com.reeltrack.picklists.PickListMgr" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% foremanMgr.init(pageContext,dbResources); %>
<% picklistMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<%
// Get the id
int contid = 0;
if(request.getParameter(PickList.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(PickList.PARAM));
} else {
    String param = "content_id_for_tabset";
    if(request.getParameter(param) != null) {
        contid = Integer.parseInt(request.getParameter(param));
    }
}

// Get the piece of content
PickList content = new PickList();
content.setId(contid);
content = (PickList)picklistMgr.getPickList(content);

Foreman foreman = new Foreman();
foreman.setCustomerId(user.getCustomerId());
CompEntities foremans = foremanMgr.searchForeman(foreman, Foreman.NAME_COLUMN, true);

String tempURL; //var for url expression
%>
<% dbResources.close(); %>

<html:begin />
<admin:title text="<%= content.getTitle() %>" />
<notifier:show_message />

<admin:subtitle text="General Info" />
<admin:box_begin />
    <form:begin submit="true" name="edit" action="pick_lists/process.jsp" />
    		<form:textfield label="Name:" name="<%= PickList.NAME_COLUMN %>" value="<%= content.getName() %>" />
    		<form:row_begin />
	            <form:label name="" label="Checked OUT to:" />
	            <form:content_begin />
	            <form:select_begin name="<%= PickList.FOREMAN_COLUMN %>" />
	                <form:option name="None" value="" match="<%= content.getForeman() %>" />
	                <% for(int f=0; f<foremans.howMany(); f++) { %>
	                    <% foreman = (Foreman)foremans.get(f); %>
	                    <form:option name="<%= foreman.getName() %>" value="<%= foreman.getName() %>" match="<%= content.getForeman() %>" />
	                <% } %>
	            <form:select_end />
	            <form:content_end />
        	<form:row_end />
			<form:hidden name="<%= PickList.PARAM %>" value="<%= new Integer(contid).toString() %>" />			
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
					<form:submit_inline button="save" waiting="true" name="save" action="update" />
				<form:buttonset_end />
			<form:row_end />
    <form:end />
<admin:box_end />

<admin:set_tabset url="pick_lists/_tabset_manage.jsp" thispage="edit.jsp" content_id_for_tabset="<%= contid %>"/>
<html:end />