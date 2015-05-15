<%@ page language="java" %>
<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.monumental.trampoline.security.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.reeltrack.users.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" />
<% reelMgr.init(pageContext,dbResources); %>

<%  
    String param = "content_id_for_tabset";    
    String paramstring = "";
    String paramstring2 = "";
    Reel reel2 = null;
	if(request.getParameter(param) != null) {
		paramstring = "?" + param + "=" + request.getParameter(param);
	}

	Reel reel = new Reel();
	reel.setId(Integer.parseInt(request.getParameter(param)));
	reel2 = reelMgr.getReelByNextCrid(reel);
	if(reel2!=null) {
		paramstring2 = "?" + param + "=" + reel2.getId();
	}	    
%>
<% dbResources.close(); %>

<admin:tab url="reels/search.jsp" text="Search All" />
<admin:tab url="reels/cable_data.jsp" text="Cable Data" params="<%= paramstring %>"/>
<admin:tab url="reels/status.jsp" text="status" params="<%= paramstring %>"/>
<admin:tab url="reels/edit.jsp" text="edit" params="<%= paramstring %>"/>
<admin:tab url="reels/quantity.jsp" text="quantity" params="<%= paramstring %>"/>
<admin:tab url="reels/circuits.jsp" text="circuits" params="<%= paramstring %>"/>
<admin:tab url="reels/issues.jsp" text="Issues" params="<%= paramstring %>"/>
<admin:tab url="reels/notes.jsp" text="Notes" params="<%= paramstring %>"/>
<admin:tab url="reels/log.jsp" text="Log" params="<%= paramstring %>"/>
<admin:tab url="reels/reel_data.jsp" text="Reel Data" params="<%= paramstring %>"/>
<% if(reel2!=null) { %>
	<admin:tab url="reels/status.jsp" text=">> Next CRID" params="<%= paramstring2 %>"/>
<% } %>


<admin:set_moduleactions url="reel_inventory/_moduleactions.jsp" />
