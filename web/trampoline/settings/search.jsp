<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.settings.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="settingsMgr" class="com.reeltrack.settings.SettingsMgr" scope="request"/>
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% settingsMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<% 
Settings content = settingsMgr.getSettings(user.getCustomerId());
String tempUrl =""; //var for url expression
%>	
<% dbResources.close(); %>


<html:begin />
<admin:title text="Settings" />

<admin:subtitle text="Edit Settings" />
<admin:box_begin />
    <form:begin submit="true" name="create" action="settings/process.jsp" />
            <form:row_begin />
                <form:label name="" label="Auto Print Reel Tags:" />
                <form:content_begin />
                    <form:select_begin name="<%= Settings.AUTO_PRINT_REEL_TAG_COLUMN %>" label="auto_print" />
                        <form:option match="<%= content.getAutoPrintReelTags() %>" value="n" name="No"/>
                        <form:option match="<%= content.getAutoPrintReelTags() %>" value="y" name="Yes"/>
                    <form:select_end />
                <form:content_end />
            <form:row_end />
            <form:hidden name="<%= Settings.PARAM %>" value="<%= new Integer(content.getId()).toString() %>" />
            <form:hidden name="<%= Settings.CUSTOMER_ID_COLUMN %>" value="<%= new Integer(user.getCustomerId()).toString() %>" />
            <form:row_begin />
                <form:label name="" label="" />
                <form:buttonset_begin align="right" padding="0"/>
                        <form:submit_inline button="save" waiting="true" name="save" action="update" />
                <form:buttonset_end />
            <form:row_end />
    <form:end />
<admin:box_end />

<admin:set_tabset url="settings/_tabset_default.jsp" thispage="search.jsp" />
<html:end />	