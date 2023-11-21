<%@page import="com.reeltrack.reels.CableTechData"%>
<%@page import="com.reeltrack.customers.CustomerJob"%>
<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.Reel"%>
<%@ page import="java.net.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="cabinetMgr" class="com.reeltrack.file_cabinets.FileCabinetMgr" scope="request"/>
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" />
<% userLoginMgr.init(pageContext); %>
<% reelMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<%
boolean canEdit = false;
if(user.isUserType(RTUser.USER_TYPE_ECS)) {
    canEdit = true;
}

Reel content = new Reel();
content.setJobCode(user.getJobCode());
content.setSearchOp(Reel.JOB_CODE_COLUMN, Reel.EQ);
content.setCustomerPN("");
content.setSearchOp(Reel.CUSTOMER_PN_COLUMN, Reel.BLANK_OR_NULL_OK);
CompEntities contents = reelMgr.getReelsWithoutCustPN(content, Reel.ECS_PN_COLUMN, true, 0, 0);

String tempUrl =""; //var for url expression
%>
<% dbResources.close(); %>
<html:begin />
<admin:title heading="Customer Part Numbers" text=""/>

<% if(contents.howMany() > 0) { %>
    <admin:box_begin text="Customer Part Numbers" name="Customer_Part_Numbers" />
        <listing:begin />
            <listing:header_begin />
                <listing:header_cell width="80" first="true" name="ECS P/N" />
                <listing:header_cell width="100" name="Description" />
                <listing:header_cell width="100" name="Cust P/N" />
            <listing:header_end />
            <% for(int i=0; i<contents.howMany(); i++) { %>
            <% content = (Reel)contents.get(i); %>
			<% if(!content.getCableDescription().equals("")) { %>
				<listing:row_begin row="<%= new Integer(i).toString() %>" />
					<listing:cell_begin />
						<%= content.getEcsPN() %>
					<listing:cell_end />
					<listing:cell_begin />
						<%= content.getCableDescription() %>
					<listing:cell_end />
					<listing:cell_begin />
						<form:begin_inline action="bill_of_materials/process.jsp" name="update_customer_pn" />
						<form:textfield_inline label="" name="<%= Reel.CUSTOMER_PN_COLUMN %>" />
						<% if(canEdit) { %>
							<form:submit_inline  button="save" waiting="true" name="save" action="update_customer_pn" />
							<form:hidden name="<%= Reel.PARAM %>" value="<%= Integer.toString(content.getId()) %>" />
							<form:hidden name="<%= CustomerJob.PARAM %>" value="<%= Integer.toString(user.getJobId()) %>" />
							<form:hidden name="<%= Reel.CABLE_DESCRIPTION_COLUMN %>" value="<%= content.getCableDescription() %>" />
						<% } %>
						<form:end_inline />
					<listing:cell_end />
				<listing:row_end />
			<% } %>
            <% } %>
        <listing:end />
    <admin:box_end />
<% } else { %>
    <admin:subtitle text="There are no empty part numbers." />
<% } %>
<admin:set_tabset url="bill_of_materials/_tabset_default.jsp" thispage="cust_pn.jsp" />
<html:end />
