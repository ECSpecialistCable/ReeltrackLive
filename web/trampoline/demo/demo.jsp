<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>	
<% dbResources.close(); %>


<html:begin />
<admin:title text="Demo Management" />

<a href="/trampoline/demo/resetReels.jsp">Reset reel data</a>
<br /><br /><br /><br />
<a href="/trampoline/demo/importData.jsp">Reset all data</a>
<br /><br />
<a href="/trampoline/demo/exportData.jsp">Export demo database for reset (JAR/WBS Only)</a>
<br /><br />


<admin:set_tabset url="demo/_tabset_default.jsp" thispage="demo.jsp" />
<html:end />	