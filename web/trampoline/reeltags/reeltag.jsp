<%@ page language="java" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.reeltrack.customers.Customer"%>
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
Customer reelCustomer = reelMgr.getCustomerForReel(content);

SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy hh:mma");
String dateString = df.format(new Date());

String tempURL; //var for url expression
String logoURL;
%>
<% dbResources.close(); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
	<title>Reel Tags</title>
	<style type="text/css">
		body {
			font-family:arial,"Lucida Grande",Geneva,Arial,Verdana,sans-serif;
			font-size: 25px;
		}

		.value {
			font-family:arial,"Lucida Grande",Geneva,Arial,Verdana,sans-serif;
			font-size: 10px;
			vertical-align: top;
			font-weight: bold;
		}

		.header {
			font-family:arial,"Lucida Grande",Geneva,Arial,Verdana,sans-serif;
			font-size: 10px;
			/*background-color: #c4c4c4;*/
			/*background-color: gray;
			font-weight: bold;*/
		}

		table {
			width: 690px;
			/*height: 400px;*/
			border: 1px solid;
			margin-bottom: 5px;
			/*background-color: gray;*/
		}

		td {
			padding: 3px;
		}
		
		@page {
			size: 8in 4in;
			margin-top: 0.0in;
			margin-bottom: 0.0in;
			margin-left: 0.0in;
			margin-right: 0.0in;
		}

		.rotate {
			position: absolute;
			top:250px;
			transform:rotate(90deg);
			-ms-transform:rotate(90deg); /* IE 9 */
			-webkit-transform:rotate(90deg); /* Safari and Chrome */
		}



	</style>
</head>
<body>
	<table style="border: none;border-bottom: solid 1px black;margin: 0px">
		<tr>
			<td>
				<table style="display:inline; width:50%;padding:0px;border: none;">
					<tr>
						<td><b><%= content.getReelTag() %></b></td>
					</tr>
					<tr>
						<td><%= reelCustomer.getName() %></td>
					</tr>
					<tr>
						<td class="header" style="width:50px">P/N</td>
						<td class="value" style="width:90px"><b><%= content.getCustomerPN()  %></b></td>
					</tr>
					<tr>
						<td class="header" style="width:50px">P/O #</td>
						<td class="value" style="width:90px"><b><%= content.getCustomerPO()  %></b></td>
					</tr>
					<tr>
						<td class="header" style="width:50px">Mfg</td>
						<td class="value" style="width:150px"><b><%= content.getManufacturer()  %></b></td>
					</tr>
				</table>
			</td>
			<td>
				<table style="display:inline; width:10%;padding:0px;border: none;">
					<% tempURL = "http://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + content.getCompEntityDirectory() + "/" + content.getRtQrCodeFile(); %>
					<tr style="padding: 0;" align="center">
						<img alt="barcode" src="<%= tempURL %>" width="125" height="125" />
					</tr>

				</table>
			</td>
			<td>
				<table style="display:inline; width:40%;padding:0px; border: none;">
					<tr>
						<td class="header" style="width:90px">CRID#</td>
						<td class="header" style="width:90px">Rec'd Qty</td>
					</tr>
					<tr>
						<td class="value" style="width:90px"><b><%= content.getReelSerial()  %></b></td>
						<td class="value" style="width:90px"><b><%= content.getOnReelQuantity()  %></b></td>
					</tr>
					<tr>
						<td class="header" style="width:90px">Weight / kft</td>
						<td class="value" style="width:90px"><b><%= new Integer(techData.getWeight()).toString() + "lbs"   %></b></td>
					</tr>
					<tr>
						<td class="header" style="width:90px">Rec'd GWT</td>
						<td class="value" style="width:90px"><b></b></td>
					</tr>
					<tr>
						<td class="header" style="width:90px">O.D. (in)</td>
						<td class="value" style="width:90px"><b><%= Double.toString(techData.getOD())+"\""   %></b></td>
					</tr>
					<tr>
						<td class="header" style="width:90px">M.B.R.</td>
						<td class="value" style="width:90px"><b><%= Double.toString(techData.getRadius())+"\""   %></b></td>
					</tr>
					<tr>
						<td class="header" style="width:90px">Max Pull</td>
						<td class="value" style="width:90px"><b><%--<%= new Integer(techData.getPullTension()).toString()  %>--%></b></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<table style="margin: 0px; width:692px; border: none">
		<tr>
			<td class="header" style="text-align: center; width: 35%">Circuit</td>
			<td class="header" style="text-align: center; width: 20%">Length</td>
			<td class="header" style="text-align: center; width: 10%">BY</td>
			<td class="header" style="text-align: center; width: 35%"><%= content.getCableDescription() %></td>
		</tr>

		<% int total = 0; %>
		<% if(circuits.howMany()==0) { %>
			<td class="value" style="width: 35%;border-top: solid 1px black"></td>
				<td class="value" style="width: 20%;border-top: solid 1px black"></td>
				<td class="value" style="width: 10%;border-top: solid 1px black"></td>
				<% logoURL = "http://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/trampoline/common/images/logo.png"; %>
				<td style="text-align: center; width: 35%; padding: 0;width:160px;border-top: solid 1px black" rowspan="<%= "3" %>" align="center">
					<table style="display:inline;width: 35%; text-align: center;border: none">
						<tr>
							<td class="header">ECS Part #</td>
							<td class="value"><%= content.getEcsPN() %></td>

							<td class="header">ECS PO #</td>
							<td class="value"><%= "" %></td>
						</tr>
						<tr>
							<td colspan="2" style="text-align: center;width: 35%;"><img alt="logo" src="<%= logoURL %>" width="130" height="40" /></td>
						</tr>
						<tr>
							<td class="header" colspan="2" style="text-align: center; width: 35%;">770.446.2222   www.ecscable.com</td>
						</tr>
						<tr>
							<td class="header" colspan="2" style="text-align: center;width: 35%;">Printed <%= dateString %></td>
						</tr>
					</table>

				</td>
		<% } else { %>
			<% for (int c=0; c<circuits.howMany(); c++ ) { %>
				<% ReelCircuit circuit = (ReelCircuit)circuits.get(c); %>
				<% total += circuit.getLength(); %>
				<tr>
					<% String borderStyle = ""; %>
					<% if(c==0) { %>
						<% borderStyle=";border-left: solid 1px black;border-right: solid 1px black;border-top: solid 1px black;"; %>
					<% } %>
					<% if(c==circuits.howMany()-1) { %>
						<% if(c==0) { %>
							<% borderStyle=";border-left: solid 1px black;border-right: solid 1px black;border-top: solid 1px black;border-bottom: solid 1px black;"; %>
						<% } else { %>
							<% borderStyle=";border-left: solid 1px black;border-right: solid 1px black;border-bottom: solid 1px black;"; %>
						<% } %>
					<% } %>

					<td class="value" style="width: 35%<%=borderStyle%>"><%= circuit.getName() %></td>
					<td class="value" style="width: 20%;<%=borderStyle%>"><%= circuit.getLength() %></td>
					<td class="value" style="width: 10%;<%=borderStyle%>"></td>
					<% if(c==0) { %>
						<% logoURL = "http://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/trampoline/common/images/logo.png"; %>
						<td style="text-align: center; width: 35%; padding: 0;width:160px;border-top: solid 1px black" rowspan="<%= "3" %>" align="center">
							<table style="display:inline;width: 35%; text-align: center;border: none">
								<tr>
									<td class="header">ECS Part #</td>
									<td class="value"><%= content.getEcsPN() %></td>

									<td class="header">ECS PO #</td>
									<td class="value"><%= "" %></td>
								</tr>
								<tr>
									<td colspan="2" style="text-align: center;width: 35%;"><img alt="logo" src="<%= logoURL %>" width="130" height="40" /></td>
								</tr>
								<tr>
									<td class="header" colspan="2" style="text-align: center; width: 35%;">770.446.2222   www.ecscable.com</td>
								</tr>
								<tr>
									<td class="header" colspan="2" style="text-align: center;width: 35%;">Printed <%= dateString %></td>
								</tr>
							</table>
						</td>
					<% } %>
				</tr>
			<% } %>
		<% } %>
	</table>
</body>
</html>