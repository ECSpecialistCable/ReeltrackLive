<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.monumental.trampoline.utilities.text.*" %>
<%@ page import="java.net.*" %>

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
boolean canEdit = false;
if(user.isUserType(RTUser.USER_TYPE_ECS)) {
    canEdit = true;
}
%>
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

CableTechData techData = reelMgr.getCableTechData(content);

int ordered = reelMgr.getCablesQuantityByStatus(content, Reel.STATUS_ORDERED);
int recieved = reelMgr.getCablesQuantityByStatus(content, Reel.STATUS_RECEIVED);
int inWH = reelMgr.getCablesQuantityByStatus(content, Reel.STATUS_IN_WHAREHOUSE);
int checkedOut = reelMgr.getCablesQuantityByStatus(content, Reel.STATUS_CHECKED_OUT);
int remaining = reelMgr.getCablesQuantityByStatus(content, "remaining");
String tempURL; //var for url expression
%>
<% dbResources.close(); %>

<html:begin />
<%--
<h1 style="text-align:right;padding-right:50px;">Reel Page</h1>
<h1 style="padding-bottom:0px;"><%= tempURL %></h1>
<p style="padding-left:0px;padding-bottom:20px;">CRID : ReelTag : Cust P/N : Status</p>
--%>
<notifier:show_message />

<% tempURL = content.getCrId() + " : " + content.getReelTag() + " : " +  content.getCableDescription(); %>
<admin:title heading="Reel Page" text="<%= tempURL %>" />

<admin:box_begin text="Data Sheet" name="Data_Sheet" open="false" />
    <form:begin_multipart submit="<%= new Boolean(canEdit).toString() %>" name="edit" action="reels/process.jsp" />
        <% if(canEdit) { %>
        <form:file name="<%= CableTechData.DATA_SHEET_FILE_COLUMN %>" label="Data Sheet File:" />
        <% } %>
        <% if(techData.getDataSheetFile() != null && !techData.getDataSheetFile().equals("")) { %>
            <form:row_begin />
            <form:label label="Download Data Sheet:"  />
            <form:content_begin />
                    <% tempURL = request.getContextPath() + techData.getCompEntityDirectory() + "/" + URLEncoder.encode(techData.getDataSheetFile()); %>
                    <admin:link external="true" text="Download" url="<%= tempURL %>" />
                <form:content_end />
            <form:row_end />
            <% if(canEdit) { %>
            <form:row_begin />
            <form:label label="Delete Data Sheet:"  />
            <form:content_begin />
                    <% String tempUrl = "reels/process.jsp?submit_action=delete_datasheet&" + Reel.PARAM + "=" + content.getId() + "&" + CableTechData.PARAM + "=" + techData.getId(); %>
                    <form:linkbutton warning="true" url="<%= tempUrl %>" process="true" name="DELETE" />
                <form:content_end />
            <form:row_end />
            <% } %>
        <% } %>
        <form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />
        <form:hidden name="<%= CableTechData.PARAM %>" value="<%= new Integer(techData.getId()).toString() %>" />
        <form:row_begin />
            <form:label name="" label="" />
            <form:buttonset_begin align="left" padding="0"/>
                <% if(canEdit) { %>
                <form:submit_inline button="save" waiting="true" name="save" action="update_datasheet" />
                <% } %>
            <form:buttonset_end />
        <form:row_end />
    <form:end />
<admin:box_end />

<admin:subtitle text="Cable Summary" />
<admin:box_begin text="Cable Summary" name="Cable_Summary" open="false" />
    <form:begin submit="<%= new Boolean(canEdit).toString() %>" name="edit" action="reels/process.jsp" />
		<form:info label="Total Ordered:" text="<%= Integer.toString(ordered) %>" />
        <form:info label="Total Received:" text="<%= Integer.toString(recieved) %>" />
        <form:info label="Total In Warehouse:" text="<%= Integer.toString(inWH) %>" />
        <form:info label="Total Checked Out:" text="<%= Integer.toString(checkedOut) %>" />
        <form:info label="Est. Remaining:" text="<%= Integer.toString(remaining) %>" />
    <form:end />
<admin:box_end />

<h4 style="color:red;">The Cable Data below can only be edited by ECS users.</h4>

<admin:subtitle text="Overall Cable" />
<admin:box_begin text="Overall Cable" name="Overall_Cable" />
    <form:begin submit="<%= new Boolean(canEdit).toString() %>" name="edit" action="reels/process.jsp" />
        <form:textfield label="O.D. (inches):" pixelwidth="50" name="<%= CableTechData.OD_COLUMN %>" value="<%= Double.toString(techData.getOD()) %>" />
        <form:textfield label="Weight/kft:" pixelwidth="50" name="<%= CableTechData.WEIGHT_COLUMN %>" value="<%= new Integer(techData.getWeight()).toString() %>" />
        <%
        String mbr = "N/A";
        if(techData.getRadius()!=0) {
            mbr = Double.toString(techData.getRadius());
        }
        %>
        <form:textfield label="MBR (inches):" name="<%= CableTechData.RADIUS_COLUMN %>" value="<%= mbr %>" />
        <form:textfield label="X-Section<br />(sq inches):" name="<%= CableTechData.XSECTION_COLUMN %>" value="<%= Double.toString(techData.getXSection()) %>" />
        <form:textfield label="Pull Tension<br />Max (lbs):" name="<%= CableTechData.PULL_TENSION_COLUMN %>" value="<%= new Integer(techData.getPullTension()).toString() %>" />
        <form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />
        <form:hidden name="<%= CableTechData.PARAM %>" value="<%= new Integer(techData.getId()).toString() %>" />
        <form:row_begin />
            <form:label name="" label="" />
            <form:buttonset_begin align="left" padding="0"/>
                <% if(canEdit) { %>
                <form:submit_inline button="save" waiting="true" name="save" action="update_overall" />
                <% } %>
            <form:buttonset_end />
        <form:row_end />
    <form:end />
<admin:box_end />

<admin:subtitle text="Conductor / Ground" />
<admin:box_begin text="Conductor / Ground" name="Conductor_Ground" open="false" />
    <form:begin submit="<%= new Boolean(canEdit).toString() %>" name="edit" action="reels/process.jsp" />
		<form:textfield label="Area (cir mil):" pixelwidth="50" name="<%= CableTechData.CONDUCTOR_AREA_COLUMN %>" value="<%= new Integer(techData.getConductorArea()).toString() %>" />
		<form:textfield label="Ground Size:" name="<%= CableTechData.CONDUCTOR_GROUND_SIZE_COLUMN %>" value="<%= techData.getConductorGroundSize() %>" />
        <form:textfield label="Cu Weight/kft:" pixelwidth="50" name="<%= CableTechData.CON_CU_WEIGHT_COLUMN %>" value="<%= new Integer(techData.getConCuWeight()).toString() %>" />
        <form:textfield label="Al Weight/kft:" pixelwidth="50" name="<%= CableTechData.CON_AL_WEIGHT_COLUMN %>" value="<%= new Integer(techData.getConAlWeight()).toString() %>" />
        <form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />
        <form:hidden name="<%= CableTechData.PARAM %>" value="<%= new Integer(techData.getId()).toString() %>" />
		<form:row_begin />
			<form:label name="" label="" />
			<form:buttonset_begin align="left" padding="0"/>
                <% if(canEdit) { %>
				<form:submit_inline button="save" waiting="true" name="save" action="update_conductor" />
                <% } %>
			<form:buttonset_end />
		<form:row_end />
    <form:end />
<admin:box_end />

<admin:subtitle text="Insulation" />
<admin:box_begin text="Insulation" name="Insulation" open="false" />
    <form:begin submit="<%= new Boolean(canEdit).toString() %>" name="edit" action="reels/process.jsp" />
        <form:textfield label="Thick (mils):" pixelwidth="50" name="<%= CableTechData.INSULATION_THICKNESS_COLUMN %>" value="<%= new Integer(techData.getInsulationThickness()).toString() %>" />
        <form:textfield label="Compound:" name="<%= CableTechData.INSULATION_COMPOUND_COLUMN %>" value="<%= techData.getInsulationCompound() %>" />
        <form:textfield label="Color code:" name="<%= CableTechData.INSULATION_COLOR_COLUMN %>" value="<%= techData.getInsulationColor() %>" />
        <form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />
        <form:hidden name="<%= CableTechData.PARAM %>" value="<%= new Integer(techData.getId()).toString() %>" />
        <form:row_begin />
            <form:label name="" label="" />
            <form:buttonset_begin align="left" padding="0"/>
                <% if(canEdit) { %>
                <form:submit_inline button="save" waiting="true" name="save" action="update_insulation" />
                <% } %>
            <form:buttonset_end />
        <form:row_end />
    <form:end />
<admin:box_end />

<admin:subtitle text="Jacket" />
<admin:box_begin text="Jacket" name="Jacket" open="false" />
    <form:begin submit="<%= new Boolean(canEdit).toString() %>" name="edit" action="reels/process.jsp" />
        <form:textfield label="Overall Shld Type:" name="<%= CableTechData.SHIELD_TYPE_COLUMN %>" value="<%= techData.getShieldType() %>" />
        <form:textfield label="Thick (mils):" pixelwidth="50"  name="<%= CableTechData.JACKET_THICKNESS_COLUMN %>" value="<%= new Integer(techData.getJacketThickness()).toString() %>" />
        <form:textfield label="Compound:" name="<%= CableTechData.JACKET_COMPOUND_COLUMN %>" value="<%= techData.getJacketCompound() %>" />
        <form:hidden name="<%= Reel.PARAM %>" value="<%= new Integer(contid).toString() %>" />
        <form:hidden name="<%= CableTechData.PARAM %>" value="<%= new Integer(techData.getId()).toString() %>" />
        <form:row_begin />
            <form:label name="" label="" />
            <form:buttonset_begin align="left" padding="0"/>
                <% if(canEdit) { %>
                <form:submit_inline button="save" waiting="true" name="save" action="update_jacket" />
                <% } %>
            <form:buttonset_end />
        <form:row_end />
    <form:end />
<admin:box_end />

<admin:set_tabset url="reels/_tabset_manage.jsp" thispage="cable_data.jsp" content_id_for_tabset="<%= contid %>"/>
<html:end />
