<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.monumental.trampoline.utilities.forms.multipart.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="java.io.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" scope="request"/>
<% securityMgr.init(dbResources); %>
<% reelMgr.init(pageContext,dbResources); %>
<% CompProperties props = new CompProperties(); %>

<%
MultipartRequest multipart = null; 
String basePath = pageContext.getServletContext().getRealPath("/");
String notifier = "";
String redirect = request.getHeader("referer");
String action = "";
if(request.getParameter("submit_action") != null) {
    action = request.getParameter("submit_action");
}

Reel contentUpload = new Reel();

int contid = 0;
if(request.getParameter(Reel.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(Reel.PARAM));
} else {
    String uploadDir = basePath + contentUpload.getComponentUploadDirectory()  + "/";
    File createDir = new File(uploadDir);
    if(!createDir.exists()) {
        createDir.mkdirs();
    }
    multipart = new MultipartRequest(request,uploadDir,330240000);
    if(multipart.getParameter("submit_action")!=null) {
        action = multipart.getParameter("submit_action");
    }
    if(multipart.getParameter(Reel.PARAM)!=null) {
        contid = Integer.parseInt(multipart.getParameter(Reel.PARAM));
    }
}

if(action.equals("create")) {
    Reel content = new Reel();
    content.setReelTag(request.getParameter(Reel.REEL_TAG_COLUMN));
    content.setCableDescription(request.getParameter(Reel.CABLE_DESCRIPTION_COLUMN));
    content.setCustomerPO(request.getParameter(Reel.CUSTOMER_PO_COLUMN));
    content.setCustomerPN(request.getParameter(Reel.CUSTOMER_PN_COLUMN));
    content.setEcsPN(request.getParameter(Reel.ECS_PN_COLUMN));
    content.setManufacturer(request.getParameter(Reel.MANUFACTURER_COLUMN));
    content.setSteelReelSerial(request.getParameter(Reel.STEEL_REEL_SERIAL_COLUMN));
    content.setOrderedQuantity(1000);
    content.setBottomFoot(500);
    contid = reelMgr.addReel(content);

    redirect = request.getContextPath() + "/trampoline/" + "reels/search.jsp";
}

if(action.equals("update_reel_data")) {
    Reel content = new Reel();
    content.setId(contid);
    File file = multipart.getFile(Reel.CTR_FILE_COLUMN);
    reelMgr.updateReelData(content, basePath, file);
    redirect = request.getContextPath() + "/trampoline/" + "reels/reel_data.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("update_datasheet")) {
    CableTechData content = new CableTechData();
    content.setId(Integer.parseInt(multipart.getParameter(CableTechData.PARAM)));
    File file = multipart.getFile(CableTechData.DATA_SHEET_FILE_COLUMN);
    reelMgr.updateCableTechData(content, basePath, file);
    redirect = request.getContextPath() + "/trampoline/" + "reels/cable_data.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("update_conductor")) {
    CableTechData content = new CableTechData();
    content.setId(Integer.parseInt(request.getParameter(CableTechData.PARAM)));
    content.setConductorGroundSize(request.getParameter(CableTechData.CONDUCTOR_GROUND_SIZE_COLUMN));
    content.setConductorArea(Integer.parseInt(request.getParameter(CableTechData.CONDUCTOR_AREA_COLUMN)));
    reelMgr.updateCableTechData(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/cable_data.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("update_insulation")) {
    CableTechData content = new CableTechData();
    content.setId(Integer.parseInt(request.getParameter(CableTechData.PARAM)));
    content.setInsulationThickness(Integer.parseInt(request.getParameter(CableTechData.INSULATION_THICKNESS_COLUMN)));
    content.setInsulationCompound(request.getParameter(CableTechData.INSULATION_COMPOUND_COLUMN));
    content.setInsulationColor(request.getParameter(CableTechData.INSULATION_COLOR_COLUMN));
    reelMgr.updateCableTechData(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/cable_data.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("update_jacket")) {
    CableTechData content = new CableTechData();
    content.setId(Integer.parseInt(request.getParameter(CableTechData.PARAM)));
    content.setJacketThickness(Integer.parseInt(request.getParameter(CableTechData.JACKET_THICKNESS_COLUMN)));
    content.setJacketCompound(request.getParameter(CableTechData.JACKET_COMPOUND_COLUMN));
    content.setShieldType(request.getParameter(CableTechData.SHIELD_TYPE_COLUMN));
    reelMgr.updateCableTechData(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/cable_data.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("update_overall")) {
    CableTechData content = new CableTechData();
    content.setId(Integer.parseInt(request.getParameter(CableTechData.PARAM)));
    content.setOD(Double.parseDouble(request.getParameter(CableTechData.OD_COLUMN)));
    content.setWeight(Integer.parseInt(request.getParameter(CableTechData.WEIGHT_COLUMN)));
    content.setRadius(Double.parseDouble(request.getParameter(CableTechData.RADIUS_COLUMN)));
    content.setXSection(Double.parseDouble(request.getParameter(CableTechData.XSECTION_COLUMN)));
    content.setPullTension(Integer.parseInt(request.getParameter(CableTechData.PULL_TENSION_COLUMN)));
    reelMgr.updateCableTechData(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/cable_data.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("update")) {
    Reel content = new Reel();
    content.setId(contid);
    content.setStatus(request.getParameter(Reel.STATUS_COLUMN));
    content.setWharehouseLocation(request.getParameter(Reel.WHAREHOUSE_LOCATION_COLUMN));
    reelMgr.updateReel(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/edit.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("update_shipping")) {
    Reel content = new Reel();
    content.setId(contid);
    content.setCarrier(request.getParameter(Reel.CARRIER_COLUMN));
    content.setTrackingPRO(request.getParameter(Reel.TRACKING_PRO_COLUMN));
    content.setPackingList(request.getParameter(Reel.PACKING_LIST_COLUMN));
    if(request.getParameter(Reel.PROJECTED_SHIPPING_DATE_COLUMN)!=null && !request.getParameter(Reel.PROJECTED_SHIPPING_DATE_COLUMN).equals("")) {
        content.setProjectedShippingDateString(request.getParameter(Reel.PROJECTED_SHIPPING_DATE_COLUMN));
    }
    reelMgr.updateReelShippingInfo(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/edit.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("update_receiving")) {
    Reel content = new Reel();
    content.setId(contid);
    content.setReceivingIssue(request.getParameter(Reel.RECEIVING_ISSUE_COLUMN));
    content.setReceivingNote(request.getParameter(Reel.RECEIVING_NOTE_COLUMN));
    content.setReceivingDisposition(request.getParameter(Reel.RECEIVING_DISPOSITION_COLUMN));
    reelMgr.updateReelReceivingInfo(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/edit.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("update_quantity")) {
    Reel content = new Reel();
    content.setId(contid);
    content.setShippedQuantity(Integer.parseInt(request.getParameter(Reel.SHIPPED_QUANTITY_COLUMN)));
    content.setReceivedQuantity(Integer.parseInt(request.getParameter(Reel.RECEIVED_QUANTITY_COLUMN)));
    content.setTopFoot(Integer.parseInt(request.getParameter(Reel.TOP_FOOT_COLUMN)));
    reelMgr.updateReelQuantity(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/quantity.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("record_pull")) {
    Reel content = new Reel();
    content.setId(contid);
    content.setTempPullAmount(Integer.parseInt(request.getParameter("pulled_quantity")));
    content.setTopFoot(Integer.parseInt(request.getParameter(Reel.TOP_FOOT_COLUMN)));
    reelMgr.updateReelPull(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/quantity.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("add_circuit")) {
    ReelCircuit content = new ReelCircuit();
    content.setReelId(contid);
    content.setLength(Integer.parseInt(request.getParameter(ReelCircuit.LENGTH_COLUMN)));
    content.setName(request.getParameter(ReelCircuit.NAME_COLUMN));
    reelMgr.addReelCircuit(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/circuits.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("update_circuit")) {
    ReelCircuit content = new ReelCircuit();
    content.setId(Integer.parseInt(request.getParameter(ReelCircuit.PARAM)));
    if(request.getParameter(ReelCircuit.IS_PULLED_COLUMN)!=null) {
        content.setIsPulled("y");
    } else {
        content.setIsPulled("n");
    }
    reelMgr.updateReelCircuit(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/circuits.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("delete_circuit")) {
    ReelCircuit content = new ReelCircuit();
    content.setId(Integer.parseInt(request.getParameter(ReelCircuit.PARAM)));
    reelMgr.deleteReelCircuit(content,basePath);
    redirect = request.getContextPath() + "/trampoline/" + "reels/circuits.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("add_note")) {
    ReelNote note = new ReelNote();
    note.setReelId(contid);
    note.setNote(request.getParameter(ReelNote.NOTE_COLUMN));
    reelMgr.addReelNote(note);
    redirect = request.getContextPath() + "/trampoline/" + "reels/notes.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("add_issue")) {
    ReelIssue issue = new ReelIssue();
    issue.setReelId(contid);
    issue.setDescription(request.getParameter(ReelIssue.DESCRIPTION_COLUMN));
    issue.setIssueLog(request.getParameter(ReelIssue.ISSUE_LOG_COLUMN));
    reelMgr.addReelIssue(issue);
    redirect = request.getContextPath() + "/trampoline/" + "reels/issues.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("update_issue")) {
    ReelIssue issue = new ReelIssue();
    issue.setId(Integer.parseInt(request.getParameter(ReelIssue.PARAM)));
    if(request.getParameter(ReelIssue.IS_RESOLVED_COLUMN)!=null) {
        issue.setIsResolved("y");
    } else {
        issue.setIsResolved("n");
    }
    issue.setIssueLog(request.getParameter(ReelIssue.ISSUE_LOG_COLUMN));
    reelMgr.updateReelIssue(issue);
    redirect = request.getContextPath() + "/trampoline/" + "reels/issues.jsp?" + Reel.PARAM + "=" + contid ;
}
%>
<% dbResources.close(); %>
<notifier:set_message text="<%= notifier %>" />		
<admin:ajax_redirect redirect="<%= redirect %>" />