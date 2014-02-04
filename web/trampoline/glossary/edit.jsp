<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.customers.*" %>
<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.glossary.Glossary"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>
<jsp:useBean id="glossaryMgr" class="com.reeltrack.glossary.GlossaryMgr" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% securityMgr.init(dbResources); %>
<% glossaryMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<%
// Get the id
int contid = 0;
if(request.getParameter(Glossary.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(Glossary.PARAM));
} else {
    String param = "content_id_for_tabset";
    if(request.getParameter(param) != null) {
        contid = Integer.parseInt(request.getParameter(param));
    }
}

// Get the piece of content
Glossary content = new Glossary();
content.setId(contid);
content = (Glossary)glossaryMgr.getGlossary(content);

boolean isReelTrack = false;
if(content.getJobId()==0) {
	isReelTrack = true;
}
String tempUrl; //var for url expression
%>
<% dbResources.close(); %>

<html:begin />
<admin:title text="<%= content.getName() %>" />
<notifier:show_message />

<admin:subtitle text="Edit Glossary" />
<admin:box_begin />
    <form:begin submit="true" name="edit" action="glossary/process.jsp" />

			<form:textfield name="<%= Glossary.NAME_COLUMN %>" label="Name:" value="<%= content.getName() %>" />
    		<form:textarea name="<%= Glossary.DESCRIPTION_COLUMN %>" rows="3" label="Description:" value="<%= content.getDescription() %>" />
			<form:hidden name="<%= Glossary.PARAM %>" value="<%= new Integer(contid).toString() %>" />
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
					<% if(isReelTrack) { %>
						<form:submit_inline button="save" waiting="true" name="save" action="update_reeltrack_glossary" />
					<% } else { %>
						<form:submit_inline button="save" waiting="true" name="save" action="update_job_glossary" />
					<% } %>
				<form:buttonset_end />
			<form:row_end />

    <form:end />
<admin:box_end />

<% tempUrl = "isReelTrack=" + isReelTrack; %>
<admin:set_tabset url="glossary/_tabset_manage.jsp" thispage="edit.jsp" content_id_for_tabset="<%= contid %>" params="<%= tempUrl %>" />
<html:end />