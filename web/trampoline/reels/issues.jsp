<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.monumental.trampoline.utilities.text.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% reelMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<%
// Get the id
int contid = 0;
if(request.getParameter(Reel.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(Reel.PARAM));
} else {
    String param = "content_id_for_tabset";
    if(request.getParameter(param) != null) {
        contid = Integer.parseInt(request.getParameter(param));
    }
}

// Get the piece of content
Reel content = new Reel();
content.setId(contid);
content = (Reel)reelMgr.getReel(content);

CompEntities issuesYes = reelMgr.getReelIssues(content,true);
CompEntities issuesNo = reelMgr.getReelIssues(content,false);
ReelIssue issue;

String tempURL; //var for url expression
%>
<% dbResources.close(); %>

<html:begin />
<admin:title text="<%= content.getTitle() %>" />
<notifier:show_message />

<admin:subtitle text="Add Issue" />
<admin:box_begin />
    <form:begin submit="true" name="edit" action="reels/process.jsp" />
    		<form:textarea name="<%= ReelIssue.DESCRIPTION_COLUMN %>" rows="3" label="Brief Description:" value="" />
            <form:textarea name="<%= ReelIssue.ISSUE_LOG_COLUMN %>" rows="6" label="Issue Log:" value="" />
			<form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />			
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
					<form:submit_inline button="save" waiting="true" name="save" action="add_issue" />
				<form:buttonset_end />
			<form:row_end />
    <form:end />
<admin:box_end />

<% if(issuesNo.howMany()==0 && issuesYes.howMany()==0) { %>
    <admin:subtitle text="There are no Issues" />
<% } %>

<% if(issuesNo.howMany() > 0) { %>
    <admin:subtitle text="Unresolved Issues" />
    <% for(int x=0; x<issuesNo.howMany(); x++) { %>
    <% issue = (ReelIssue)issuesNo.get(x); %>
    <admin:box_begin />
    <% tempURL = "issueN" + x; %>
    <form:begin submit="true" name="<%= tempURL %>" action="reels/process.jsp" />
            <form:row_begin />
                <form:label name="" label="Is Resolved?:" />
                <form:content_begin />      
                    <form:checkbox label="" name="<%= ReelIssue.IS_RESOLVED_COLUMN %>" value="y" match="<%= issue.getIsResolved() %>" />       
                <form:content_end />                
            <form:row_end />
            <form:info label="Created:" text="<%= issue.getCreatedDateText() %>" />
            <form:info label="By User:" text="<%= issue.getCreatedBy() %>" />
            <form:info label="Brief Description:" text="<%= issue.getDescription() %>" />
            <form:info label="Issue Log:" text="<%= TextParser.addBreakTags(issue.getIssueLog()) %>" />
            <form:textarea name="<%= ReelIssue.ISSUE_LOG_COLUMN %>" rows="6" label="Add to Issue Log:" value="" />
            <form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />
            <form:hidden name="<%= ReelIssue.PARAM %>" value="<%= new Integer(issue.getId()).toString() %>" />           
            <form:row_begin />
                <form:label name="" label="" />
                <form:buttonset_begin align="left" padding="0"/>
                    <form:submit_inline button="save" waiting="true" name="save" action="update_issue" />
                <form:buttonset_end />
            <form:row_end />
    <form:end />
    <admin:box_end />
    <% } %>
<% } %>

<% if(issuesYes.howMany() > 0) { %>
    <admin:subtitle text="Resolved Issues" />
    <% for(int x=0; x<issuesYes.howMany(); x++) { %>
    <% issue = (ReelIssue)issuesYes.get(x); %>
    <admin:box_begin />
    <% tempURL = "issueY" + x; %>
    <form:begin submit="true" name="<%= tempURL %>" action="reels/process.jsp" />
            <form:row_begin />
                <form:label name="" label="Is Resolved?:" />
                <form:content_begin />      
                    <form:checkbox label="" name="<%= ReelIssue.IS_RESOLVED_COLUMN %>" value="y" match="<%= issue.getIsResolved() %>" />       
                <form:content_end />                
            <form:row_end />
            <form:info label="Created:" text="<%= issue.getCreatedDateText() %>" />
            <form:info label="By User:" text="<%= issue.getCreatedBy() %>" />
            <form:info label="Brief Description:" text="<%= issue.getDescription() %>" />
            <form:info label="Issue Log:" text="<%= TextParser.addBreakTags(issue.getIssueLog()) %>" />
            <form:textarea name="<%= ReelIssue.ISSUE_LOG_COLUMN %>" rows="6" label="Add to Issue Log:" value="" />
            <form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />
            <form:hidden name="<%= ReelIssue.PARAM %>" value="<%= new Integer(issue.getId()).toString() %>" />           
            <form:row_begin />
                <form:label name="" label="" />
                <form:buttonset_begin align="left" padding="0"/>
                    <form:submit_inline button="save" waiting="true" name="save" action="update_issue" />
                <form:buttonset_end />
            <form:row_end />
    <form:end />
    <admin:box_end />
    <% } %>
<% } %>

<admin:set_tabset url="reels/_tabset_manage.jsp" thispage="issues.jsp" content_id_for_tabset="<%= contid %>"/>
<html:end />