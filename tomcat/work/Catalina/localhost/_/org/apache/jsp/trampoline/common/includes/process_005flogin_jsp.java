/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/7.0.37
 * Generated at: 2013-09-16 18:05:55 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.trampoline.common.includes;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.monumental.trampoline.component.*;
import com.monumental.trampoline.security.*;

public final class process_005flogin_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  private javax.el.ExpressionFactory _el_expressionfactory;
  private org.apache.tomcat.InstanceManager _jsp_instancemanager;

  public java.util.Map<java.lang.String,java.lang.Long> getDependants() {
    return _jspx_dependants;
  }

  public void _jspInit() {
    _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
    _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(getServletConfig());
  }

  public void _jspDestroy() {
  }

  public void _jspService(final javax.servlet.http.HttpServletRequest request, final javax.servlet.http.HttpServletResponse response)
        throws java.io.IOException, javax.servlet.ServletException {

    final javax.servlet.jsp.PageContext pageContext;
    javax.servlet.http.HttpSession session = null;
    final javax.servlet.ServletContext application;
    final javax.servlet.ServletConfig config;
    javax.servlet.jsp.JspWriter out = null;
    final java.lang.Object page = this;
    javax.servlet.jsp.JspWriter _jspx_out = null;
    javax.servlet.jsp.PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      com.monumental.trampoline.datasources.DbResources dbResources = null;
      dbResources = (com.monumental.trampoline.datasources.DbResources) _jspx_page_context.getAttribute("dbResources", javax.servlet.jsp.PageContext.PAGE_SCOPE);
      if (dbResources == null){
        dbResources = new com.monumental.trampoline.datasources.DbResources();
        _jspx_page_context.setAttribute("dbResources", dbResources, javax.servlet.jsp.PageContext.PAGE_SCOPE);
      }
      out.write('\n');
      com.monumental.trampoline.security.UserLoginMgr userLoginMgr = null;
      userLoginMgr = (com.monumental.trampoline.security.UserLoginMgr) _jspx_page_context.getAttribute("userLoginMgr", javax.servlet.jsp.PageContext.PAGE_SCOPE);
      if (userLoginMgr == null){
        userLoginMgr = new com.monumental.trampoline.security.UserLoginMgr();
        _jspx_page_context.setAttribute("userLoginMgr", userLoginMgr, javax.servlet.jsp.PageContext.PAGE_SCOPE);
      }
      out.write('\n');
      out.write('\n');
 CompProperties props = new CompProperties(); 
      out.write('\n');
      out.write('\n');
 	 
userLoginMgr.init(pageContext, dbResources);

String redirect = request.getHeader("referer");
String action = "";
if(request.getParameter("submit_action") != null) {
    action = request.getParameter("submit_action");
}

      out.write('\n');
      out.write('\n');
      out.write('\n');
  if(action.equals("login" )) { 
      out.write('\n');
  
userLoginMgr.login(request.getParameter(User.USERNAME_COLUMN), request.getParameter(User.PASSWORD_COLUMN));
redirect = request.getContextPath() + "/trampoline/index.jsp";

      out.write('\n');
 } 
      out.write('\n');
      out.write('\n');
      out.write('\n');
 if(action.equals("logout")) { 
      out.write('\n');
  
userLoginMgr.logout();
redirect = request.getContextPath() + "/trampoline/index.jsp";			

      out.write('\n');
 } 
      out.write('\n');
 dbResources.close(); 
      out.write('\n');
 response.sendRedirect(redirect);
    } catch (java.lang.Throwable t) {
      if (!(t instanceof javax.servlet.jsp.SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try { out.clearBuffer(); } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
