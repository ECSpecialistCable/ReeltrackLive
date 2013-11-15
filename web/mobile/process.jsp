<%@ page language="java" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" scope="request"/>
<% reelMgr.init(pageContext,dbResources); %>
<% CompProperties props = new CompProperties(); %>

<%
String action = "";
if(request.getParameter("action") != null) {
    action = request.getParameter("action");
}

if(action.equals("mark_staged")) {
    Reel content = new Reel();
    content.setId(Integer.parseInt(request.getParameter("id")));
    content.setTopFoot(Integer.parseInt(request.getParameter("top")));
    reelMgr.markReelStaged(content);
}

if(action.equals("mark_checkedout")) {
    Reel content = new Reel();
    content.setId(Integer.parseInt(request.getParameter("id")));
    content.setTopFoot(Integer.parseInt(request.getParameter("top")));
    reelMgr.markReelCheckedOut(content);
}
%>
<% dbResources.close(); %>