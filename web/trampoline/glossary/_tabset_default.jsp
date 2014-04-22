<%@ page language="java" %>
<%@ page import="com.reeltrack.users.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>

<admin:tab url="glossary/reeltrack_glossary.jsp" text="ReelTrack Glossary" />
<admin:tab url="glossary/job_glossary.jsp" text="Job Glossary" />
<%--<admin:tab url="glossary/import_glossary.jsp" text="Import Glossary" />--%>

<admin:set_moduleactions url="glossary/_moduleactions.jsp" />
