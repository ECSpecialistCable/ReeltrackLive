<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Enumeration"%>
<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.monumental.trampoline.security.*" %>
<%@ page import="com.reeltrack.picklists.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.foremans.*" %>
<%@ page import="com.reeltrack.reels.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<jsp:useBean id="picklistMgr" class="com.reeltrack.picklists.PickListMgr" />
<jsp:useBean id="foremanMgr" class="com.reeltrack.foremans.ForemanMgr" scope="request"/>

<% userLoginMgr.init(pageContext); %>
<% picklistMgr.init(pageContext,dbResources); %>
<% foremanMgr.init(pageContext,dbResources); %>
<% 
RTUser user = (RTUser)userLoginMgr.getUser();

int howMany = 25;
int pageNdx = 1;
if(request.getParameter("pageIdx") != null) {
    pageNdx = Integer.parseInt(request.getParameter("pageIdx"));
}

int skip = (pageNdx-1) * howMany;
if(request.getParameter("skip") != null) {
    skip = Integer.parseInt(request.getParameter("skip"));
}

PickList content = new PickList();
Reel reel = new Reel();
ReelCircuit circuit = new ReelCircuit();
if(session.getAttribute("pick_lists_search")!=null) {
    content = (PickList)session.getAttribute("pick_lists_search");
}
if(session.getAttribute("pick_lists_search_reel")!=null) {
    reel = (Reel)session.getAttribute("pick_lists_search_reel");
}
if(session.getAttribute("pick_lists_search_circuit")!=null) {
    circuit = (ReelCircuit)session.getAttribute("pick_lists_search_circuit");
}

if(request.getParameter(PickList.ID_COLUMN) != null) {
	if(!request.getParameter(PickList.ID_COLUMN).equals("")) {
		content.setId(Integer.parseInt(request.getParameter(PickList.ID_COLUMN)));
	} else {
		content.getData().removeValue(PickList.ID_COLUMN);
	}
}

if(request.getParameter(PickList.FOREMAN_COLUMN) != null) {  
    content.setForeman(request.getParameter(PickList.FOREMAN_COLUMN)); 
}

if(request.getParameter(Reel.REEL_TAG_COLUMN) != null) {  
    reel.setReelTag(request.getParameter(Reel.REEL_TAG_COLUMN));
    reel.setSearchOp(Reel.REEL_TAG_COLUMN, Reel.TRUE_PARTIAL); 
}

if(request.getParameter(Reel.CABLE_DESCRIPTION_COLUMN) != null) {  
    reel.setCableDescription(request.getParameter(Reel.CABLE_DESCRIPTION_COLUMN));
    reel.setSearchOp(Reel.CABLE_DESCRIPTION_COLUMN, Reel.TRUE_PARTIAL); 
}

if(request.getParameter(Reel.CUSTOMER_PN_COLUMN) != null) {  
    reel.setCustomerPN(request.getParameter(Reel.CUSTOMER_PN_COLUMN));
    reel.setSearchOp(Reel.CUSTOMER_PN_COLUMN, Reel.PARTIAL); 
}

if(request.getParameter(ReelCircuit.PARAM) != null) {  
    circuit.setId(Integer.parseInt(request.getParameter(ReelCircuit.PARAM)));
}

if(request.getParameter(Reel.CR_ID_COLUMN) != null) {
    if(request.getParameter(Reel.CR_ID_COLUMN).equals("")) {
        reel.getData().removeValue(Reel.CR_ID_COLUMN);
    } else {
        reel.setCrId(Integer.parseInt(request.getParameter(Reel.CR_ID_COLUMN)));
        reel.setSearchOp(Reel.CR_ID_COLUMN, Reel.EQ);
    }
}

session.setAttribute("pick_lists_search",content);
session.setAttribute("pick_lists_search_reel",reel);
session.setAttribute("pick_lists_search_circuit",circuit);

CompEntities contents = picklistMgr.getPickLists(content, reel, circuit);

Foreman foreman = new Foreman();
foreman.setCustomerId(user.getCustomerId());
CompEntities foremans = foremanMgr.searchForeman(foreman, Foreman.NAME_COLUMN, true);

CompEntities circuits = picklistMgr.getReelCircuits();

boolean dosearch = true;
String tempURL = "";
%>

<% dbResources.close(); %>
<html:begin />
<admin:title text="Pick Lists" />

<admin:subtitle text="Filter Pick Lists" />
    <admin:box_begin />
    <form:begin_selfsubmit name="search" action="pick_lists/search.jsp" />
        <% 
        if(content.getId()!=0) {
            tempURL = new Integer(content.getId()).toString();
        } else {
            tempURL = "";
        }
        %>
        <form:textfield pixelwidth="40" label="ID:" name="<%= PickList.ID_COLUMN %>" value="<%= tempURL %>" />
        <% if(reel.getCrId()!=0) { %>
			<form:textfield label="CRID #:" name="<%= Reel.CR_ID_COLUMN %>" value="<%= reel.getCrId() + "" %>" />
		<% } else { %>
			<form:textfield label="CRID #:" name="<%= Reel.CR_ID_COLUMN %>" value="<%= "" %>" />
		<% } %>
		<form:textfield label="Reel Tag:" name="<%= Reel.REEL_TAG_COLUMN %>" value="<%= reel.getReelTag() %>" />
        <form:textfield label="Description:" name="<%= Reel.CABLE_DESCRIPTION_COLUMN %>" value="<%= reel.getCableDescription() %>" />
        <% tempURL = user.getCustomerName() + " P/N:"; %>
        <form:textfield label="<%= tempURL %>" name="<%= Reel.CUSTOMER_PN_COLUMN %>" value="<%= reel.getCustomerPN() %>" />
        <form:row_begin />
            <form:label name="" label="Circuit:" />
            <form:content_begin />
            <form:select_begin name="<%= ReelCircuit.PARAM %>" />
                <form:option name="Any" value="0" match="<%= new Integer(circuit.getId()).toString() %>" />
                <% for(int c=0; c<circuits.howMany(); c++) { %>
                    <% ReelCircuit tmpCircuit = (ReelCircuit)circuits.get(c); %>
                    <form:option name="<%= tmpCircuit.getName() %>" value="<%= new Integer(tmpCircuit.getId()).toString() %>" match="<%= new Integer(circuit.getId()).toString() %>" />
                <% } %>
            <form:select_end />
            <form:content_end />
        <form:row_end />
        <form:row_begin />
            <form:label name="" label="Foreman:" />
            <form:content_begin />
            <form:select_begin name="<%= PickList.FOREMAN_COLUMN %>" />
                <form:option name="Any" value="" match="<%= content.getForeman() %>" />
                <% for(int f=0; f<foremans.howMany(); f++) { %>
                    <% foreman = (Foreman)foremans.get(f); %>
                    <form:option name="<%= foreman.getName() %>" value="<%= foreman.getName() %>" match="<%= content.getForeman() %>" />
                <% } %>
            <form:select_end />
            <form:content_end />
        <form:row_end />
        <form:row_begin />
            <form:label name="" label="" />
            <form:buttonset_begin align="left" padding="0"/>
                <form:submit_inline button="submit" waiting="true" name="search" action="test" />
            <form:buttonset_end />
        <form:row_end />
    <form:end />
<admin:box_end />

<% if(dosearch) { %>
    <% if(contents.howMany() > 0) { %>
        <%--
        <admin:search_listing_pagination text="Pick Lists" url="reels/search.jsp" 
                    pageIndex="<%= new Integer(pageNdx).toString() %>"
                    column="<%= column %>"
                    ascending="<%= new Boolean(ascending).toString() %>"
                    howMany="<%= new Integer(howMany).toString() %>"
                    skip="<%= new Integer(skip).toString() %>"      
                    count="<%= new Integer(count).toString() %>"
                    search_params=""
                />
        --%>
    <admin:box_begin color="false" />
   
    <listing:begin />
        <listing:header_begin />
            <listing:header_cell width="75" first="true" name="Created" />
            <listing:header_cell name="Name" />
            <listing:header_cell width="150" name="Foreman" />
            <listing:header_cell width="50" name="Reels" />
            <listing:header_cell width="100" name="Status" />
            <listing:header_cell width="100" name=""  />
        <listing:header_end />
        <% for(int i=0; i<contents.howMany(); i++) { %>
        <% content = (PickList)contents.get(i); %>
        <listing:row_begin row="<%= new Integer(i).toString() %>" />
            <listing:cell_begin />
                <%= content.getCreatedDateText() %>
            <listing:cell_end />
            <listing:cell_begin />
                <%= content.getName() %>
            <listing:cell_end />
            <listing:cell_begin />
                <%= content.getForeman() %>
            <listing:cell_end />
            <listing:cell_begin />
                <%
                CompEntities reels = content.getCompEntities(Reel.PARAM);
                int total = 0;
                int staged = 0;
                int checkedout = 0;
                if(reels!=null) {
                    for(int y=0; y<reels.howMany();y++) {
                        Reel reelnum = (Reel)reels.get(y);
                        total++;
                        if(reelnum.getStatus().equals(Reel.STATUS_STAGED)) staged++;
                        if(reelnum.getStatus().equals(Reel.STATUS_CHECKED_OUT)) checkedout++;
                    }
                }
                %>
                <% tempURL = new Integer(total).toString() + "/" + new Integer(staged).toString() + "/" + new Integer(checkedout).toString(); %>
                <%= tempURL %>
            <listing:cell_end />
            <listing:cell_begin />
                <%= content.getStatus() %>
            <listing:cell_end />
            <listing:cell_begin align="right"/>
                <% tempURL = "pick_lists/edit.jsp?" +  PickList.PARAM + "=" + content.getId(); %>
                <form:linkbutton url="<%= tempURL %>" name="EDIT" />
                <%--
                <% tempURL = "pick_lists/process.jsp?submit_action=print&" + PickList.PARAM + "=" + content.getId(); %>
                <form:linkbutton url="<%= tempURL %>" process="true" name="PRINT" />
                --%>
                <% tempURL = "pick_lists/picklist.jsp?" + PickList.PARAM + "=" + content.getId(); %>
                <%--<a href="<%= tempURL %>" target="_new">PRINT</a>--%>
                <form:linkbutton url="<%= tempURL %>" name="PRINT" newtab="true" />
            <listing:cell_end />
        <listing:row_end />
        <% } %>
    <listing:end />
    <admin:box_end />
    <% } else { %>
    <admin:subtitle text="No Pick Lists Found." />
    <% } %>
<% } %>

<admin:set_tabset url="pick_lists/_tabset_default.jsp" thispage="search.jsp" />
<html:end />    