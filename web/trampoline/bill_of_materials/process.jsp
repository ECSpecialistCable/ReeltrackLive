<%@page import="com.reeltrack.reels.CableTechData"%>
<%@page import="com.monumental.trampoline.utilities.forms.multipart.MultipartRequest"%>
<%@page import="java.io.File"%>
<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.customers.CustomerJob"%>
<%@ page import="com.reeltrack.reels.Reel" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>
<jsp:useBean id="customerMgr" class="com.reeltrack.customers.CustomerMgr" scope="request"/>
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" />
<% securityMgr.init(dbResources); %>
<% customerMgr.init(pageContext,dbResources); %>
<% reelMgr.init(pageContext,dbResources); %>
<% CompProperties props = new CompProperties(); %>

<% 
String basePath = pageContext.getServletContext().getRealPath("/");
String notifier = "";
String redirect = request.getHeader("referer");
String action = "";
MultipartRequest multipart = null;
CustomerJob content = new CustomerJob();

if(request.getParameter("submit_action") != null) {
    action = request.getParameter("submit_action");
}

int contid = 0;
if(request.getParameter(CustomerJob.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(CustomerJob.PARAM));
} else {
	if(action == null || action.equals("")) {
		String uploadDir = basePath + content.getComponentUploadDirectory()  + "/";
		File createDir = new File(uploadDir);
		if(!createDir.exists()) {
			createDir.mkdirs();
		}
		multipart = new MultipartRequest(request,uploadDir,104857600);
		if(multipart.getParameter("submit_action")!=null) {
			action = multipart.getParameter("submit_action");
		}
		if(multipart.getParameter(CustomerJob.PARAM)!=null) {
			contid = Integer.parseInt(multipart.getParameter(CustomerJob.PARAM));
		}
	}
}


if(action.equals("upload_bom_pdf")) {
    content = new CustomerJob();
    content.setId(contid);
    File file = multipart.getFile(CustomerJob.BOM_PDF_COLUMN);
	if(file!=null) {
		customerMgr.updateCustomerJob(content, file, basePath);
	}

	//redirect = request.getContextPath() + "/trampoline/" + "users/edit.jsp?" + RTUser.PARAM + "=" + contid;
    redirect = request.getContextPath() + "/trampoline/" + "bill_of_materials/search.jsp";
}

if(action.equals("update_usage_tracking")) {
	Reel reel = new Reel();
	reel.setId(Integer.parseInt(request.getParameter(Reel.PARAM)));
	CableTechData techData = reelMgr.getCableTechData(reel);
	
	CableTechData toUpdate = new CableTechData();
	toUpdate.setId(techData.getId());
	toUpdate.setUsageTracking(request.getParameter(CableTechData.USAGE_TRACKING_COLUMN));
	reelMgr.updateCableTechData(toUpdate);

    redirect = request.getContextPath() + "/trampoline/" + "bill_of_materials/search.jsp";
}

if(action.equals("upload_data_sheet")) {
	Reel reel = new Reel();
	reel.setId(Integer.parseInt(multipart.getParameter(Reel.PARAM)));
	CableTechData techData = reelMgr.getCableTechData(reel);
	
	CableTechData toUpdate = new CableTechData();
	toUpdate.setId(techData.getId());
	File file = multipart.getFile(CableTechData.DATA_SHEET_FILE_COLUMN);
	if(file!=null && !file.getName().equals("")) {
		reelMgr.updateCableTechData(toUpdate, basePath, file);
	}
    redirect = request.getContextPath() + "/trampoline/" + "bill_of_materials/search.jsp";
}

if(action.equals("update_customer_pn")) {
	Reel reel = new Reel();
	reel.setId(Integer.parseInt(request.getParameter(Reel.PARAM)));
	reel.setCustomerPN(request.getParameter(Reel.CUSTOMER_PN_COLUMN));
	reelMgr.updateReel(reel);
    redirect = request.getContextPath() + "/trampoline/" + "bill_of_materials/cust_pn.jsp";
}
%>
<% dbResources.close(); %>
<notifier:set_message text="<%= notifier %>" />		
<admin:ajax_redirect redirect="<%= redirect %>" />