<%@ page language="java" %>
<%@ page import="com.reeltrack.users.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>

<admin:tab url="received/search.jsp" text="All" />
<admin:tab url="received/no_location.jsp" text="No Location" />
<admin:tab url="received/in_wharehouse.jsp" text="In Wharehouse" />
<admin:tab url="received/staged.jsp" text="Staged" />
<admin:tab url="received/checked_out.jsp" text="Checked Out" />
<admin:tab url="received/complete.jsp" text="Complete" />
<admin:tab url="received/scrapped.jsp" text="Scrapped" />

<admin:set_moduleactions url="reel_inventory/_moduleactions.jsp" />
