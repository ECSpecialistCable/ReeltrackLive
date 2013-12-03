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

CompEntities notes = reelMgr.getReelNotes(content);
ReelNote note;

String tempURL; //var for url expression
%>
<% dbResources.close(); %>

<html:begin />
<% tempURL = content.getCrId() + " : " + content.getReelTag() + " : " + content.getCableDescription() + " : " + content.getStatus(); %>
<admin:title text="<%= tempURL %>" />
<notifier:show_message />

<admin:subtitle text="Add Note" />
<admin:box_begin />
    <form:begin submit="true" name="edit" action="reels/process.jsp" />
    		<form:textarea name="<%= ReelNote.NOTE_COLUMN %>" rows="5" label="Note:" value="" />
			<form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />			
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
					<form:submit_inline button="save" waiting="true" name="save" action="add_note" />
				<form:buttonset_end />
			<form:row_end />
    <form:end />
<admin:box_end />


<% if(notes.howMany() > 0) { %>
    <admin:subtitle text="All Notes" />
    <admin:box_begin color="false" />
        <listing:begin />
        <listing:header_begin />
            <listing:header_cell width="75" first="true" name="Created" />
            <listing:header_cell width="100" name="By User" />
            <listing:header_cell name="Note" />
        <listing:header_end />
        <% for(int i=0; i<notes.howMany(); i++) { %>
        <% note = (ReelNote)notes.get(i); %>
        <listing:row_begin row="<%= new Integer(i).toString() %>" />
            <listing:cell_begin />
                <%= note.getCreatedDateText() %>
            <listing:cell_end />
            <listing:cell_begin />
                <%= note.getCreatedBy() %>
            <listing:cell_end />
            <listing:cell_begin />
                <%= TextParser.addBreakTags(note.getNote()) %>
            <listing:cell_end />
        <listing:row_end />
        <% } %>
    <listing:end />
    <admin:box_end />
<% } else { %>
    <admin:subtitle text="There are no Notes." />
<% } %>

<admin:set_tabset url="reels/_tabset_manage.jsp" thispage="notes.jsp" content_id_for_tabset="<%= contid %>"/>
<html:end />