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

boolean checkedout = false;
boolean circuits = false;
if(reelID!=0 && !tagType.equals("") && !jobCode.equals("")) {
	Reel content = new Reel();
	content.setId(reelID);
	content = (Reel)reelMgr.getReel(content);
	if(jobCode.equals(content.getJobCode())) {
		if(tagType.equals("RT")) {
			Reel rtReel = new Reel();
			rtReel.setId(reelID);
			rtReel.setJobCode(jobCode);
      if(content.getStatus().equals(Reel.STATUS_CHECKED_OUT)) {
        checkedout = true;
        if(content.getReelType().equals(Reel.REEL_TYPE_CIRCUIT)) {
          circuits = true;
        }
      }
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

<!DOCTYPE html>
<html>
<head>
  <title>ECS ReelTrack</title>
  <link rel="icon" type="image/png" href="myicon.png">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <!-- Bootstrap -->
  <link href="interface/css/bootstrap.css" rel="stylesheet">
  <link href="interface/css/bootstrap-datetimepicker.min.css" rel="stylesheet">
  <link href="interface/css/bootstrap-dialog.css" rel="stylesheet">
  <link href="interface/css/tramp.css" rel="stylesheet">



  <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
  <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
      <![endif]-->
    </head>
    <body>

      <div class="container" style="">

        <!-- HEADER ROW START -->
        <div class="row tramp_header">
          <div id="headerContent" class="col-md-12" style="height:85px;background-image: url('interface/images/header1.png');padding:0px;width:100%;border-top-left-radius:5px;border-top-right-radius:5px;">
            <!-- class="img-rounded" -->
            <%--<img src="interface/images/header1.png" style="width:100%;border-top-left-radius:5px;border-top-right-radius:5px;"/>--%>


          </div>
        </div>
        <!-- HEADER ROW END -->

<!--@media (max-width: 767px) {-->
        <!-- NAV ROW START -->
        <div class="row" style="background:white;">
          <div class="col-md-12" style="padding:0px;">
            <nav id="navContent" class="navbar navbar-inverse tramp_nav_bar" role="navigation">
            <%--
              <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                  <span class="sr-only">Toggle navigation</span>
                  <span class="icon-bar"></span>
                  <span class="icon-bar"></span>
                  <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" onClick="javascript:backButtonClicked();"><span class="glyphicon glyphicon-backward" style="color:#fff;font-size:16px;"></span></a>
              </div>
              <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav">
                  <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">Projects <b class="caret"></b></a>
                    <ul class="dropdown-menu">
                      <li><a href="#">Action</a></li>
                      <li><a href="#">Another action</a></li>
                      <li><a href="#">Something else here</a></li>
                      <li class="divider"></li>
                      <li><a href="#">Separated link</a></li>
                      <li class="divider"></li>
                      <li><a href="#">One more separated link</a></li>
                    </ul>
                  </li>
                  <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">Credibility Factors <b class="caret"></b></a>
                    <ul class="dropdown-menu">
                      <li><a href="javascript:loadModule('factors/search.jsp');">Factors</a></li>
                    </ul>
                  </li>
                  <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">Configuration <b class="caret"></b></a>
                    <ul class="dropdown-menu">
                      <li><a href="#">Action</a></li>
                      <li><a href="#">Another action</a></li>
                      <li><a href="#">Something else here</a></li>
                    </ul>
                  </li>
                </ul>
              </div>
              --%>
            </nav>
          </div>
        </div>
        <!-- NAV ROW END -->


        <div class="row" style="">
          <div class="col-md-12" style="padding-top:0px;padding-left:0px;padding-right:0px;">
            <ul id="tabsetContent" class="nav nav-tabs" style="padding-right:15px;padding-left:15px;background:white;">

              <li class="disabled"><a href="#home">&nbsp;</a></li>
              <%--
              <li><a href="#profile" data-toggle="tab" class="nav_txt">Profile</a></li>
              <li class="active"><a href="#messages" data-toggle="tab" class="nav_txt">Messages</a></li>
              <li><a href="#settings" data-toggle="tab" class="nav_txt">Settings</a></li>
              --%>
            </ul>
          </div>
        </div>
        <!-- border-bottom-left-radius:5px;border-bottom-right-radius:5px;  -->
        <div class="row" style="border-top-left-radius:0px;border-top-right-radius:0px;background:white;border-left:0px solid lightgray;border-right:0px solid lightgray;border-bottom:0px solid lightgray;">
          <div id="tabContent" class="col-md-12" style="padding-top:20px;background:white;min-height:400px;padding-left:20px;padding-right:20px;">
<%--
            <h2 style="margin-top:0;margin-bottom:20px;color:#333333;">This is the page title</h2>
            <p style="margin-top:0;margin-bottom:20px;color:darkgray;">This is optional descriptive copy.</p>


            <div class="panel panel-primary">
              <div class="panel-heading blue_bg">
                <h3 class="panel-title"><a data-toggle="collapse" href="#collapse1">Panel Title</a></h3>
              </div>
              <div class="panel-body panel-collapse collapse in" id="collapse1">
                <div class="row">
                  <div class="col-md-8" style="margin-bottom:20px;color:darkgray;">
                    This is optional descriptive copy. This is optional descriptive copy. This is optional descriptive copy. This is optional descriptive copy. This is optional descriptive copy.
                  </div>
                  <div class="col-md-4" style="">&nbsp;</div>
                </div>


                <form class="form-horizontal" role="form">
                  <div class="form-group">
                    <label style="padding-right:0;color:#333333;" for="textfield" class="col-sm-3 control-label">Text Field</label>
                    <div class="col-sm-9">
                      <input type="email" class="form-control" id="textfield" placeholder="Email">
                      <p class="help-block" style="margin-bottom:0;color:darkgray;">Example block-level help text here.</p>
                    </div>
                  </div>
                  <div class="form-group">
                    <label style="padding-right:0;color:#333333;" for="textarea" class="col-sm-3 control-label">Text Area</label>
                    <div class="col-sm-9">
                      <textarea class="form-control" id="textarea" rows="3"></textarea>
                      <p class="help-block" style="margin-bottom:0;">Example block-level help text here.</p>
                    </div>
                  </div>
                  <div class="form-group">
                    <label style="padding-right:0;color:#333333;" for="textarea" class="col-sm-3 control-label">select</label>
                    <div class="col-sm-9">

            <select class="form-control">
  <option>1</option>
  <option>2</option>
  <option>3</option>
  <option>4</option>
  <option>5</option>
</select>
                    </div>
                  </div>
                  <div class="form-group">
                    <label style="padding-right:0;color:#333333;" for="checkbox" class="col-sm-3 control-label">Checkbox</label>
                    <div class="col-sm-9">
                      <div class="checkbox">
                        <label>
                          <input type="checkbox" id="checkbox"> Checkbox sub label
                        </label>
                      </div>
                    </div>
                  </div>
                  <div class="form-group">
                    <label style="padding-right:0;color:#333333;" for="exampleInputFile" class="col-sm-3 control-label">File input</label>
                    <div class="col-sm-9">
                      <input type="file" id="exampleInputFile">
                    </div>
                  </div>
                  <div class="form-group">
                    <div class="col-sm-offset-3 col-sm-9">
                      <button type="submit" class="btn btn-primary btn-sm">Sign in</button>
                    </div>
                  </div>
                </form>
              </div>
            </div>




            <div class="panel panel-primary">
              <div class="panel-heading">
                <h3 class="panel-title"><a data-toggle="collapse" href="#collapse2">Panel Title</a>

                <ul class="pagination pagination-sm pull-right" style="margin:0; padding:0;">
                    <li><a href="#" style="color:#cc3300;">1</a></li>
                    <li><a href="#" style="color:#cc3300;">2</a></li>
                    <li><a href="#" style="color:#cc3300;">3</a></li>
                    <li><a href="#" style="color:#cc3300;">4</a></li>
                    <li><a href="#" style="color:#cc3300;">5</a></li>
                  </ul>
                  <div class="clearfix"></div>
                  </h3>
              </div>

              <div id="collapse2" class="panel-collapse collapse in">
                <div class="panel-body">
                  <div class="row">
                    <div class="col-md-8" style="margin-bottom:20px;color:darkgray;">
                      This is optional descriptive copy. This is optional descriptive copy. This is optional descriptive copy. This is optional descriptive copy. This is optional descriptive copy. This is optional descriptive copy. This is optional descriptive copy. This is optional descriptive copy. This is optional descriptive copy. This is optional descriptive copy.
                    </div>
                    <div class="col-md-4" style="">&nbsp;</div>
                  </div>
                  <!--
                  <ul class="pagination pagination-sm pull-right" style="margin:0; padding:0;">
                    <li><a href="#" style="color:#cc3300;">1</a></li>
                    <li><a href="#" style="color:#cc3300;">2</a></li>
                    <li><a href="#" style="color:#cc3300;">3</a></li>
                    <li><a href="#" style="color:#cc3300;">4</a></li>
                    <li><a href="#" style="color:#cc3300;">5</a></li>
                  </ul>
                  <div class="clearfix"></div>
                  -->
                </div>

                <!-- Table -->
                <div class="table-responsive">
                <table class="table table-striped">
                  <thead>
                    <tr style="color:#333333;">
                      <th>
                        First
                      </th>
                      <th>
                        Last
                      </th>
                      <th>
                        Email
                      </th>
                      <th>
                        Project
                      </th>
                      <th>
                        Status
                      </th>
                      <th>
                        &nbsp;
                      </th>
                    </tr>
                  </thead>
                  <tbody style="color:#333333;">
                    <tr>
                      <td>
                        John
                      </td>
                      <td>
                        McDonald
                      </td>
                      <td>
                        <a href="#" style="color:#cc3300;">john@mcdonalds.com</a>
                      </td>
                      <td>
                        Smith & Smith
                      </td>
                      <td>
                        Active
                      </td>
                      <td style="text-align:right;">
                        <button type="button" class="btn btn-primary btn-sm">Edit</button>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        John
                      </td>
                      <td>
                        McDonald
                      </td>
                      <td>
                        john@mcdonalds.com
                      </td>
                      <td>
                        Smith & Smith
                      </td>
                      <td>
                        Active
                      </td>
                      <td style="text-align:right;">
                        <div class="btn-group">
                          <button type="button" class="btn btn-primary btn-sm">Action</button>
                          <button type="button" class="btn btn-primary dropdown-toggle btn-sm" data-toggle="dropdown">
                            <span class="caret"></span>
                            <span class="sr-only">Toggle Dropdown</span>
                          </button>
                          <ul class="dropdown-menu" role="menu">
                            <li><a href="#">Action</a></li>
                            <li><a href="#">Another action</a></li>
                            <li><a href="#">Something else here</a></li>
                            <li class="divider"></li>
                            <li><a href="#">Separated link</a></li>
                          </ul>
                        </div>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        John
                      </td>
                      <td>
                        McDonald
                      </td>
                      <td>
                        john@mcdonalds.com
                      </td>
                      <td>
                        Smith & Smith
                      </td>
                      <td>
                        Active
                      </td>
                      <td style="text-align:right;">
                        <button type="button" class="btn btn-primary btn-sm">Edit</button>
                      </td>
                    </tr>
                  </tbody>
                </table>
                </div>
              </div>
            </div>
--%>
          </div>
        </div>
        <div class="row" style="border-bottom-left-radius:5px;border-bottom-right-radius:5px;color:#999999; background:#030623; height:50px;">
          <div class="col-md-12">
            <p class="pull-left" style="margin-top:15px;">Copyright 2016 @ECS ReelTrack</p>
            <p id="footerContent" class="pull-right" style="margin-top:15px;"></p>
          </div>
        </div>


      </div>

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://code.jquery.com/jquery.js"></script>
    <script src="interface/js/bootstrap.min.js"></script>
    <script src="interface/js/moment.js"></script>
    <script src="interface/js/bootstrap-datetimepicker.min.js"></script>
    <script src="interface/js/bootstrap-dialog.js"></script>
    <script src="interface/js/jquery.cookie.js"></script>
    <script src="interface/js/tramp.js"></script>
    <script>
    	function openTag(reelID) {
    		var win = window.open('/trampoline/reeltags/reeltag_image.jsp?reel_param=' + reelID, '_blank');
    	}
    </script>
    <script>
    <% if(reelID==0) { %>
      loadLoginScreen();
    <% } else { %>
      <%
      String tempURL = "reels/status.jsp?" +  Reel.PARAM + "=" + reelID;
      if(checkedout) {
        if(circuits) {
          tempURL = "reels/circuits.jsp?" +  Reel.PARAM + "=" + reelID;
        } else {
          tempURL = "reels/quantity.jsp?" +  Reel.PARAM + "=" + reelID;
        }
      }
      %>
      loadDirect('<%= tempURL %>');
    <% } %>
    </script>

    </body>
    </html>
