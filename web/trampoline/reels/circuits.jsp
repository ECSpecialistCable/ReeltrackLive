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

<% 
int circuitLengthsTotal = 0;
for(int i=0; i<circuits.howMany(); i++) {
    circuit = (ReelCircuit)circuits.get(i);
    if(!circuit.isPulled()) {
        circuitLengthsTotal += circuit.getLength();
    }
}
int remainingQty = content.getEstimatedOnReelQty() - circuitLengthsTotal;
%>

<html:begin />
<% tempURL = content.getCrId() + " : " + content.getReelTag() + " : " + content.getCableDescription() + " : " + content.getStatus(); %>
<admin:title text="<%= tempURL %>" />
<notifier:show_message />

<% if(content.getStatus().equals(Reel.STATUS_CHECKED_OUT)) { %>
    <h2 style="color:red;">Reel is currently checked out. Quantity on reel cannot be verified until reel is returned to warehouse.</h2>
<% } %>

<% if(remainingQty<0) { %>
    <h2 style="color:red;">ALERT: REEL SHOWS NEGATIVE QUANTITY</h2>
<% } %>

<admin:subtitle text="Add Circuit" />
<admin:box_begin />
    <form:begin submit="true" name="edit" action="reels/process.jsp" />
    		<form:textfield label="Est. Length:" pixelwidth="40" name="<%= ReelCircuit.LENGTH_COLUMN %>" value="0" />
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

<admin:subtitle text="Import Circuits" />
<admin:box_begin />
    <form:begin_multipart submit="true" name="import_circuits" action="reels/process.jsp" />
    		<form:file name="ctr_imported_file" label="File:" />
			<form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
					<form:submit_inline button="save" waiting="true" name="save" action="import_circuits" />
				<form:buttonset_end />
			<form:row_end />
    <form:end />
<admin:box_end />

<% if(circuits.howMany() > 0) { %>
    <%
    if(content.getStatus().equals(Reel.STATUS_ORDERED)) {
        tempURL = "Ordered Qty = " + content.getEstimatedOnReelQty() + "': Circuits assigned = " + circuitLengthsTotal + "'; Unassigned cable = " + remainingQty + "'";
    } else if(content.getStatus().equals(Reel.STATUS_SHIPPED)) {
        tempURL = "Shipped Qty = " + content.getEstimatedOnReelQty() + "': Circuits assigned = " + circuitLengthsTotal + "';  Unassigned cable = " + remainingQty + "'";
    } else if(content.getStatus().equals(Reel.STATUS_IN_WHAREHOUSE) || content.getStatus().equals(Reel.STATUS_STAGED)) {
        tempURL = "Qty remaining on reel = " + content.getEstimatedOnReelQty() + "' : Un-pulled circuits = " + circuitLengthsTotal + "'; Unassigned cable = " + remainingQty + "'";
    } else if(content.getStatus().equals(Reel.STATUS_CHECKED_OUT)) {
        tempURL = "Reel is Checked out.  Qty on reel may not be current.  Un-pulled circuits  = " + circuitLengthsTotal + "'; Unassigned cable = " + remainingQty + "'";
    } else if(content.getStatus().equals(Reel.STATUS_COMPLETE)) {
        tempURL = "There are " + remainingQty + "' remaining on this reel and available for additional pulls or scrap.";
    } else if(content.getStatus().equals(Reel.STATUS_SCRAPPED)) {
        tempURL = "There was " + remainingQty + "' remaining on this reel before it was marked as scrapped.";
    }
    %>
    <admin:subtitle text="<%= tempURL %>" />
    <admin:box_begin color="false" />
        <listing:begin />
        <listing:header_begin />
            <listing:header_cell width="10" first="true" name="#" />
            <listing:header_cell name="Name" />
            <listing:header_cell width="100" name="Est. Length" />
            <listing:header_cell width="175" name="Mark Actual Length Pulled" />
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
                <% tempURL = "z" + circuit.getId(); %>
                <form:begin_inline name="<%= tempURL %>" action="reels/process.jsp" />
                    <form:textfield_inline pixelwidth="40" name="<%= ReelCircuit.LENGTH_COLUMN %>" value="<%= new Integer(circuit.getLength()).toString() %>" />
                    <form:hidden name="<%= Reel.PARAM %>" value="<%= content.getId() %>" />
                    <form:hidden name="<%= ReelCircuit.PARAM %>" value="<%= circuit.getId() %>" />
                    <%--<form:hidden name="submit_action" value="update_circuit" />--%>
                    <form:submit_inline waiting="true" name="save" action="update_circuit" />
                <form:end_inline />
            <listing:cell_end />
            <listing:cell_begin />
                <% tempURL = "i" + circuit.getId(); %>
                <form:begin_inline name="<%= tempURL %>" action="reels/process.jsp" />
                    <form:textfield_inline pixelwidth="40" name="<%= ReelCircuit.ACT_LENGTH_COLUMN %>" value="<%= new Integer(circuit.getActLength()).toString() %>" />
                    <form:checkbox label="" name="<%= ReelCircuit.IS_PULLED_COLUMN %>" value="y" match="<%= circuit.getIsPulled() %>" />        
                    <%-- onclick="this.form.submit();"  --%>
                    <form:hidden name="<%= Reel.PARAM %>" value="<%= content.getId() %>" />
                    <form:hidden name="<%= ReelCircuit.PARAM %>" value="<%= circuit.getId() %>" />
                    <%--<form:hidden name="submit_action" value="update_circuit" />--%>
                    <form:submit_inline waiting="true" name="save" action="update_circuit" />
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