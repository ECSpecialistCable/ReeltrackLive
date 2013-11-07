<%@ page language="java" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.reeltrack.picklists.*" %>
<%@ page import="com.reeltrack.foremans.*" %>
<%@ page import="com.monumental.trampoline.component.*" %>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="foremanMgr" class="com.reeltrack.foremans.ForemanMgr" scope="request"/>
<jsp:useBean id="picklistMgr" class="com.reeltrack.picklists.PickListMgr" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% foremanMgr.init(pageContext,dbResources); %>
<% picklistMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<%
// Get the id
int contid = 0;
if(request.getParameter(PickList.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(PickList.PARAM));
} else {
    String param = "content_id_for_tabset";
    if(request.getParameter(param) != null) {
        contid = Integer.parseInt(request.getParameter(param));
    }
}

// Get the piece of content
PickList content = new PickList();
content.setId(contid);
content = (PickList)picklistMgr.getPickList(content);

picklistMgr.generateQrCodesforPickList(content);
CompEntities pickReels = picklistMgr.getReelsOnPickList(content);

String tempURL; //var for url expression
%>
<% dbResources.close(); %>

<html>
<head>
<style type="text/css">
body {
    font-family:arial,"Lucida Grande",Geneva,Arial,Verdana,sans-serif;
    font-size: 25px;
}

.value {
	font-family:arial,"Lucida Grande",Geneva,Arial,Verdana,sans-serif;
	font-size: 12px;
	vertical-align:top;	
}

.header {
	font-family:arial,"Lucida Grande",Geneva,Arial,Verdana,sans-serif;
	font-size: 12px;
	background-color: #c4c4c4;	
}

table {
	width: 960px;
	border: 1px solid;
	margin-bottom: 5px;
}

td {
	padding: 5px;
}

</style>
</head>
<body>


<% for(int i=0; i<pickReels.howMany(); i++) { %>
	<% Reel reel = (Reel)pickReels.get(i); %>
	<table>
	<tr>
		<td class="header">ReelTag / Description</td>
		<td class="header">Customer P/N</td>
		<td class="header">Serial #</td>
		<td class="header">Location</td>
		<td class="header">Status</td>
		<% tempURL = reel.getCompEntityDirectory() + "/" + reel.getPlQrCodeFile(); %>
		<td rowspan="6" width="250"><img src="<%= tempURL %>" width="250" height="250" /></td>
	</tr>
	<tr>
		<td class="value"><%= reel.getReelTag() %></td>
		<td class="value"><%= reel.getCustomerPN() %></td>
		<td class="value"><%= reel.getReelSerial() %></td>
		<td class="value"><%= reel.getWharehouseLocation() %></td>
		<td class="value"><%= reel.getStatus() %></td>
	</tr>
	<tr>
		<td class="header" colspan="3">&nbsp;</td>
		<td class="header">Type</td>
		<td class="header">Quantity</td>
	</tr>
	<tr>
		<td class="value" colspan="3">&nbsp;</td>
		<td class="value"><%= reel.getReelType() %></td>
		<td class="value"><%= reel.getOnReelQuantity() %></td>
	</tr>
	<tr>
		<td class="header" colspan="3">&nbsp;</td>
		<td class="header">Circuit Name</td>
		<td class="header">Quantity</td>
	</tr>
	<tr>
		<td class="value" colspan="3">&nbsp;</td>
		<td class="value">&nbsp;</td>
		<td class="value">&nbsp;</td>
	</tr>
	</table>
	<% } %>


</body>
</html>

<%--
<% if(pickReels.howMany() > 0) { %>

	    <% for(int i=0; i<pickReels.howMany(); i++) { %>
	    <% Reel reel3 = (Reel)pickReels.get(i); %>
	    <listing:row_begin row="<%= new Integer(i).toString() %>" />
	        <listing:cell_begin />
	            <%= reel3.getReelTag() %><br />
	            <%= reel3.getCableDescription() %>
	        <listing:cell_end />
	        <listing:cell_begin />
	            <%= reel3.getCustomerPN() %>
	        <listing:cell_end />
	        <listing:cell_begin />
	            <%= reel3.getReelType() %>
	        <listing:cell_end />
	        <listing:cell_begin />
	            <%= reel3.getOnReelQuantity() %>
	        <listing:cell_end />
	        <listing:cell_begin />
	            <%= reel3.getWharehouseLocation() %>
	        <listing:cell_end />
	        <listing:cell_begin />
	            <%= reel3.getId() %>
	        <listing:cell_end />
	        <listing:cell_begin align="right"/>
	            <% tempURL = "pick_lists/process.jsp?submit_action=delete_reel&" + PickList.PARAM + "=" + content.getId() + "&" + Reel.PARAM + "=" + reel3.getId(); %>
                <form:linkbutton warning="true" url="<%= tempURL %>" process="true" name="Delete" />
	        <listing:cell_end />
	    <listing:row_end />
	    <% } %>
	<listing:end />
	<admin:box_end />
--%>