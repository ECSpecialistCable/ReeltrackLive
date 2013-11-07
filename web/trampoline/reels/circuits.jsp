<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.monumental.trampoline.component.*" %>

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

CompEntities circuits = reelMgr.getReelCircuits(content);
ReelCircuit circuit;

String tempURL; //var for url expression
%>
<% dbResources.close(); %>

<html:begin />
<admin:title text="<%= content.getTitle() %>" />
<notifier:show_message />

<admin:subtitle text="Add Circuit" />
<admin:box_begin />
    <form:begin submit="true" name="edit" action="reels/process.jsp" />
    		<form:textfield label="Length:" pixelwidth="40" name="<%= ReelCircuit.LENGTH_COLUMN %>" value="0" />
    		<form:textfield label="Name:" name="<%= ReelCircuit.NAME_COLUMN %>" value="" />
			<form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />			
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
					<form:submit_inline button="save" waiting="true" name="save" action="add_circuit" />
				<form:buttonset_end />
			<form:row_end />
    <form:end />
<admin:box_end />

<% 
int circuitLengthsTotal = 0;
for(int i=0; i<circuits.howMany(); i++) {
    circuit = (ReelCircuit)circuits.get(i);
    if(!circuit.isPulled()) {
        circuitLengthsTotal += circuit.getLength();
    }
}
int remainingQty = content.getOnReelQuantity() - circuitLengthsTotal;
%>
<% if(circuits.howMany() > 0) { %>
    <% tempURL = "All Circuits (" + content.getOnReelQuantity() + " On Reel - " + circuitLengthsTotal + " Circuits = " + remainingQty + " Remaining)"; %>
    <admin:subtitle text="<%= tempURL %>" />
    <admin:box_begin color="false" />
        <listing:begin />
        <listing:header_begin />
            <listing:header_cell width="10" first="true" name="#" />
            <listing:header_cell name="Name" />
            <listing:header_cell width="75" name="Length" />
            <listing:header_cell width="75" name="Pulled" />
            <listing:header_cell width="50" name=""  />
        <listing:header_end />
        <% for(int i=0; i<circuits.howMany(); i++) { %>
        <% circuit = (ReelCircuit)circuits.get(i); %>
        <listing:row_begin row="<%= new Integer(i).toString() %>" />
            <listing:cell_begin />
                <%= new Integer(i+1).toString() %>
            <listing:cell_end />
            <listing:cell_begin />
                <%= circuit.getName() %>
            <listing:cell_end />
            <listing:cell_begin />
                <%= circuit.getLength() %>
            <listing:cell_end />
            <listing:cell_begin />
                <% tempURL = "i" + circuit.getId(); %>
                <form:begin_inline name="<%= tempURL %>" action="reels/process.jsp" />
                    <form:checkbox label="" name="<%= ReelCircuit.IS_PULLED_COLUMN %>" onclick="this.form.submit();" value="y" match="<%= circuit.getIsPulled() %>" />        
                    <form:hidden name="<%= Reel.PARAM %>" value="<%= content.getId() %>" />
                    <form:hidden name="<%= ReelCircuit.PARAM %>" value="<%= circuit.getId() %>" />
                    <form:hidden name="submit_action" value="update_circuit" />
                <form:end_inline />
            <listing:cell_end />
            <listing:cell_begin align="right"/>
                <% tempURL = "reels/process.jsp?submit_action=delete_circuit&" + Reel.PARAM + "=" + content.getId() + "&" + ReelCircuit.PARAM + "=" + circuit.getId(); %>
                <% if(!circuit.isPulled()) { %>
                <form:linkbutton warning="true" url="<%= tempURL %>" process="true" name="DELETE" />
                <% } %>
            <listing:cell_end />
        <listing:row_end />
        <% } %>
    <listing:end />
    <admin:box_end />
<% } else { %>
    <admin:subtitle text="There are no Circuits." />
<% } %>

<admin:set_tabset url="reels/_tabset_manage.jsp" thispage="circuits.jsp" content_id_for_tabset="<%= contid %>"/>
<html:end />