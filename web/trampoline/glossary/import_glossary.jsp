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
//content.setSearchOp(Glossary.JOB_ID_COLUMN, Glossary.NOT_EQUAL);
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
<admin:title text="Import Glossary" />
<% if(canEdit) { %>
<admin:box_begin />
     <form:begin_multipart submit="true" name="import_glossary" action="glossary/process.jsp" />
    		<form:file name="glossary_imported_file" label="File:" />
			<form:hidden name="<%= Glossary.PARAM %>" value="0" />
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
					<form:submit_inline button="save" waiting="true" name="save" action="import_glossary" />
				<form:buttonset_end />
			<form:row_end />
    <form:end />	
<admin:box_end />
<% } %>

<admin:set_tabset url="glossary/_tabset_default.jsp" thispage="import_glossary.jsp" />
<html:end />