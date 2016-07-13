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

CompEntities circuits = reelMgr.getReelCircuitPulls(content);
ReelCircuit circuit;

CableTechData techData = reelMgr.getCableTechData(content);

boolean canSubmit = true;
if(user.isUserType(RTUser.USER_TYPE_INVENTORY)) {
    canSubmit = false;
}

String tempURL; //var for url expression
int weight = techData.getWeight();
%>
<% dbResources.close(); %>

<html:begin />
<h1 style="text-align:right;padding-right:50px;">Reel Page</h1>
<% tempURL = content.getCrId() + " : " + content.getReelTag() + " : " + content.getCableDescription() + " : " + content.getStatus(); %>
<h1 style="padding-bottom:0px;"><%= tempURL %></h1>
<p style="padding-left:0px;padding-bottom:20px;">CRID : ReelTag : Cust P/N : Status</p>
<notifier:show_message />

<admin:subtitle text="Edit Quantity" />
<admin:box_begin />
    <form:begin submit="<% new Boolean(canSubmit).toString() %>" name="edit" action="reels/process.jsp" />
    		<form:info label="Ordered Qty:" text="<%= new Integer(content.getOrderedQuantity()).toString() %>" />
    		<form:info label="Shipped Qty:" text="<%= new Integer(content.getShippedQuantity()).toString() %>" />
    		<form:textfield label="Received Qty:" pixelwidth="40" name="<%= Reel.RECEIVED_QUANTITY_COLUMN %>" value="<%= new Integer(content.getReceivedQuantity()).toString() %>" />
    		<% if(techData.getUsageTracking().equals(CableTechData.USAGE_FOOT_MARKERS)) { %>
                <%--
                <form:textfield pixelwidth="40" label="Bottom Ft:" name="<%= Reel.BOTTOM_FOOT_COLUMN %>" value="<%= new Integer(content.getBottomFoot()).toString() %>" />
                <form:row_begin />
                    <form:label name="" label="Bottom Foot Not Visible?:" />
                    <form:content_begin />
                    <form:checkbox label="" name="<%= Reel.BOTTOM_FOOT_NOT_VISIBLE_COLUMN %>" value="y" match="<%= content.getBottomFootNotVisible() %>" />
                    <form:content_end />
                <form:row_end />
                --%>
                <form:info label="Orig Top Seq Mark #:" text="<%= new Integer(content.getOrigTopFoot()).toString() %>" />
                <form:info label="Seq Mark #:" text="<%= new Integer(content.getTopFoot()).toString() %>" />
    		<% } else if(techData.getUsageTracking().equals(CableTechData.USAGE_WEIGHT)) { %>
                <form:info label="Reel GWT:" text="<%= new Integer(content.getReceivedWeight()).toString() %>" />
                <form:info label="Current GWT:" text="<%= new Integer(content.getCurrentWeight()).toString() %>" />
            <% } else if(techData.getUsageTracking().equals(CableTechData.USAGE_QUANTITY_PULLED)) { %>
                <form:info label="Cable Used Qty:" text="<%= new Integer(content.getCableUsedQuantity()).toString() %>" />
            <% } %>
    		<form:info label="On Reel Qty:" text="<%= new Integer(content.getOnReelQuantity()).toString() %>" />
			<form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
                    <% if(canSubmit) { %>
					<form:submit_inline button="save" waiting="true" name="save" action="update_quantity" />
                    <% } %>
				<form:buttonset_end />
			<form:row_end />
    <form:end />
<admin:box_end />

<% if(canSubmit) { %>

    <% if(techData.getUsageTracking().equals(CableTechData.USAGE_QUANTITY_PULLED)) { %>
    <admin:subtitle text="Record Cable Used Quantity (Cable Pulled)" />
    <admin:box_begin />
        <form:begin submit="true" name="edit" action="reels/process.jsp" />
                <form:textfield label="Circuit Name:" name="<%= ReelCircuit.NAME_COLUMN %>" value="" />
        		<form:textfield label="Pulled Qty:" pixelwidth="40" name="pulled_quantity" value="0" />
        		<%--<form:textfield label="Top Foot #:" pixelwidth="40" name="<%= Reel.TOP_FOOT_COLUMN %>" value="0" />--%>
    			<form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />
    			<form:row_begin />
    				<form:label name="" label="" />
    				<form:buttonset_begin align="left" padding="0"/>
    					<form:submit_inline warning="true" message="Please confirm quantity entered is correct.  Once entered, it cannot be changed." button="save" waiting="true" name="save" action="record_pull" />
    				<form:buttonset_end />
    			<form:row_end />
        <form:end />
    <admin:box_end />
    <% } %>
<%--
    <% if(techData.getUsageTracking().equals(CableTechData.USAGE_WEIGHT)) { %>
    <admin:subtitle text="Record Current Cable Weight" />
    <admin:box_begin />
        <form:begin submit="true" name="edit" action="reels/process.jsp" />
                <form:textfield label="Current lbs:" pixelwidth="40" name="current_weight" value="0" />
                <form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />
                <form:row_begin />
                    <form:label name="" label="" />
                    <form:buttonset_begin align="left" padding="0"/>
                        <form:submit_inline warning="true" message="Please confirm Current Lbs is correct." button="save" waiting="true" name="save" action="record_weight" />
                    <form:buttonset_end />
                <form:row_end />
        <form:end />
    <admin:box_end />
    <% } %>
--%>
    <% if(techData.getUsageTracking().equals(CableTechData.USAGE_FOOT_MARKERS)) { %>
    <div style="color:red;text-align:center;">** Since ReelTrack recalculates the quantity remaining on the reel when a new Top Ft marker is entered,<br />you MUST enter the Top Ft marker after each pull.<br /><br /></div>
    <admin:subtitle text="Record Current Top Marker" />
    <admin:box_begin />
        <form:begin submit="true" name="edit" action="reels/process.jsp" />
                <form:textfield label="Circuit Name:" name="<%= ReelCircuit.NAME_COLUMN %>" value="" />
                <form:textfield label="Top Foot #:" pixelwidth="40" name="<%= Reel.TOP_FOOT_COLUMN %>" value="0" />
                <form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />
                <form:row_begin />
                    <form:label name="" label="" />
                    <form:buttonset_begin align="left" padding="0"/>
                        <form:submit_inline warning="true" message="Please confirm Top Foot # is correct." button="save" waiting="true" name="save" action="record_top_marker" />
                    <form:buttonset_end />
                <form:row_end />
        <form:end />
    <admin:box_end />
    <% } %>

<% } %>

<% if(circuits.howMany() > 0) { %>
    <% tempURL = "Quantity on reel = " + content.getEstimatedOnReelQty(); %>
    <admin:subtitle text="<%= tempURL %>" />
    <admin:box_begin color="false" />
        <listing:begin />
        <listing:header_begin />
            <listing:header_cell width="10" first="true" name="#" />
            <listing:header_cell name="Name" />
            <listing:header_cell width="100" name="Qty Pulled" />
            <listing:header_cell width="150" name="Top Foot # after Pull" />
            <listing:header_cell width="150" name="Max Tension During Pull" />
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
                <%= new Integer(circuit.getActLength()).toString() %>
            <listing:cell_end />
            <listing:cell_begin />
                <% if(circuit.getMarker()!=0) { %>
                <%= new Integer(circuit.getMarker()).toString() %>
                <% } %>
            <listing:cell_end />
            <listing:cell_begin />
                <% tempURL = "i" + circuit.getId(); %>
                <% if(canSubmit && circuit.getMaxTension()==0) { %>
                <form:begin_inline submit="<%= new Boolean(canSubmit).toString() %>" name="<%= tempURL %>" action="reels/process.jsp" />
                    <form:textfield_inline pixelwidth="40" name="<%= ReelCircuit.MAX_TENSION_COLUMN %>" value="<%= new Integer(circuit.getMaxTension()).toString() %>" />
                    <%-- onclick="this.form.submit();"  --%>
                    <form:hidden name="<%= Reel.PARAM %>" value="<%= content.getId() %>" />
                    <form:hidden name="<%= ReelCircuit.PARAM %>" value="<%= circuit.getId() %>" />
                    <%--<form:hidden name="submit_action" value="update_circuit" />--%>
                    
                    <form:submit_inline waiting="true" button="save" name="save" action="update_circuit_pull" />
                    
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
    <admin:subtitle text="There are no Recorded Pulls." />
<% } %>

<admin:set_tabset url="reels/_tabset_manage.jsp" thispage="quantity.jsp" content_id_for_tabset="<%= contid %>"/>
<html:end />
