<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.foremans.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="foremanMgr" class="com.reeltrack.foremans.ForemanMgr" scope="request"/>
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% foremanMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<%
boolean canEdit = false;
if(user.isUserType(RTUser.USER_TYPE_ECS) || user.isUserType(RTUser.USER_TYPE_MANAGEMENT)) {
    canEdit = true;
}
Foreman content = new Foreman();
content.setCustomerId(user.getCustomerId());
CompEntities contents = foremanMgr.searchForeman(content, Foreman.NAME_COLUMN, true);

String tempUrl =""; //var for url expression
%>
<% dbResources.close(); %>


<html:begin />
<admin:title heading="Foremen" text=""/>

<admin:subtitle text="Import Foremen" />
<admin:box_begin text="Import Foremen" name="Import_Foremen" />
	<form:begin_multipart name="import_foremen" action="foremans/process.jsp"/>
	<form:hidden name="<%= Foreman.CUSTOMER_ID_COLUMN %>" value="<%= new Integer(user.getCustomerId()).toString() %>" />
	<form:file label="Excel File:" name="excel_upload" />
	<form:row_begin/>
		<form:label label="" name=""/>
		<form:buttonset_begin padding="0" align="left"/>
			<form:submit_inline name="SAVE" button="save" waiting="true" action="import"/>
		<form:buttonset_end/>
	<form:row_end/>

	<form:row_begin/>
	<form:label label="Excel Template:" name=""/>
	<form:content_begin />
		<a href="/excel_examples/foreman_import.xlsx">Download</a>
	<form:content_end />
	<form:row_end/>
	<form:end/>
<admin:box_end/>

<admin:subtitle text="Add Foreman" />
<admin:box_begin text="Add Foreman" name="Add_Foreman" />
    <form:begin submit="true" name="create" action="foremans/process.jsp" />
            <form:textfield name="<%= Foreman.NAME_COLUMN %>" label="name:" />
            <form:hidden name="<%= Foreman.CUSTOMER_ID_COLUMN %>" value="<%= new Integer(user.getCustomerId()).toString() %>" />
            <form:row_begin />
                <form:label name="" label="" />
                <form:buttonset_begin align="left" padding="0"/>
                        <form:submit_inline button="save" waiting="true" name="save" action="create" />
                <form:buttonset_end />
            <form:row_end />
    <form:end />
<admin:box_end />

<% if(contents.howMany() > 0) { %>
    <admin:subtitle text="Foremen" />
    <admin:box_begin text="Foremen" name="Foremen" />
        <listing:begin />
            <listing:header_begin />
                <listing:header_cell first="true" name="Name" />
                <listing:header_cell width="100" name="" />
            <listing:header_end />
            <% for(int i=0; i<contents.howMany(); i++) { %>
            <% content = (Foreman)contents.get(i); %>
            <listing:row_begin row="<%= new Integer(i).toString() %>" />
                <listing:cell_begin />
                    <% if(canEdit) { %>
                    <form:begin_inline action="foremans/process.jsp" name="update_foreman" />
                        <form:textfield_inline pixelwidth="150" label="" value="<%= content.getName() %>" name="<%= Foreman.NAME_COLUMN %>" />
                        <form:hidden name="<%= Foreman.PARAM  %>" value="<%= new Integer(content.getId()).toString() %>" />
                        <form:hidden name="submit_action" value="update" />
                        <%--<form:submit_inline  button="save" waiting="true" name="save" action="update" />--%>
                    <form:end_inline />
                    <% } else { %>
                        <%= content.getName() %>
                    <% } %>
                <listing:cell_end />
                <listing:cell_begin align="right"/>
                <% tempUrl = "foremans/process.jsp?submit_action=delete&" + Foreman.PARAM + "=" + content.getId(); %>
                <form:linkbutton warning="true" url="<%= tempUrl %>" process="true" name="DELETE" />
                <listing:cell_end />
            <listing:row_end />
            <% } %>
        <listing:end />
    <admin:box_end />
<% } else { %>
    <admin:subtitle text="There are no Foremen." />
<% } %>

<admin:set_tabset url="foremans/_tabset_default.jsp" thispage="search.jsp" />
<html:end />
