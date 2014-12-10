<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.monumental.trampoline.utilities.forms.multipart.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.reeltrack.drivers.*" %>
<%@ page import="java.util.Hashtable"%>
<%@ page import="com.reeltrack.picklists.*" %>
<%@ page import="com.reeltrack.customers.Customer"%>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>"
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>

<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" scope="request"/>
<jsp:useBean id="picklistMgr" class="com.reeltrack.picklists.PickListMgr" scope="request"/>
<% userLoginMgr.init(pageContext); %>
<% securityMgr.init(dbResources); %>
<% picklistMgr.init(pageContext,dbResources); %>
<% reelMgr.init(pageContext,dbResources); %>
<% CompProperties props = new CompProperties(); %>

<%
RTUser user = (RTUser)userLoginMgr.getUser();
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

if(action.equals("mark_shipped")) {
    Reel content = new Reel();
    content.setId(contid);
    content.setShippedQuantity(Integer.parseInt(request.getParameter(Reel.SHIPPED_QUANTITY_COLUMN)));
    content.setCarrier(request.getParameter(Reel.CARRIER_COLUMN));
	if(!request.getParameter("other_carrier").equals("")) {
		content.setCarrier(request.getParameter("other_carrier"));
	}
    content.setTrackingPRO(request.getParameter(Reel.TRACKING_PRO_COLUMN));
    content.setPackingList(request.getParameter(Reel.PACKING_LIST_COLUMN));
    if(request.getParameter(Reel.PROJECTED_SHIPPING_DATE_COLUMN)!=null && !request.getParameter(Reel.PROJECTED_SHIPPING_DATE_COLUMN).equals("")) {
        content.setProjectedShippingDateString(request.getParameter(Reel.PROJECTED_SHIPPING_DATE_COLUMN));
    }
    if(request.getParameter(Reel.SHIPPING_DATE_COLUMN)!=null && !request.getParameter(Reel.SHIPPING_DATE_COLUMN).equals("")) {
        content.setShippingDateString(request.getParameter(Reel.SHIPPING_DATE_COLUMN));
    }
    reelMgr.markReelShipped(content);
    session.removeAttribute("RT");
    session.removeAttribute("PL");
    redirect = request.getContextPath() + "/trampoline/" + "reels/status.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("mark_received")) {
    Reel content = new Reel();
    content.setId(contid);
	Reel reel = reelMgr.getReel(content);
    content.setTrackingPRO(request.getParameter(Reel.TRACKING_PRO_COLUMN));
    content.setPackingList(request.getParameter(Reel.PACKING_LIST_COLUMN));
    content.setSteelReelSerial(request.getParameter(Reel.STEEL_REEL_SERIAL_COLUMN));
    try {
    content.setShippedQuantity(Integer.parseInt(request.getParameter(Reel.SHIPPED_QUANTITY_COLUMN)));
    } catch(Exception e) {}
    try {
    content.setReceivedQuantity(Integer.parseInt(request.getParameter(Reel.RECEIVED_QUANTITY_COLUMN)));
    } catch(Exception e) {}
    try {
    content.setOrigTopFoot(Integer.parseInt(request.getParameter(Reel.ORIG_TOP_FOOT_COLUMN)));
    } catch(Exception e) {}
    try {
    content.setReceivedWeight(Integer.parseInt(request.getParameter(Reel.RECEIVED_WEIGHT_COLUMN)));
    } catch(Exception e) {}
    
    content.setWharehouseLocation(request.getParameter(Reel.WHAREHOUSE_LOCATION_COLUMN));
    content.setReceivingIssue(request.getParameter(Reel.RECEIVING_ISSUE_COLUMN));
    content.setReceivingNote(request.getParameter(Reel.RECEIVING_NOTE_COLUMN));
    content.setReceivingDisposition(request.getParameter(Reel.RECEIVING_DISPOSITION_COLUMN));
    if(content.getReceivingDisposition().equalsIgnoreCase(Reel.RECEIVING_DISPOSITION_REFUSED) && request.getParameter("refused_check")==null) {

    } else {
    	if(content.getReceivingDisposition().equalsIgnoreCase(Reel.RECEIVING_DISPOSITION_REFUSED)) {
    		Customer customer = reelMgr.getCustomerForReel(reel);
    		String issueLog = reel.getEcsPN() + " manufactured by " + reel.getManufacturer()  + " on ECS PO " + reel.getOrdNo() + " with reel tag " + reel.getReelTag();
    		issueLog += "Customer Reel ID# " + reel.getCrId() + " - " + reel.getCableDescription() + " with reel tag " + reel.getReelTag() + " was refused by " + user.getFname() + " " + user.getLname() + " with " + customer.getName() + " on " + user.getJobName() + " Project - " + user.getJobCode();

    		ReelIssue issue = new ReelIssue();
    		issue.setReelId(contid);
    		issue.setDescription(content.getReceivingNote());
    		issue.setIssueLog(issueLog);
    		reelMgr.addReelIssue(issue);
    	}

        reelMgr.markReelReceived(content);
        session.removeAttribute("RT");
        session.removeAttribute("PL");
    }
    
    redirect = request.getContextPath() + "/trampoline/" + "reels/status.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("mark_staged")) {
    Reel content = new Reel();
    content.setId(Integer.parseInt(request.getParameter(Reel.PARAM)));
	Reel prevContent = reelMgr.getReel(content);
    try {
        content.setTopFoot(Integer.parseInt(request.getParameter(Reel.TOP_FOOT_COLUMN)));
    } catch(Exception e) {}
    try {
        content.setCurrentWeight(Integer.parseInt(request.getParameter(Reel.CURRENT_WEIGHT_COLUMN)));
    } catch(Exception e) {}
    reelMgr.markReelStaged(content);

    if(request.getParameter(PickList.PARAM)!=null) {
        PickList picklist = new PickList();
		int picklistId = Integer.parseInt(request.getParameter(PickList.PARAM));
		picklist.setDriver(request.getParameter(PickList.DRIVER_COLUMN));
		picklist.setForeman(request.getParameter(PickList.FOREMAN_COLUMN));
		if(picklistId!=0) {
			picklist.setId(picklistId);			
			picklistMgr.updatePickList(picklist);
		} else {
			picklist.setName(prevContent.getReelTag());
			picklistId = picklistMgr.addPickList(picklist);
			content = new Reel();
			content.setId(Integer.parseInt(request.getParameter(Reel.PARAM)));
			content.setPickListId(picklistId);
			picklistMgr.updateReelForPickList(content);
		}

    }
    
    session.removeAttribute("RT");
    session.removeAttribute("PL");
    redirect = request.getContextPath() + "/trampoline/" + "reels/status.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("mark_checkedout")) {
    Reel content = new Reel();
    content.setId(Integer.parseInt(request.getParameter(Reel.PARAM)));
	Reel prevContent = reelMgr.getReel(content);
    try {
        content.setTopFoot(Integer.parseInt(request.getParameter(Reel.TOP_FOOT_COLUMN)));
    } catch(Exception e) {}
    try {
        content.setCurrentWeight(Integer.parseInt(request.getParameter(Reel.CURRENT_WEIGHT_COLUMN)));
    } catch(Exception e) {}
    reelMgr.markReelCheckedOut(content);

    if(request.getParameter(PickList.PARAM)!=null) {
        PickList picklist = new PickList();
		int picklistId = Integer.parseInt(request.getParameter(PickList.PARAM));
		picklist.setDriver(request.getParameter(PickList.DRIVER_COLUMN));
		picklist.setForeman(request.getParameter(PickList.FOREMAN_COLUMN));
		if(picklistId!=0) {
			picklist.setId(picklistId);
			picklistMgr.updatePickList(picklist);
		} else {
			picklist.setName(prevContent.getReelTag());
			picklistId = picklistMgr.addPickList(picklist);
			content = new Reel();
			content.setId(Integer.parseInt(request.getParameter(Reel.PARAM)));
			content.setPickListId(picklistId);
			picklistMgr.updateReelForPickList(content);
		}

    }

    session.removeAttribute("RT");
    session.removeAttribute("PL");
    redirect = request.getContextPath() + "/trampoline/" + "reels/status.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("mark_checkedin")) {
    Reel content = new Reel();
    content.setId(contid);
    try {
        content.setTopFoot(Integer.parseInt(request.getParameter(Reel.TOP_FOOT_COLUMN)));
    } catch(Exception e) {}
    try {
        content.setCurrentWeight(Integer.parseInt(request.getParameter(Reel.CURRENT_WEIGHT_COLUMN)));
    } catch(Exception e) {}
    content.setWharehouseLocation(request.getParameter(Reel.WHAREHOUSE_LOCATION_COLUMN));
    String driver = request.getParameter(Driver.PARAM);
    reelMgr.markReelCheckedIn(content,driver);
    session.removeAttribute("RT");
    session.removeAttribute("PL");
    redirect = request.getContextPath() + "/trampoline/" + "reels/status.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("mark_complete")) {
    Reel content = new Reel();
    content.setId(contid);
    reelMgr.markReelComplete(content);
    session.removeAttribute("RT");
    session.removeAttribute("PL");
    redirect = request.getContextPath() + "/trampoline/" + "reels/status.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("mark_scrapped")) {
    Reel content = new Reel();
    content.setId(contid);
    reelMgr.markReelScrapped(content);
    session.removeAttribute("RT");
    session.removeAttribute("PL");
    redirect = request.getContextPath() + "/trampoline/" + "reels/status.jsp?" + Reel.PARAM + "=" + contid ;
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

if(action.equals("delete_ctr")) {
    Reel content = new Reel();
    content.setId(contid);
    content.setCTRFile("");
    reelMgr.updateReel(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/reel_data.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("update_datasheet")) {
    CableTechData content = new CableTechData();
    content.setId(Integer.parseInt(multipart.getParameter(CableTechData.PARAM)));
    File file = multipart.getFile(CableTechData.DATA_SHEET_FILE_COLUMN);
    reelMgr.updateCableTechData(content, basePath, file);
    redirect = request.getContextPath() + "/trampoline/" + "reels/cable_data.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("delete_datasheet")) {
    CableTechData content = new CableTechData();
    content.setId(Integer.parseInt(request.getParameter(CableTechData.PARAM)));
    content.setDataSheetFile("");
    reelMgr.updateCableTechData(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/cable_data.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("update_conductor")) {
    CableTechData content = new CableTechData();
    content.setId(Integer.parseInt(request.getParameter(CableTechData.PARAM)));
    content.setConductorGroundSize(request.getParameter(CableTechData.CONDUCTOR_GROUND_SIZE_COLUMN));
    content.setConductorArea(Integer.parseInt(request.getParameter(CableTechData.CONDUCTOR_AREA_COLUMN)));
    content.setConAlWeight(Integer.parseInt(request.getParameter(CableTechData.CON_AL_WEIGHT_COLUMN)));
    content.setConCuWeight(Integer.parseInt(request.getParameter(CableTechData.CON_CU_WEIGHT_COLUMN)));
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
    if(!request.getParameter(CableTechData.RADIUS_COLUMN).equals("N/A")) {
        try {
        content.setRadius(Double.parseDouble(request.getParameter(CableTechData.RADIUS_COLUMN)));
        } catch(Exception e) {}
    }
    content.setXSection(Double.parseDouble(request.getParameter(CableTechData.XSECTION_COLUMN)));
    content.setPullTension(Integer.parseInt(request.getParameter(CableTechData.PULL_TENSION_COLUMN)));
    reelMgr.updateCableTechData(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/cable_data.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("update")) {
    Reel content = new Reel();
    content.setId(contid);
	Reel prevContent = reelMgr.getReel(content);
    if(request.getParameter(Reel.STATUS_COLUMN)!=null) {
        content.setStatus(request.getParameter(Reel.STATUS_COLUMN));
    }
    content.setWharehouseLocation(request.getParameter(Reel.WHAREHOUSE_LOCATION_COLUMN));
    if(request.getParameter(Reel.HAS_REEL_MARKERS_COLUMN)!=null) {
        content.setHasReelMarkers(request.getParameter(Reel.HAS_REEL_MARKERS_COLUMN));
    }
    if(request.getParameter(Reel.REEL_TAG_COLUMN)!=null) {
        String newRT = request.getParameter(Reel.REEL_TAG_COLUMN);
		if(!prevContent.getReelTag().equalsIgnoreCase(newRT)) {
			reelMgr.addReelLog(prevContent, user.getName() + " changed the reeltag from " + prevContent.getReelTag() + " to " + newRT);
		}
		content.setReelTag(request.getParameter(Reel.REEL_TAG_COLUMN));
    }
    if(request.getParameter(Reel.CABLE_DESCRIPTION_COLUMN)!=null) {
        content.setCableDescription(request.getParameter(Reel.CABLE_DESCRIPTION_COLUMN));
    }
    if(request.getParameter(Reel.CUSTOMER_PN_COLUMN)!=null) {
        content.setCustomerPN(request.getParameter(Reel.CUSTOMER_PN_COLUMN));
    }
    if(request.getParameter(Reel.MANUFACTURER_COLUMN)!=null) {
        content.setManufacturer(request.getParameter(Reel.MANUFACTURER_COLUMN));
    }

    /*
    if(request.getParameter(Reel.BOTTOM_FOOT_COLUMN)!=null) {
        content.setBottomFoot(Integer.parseInt(request.getParameter(Reel.BOTTOM_FOOT_COLUMN)));
        if(request.getParameter(Reel.BOTTOM_FOOT_NOT_VISIBLE_COLUMN)!=null) {
            content.setBottomFootNotVisible("y");
        } else {
            content.setBottomFootNotVisible("n");
        }
        if(content.getBottomFoot()>0) {
            content.setHasReelMarkers("y");
            content.setBottomFootNotVisible("n");
        }
    }
    */
    if(request.getParameter(Reel.ORIG_TOP_FOOT_COLUMN)!=null) {
        content.setOrigTopFoot(Integer.parseInt(request.getParameter(Reel.ORIG_TOP_FOOT_COLUMN)));
    }

    if(request.getParameter(Reel.TOP_FOOT_COLUMN)!=null) {
        content.setTopFoot(Integer.parseInt(request.getParameter(Reel.TOP_FOOT_COLUMN)));
    }

    /*
    if(content.getTopFoot()>0 || content.getBottomFoot()>0) {
        content.setHasReelMarkers("y");
    }
    */
    content.setSteelReelSerial(request.getParameter(Reel.STEEL_REEL_SERIAL_COLUMN));
    reelMgr.updateReel(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/edit.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("update_reel_invoice")) {
    Reel content = new Reel();
    content.setId(contid);
    content.setInvoiceNum(request.getParameter(Reel.INVOICE_NUM_COLUMN));
    if(request.getParameter(Reel.INVOICE_DATE_COLUMN)!=null && !request.getParameter(Reel.INVOICE_DATE_COLUMN).equals("")) {
        content.setInvoiceDateString(request.getParameter(Reel.INVOICE_DATE_COLUMN));
    }
    content.setCustomerPO(request.getParameter(Reel.CUSTOMER_PO_COLUMN));
    reelMgr.updateReel(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/reel_data.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("update_shipping")) {
    Reel content = new Reel();
    content.setId(contid);
    content.setCarrier(request.getParameter(Reel.CARRIER_COLUMN));
	if(!request.getParameter("other_carrier").equals("")) {
		content.setCarrier(request.getParameter("other_carrier"));
	}
    content.setTrackingPRO(request.getParameter(Reel.TRACKING_PRO_COLUMN));
    content.setPackingList(request.getParameter(Reel.PACKING_LIST_COLUMN));
    if(request.getParameter(Reel.PROJECTED_SHIPPING_DATE_COLUMN)!=null && !request.getParameter(Reel.PROJECTED_SHIPPING_DATE_COLUMN).equals("")) {
        content.setProjectedShippingDateString(request.getParameter(Reel.PROJECTED_SHIPPING_DATE_COLUMN));
    }
    if(request.getParameter(Reel.SHIPPING_DATE_COLUMN)!=null && !request.getParameter(Reel.SHIPPING_DATE_COLUMN).equals("")) {
        content.setShippingDateString(request.getParameter(Reel.SHIPPING_DATE_COLUMN));
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
    //content.setShippedQuantity(Integer.parseInt(request.getParameter(Reel.SHIPPED_QUANTITY_COLUMN)));
    content.setReceivedQuantity(Integer.parseInt(request.getParameter(Reel.RECEIVED_QUANTITY_COLUMN)));
    //content.setTopFoot(Integer.parseInt(request.getParameter(Reel.TOP_FOOT_COLUMN)));
     if(request.getParameter(Reel.BOTTOM_FOOT_COLUMN)!=null) {
        content.setBottomFoot(Integer.parseInt(request.getParameter(Reel.BOTTOM_FOOT_COLUMN)));
        if(request.getParameter(Reel.BOTTOM_FOOT_NOT_VISIBLE_COLUMN)!=null) {
            content.setBottomFootNotVisible("y");
        } else {
            content.setBottomFootNotVisible("n");
        }
        if(content.getBottomFoot()>0) {
            content.setHasReelMarkers("y");
            content.setBottomFootNotVisible("n");
        }
    }   
    
    reelMgr.updateReelQuantity(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/quantity.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("record_pull")) {
    Reel content = new Reel();
    content.setId(contid);
    content.setTempPullAmount(Integer.parseInt(request.getParameter("pulled_quantity")));
    reelMgr.updateReelPull(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/quantity.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("record_top_marker")) {
    Reel content = new Reel();
    content.setId(contid);
    content.setTopFoot(Integer.parseInt(request.getParameter(Reel.TOP_FOOT_COLUMN)));
    reelMgr.updateReelTop(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/quantity.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("record_weight")) {
    Reel content = new Reel();
    content.setId(contid);
    content.setCurrentWeight(Integer.parseInt(request.getParameter("current_weight")));
    reelMgr.updateReelWeight(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/quantity.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("import_circuits")) {
	File file = multipart.getFile("ctr_imported_file");
	if(file!=null) {
		try {
			CircuitReader reader = new CircuitReader();
			Hashtable contents = reader.getContents(file);
			reelMgr.addReelCircuits(contents, contid);
		} catch(Exception e) {e.printStackTrace();}
	}
    redirect = request.getContextPath() + "/trampoline/" + "reels/circuits.jsp?" + Reel.PARAM + "=" + contid ;
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
    if(request.getParameter(ReelCircuit.LENGTH_COLUMN)!=null) {
        content.setLength(Integer.parseInt(request.getParameter(ReelCircuit.LENGTH_COLUMN)));
    }
    if(request.getParameter(ReelCircuit.ACT_LENGTH_COLUMN)!=null) {
        content.setActLength(Integer.parseInt(request.getParameter(ReelCircuit.ACT_LENGTH_COLUMN)));
        if(request.getParameter(ReelCircuit.IS_PULLED_COLUMN)!=null) {
            content.setIsPulled("y");
        } else {
            content.setIsPulled("n");
        }
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

if(action.equals("delete_unpulled_circuits")) {
    Reel content = new Reel();
    content.setId(contid);
    reelMgr.deleteUnpulledCircuits(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/circuits.jsp?" + Reel.PARAM + "=" + contid ;
}

if(action.equals("add_note")) {
    ReelNote note = new ReelNote();
    note.setReelId(contid);
    note.setNote(request.getParameter(ReelNote.NOTE_COLUMN));
    boolean send_note = false;
    if(request.getParameter("send_note")!=null) {
        send_note = true;
    }

    reelMgr.addReelNote(note,send_note);
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

if(action.equals("delete_reel")) {
    Reel content = new Reel();
    content.setId(contid);
	Reel toRemove = reelMgr.getReel(content);
    content.setPickListId(0);
    picklistMgr.updateReelForPickList(content, toRemove);
	reelMgr.deleteReel(content, basePath);

    redirect = request.getContextPath() + "/trampoline/" + "reels/search.jsp";
}

if(action.equals("update_unique_id")) {
	Reel content = new Reel();
    content.setId(contid);
	content.setUniqueId(Integer.parseInt(request.getParameter(Reel.UNIQUE_ID_COLUMN)));
	reelMgr.updateReel(content);
    redirect = request.getContextPath() + "/trampoline/" + "reels/reel_data.jsp?" + Reel.PARAM + "=" + contid ;
}
%>
<% dbResources.close(); %>
<notifier:set_message text="<%= notifier %>" />		
<admin:ajax_redirect redirect="<%= redirect %>" />