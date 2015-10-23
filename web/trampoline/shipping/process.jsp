<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" scope="request"/>
<% securityMgr.init(dbResources); %>
<% reelMgr.init(pageContext,dbResources); %>
<% CompProperties props = new CompProperties(); %>

<% 
String basePath = pageContext.getServletContext().getRealPath("/");
String notifier = "";
String redirect = request.getHeader("referer");
String action = "";
if(request.getParameter("submit_action") != null) {
    action = request.getParameter("submit_action");
}

int contid = 0;
if(request.getParameter(Reel.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(Reel.PARAM));
}

if(action.equals("mark_shipped")) {
    Reel content = new Reel();
    content.setId(contid);
    if(request.getParameter("ordered_to_shipping")!=null) {
        content.setShippedQuantity(Integer.parseInt(request.getParameter(Reel.ORDERED_QUANTITY_COLUMN)));
    } else {
        content.setShippedQuantity(Integer.parseInt(request.getParameter(Reel.SHIPPED_QUANTITY_COLUMN)));
    }
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
    //redirect = request.getContextPath() + "/trampoline/" + "shipping/search.jsp";
    redirect = "/trampoline/reeltags/reeltag.jsp?" + Reel.PARAM + "=" + content.getId();
}
%>
<% dbResources.close(); %>
<notifier:set_message text="<%= notifier %>" />		
<admin:ajax_redirect redirect="<%= redirect %>" />