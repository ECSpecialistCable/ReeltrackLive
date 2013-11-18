<%@ page language="java" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% reelMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<%
// Get the id
int contid = 0;
if(request.getParameter(Reel.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(Reel.PARAM));
} else {
    String param = "content_id_for_tabset";
    if(request.getParameter(param) != null) {
        contid = Integer.parseInt(request.getParameter(param));
    }
}

// Get the piece of content
Reel content = new Reel();
content.setId(contid);
reelMgr.generateQrCode(content);
content = (Reel)reelMgr.getReel(content);
CompEntities circuits = reelMgr.getReelCircuits(content);
CableTechData techData = reelMgr.getCableTechData(content);

SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy");
String dateString = df.format(new Date());

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
	vertical-align: top;	
}

.header {
	font-family:arial,"Lucida Grande",Geneva,Arial,Verdana,sans-serif;
	font-size: 12px;
	background-color: #c4c4c4;
	font-weight: bold;	
}

table {
	width: 800px;
	height: 400px;
	border: 1px solid;
	margin-bottom: 5px;
}

td {
	padding: 5px;
}

</style>
</head>
<body>

	<% int rowspan = 9 + circuits.howMany(); %>
	<table>
	<tr>
		<td class="header">ReelTag / Description</td>
		<td class="header">Customer P/N</td>
		<td class="header">Serial #</td>
		<td class="header">Type</td>
		<td class="header">Quantity</td>
		<% tempURL = "http://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + content.getCompEntityDirectory() + "/" + content.getRtQrCodeFile(); %>
		<td rowspan="<%= rowspan %>" width="250" valign="top"><img src="<%= tempURL %>" width="250" height="250" /></td>
	</tr>
	<tr>
		<td class="value"><%= content.getReelTag() %></td>
		<td class="value"><%= content.getCustomerPN() %></td>
		<td class="value"><%= content.getReelSerial() %></td>
		<td class="value"><%= content.getReelType() %></td>
		<td class="value"><%= content.getOnReelQuantity() %></td>
	</tr>
	<tr>
		<td class="header" colspan="3">&nbsp;</td>
		<td class="header">Circuit Name</td>
		<td class="header">Length</td>
	</tr>
	<% int total = 0; %>
	<% for (int c=0; c<circuits.howMany(); c++ ) { %>
	<% ReelCircuit circuit = (ReelCircuit)circuits.get(c); %>
	<% total += circuit.getLength(); %>
	<tr>
		<td class="value" colspan="3">&nbsp;</td>
		<td class="value"><%= circuit.getName() %></td>
		<td class="value"><%= circuit.getLength() %></td>
	</tr>
	<% } %>
	<tr>
		<td class="value" colspan="3">&nbsp;</td>
		<td class="value"><b>Total</b></td>
		<td class="value"><%= total %></td>
	</tr>
	
	<tr>
		<td class="header">Maufacturer</td>
		<td class="header">O.D. (inches)</td>
		<td class="header">Weight</td>
		<td class="header">X-Section</td>
		<td class="header">Pull Tension Max (lbs)</td>
	</tr>
	<tr>
		<td class="value"><%= content.getManufacturer() %></td>
		<td class="value"><%= Double.toString(techData.getOD()) %></td>
		<td class="value"><%= new Integer(techData.getWeight()).toString() %></td>
		<td class="value"><%= Double.toString(techData.getXSection()) %></td>
		<td class="value"><%= new Integer(techData.getPullTension()).toString() %></td>
	</tr>
	</table>


</body>
</html>