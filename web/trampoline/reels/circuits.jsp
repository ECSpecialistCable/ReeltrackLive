<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.picklists.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<jsp:useBean id="picklistMgr" class="com.reeltrack.picklists.PickListMgr" />
<% picklistMgr.init(pageContext,dbResources); %>
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

PickList picklist = new PickList();
if(content.getPickListId()!=0) {
    picklist.setId(content.getPickListId());
    picklist = (PickList)picklistMgr.getPickList(picklist);
}

CableTechData techData = reelMgr.getCableTechData(content);

CompEntities circuits = reelMgr.getReelCircuits(content);
ReelCircuit circuit;

String tempURL; //var for url expression
%>
<% dbResources.close(); %>

<%
int circuitLengthsTotal = 0;
int sumVariance = 0;
for(int i=0; i<circuits.howMany(); i++) {
    circuit = (ReelCircuit)circuits.get(i);
    if(!circuit.isPulled()) {
        circuitLengthsTotal += circuit.getLength();
    } else {
        sumVariance += (circuit.getLength() - circuit.getActLength());
    }
}
int remainingQty = content.getEstimatedOnReelQty() - circuitLengthsTotal;

boolean canSubmit = true;
if(user.isUserType(RTUser.USER_TYPE_INVENTORY)) {
    canSubmit = false;
}

%>

<html:begin />
<%--
<h1 style="text-align:right;padding-right:50px;">Reel Page</h1>
<% tempURL = content.getCrId() + " : " + content.getReelTag() + " : " + content.getCableDescription() + " : " + content.getStatus(); %>
<h1 style="padding-bottom:0px;"><%= tempURL %></h1>
<p style="padding-left:0px;padding-bottom:20px;">CRID : ReelTag : Cust P/N : Status</p>
--%>
<notifier:show_message />

<%
tempURL = content.getCrId() + " : " + content.getReelTag() + " : " + content.getCableDescription() + " : " + content.getStatus();
if(content.getStatus().equals(Reel.STATUS_IN_WHAREHOUSE)) {
    tempURL = content.getCrId() + " : " + content.getReelTag() + " : " + content.getCableDescription() + " : " + content.getStatus() + " - " + content.getWharehouseLocation();
} else if(content.getStatus().equals(Reel.STATUS_CHECKED_OUT)) {
    tempURL = content.getCrId() + " : " + content.getReelTag() + " : " + content.getCableDescription() + " : " + content.getStatus() + " - " + picklist.getForeman();
}
%>

<admin:title heading="Reel Page" text="<%= tempURL %>" />

<% if(remainingQty<0) { %>
    <h4 style="color:red;">ALERT: REEL SHOWS NEGATIVE QUANTITY</h4>
<% } %>

<% if(remainingQty - sumVariance <= 10) { %>
  <h4 style="color:red;">PULLED CIRUITS HAVE BEEN LONGER THAN PLANNED.<br />CHECK QUANTITY ON REEL BEFORE PROCEEDING WITH NEXT PULL.</h4>
<% } %>

<% if(canSubmit) { %>
<admin:subtitle text="Delete all Unpulled Circuits" />
<admin:box_begin text="Delete all Unpulled Circuits" name="Delete_all_Unpulled_Circuits" />
    <form:begin submit="true" name="edit" action="reels/process.jsp" />
            <form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />
            <form:row_begin />
                <form:label name="" label="Delete Unpulled Circuits:" />
                <form:buttonset_begin align="left" padding="0"/>
                    <% tempURL = "reels/process.jsp?submit_action=delete_unpulled_circuits&" +  Reel.PARAM + "=" + content.getId(); %>
                    <form:linkbutton url="<%= tempURL %>" name="DELETE" />
                <form:buttonset_end />
            <form:row_end />
    <form:end />
<admin:box_end />

<admin:subtitle text="Add Circuit" />
<admin:box_begin text="Add Circuit" name="Add_Circuit" />
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

<%--
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
--%>
<% } %>

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

    <% if(techData.getUsageTracking().equals(CableTechData.USAGE_FOOT_MARKERS)) { %>
    <h4 style="color:red;">Since ReelTrack recalculates the quantity remaining on the reel when a new Top Ft marker is entered, you MUST enter the Top Ft marker after each pull.</h4>
    <% } %>

    <% tempURL = "Quantity remaining on reel = " + content.getEstimatedOnReelQty() + "', Un-Pulled Circuits = " + circuitLengthsTotal + "', Unassigned cable = " + remainingQty + "'"; %>
    <admin:subtitle text="<%= tempURL %>" />
    <admin:box_begin text="<%= tempURL %>" />
        <listing:begin />
        <listing:header_begin />
            <listing:header_cell setWidth="50" first="true" name="#" />
            <listing:header_cell name="Name" />
            <listing:header_cell setWidth="150" name="Est. Length" />
            <listing:header_cell width="30" name="Act. Length" />
            <listing:header_cell width="75" name="Top Foot #<br />after Pull" />
            <%
            String header_title = "Update Qty Pulled";
            if(techData.getUsageTracking().equals(CableTechData.USAGE_FOOT_MARKERS)) {
              header_title = "Update Top Ft #";
            }
            %>
            <listing:header_cell setWidth="150" name="<%= header_title %>" />
            <listing:header_cell setWidth="150" name="Max Tension<br />During Pull" />
            <listing:header_cell width="50" name=""  />
        <listing:header_end />
        <% for(int i=0; i<circuits.howMany(); i++) { %>
        <% circuit = (ReelCircuit)circuits.get(i); %>
        <listing:row_begin row="<%= new Integer(i).toString() %>" />
            <listing:cell_begin />
                <% String orderForm = "order_" + i; %>
                <form:begin_inline name="<%= orderForm %>" action="reels/process.jsp" />
                <form:select_begin label="" name="<%= ReelCircuit.POSITION_COLUMN %>" onchange="submitInline(this.form);"/>
                    <% for(int p=0; p<circuits.howMany();p++) { %>
                    <form:option name="<%= new Integer(p+1).toString() %>" value="<%= new Integer(p+1).toString() %>" match="<%= new Integer(i+1).toString() %>" />
                    <% } %>
                <form:select_end />
                <form:hidden name="<%= Reel.PARAM %>" value="<%= content.getId() %>" />
                <form:hidden name="<%= ReelCircuit.PARAM %>" value="<%= circuit.getId() %>" />
                <form:hidden name="submit_action" value="update_circuit_order" />
                <form:end_inline />
            <listing:cell_end />
            <listing:cell_begin />
                <%= circuit.getName() %>
            <listing:cell_end />
            <listing:cell_begin />
                <% tempURL = "z" + circuit.getId(); %>
                <% if(!circuit.isPulled() && canSubmit) { %>
                <form:begin_inline submit="<%= new Boolean(canSubmit).toString() %>" name="<%= tempURL %>" action="reels/process.jsp" />
                    <form:textfield_inline minWidth="50" name="<%= ReelCircuit.LENGTH_COLUMN %>" value="<%= new Integer(circuit.getLength()).toString() %>" />
                    <form:hidden name="<%= Reel.PARAM %>" value="<%= content.getId() %>" />
                    <form:hidden name="<%= ReelCircuit.PARAM %>" value="<%= circuit.getId() %>" />
                    <form:hidden name="submit_action" value="update_circuit" />
                    <%--<form:submit_inline waiting="true" button="save" name="save" action="update_circuit" />--%>
                <form:end_inline />
                <% } else { %>
                    <%= new Integer(circuit.getLength()).toString() %>
                <% } %>
            <listing:cell_end />
            <listing:cell_begin />
                <%= new Integer(circuit.getActLength()).toString() %>
            <listing:cell_end />
            <listing:cell_begin />
                <% if(circuit.getMarker()==0) { %>
                na
                <% } else { %>
                <%= circuit.getMarker() %>
                <% } %>

                <% tempURL = "i" + circuit.getId(); %>
                <%--
                <form:begin_inline submit="<%= new Boolean(canSubmit).toString() %>" name="<%= tempURL %>" action="reels/process.jsp" />
                    <form:checkbox label="" name="<%= ReelCircuit.IS_PULLED_COLUMN %>" value="y" match="<%= circuit.getIsPulled() %>" />
                    <form:hidden name="<%= Reel.PARAM %>" value="<%= content.getId() %>" />
                    <form:hidden name="<%= ReelCircuit.PARAM %>" value="<%= circuit.getId() %>" />
                    <form:hidden name="mark_pulled" value="yes" />
                    <% if(canSubmit) { %>
                    <form:submit_inline waiting="true" button="save" name="save" action="update_circuit" />
                    <% } %>
                <form:end_inline />
                --%>
            <listing:cell_end />
            <listing:cell_begin />
                <% tempURL = "i" + circuit.getId(); %>
                <% if(!circuit.isPulled() && canSubmit) { %>
                <%
                String confirm = "Please confirm top foot marker entered is correct.  Once entered, it cannot be changed.";
                if(!techData.getUsageTracking().equals(CableTechData.USAGE_FOOT_MARKERS)) {
                    confirm = "Please confirm the quantity pulled entered is correct.  Once entered, it cannot be changed.";
                }
                %>
                <form:begin_inline confirm="<%= confirm %>" submit="<%= new Boolean(canSubmit).toString() %>" name="<%= tempURL %>" action="reels/process.jsp" />

                    <form:textfield_inline minWidth="50" name="<%= ReelCircuit.ACT_LENGTH_COLUMN %>" value="0" />
                    <form:hidden name="<%= Reel.PARAM %>" value="<%= content.getId() %>" />
                    <form:hidden name="<%= ReelCircuit.PARAM %>" value="<%= circuit.getId() %>" />
                    <%--<form:hidden name="submit_action" value="update_circuit" />--%>
                    <% if(techData.getUsageTracking().equals(CableTechData.USAGE_FOOT_MARKERS)) { %>
                    <form:hidden name="submit_action" value="update_circuit" />
                    <%--<form:submit_inline warning="true" message="Please confirm top foot marker entered is correct.  Once entered, it cannot be changed."  waiting="true" button="save" name="save" action="update_circuit" />--%>
                    <%--<form:submit_inline waiting="true" button="save" name="save" action="update_circuit" />--%>
                    <% } else { %>
                    <form:hidden name="submit_action" value="update_circuit" />
                    <%--<form:submit_inline warning="true" message="Please confirm top foot marker entered is correct.  Once entered, it cannot be changed."  waiting="true" button="save" name="save" action="update_circuit" />--%>
                    <%--<form:submit_inline waiting="true" button="save" name="save" action="update_circuit" />--%>
                    <% } %>
                <form:end_inline />
                <% } else { %>
                Pulled
                <% } %>
            <listing:cell_end />
            <listing:cell_begin/>
                <% tempURL = "i" + circuit.getId(); %>
                <% if(canSubmit && circuit.getMaxTension()==0) { %>
                <form:begin_inline submit="<%= new Boolean(canSubmit).toString() %>" name="<%= tempURL %>" action="reels/process.jsp" />
                    <form:textfield_inline minWidth="50" name="<%= ReelCircuit.MAX_TENSION_COLUMN %>" value="<%= new Integer(circuit.getMaxTension()).toString() %>" />
                    <%-- onclick="this.form.submit();"  --%>
                    <form:hidden name="<%= Reel.PARAM %>" value="<%= content.getId() %>" />
                    <form:hidden name="<%= ReelCircuit.PARAM %>" value="<%= circuit.getId() %>" />
                    <form:hidden name="submit_action" value="update_circuit" />

                    <%--<form:submit_inline waiting="true" button="save" name="save" action="update_circuit" />--%>

                <form:end_inline />
                <% } else { %>
                <%= circuit.getMaxTension() %>
                <% } %>
            <listing:cell_end />
            <listing:cell_begin align="right"/>
                <% tempURL = "reels/process.jsp?submit_action=delete_circuit&" + Reel.PARAM + "=" + content.getId() + "&" + ReelCircuit.PARAM + "=" + circuit.getId(); %>
                <% if(!circuit.isPulled() && canSubmit) { %>
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
