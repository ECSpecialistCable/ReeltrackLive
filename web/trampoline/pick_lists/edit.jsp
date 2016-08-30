<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.reeltrack.picklists.*" %>
<%@ page import="com.reeltrack.foremans.*" %>
<%@ page import="com.monumental.trampoline.component.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="foremanMgr" class="com.reeltrack.foremans.ForemanMgr" scope="request"/>
<jsp:useBean id="picklistMgr" class="com.reeltrack.picklists.PickListMgr" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" />
<% userLoginMgr.init(pageContext); %>
<% foremanMgr.init(pageContext,dbResources); %>
<% picklistMgr.init(pageContext,dbResources); %>
<% reelMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<%
// Get the id
int contid = 0;
if(request.getParameter(PickList.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(PickList.PARAM));
} else {
    String param = "content_id_for_tabset";
    if(request.getParameter(param) != null) {
        contid = Integer.parseInt(request.getParameter(param));
    }
}

// Get the piece of content
PickList content = new PickList();
content.setId(contid);
content = (PickList)picklistMgr.getPickList(content);

Foreman foreman = new Foreman();
foreman.setCustomerId(user.getCustomerId());
CompEntities foremans = foremanMgr.searchForeman(foreman, Foreman.NAME_COLUMN, true);

CompEntities circuits = picklistMgr.getReelCircuits();

int howMany = 15;
int pageNdx = 1;
if(request.getParameter("pageIdx") != null) {
    pageNdx = Integer.parseInt(request.getParameter("pageIdx"));
}

int skip = (pageNdx-1) * howMany;
if(request.getParameter("skip") != null) {
    skip = Integer.parseInt(request.getParameter("skip"));
}

Reel reel = new Reel();
ReelCircuit circuit = new ReelCircuit();
if(session.getAttribute("pick_lists_edit_reel")!=null) {
    reel = (Reel)session.getAttribute("pick_lists_edit_reel");
}
if(session.getAttribute("pick_lists_edit_circuit")!=null) {
    circuit = (ReelCircuit)session.getAttribute("pick_lists_edit_circuit");
}


if(request.getParameter(Reel.PN_VOLT_COLUMN) != null) {
    reel.setPnVolt(request.getParameter(Reel.PN_VOLT_COLUMN));
    reel.setSearchOp(Reel.PN_VOLT_COLUMN, Reel.EQ);
}

if(request.getParameter(Reel.PN_GAUGE_COLUMN) != null) {
    reel.setPnGauge(request.getParameter(Reel.PN_GAUGE_COLUMN));
    reel.setSearchOp(Reel.PN_GAUGE_COLUMN, Reel.EQ);
}

if(request.getParameter(Reel.PN_CONDUCTOR_COLUMN) != null) {
    reel.setPnConductor(request.getParameter(Reel.PN_CONDUCTOR_COLUMN));
    reel.setSearchOp(Reel.PN_CONDUCTOR_COLUMN, Reel.EQ);
}

if(request.getParameter(Reel.REEL_TAG_COLUMN) != null) {
    reel.setReelTag(request.getParameter(Reel.REEL_TAG_COLUMN));
    reel.setSearchOp(Reel.REEL_TAG_COLUMN, Reel.TRUE_PARTIAL);
}

if(request.getParameter(Reel.CUSTOMER_PN_COLUMN) != null) {
    reel.setCustomerPN(request.getParameter(Reel.CUSTOMER_PN_COLUMN));
    reel.setSearchOp(Reel.CUSTOMER_PN_COLUMN, Reel.PARTIAL);
}

if(request.getParameter(Reel.ON_REEL_QUANTITY_COLUMN) != null) {
	if(!request.getParameter(Reel.ON_REEL_QUANTITY_COLUMN).equals("")) {
    	reel.setOnReelQuantity(Integer.parseInt(request.getParameter(Reel.ON_REEL_QUANTITY_COLUMN)));
    	reel.setSearchOp(Reel.ON_REEL_QUANTITY_COLUMN, Reel.GTEQ);
    } else {
    	reel.setOnReelQuantity(0);
    	reel.setSearchOp(Reel.ON_REEL_QUANTITY_COLUMN, Reel.GTEQ);
    }
}

if(request.getParameter(ReelCircuit.PARAM) != null) {
    circuit.setId(Integer.parseInt(request.getParameter(ReelCircuit.PARAM)));
}

session.setAttribute("pick_lists_edit_reel",reel);
session.setAttribute("pick_lists_edit_circuit",circuit);

CompEntities reels = picklistMgr.searchReelsForPickList(reel, circuit);

CompEntities pickReels = picklistMgr.getReelsOnPickList(content);
pickReels.sortByMethodName("getPosition", true);

String[] volts = reelMgr.getPnVolts();
String[] gauges = reelMgr.getPnGauges();
String[] conductors = reelMgr.getPnConductors();

String tempURL; //var for url expression
%>
<% dbResources.close(); %>

<% tempURL = "Picklist: " + content.getTitle(); %>
<html:begin />
<admin:title heading="Pick Lists" text="<%= content.getTitle() %>" />
<notifier:show_message />

<admin:subtitle text="General Info" />
<admin:box_begin text="General Info" name="General_Info" />
    <form:begin submit="true" name="edit" action="pick_lists/process.jsp" />
    		<form:textfield label="Picklist Name:" name="<%= PickList.NAME_COLUMN %>" value="<%= content.getName() %>" />
    		<form:row_begin />
	            <form:label name="" label="Checked OUT to:" />
	            <form:content_begin />
	            <form:select_begin name="<%= PickList.FOREMAN_COLUMN %>" />
	                <form:option name="None" value="" match="<%= content.getForeman() %>" />
	                <% for(int f=0; f<foremans.howMany(); f++) { %>
	                    <% foreman = (Foreman)foremans.get(f); %>
	                    <form:option name="<%= foreman.getName() %>" value="<%= foreman.getName() %>" match="<%= content.getForeman() %>" />
	                <% } %>
	            <form:select_end />
	            <form:content_end />
        	<form:row_end />
			<form:hidden name="<%= PickList.PARAM %>" value="<%= new Integer(contid).toString() %>" />
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
					<form:submit_inline button="save" waiting="true" name="save" action="update" />
				<form:buttonset_end />
			<form:row_end />
    <form:end />
<admin:box_end />

<% if(pickReels.howMany() > 0) { %>
	<admin:subtitle text="Reels on Picklist" />
	<admin:box_begin text="Reels on Picklist" name="Reels_on_Picklist" />
	<listing:begin />
	    <listing:header_begin />
			<listing:header_cell first="true" name="#" width="70" />
	    	<listing:header_cell width="45" name="CRID #"  />
			<listing:header_cell name="Reel Tag / Desc." />
	        <listing:header_cell width="100" name="Cust P/N" />
	        <listing:header_cell width="100" name="Type" />
	        <listing:header_cell width="40" name="Qty" />
	        <listing:header_cell width="75" name="Location" />
	        <listing:header_cell width="40" name=""  />
	    <listing:header_end />
	    <% for(int i=0; i<pickReels.howMany(); i++) { %>
	    <% Reel reel3 = (Reel)pickReels.get(i); %>
	    <listing:row_begin row="<%= new Integer(i).toString() %>" />
			<listing:cell_begin width="50"/>
				<% tempURL = i + "_update"; %>
				<form:begin_inline name="<%= tempURL %>" action="pick_lists/process.jsp" />
					<form:select_begin name="<%= Reel.POSITION_COLUMN %>" onchange="test" />
					<% for(int pos=0;pos<pickReels.howMany(); pos++) { %>
						<form:option value="<%= new Integer(pos+1).toString() %>" name="<%= new Integer(pos+1).toString() %>" match="<%= new Integer(reel3.getPosition()).toString() %>" />
					<% } %>
					<form:select_end />
					<form:hidden name="submit_action" value="update_reel_position" />
					<form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(reel3.getId()).toString() %>" />
					<form:hidden name="<%= PickList.PARAM %>" value="<%= new Integer(content.getId()).toString() %>" />
				<form:end_inline />
			<listing:cell_end />
	    	<listing:cell_begin />
	            <%= reel3.getCrId() %>
	        <listing:cell_end />
	        <listing:cell_begin />
	            <%= reel3.getReelTag() %><br />
	            <%= reel3.getCableDescription() %>
	        <listing:cell_end />
	        <listing:cell_begin />
	            <%= reel3.getCustomerPN() %>
	        <listing:cell_end />
	        <listing:cell_begin />
	            <%= reel3.getReelType() %>
	        <listing:cell_end />
	        <listing:cell_begin />
	            <%= reel3.getOnReelQuantity() %>
	        <listing:cell_end />
	        <listing:cell_begin />
	            <%= reel3.getWharehouseLocation() %>
	        <listing:cell_end />
	        <listing:cell_begin align="right"/>
	            <% tempURL = "pick_lists/process.jsp?submit_action=delete_reel&" + PickList.PARAM + "=" + content.getId() + "&" + Reel.PARAM + "=" + reel3.getId(); %>
                <form:linkbutton warning="true" url="<%= tempURL %>" process="true" name="Delete" />
	        <listing:cell_end />
	    <listing:row_end />
	    <% } %>
	<listing:end />
	<admin:box_end />
<% } else { %>
	<admin:subtitle text="No Reels On Pick List." />
<% } %>

<br />
<admin:subtitle text="Search Reels to Add to Pick List" />
    <admin:box_begin text="Search Reels to Add to Pick List" name="Search_Reels_to_Add" />
    <form:begin_selfsubmit name="search" action="pick_lists/edit.jsp" />
    	<form:row_begin />
            <form:label name="" label="Circuit:" />
            <form:content_begin />
            <form:select_begin name="<%= ReelCircuit.PARAM %>" />
                <form:option name="Any" value="0" match="<%= new Integer(circuit.getId()).toString() %>" />
                <% for(int c=0; c<circuits.howMany(); c++) { %>
                    <% ReelCircuit tmpCircuit = (ReelCircuit)circuits.get(c); %>
                    <form:option name="<%= tmpCircuit.getName() %>" value="<%= new Integer(tmpCircuit.getId()).toString() %>" match="<%= new Integer(circuit.getId()).toString() %>" />
                <% } %>
            <form:select_end />
            <form:content_end />
        <form:row_end />
        <form:row_begin />
            <form:label name="" label="Voltage:" />
            <form:content_begin />
            <form:select_begin name="<%= Reel.PN_VOLT_COLUMN %>" />
                <form:option name="Any" value="" match="<%= reel.getPnVolt() %>" />
                <% for(int x=0; x<volts.length; x++) { %>
                    <% tempURL = volts[x] + " (" + Reel.convertPnVolt(volts[x]) + ")"; %>
                    <form:option name="<%= tempURL %>" value="<%= volts[x] %>" match="<%= reel.getPnVolt() %>" />
                <% } %>
            <form:select_end />
            <form:content_end />
        <form:row_end />
        <form:row_begin />
            <form:label name="" label="Gauge:" />
            <form:content_begin />
            <form:select_begin name="<%= Reel.PN_GAUGE_COLUMN %>" />
                <form:option name="Any" value="" match="<%= reel.getPnGauge() %>" />
                <% for(int x=0; x<gauges.length; x++) { %>
                    <% tempURL = gauges[x] + " (" + Reel.convertPnGauge(gauges[x]) + ")"; %>
                    <form:option name="<%= tempURL %>" value="<%= gauges[x] %>" match="<%= reel.getPnGauge() %>" />
                <% } %>
            <form:select_end />
            <form:content_end />
        <form:row_end />
        <form:row_begin />
            <form:label name="" label="Conductor Count:" />
            <form:content_begin />
            <form:select_begin name="<%= Reel.PN_CONDUCTOR_COLUMN %>" />
                <form:option name="Any" value="" match="<%= reel.getPnConductor() %>" />
                <% for(int x=0; x<conductors.length; x++) { %>
                    <form:option name="<%= conductors[x] %>" value="<%= conductors[x] %>" match="<%= reel.getPnConductor() %>" />
                <% } %>
            <form:select_end />
            <form:content_end />
        <form:row_end />
    	<form:textfield label="Customer P/N:" name="<%= Reel.CUSTOMER_PN_COLUMN %>" value="<%= reel.getCustomerPN() %>" />
        <form:textfield label="Reel Tag:" name="<%= Reel.REEL_TAG_COLUMN %>" value="<%= reel.getReelTag() %>" />
        <%
        if(reel.getOnReelQuantity()!=0) {
            tempURL = new Integer(reel.getOnReelQuantity()).toString();
        } else {
            tempURL = "";
        }
        %>
        <form:textfield pixelwidth="40" label="Pull Length:" name="<%= Reel.ON_REEL_QUANTITY_COLUMN %>" value="<%= tempURL %>" />
        <form:hidden name="<%= PickList.PARAM %>" value="<%= new Integer(contid).toString() %>" />
        <form:row_begin />
            <form:label name="" label="" />
            <form:buttonset_begin align="left" padding="0"/>
                <form:submit_inline button="submit" waiting="true" name="search" action="test" />
            <form:buttonset_end />
        <form:row_end />
    <form:end />
<admin:box_end />

<% if(reels.howMany() > 0) { %>
	<admin:subtitle text="Add Reel to Pick List" />
	<admin:box_begin text="Add Reel to Pick List" name="Add_Reel_to_Pick_List" />
	<listing:begin />
	    <listing:header_begin />
	    	<listing:header_cell first="true" width="45" name="CRID #"  />
	        <listing:header_cell name="Reel Tag / Desc." />
	        <listing:header_cell width="100" name="Cust P/N" />
	        <listing:header_cell width="100" name="Type" />
	        <listing:header_cell width="40" name="Qty" />
	        <listing:header_cell width="75" name="Location" />
	        <listing:header_cell width="40" name=""  />
	    <listing:header_end />
	    <% for(int i=0; i<reels.howMany(); i++) { %>
	    <% Reel reel2 = (Reel)reels.get(i); %>
	    <listing:row_begin row="<%= new Integer(i).toString() %>" />
	    	<listing:cell_begin />
	            <%= reel2.getCrId() %>
	        <listing:cell_end />
	        <listing:cell_begin />
	            <%= reel2.getReelTag() %><br />
	            <%= reel2.getCableDescription() %>
	        <listing:cell_end />
	        <listing:cell_begin />
	            <%= reel2.getCustomerPN() %>
	        <listing:cell_end />
	        <listing:cell_begin />
	            <%= reel2.getReelType() %>
	        <listing:cell_end />
	        <listing:cell_begin />
	            <%= reel2.getOnReelQuantity() %>
	        <listing:cell_end />
	        <listing:cell_begin />
	            <%= reel2.getWharehouseLocation() %>
	        <listing:cell_end />
	        <listing:cell_begin align="right"/>
	            <% tempURL = "pick_lists/process.jsp?submit_action=add_reel&" + PickList.PARAM + "=" + content.getId() + "&" + Reel.PARAM + "=" + reel2.getId(); %>
                <form:linkbutton url="<%= tempURL %>" process="true" name="Add" />
	        <listing:cell_end />
	    <listing:row_end />
	    <% } %>
	<listing:end />
	<admin:box_end />
<% } else { %>
	<admin:subtitle text="No Reels Found." />
<% } %>



<admin:set_tabset url="pick_lists/_tabset_manage.jsp" thispage="edit.jsp" content_id_for_tabset="<%= contid %>"/>
<html:end />
