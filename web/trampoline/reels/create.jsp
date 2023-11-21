<%@page import="com.monumental.trampoline.datasources.DbResources"%>
<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.monumental.trampoline.component.CompEntities"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>

<%
RTUser user = (RTUser)userLoginMgr.getUser();
dbResources.close();
%>

<html:begin />
<admin:title text="Reels" />

<admin:subtitle text="Add Reel" />
<admin:box_begin />
    <form:begin submit="true" name="create" action="reels/process.jsp" />
			<form:textfield name="<%= Reel.REEL_TAG_COLUMN %>" label="Reel Tag:" />
			<form:textfield name="<%= Reel.CABLE_DESCRIPTION_COLUMN %>" label="Description:" />
			<form:textfield name="<%= Reel.CUSTOMER_PO_COLUMN %>" label="Customer PO:" />
			<form:textfield name="<%= Reel.CUSTOMER_PN_COLUMN %>" label="Customer P/N:" required="true" />
			<form:textfield name="<%= Reel.ECS_PN_COLUMN %>" label="ECS P/N:" required="true" />
			<form:row_begin />
				<form:label name="" label="Manufacturer:" />
				<form:content_begin />
					<form:select_begin name="<%= Reel.MANUFACTURER_COLUMN %>" />
                		<% String[] manuList  = new Reel().getManufacturerList(); %>
                		<% for(int x=0; x<manuList.length; x++) { %>
                    		<form:option name="<%= manuList[x] %>" value="<%= manuList[x] %>"/>
                		<% } %>
            		<form:select_end />
				<form:content_end />
			<form:row_end />
			<form:textfield name="<%= Reel.STEEL_REEL_SERIAL_COLUMN %>" label="Steel Reel Serial #:" />
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
						<form:submit_inline button="save" waiting="true" name="save" action="create" />
				<form:buttonset_end />
			<form:row_end />
    <form:end />
<admin:box_end />

<admin:set_tabset url="reels/_tabset_default.jsp" thispage="create.jsp" />
<html:end />