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
			background:white;
			margin:0px;
		}

		.value {
			font-family:arial,"Lucida Grande",Geneva,Arial,Verdana,sans-serif;
			font-size: 12px;
			vertical-align: top;
			font-weight: bold;
		}

		.header {
			font-family:arial,"Lucida Grande",Geneva,Arial,Verdana,sans-serif;
			font-size: 12px;
			text-align: right;
			/*background-color: #c4c4c4;*/
			/*background-color: gray;
			font-weight: bold;*/
		}

		table {
			width: 650px;
			/*height: 400px;*/
			border: 1px solid;
			margin-bottom: 5px;
			/*background-color: gray;*/
		}

		td {
			padding: 3px;
		}
		
		tr{

}
		
		@page {
			size: 6.7in 3.3in;
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
<body style="border:none; width: 650px !important;">
	
	<table style="border:none;margin: 0px; margin-bottom: 0px;padding: 0px;">
		<tr>
			<td colspan="2" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 10px;"><%= reelCustomer.getName().toUpperCase() %></td>
			<td rowspan="8" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top; margin-bottom: 0px; padding-bottom: 0px;padding-top: 0px; text-align: center">
					<% tempURL = "http://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + content.getCompEntityDirectory() + "/" + content.getRtQrCodeFile(); %>
					<img alt="barcode" src="<%= tempURL %>" width="170" height="170" />
			</td>
			<td class="header" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 15px;">Mfg</td>
			<td class="value" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 15px;"><b><%= "ABC"  %></b></td>
		</tr>
		<tr>
			<td class="header" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 0px;">P/N</td>
			<td class="value" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 0px;"><b><%= content.getCustomerPN()  %></b></td>

			<td class="header" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 0px;">Weight / kft</td>
			<td class="value" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 0px;"><b><%= new Integer(techData.getWeight()).toString() + "lbs"   %></b></td>
		</tr>
		<tr>
			<td class="header" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 0px;">P/O #</td>
			<td class="value" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 0px;"><b><%= content.getCustomerPO()  %></b></td>

			<td class="header" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 0px;">O.D. (in)</td>
			<td class="value" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 0px;"><b><%= Double.toString(techData.getOD())+"\""   %></b></td>
		</tr>
		<tr>
			<td class="header" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 0px;">Rec'd QTY</td>
			<td class="value" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 0px;"><b><%= content.getOnReelQuantity()  %></b></td>

			<td class="header" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 0px;">M.B.R.</td>
			<td class="value" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 0px;"><b><%= Double.toString(techData.getRadius())+"\""   %></b></td>
		</tr>
		<tr>
			<td class="header" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 0px;">Rec'd GWT</td>
			<td class="value" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 0px;"><b></b></td>

			<td class="header" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 0px;">Max Pull</td>
			<td class="value" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 0px;"><b></b></td>
		</tr>
		<tr >
			<td class="header" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 0px;"></td>
			<td class="value" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 0px;"><b></b></td>

			<td class="header" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 0px;"></td>
			<td class="value" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 0px;"><b></b></td>
		</tr>
		<tr>
			<td class="header" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 0px;"></td>
			<td class="value" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 0px;"><b></b></td>

			<td class="header" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 0px;"></td>
			<td class="value" style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: top;padding-bottom: 0px;padding-top: 0px;"><b></b></td>
		</tr>
		<tr>
			<td colspan="2" style="/*border:solid #003DB8 1px;*/border-top:solid 2px black;border-bottom: solid 2px black;width:20%;vertical-align: center;padding-bottom: 0px;padding-top: 0px;text-align: left;"><b><%= content.getReelTag() %></b></td>
			<td style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: center;padding-bottom: 0px;padding-top: 0px;border-top:solid 2px black;border-bottom: solid 2px black;text-align: right;">CRID#</td>
			<td  style="/*border:solid #003DB8 1px;*/width:20%;vertical-align: center;padding-bottom: 0px;padding-top: 0px;border-top:solid 2px black;border-bottom: solid 2px black;"><b><%= content.getCrId() %></b></td>
		</tr>		
	</table>
	<table style="margin: 0px; margin-top: -25px; padding-top: 20px; width:650px;margin-right: 10px; /*border: solid green 2px*/border:none">
		<tr>
			<td class="header" style="text-align: left; width: 20%">CIRCUIT</td>
			<td class="header" style="text-align: center; width: 20%">LENGTH</td>
			<td class="header" style="text-align: center; width: 10%">BY</td>
			<td class="header" style="text-align: center; width: 30%"><%= content.getCableDescriptionEscaped() %></td>
		</tr>

		<% int total = 0; %>

		<% for (int c=0; c<circuits.howMany() || c<5; c++ ) { %>
			<% ReelCircuit circuit = new ReelCircuit(); %>
			<% if(c<circuits.howMany()) { %>
				<%  circuit = (ReelCircuit)circuits.get(c); %>
				<% total += circuit.getLength(); %>
			<% } %>
			<tr>
				<% String borderStyle = "border-bottom: dotted 1px black"; %>
					<td class="value" style="height:14px;width: 25%;<%=borderStyle%>;padding-bottom:0px"><%= circuit.getName() %></td>
				<% if(c<circuits.howMany()) { %>
					<td class="value" style="height:14px;width: 20%;<%=borderStyle%>"><%= circuit.getLength() %></td>
				<% } else { %>
					<td class="value" style="height:14px;width: 20%;<%=borderStyle%>"></td>
				<% } %>
				<td class="value" style="height:1px;width: 10%;<%=borderStyle%>"></td>
				<% if(c==0) { %>
					<% logoURL = "http://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/trampoline/common/images/logo_reeltag.jpg"; %>
					<td style="text-align: center; width: 75%; padding: 0;width:160px;" rowspan="<%= "6" %>" align="center">
						<table style="display:inline;width: 75%; text-align: center;border: none">
							<tr>
								<td class="header" style="text-align: right;width: 40%">ECS PART #</td>
								<td class="value" style="/*border:solid #003DB8 1px;*/text-align: left;width: 35%"><%= content.getEcsPN() %></td>
							</tr>
							<tr>
								<td class="header" style="text-align: right;width: 40%">ECS PO #</td>
								<td class="value" style="/*border:solid #003DB8 1px;*/text-align: left"><%= "" %></td>
							</tr>
							<tr>
								<td colspan="2" style="/*border:solid #003DB8 1px;*/text-align: center;width: 75%;padding-top: 0px;padding-bottom: 0px;margin-bottom: 0px"><img alt="logo" src="<%= logoURL %>" width="130" height="40" />
								</td>
							</tr>
							<tr>
								<td class="header" colspan="2" style="/*border:solid #003DB8 1px;*/text-align: left; width: 75%;padding: 0px;padding-left: 7px;">770.446.2222 www.ecscable.com</td>
							</tr>
						</table>
					</td>
				<% } %>
			</tr>
		<% } %>
		<tr>
			<td class="header" colspan="3" style="text-align: center;">PRINTED <%= dateString %></td>
		</tr>
	</table>
	<%-- changed the code to above to tighten up the new design
	<table style="border: none;margin: 0px; margin-bottom: 0px;">
		<tr>
			<td style="vertical-align: top">
				<table style="display:inline; width:50%;padding:0px;border: none;vertical-align: top;">
					<tr>
						<td style="padding-top: 7px;" colspan="2"><%= reelCustomer.getName().toUpperCase() %></td>
					</tr>
					<tr>
						<td class="header" style="width:35px">P/N</td>
						<td class="value" style="width:90px"><b><%= content.getCustomerPN()  %></b></td>
					</tr>
					<tr>
						<td class="header" style="width:35px">P/O #</td>
						<td class="value" style="width:90px"><b><%= content.getCustomerPO()  %></b></td>
					</tr>
					<tr>
						<td class="header" style="width:35px">Rec'd QTY</td>
						<td class="value" style="width:90px"><b><%= content.getOnReelQuantity()  %></b></td>
					</tr>
					<tr>
						<td class="header" style="width:35px">Rec'd GWT</td>
						<td class="value" style="width:90px"><b></b></td>
					</tr>
					<tr>
						<td colspan="2" style="width:90px;border-top:solid 2px black;border-bottom: solid 2px black; text-align: left; padding-left: 0px;height: 30px !important"><b><%= content.getReelTag() %></b></td>
					</tr>
				</table>
			</td>
			<td style="vertical-align: top; margin-bottom: 0px; padding-bottom: 0px;padding-top: 2px;">
				<table style="display:inline; width:10%;padding:0px;border: none;vertical-align: top;">
					<% tempURL = "http://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + content.getCompEntityDirectory() + "/" + content.getRtQrCodeFile(); %>
					<tr style="padding: 0px;">
						<td style="padding: 0px;">
							<img alt="barcode" src="<%= tempURL %>" width="180" height="180" />
						</td>
					</tr>

				</table>
			</td>
			<td style="vertical-align: top;">
				<table style="display:inline; width:40%;padding:0px; border: none;vertical-align: top;" >
					<tr>
						<td></td><td></td>
					</tr>
					<tr>
						<td class="header" style="width:90px;">Mfg</td>
						<td class="value" style="width:90px"><b><%= content.getManufacturer()  %></b></td>
					</tr>
					<tr>
						<td></td><td></td>
					</tr>
					<tr>
						<td class="header" style="width:90px;padding-top: 7px">Weight / kft</td>
						<td class="value" style="width:90px;padding-top: 7px"><b><%= new Integer(techData.getWeight()).toString() + "lbs"   %></b></td>
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
						<td class="value" style="width:90px"><b></b></td>
					</tr>
					<tr>
						<td style="width:90px;border-top:solid 2px black;border-bottom: solid 2px black; text-align: right; padding-left: 0px;">CRID#</td>
						<td style="width:90px;border-top:solid 2px black;border-bottom: solid 2px black; text-align: left; padding-left: 0px;"><b><%= content.getCrId() %></b></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<table style="margin: 0px; margin-top: -25px; padding-top: 0px; width:692px; border: none">
		<tr>
			<td class="header" style="text-align: left; width: 35%">CIRCUIT</td>
			<td class="header" style="text-align: center; width: 20%">LENGTH</td>
			<td class="header" style="text-align: center; width: 10%">BY</td>
			<td class="header" style="text-align: center; width: 35%"><%= content.getCableDescription() %></td>
		</tr>

		<% int total = 0; %>
		
		<% for (int c=0; c<circuits.howMany() || c<5; c++ ) { %>
			<% ReelCircuit circuit = new ReelCircuit(); %>
			<% if(c<circuits.howMany()) { %>
				<%  circuit = (ReelCircuit)circuits.get(c); %>
				<% total += circuit.getLength(); %>
			<% } %>
			<tr>
				<% String borderStyle = "border-bottom: dotted 1px black"; %>
					<td class="value" style="height:13px;width: 35%;<%=borderStyle%>;padding-bottom:0px"><%= circuit.getName() %></td>
				<% if(c<circuits.howMany()) { %>
					<td class="value" style="height:13px;width: 20%;<%=borderStyle%>"><%= circuit.getLength() %></td>
				<% } else { %>
					<td class="value" style="height:13px;width: 20%;<%=borderStyle%>"></td>
				<% } %>
				<td class="value" style="height:1px;width: 10%;<%=borderStyle%>"></td>
				<% if(c==0) { %>
					<% logoURL = "http://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/trampoline/common/images/logo_big.png"; %>
					<td style="text-align: center; width: 35%; padding: 0;width:160px;" rowspan="<%= "5" %>" align="center">
						<table style="display:inline;width: 35%; text-align: center;border: none">
							<tr>
								<td class="header" style="text-align: right">ECS PART #</td>
								<td class="value" style="text-align: left"><%= content.getEcsPN() %></td>
							</tr>
							<tr>
								<td class="header" style="text-align: right">ECS PO #</td>
								<td class="value" style="text-align: left"><%= "" %></td>
							</tr>
							<tr>
								<td colspan="2" style="text-align: center;width: 35%;padding-top: 0px;padding-bottom: 0px;margin-bottom: 0px"><img alt="logo" src="<%= logoURL %>" width="130" height="40" />
								</td>
							</tr>
							<tr>
								<td class="header" colspan="2" style="text-align: center; width: 35%;">770.446.2222 www.ecscable.com</td>
							</tr>
						</table>
					</td>
				<% } %>
			</tr>
		<% } %>
		<tr>
			<td class="header" colspan="5" style="text-align: center;">PRINTED <%= dateString %></td>
		</tr>
	</table>
	--%>
</body>
</html>