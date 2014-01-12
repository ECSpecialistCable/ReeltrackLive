<%@ page language="java" %>		
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr"/>
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" />
<% userLoginMgr.init(pageContext, dbResources); %>
<% reelMgr.init(pageContext,dbResources); %>

<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<%
int reelID = 0;
if(request.getParameter("id")!=null) {
    reelID = Integer.parseInt(request.getParameter("id"));
}
String tagType = "";
if(request.getParameter("type")!=null) {
    tagType = request.getParameter("type");
}
String jobCode = "";
if(request.getParameter("job")!=null) {
    jobCode = request.getParameter("job");
}

if(reelID!=0 && !tagType.equals("") && !jobCode.equals("")) {
	Reel content = new Reel();
	content.setId(reelID);
	content = (Reel)reelMgr.getReel(content);
	if(jobCode.equals(content.getJobCode())) {
		if(tagType.equals("RT")) {
			Reel rtReel = new Reel();
			rtReel.setId(reelID);
			rtReel.setJobCode(jobCode);
			session.setAttribute("RT",content);
		}
		if(tagType.equals("PL")) {
			Reel plReel = new Reel();
			plReel.setId(reelID);
			plReel.setJobCode(jobCode);
			session.setAttribute("PL",content);
		}
	} else {
		reelID=0;
	}
}

	boolean isIpad = false;
	String user_agent = request.getHeader("user-agent");
	if(user_agent.contains("iPad")) {
		isIpad = true;
		//session.setAttribute("ipad_user_id", user);
		int userId = 0;
		if(user!=null) {
			userId = user.getId();
		}

	   Cookie cookie = null;
	   Cookie[] cookies = null;
	   // Get an array of Cookies associated with this domain
	   cookies = request.getCookies();
	   if( cookies != null ){
		  for (int i = 0; i < cookies.length; i++){
			 cookie = cookies[i];
			 if((cookie.getName( )).compareTo("user_id") == 0 ){
				cookie.setMaxAge(0); // delete cookie if its already there
				cookie.setValue(String.valueOf(userId));
				response.addCookie(cookie); // re add it with new user id
			 } else {
				 Cookie iPadLoginUser = new Cookie("user_id", String.valueOf(userId));
				response.addCookie(iPadLoginUser);
			}
		  }
	  }		
	}
%>
<% dbResources.close(); %>

<c:remove var="flash" />

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1" />
        <meta http-equiv="imagetoolbar" content="no" />
        <title>
            <jsp:include page="common/includes/title.jsp" />
        </title>
        <!--<link rel="stylesheet" href="common/css/bootstrap.min.css" type="text/css" media="screen" charset="utf-8" />-->
        <link rel="stylesheet" href="common/css/structure.css" type="text/css" media="screen" charset="utf-8" />
        <link rel="stylesheet" href="common/css/style.css" type="text/css" media="screen" charset="utf-8" />
		<link rel="stylesheet" href="common/css/colorbox.css" type="text/css" media="screen" charset="utf-8" />
		<link rel="stylesheet" href="common/css/datePicker.css" type="text/css" media="screen" charset="utf-8" />

        <!--[if IE]>
			<link rel="stylesheet" href="common/css/ie.css" type="text/css" media="screen" charset="utf-8" />
        <![endif]-->    
        <!--[if IE 7]>
			<link rel="stylesheet" href="common/css/ie7.css" type="text/css" media="screen" charset="utf-8" />
        <![endif]-->    
        <!--[if IE 6]>
			<link rel="stylesheet" href="common/css/ie6.css" type="text/css" media="screen" charset="utf-8" />
		<![endif]-->	
        
        <link rel="stylesheet" href="common/css/client.css" type="text/css" media="screen" charset="utf-8" />

        


<!-- jquery first -->
<script src="common/js/jquery-1.4.2.min.js" type="text/javascript" charset="utf-8"></script>
<script src="common/js/jquery-ui.js" type="text/javascript" charset="utf-8"></script>

<!-- then standard modules for the admin -->
<script src="common/js/constants.jsp?busted=<%= (new java.util.Date()).getTime() %>" type="text/javascript" charset="utf-8"></script>
<script src="common/js/utils.js?busted=<%= (new java.util.Date()).getTime() %>" type="text/javascript" charset="utf-8"></script>
<script src="common/js/behaviors.js?busted=<%= (new java.util.Date()).getTime() %>" type="text/javascript" charset="utf-8"></script>
<script src="common/js/core.js?busted=<%= (new java.util.Date()).getTime() %>" type="text/javascript" charset="utf-8"></script>
<script src="common/js/form.js?busted=<%= (new java.util.Date()).getTime() %>" type="text/javascript" charset="utf-8"></script>
<script src="common/js/form_validation_utils.js?busted=<%= (new java.util.Date()).getTime() %>" type="text/javascript" charset="utf-8"></script>
<script src="common/js/notification.js?busted=<%= (new java.util.Date()).getTime() %>" type="text/javascript" charset="utf-8"></script>

<!-- then library modules -->
		
<script src="common/js/date_oldDATE_SAVE.js?busted=<%= (new java.util.Date()).getTime() %>" type="text/javascript" charset="utf-8"></script>
<script src="common/js/jquery.datePicker.js?busted=<%= (new java.util.Date()).getTime() %>" type="text/javascript" charset="utf-8"></script>
<script src="common/js/jquery.colorbox.js?busted=<%= (new java.util.Date()).getTime() %>" type="text/javascript" charset="utf-8"></script>

<!-- and finally, the admin.js -->
<script src="common/js/admin.js?busted=<%= (new java.util.Date()).getTime() %>" type="text/javascript" charset="utf-8"></script>

<!--<script src="common/js/bootstrap.min.js" type="text/javascript" charset="utf-8"></script>-->

    </head>
    <body id="outer" class=" yui-skin-sam">
    <div id="wayout">
        <div id="container">
            
            <div id="branding">
            </div>
            <div id="tabs_frame">
				<div id="tabs_mask">
		            <div id="tabs">
		                <!-- these load dynamically based on what modulaction is clicked -->
		            </div>
				</div>
				<div id="tab_arrows">
					<a href="#" id="tabs_arrow_left"><img src="common/images/tabArrowLeft.gif" width="17" height="20" alt="TabArrowLeft" border="0" /></a>
					<a href="#" id="tabs_arrow_right"><img src="common/images/tabArrowRight.gif" width="17" height="20" alt="TabArrowRight" border="0" /></a>

				</div>
			</div>
            
            <% if(!userLoginMgr.isLoggedIn()) { %>
                <%--
            	<div id="login">                
	                <form:begin_login name="login_form" action="common/includes/process_login.jsp" />
		                <form:row_begin />
			                <form:content_begin />
				                <form:label_inline name="<%= RTUser.USERNAME_COLUMN %>" label="Username:" />
								<form:textfield_inline name="<%= RTUser.USERNAME_COLUMN %>" pixelwidth="100" label="<%= RTUser.USERNAME_COLUMN %>" />
				                &nbsp;
								<form:label_inline name="<%= RTUser.PASSWORD_COLUMN %>" label="Password:" />
				                <form:password_inline name="<%= RTUser.PASSWORD_COLUMN %>" pixelwidth="100" label="<%= RTUser.PASSWORD_COLUMN %>" />		
				                &nbsp;
			                <form:content_end />
							<form:buttonset_begin align="right" padding="0" />
			                	<form:submit_inline button="login" waiting="true" name="login" action="login" />
			                <form:buttonset_end />
		                <form:row_end />
	                <form:end />
	            </div>
                 --%>  
            <% } else { %>				
				<% String welcomeStr = "Welcome, " + user.getUsername(); %>
           		<admin:welcome_tab text="<%= welcomeStr %>" action="common/includes/process_login.jsp?submit_action=logout"  valign="top" align="left" />                               
            <% } %>
            
            <div id="modules">
                <%--<c:if test="<%= userLoginMgr.isLoggedIn() %>">--%> 		
                    <!-- @option: uncomment the elements above and below the jsp:include  -->
                    <!-- <form action="" method="get" id="moduleform">           -->
                    <!-- <select name="moduleselector" id="moduleselector">              -->
                    <!-- <option value="">Choose a Module:</option>              -->
                    <jsp:include page="common/interface/modules.jsp" />
                    <!-- </select> -->
                    <!-- </form> -->
                    <div id="moduleactions">
                        <!-- this is populated by javascript when a module is selected -->			
                        <!-- actions are dynamically pulled from <modulename>/moduleaction.html -->			
                    </div>
                    
                <%--</c:if>--%> 						
                
            </div>
            
            
            <div id="main">
                <!-- main content area is populated dynamically based on what moduleaction is clicked -->
                <% if(reelID==0) { %>
                    <jsp:include page="common/includes/login.jsp" />
                <% } else { %>
                    <% String tempURL = "reels/status.jsp?" +  Reel.PARAM + "=" + reelID; %>
                    <script language="javascript">
                    CORE.loadPage("<%= tempURL %>");
                    </script>
                <% } %>

            </div>
            
        </div>	
		<div id="invisible" style="display: none;">
		</div>
		<br /><br />
	</div>
    </body>
</html>
