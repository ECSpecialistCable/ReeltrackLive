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
    String paramstring3 = "";
    String paramstring4 = "";
	if(request.getParameter(param) != null) {
		paramstring = "?" + param + "=" + request.getParameter(param);
	}

	Reel reel = new Reel();
	reel.setId(Integer.parseInt(request.getParameter(param)));
	reel = reelMgr.getReelByNextCrid(reel);
	if(reel!=null && reel.getId()!=0) {
		paramstring2 = "?" + param + "=" + reel.getId();
	}

	Reel reel2 = new Reel();
	reel2.setId(Integer.parseInt(request.getParameter(param)));
	reel2 = reelMgr.getReelByLastCrid(reel2);
	if(reel2!=null && reel2.getId()!=0) {
		paramstring3 = "?" + param + "=" + reel2.getId();
	}

	Reel reel3 = new Reel();
	reel3.setId(Integer.parseInt(request.getParameter(param)));
	reel3 = reelMgr.getReelByPreviousCrid(reel3);
	if(reel3!=null && reel3.getId()!=0) {
		paramstring4 = "?" + param + "=" + reel3.getId();
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
<% if(reel3!=null && reel3.getId()!=0) { %>
	<admin:tab url="reels/status.jsp" text="<<" params="<%= paramstring4 %>"/>
<% } %>
<% if(reel!=null && reel.getId()!=0) { %>
	<admin:tab url="reels/status.jsp" text=">>" params="<%= paramstring2 %>"/>
<% } %>
<% if(reel2!=null && reel2.getId()!=0) { %>
	<admin:tab url="reels/status.jsp" text="LAST" params="<%= paramstring3 %>"/>
<% } %>


<admin:set_moduleactions url="reel_inventory/_moduleactions.jsp" />
