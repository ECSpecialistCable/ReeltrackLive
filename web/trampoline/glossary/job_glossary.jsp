<%@page import="com.reeltrack.glossary.Glossary"%>
<%@page import="com.monumental.trampoline.datasources.DbResources"%>
<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.monumental.trampoline.component.CompEntities"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<jsp:useBean id="glossaryMgr" class="com.reeltrack.glossary.GlossaryMgr"/>
<% userLoginMgr.init(pageContext); %>
<% glossaryMgr.init(pageContext,dbResources); %>

<%
RTUser user = (RTUser)userLoginMgr.getUser();

Glossary content = new Glossary();
content.setJobId(user.getJobId());
content.setIsVideo("n");
CompEntities contents = glossaryMgr.searchGlossary(content, Glossary.NAME_COLUMN, true, 0, 0);
dbResources.close();
%>
<%
boolean canEdit = false;
if(user.isUserType(RTUser.USER_TYPE_ECS)) {
    canEdit = true;
}
%>

<html:begin />
<admin:title heading="Glossary" text="Job"/>
<% if(canEdit) { %>
<admin:subtitle text="Import Job Glossary" />
<admin:box_begin text="Import Job Glossary" name="Import" />
	<form:begin_multipart name="import_glossary" action="glossary/process.jsp"/>
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
		<a href="/excel_examples/job_glossary_import.xlsx">Download</a>
	<form:content_end />
	<form:row_end/>
	<form:end/>
<admin:box_end/>

<admin:subtitle text="Add Job Glossary" />
<admin:box_begin text="Add Job Glossary" name="Add" />
    <form:begin submit="true" name="create_job_glossary" action="glossary/process.jsp" />

    		<form:textfield name="<%= Glossary.NAME_COLUMN %>" label="Name:" />
    		<form:textarea name="<%= Glossary.DESCRIPTION_COLUMN %>" rows="3" label="Description:" value="" />
			<form:row_begin />
				<form:label name="" label="Type:" />
				<form:content_begin />
					<form:select_begin name="<%= Glossary.GLOSSARY_TYPE_COLUMN %>" />
						<% for(String type:Glossary.GLOSSARY_TYPES) { %>
							<form:option name="<%= type %>" value="<%= type %>" />
						<% } %>
					<form:select_end />
				<form:content_end />
			<form:row_end />
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
						<form:submit_inline button="save" waiting="true" name="save" action="create_job_glossary" />
				<form:buttonset_end />
			<form:row_end />
    <form:end />
<admin:box_end />
<% } %>

<% if(contents.howMany() > 0) { %>
    <admin:subtitle text="Job Glossary Found" />
    <admin:box_begin text="Job Glossary" name="Job_Glossary" />
        <listing:begin />
            <listing:header_begin />
                <listing:header_cell first="true" width="150" name="Name" />
                <listing:header_cell name="Description" />
                <listing:header_cell width="110" name="Type" />
                <% if(canEdit) { %>
                <listing:header_cell width="100" name="" />
                <% } %>
            <listing:header_end />
            <% for(int i=0; i<contents.howMany(); i++) { %>
            <% content = (Glossary)contents.get(i); %>
            <listing:row_begin row="<%= new Integer(i).toString() %>" />
                <listing:cell_begin />
                    <%= content.getName() %>
                <listing:cell_end />
                <listing:cell_begin />
                    <%= content.getDescription() %>
                <listing:cell_end />
				<listing:cell_begin />
                    <%= content.getGlossaryType() %>
                <listing:cell_end />
                <% if(canEdit) { %>
                <listing:cell_begin align="right"/>
                    <% String tempUrl = "glossary/edit.jsp?" +  Glossary.PARAM + "=" + content.getId(); %>
                    <form:linkbutton url="<%= tempUrl %>" name="EDIT" />
                    <% tempUrl = "glossary/process.jsp?submit_action=delete_job_glossary&" + Glossary.PARAM + "=" + content.getId(); %>
                    <form:linkbutton warning="true" url="<%= tempUrl %>" process="true" name="DELETE" />
                <listing:cell_end />
                <% } %>
            <listing:row_end />
            <% } %>
        <listing:end />
    <admin:box_end />
<% } else { %>
    <admin:subtitle text="No Job Glossary Found." />
<% } %>

<admin:set_tabset url="glossary/_tabset_default.jsp" thispage="job_glossary.jsp" />
<html:end />
