/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/8.0.15
 * Generated at: 2016-09-15 14:52:24 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.trampoline.pick_005flists;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.reeltrack.users.*;
import com.reeltrack.reels.*;
import com.reeltrack.picklists.*;
import com.reeltrack.foremans.*;
import com.monumental.trampoline.component.*;
import java.text.SimpleDateFormat;
import java.util.Date;

public final class picklist_jsp extends org.apache.jasper.runtime.HttpJspBase
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

final java.lang.String _jspx_method = request.getMethod();
if (!"GET".equals(_jspx_method) && !"POST".equals(_jspx_method) && !"HEAD".equals(_jspx_method) && !javax.servlet.DispatcherType.ERROR.equals(request.getDispatcherType())) {
response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "JSPs only permit GET POST or HEAD");
return;
}

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
      com.reeltrack.foremans.ForemanMgr foremanMgr = null;
      foremanMgr = (com.reeltrack.foremans.ForemanMgr) _jspx_page_context.getAttribute("foremanMgr", javax.servlet.jsp.PageContext.REQUEST_SCOPE);
      if (foremanMgr == null){
        foremanMgr = new com.reeltrack.foremans.ForemanMgr();
        _jspx_page_context.setAttribute("foremanMgr", foremanMgr, javax.servlet.jsp.PageContext.REQUEST_SCOPE);
      }
      out.write('\n');
      com.reeltrack.picklists.PickListMgr picklistMgr = null;
      picklistMgr = (com.reeltrack.picklists.PickListMgr) _jspx_page_context.getAttribute("picklistMgr", javax.servlet.jsp.PageContext.PAGE_SCOPE);
      if (picklistMgr == null){
        picklistMgr = new com.reeltrack.picklists.PickListMgr();
        _jspx_page_context.setAttribute("picklistMgr", picklistMgr, javax.servlet.jsp.PageContext.PAGE_SCOPE);
      }
      out.write('\n');
      com.reeltrack.reels.ReelMgr reelMgr = null;
      reelMgr = (com.reeltrack.reels.ReelMgr) _jspx_page_context.getAttribute("reelMgr", javax.servlet.jsp.PageContext.PAGE_SCOPE);
      if (reelMgr == null){
        reelMgr = new com.reeltrack.reels.ReelMgr();
        _jspx_page_context.setAttribute("reelMgr", reelMgr, javax.servlet.jsp.PageContext.PAGE_SCOPE);
      }
      out.write('\n');
      com.reeltrack.users.RTUserLoginMgr userLoginMgr = null;
      userLoginMgr = (com.reeltrack.users.RTUserLoginMgr) _jspx_page_context.getAttribute("userLoginMgr", javax.servlet.jsp.PageContext.PAGE_SCOPE);
      if (userLoginMgr == null){
        userLoginMgr = new com.reeltrack.users.RTUserLoginMgr();
        _jspx_page_context.setAttribute("userLoginMgr", userLoginMgr, javax.servlet.jsp.PageContext.PAGE_SCOPE);
      }
      out.write('\n');
 userLoginMgr.init(pageContext); 
      out.write('\n');
 foremanMgr.init(pageContext,dbResources); 
      out.write('\n');
 picklistMgr.init(pageContext,dbResources); 
      out.write('\n');
 reelMgr.init(pageContext,dbResources); 
      out.write('\n');
 RTUser user = (RTUser)userLoginMgr.getUser(); 
      out.write('\n');

// Get the id
int contid = 0;
if(request.getParameter(PickList.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(PickList.PARAM));
} else {
    String param = "content_id_for_tabset";
    if(request.getParameter(param) != null) {
        contid = Integer.parseInt(request.getParameter(param));
    }
}

// Get the piece of content
PickList content = new PickList();
content.setId(contid);
content = (PickList)picklistMgr.getPickList(content);

picklistMgr.generateQrCodesforPickList(content);
CompEntities pickReels = picklistMgr.getReelsOnPickList(content);
reelMgr.fillReelCircuits(pickReels);

SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy");
String dateString = df.format(new Date());

String tempURL; //var for url expression

      out.write('\n');
 dbResources.close(); 
      out.write("\n");
      out.write("\n");
      out.write("<html>\n");
      out.write("<head>\n");
      out.write("<style type=\"text/css\">\n");
      out.write("body {\n");
      out.write("    font-family:arial,\"Lucida Grande\",Geneva,Arial,Verdana,sans-serif;\n");
      out.write("    font-size: 25px;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".value {\n");
      out.write("\tfont-family:arial,\"Lucida Grande\",Geneva,Arial,Verdana,sans-serif;\n");
      out.write("\tfont-size: 12px;\n");
      out.write("\tvertical-align:top;\t\n");
      out.write("}\n");
      out.write("\n");
      out.write(".header {\n");
      out.write("\tfont-family:arial,\"Lucida Grande\",Geneva,Arial,Verdana,sans-serif;\n");
      out.write("\tfont-size: 12px;\n");
      out.write("\tbackground-color: #c4c4c4;\n");
      out.write("\tfont-weight: bold;\t\n");
      out.write("}\n");
      out.write("\n");
      out.write("table {\n");
      out.write("\twidth: 960px;\n");
      out.write("\tborder: 1px solid;\n");
      out.write("\tmargin-bottom: 5px;\n");
      out.write("}\n");
      out.write("\n");
      out.write("td {\n");
      out.write("\tpadding: 5px;\n");
      out.write("}\n");
      out.write("\n");
      out.write("</style>\n");
      out.write("</head>\n");
      out.write("<body>\n");
 for(int i=0; i<pickReels.howMany(); i++) { 
      out.write('\n');
      out.write('	');
 Reel reel = (Reel)pickReels.get(i); 
      out.write('\n');
      out.write('	');
 CompEntities circuits = reel.getCompEntities(ReelCircuit.PARAM); 
      out.write('\n');
      out.write('	');
 int rowspan = 7 + circuits.howMany(); 
      out.write("\n");
      out.write("\t<h1 ");
 if(i>0) { 
      out.write("style=\"page-break-before: always;\"");
 } 
      out.write(">Pick List: ");
      out.print( content.getName() );
      out.write("</h1>\n");
      out.write("\t<table>\n");
      out.write("\t<tr>\n");
      out.write("\t\t<td class=\"header\">Pick List number</td>\n");
      out.write("\t\t<td class=\"header\">Name</td>\n");
      out.write("\t\t<td class=\"header\">Foreman</td>\n");
      out.write("\t\t<td class=\"header\">Reels</td>\n");
      out.write("\t\t<td class=\"header\">Date</td>\n");
      out.write("\t</tr>\n");
      out.write("\t<tr>\n");
      out.write("\t\t<td class=\"value\">");
      out.print( content.getId() );
      out.write("</td>\n");
      out.write("\t\t<td class=\"value\">");
      out.print( content.getName() );
      out.write("</td>\n");
      out.write("\t\t<td class=\"value\">");
      out.print( content.getForeman() );
      out.write("</td>\n");
      out.write("\t\t<td class=\"value\">");
      out.print( i+1 );
      out.write(" of ");
      out.print( pickReels.howMany() );
      out.write("</td>\n");
      out.write("\t\t<td class=\"value\">");
      out.print( dateString );
      out.write("</td>\n");
      out.write("\t</tr>\n");
      out.write("\t</table>\n");
      out.write("\t<br />\n");
      out.write("\t<table>\n");
      out.write("\t<tr>\n");
      out.write("\t\t<td class=\"header\" style=\"font-size:14px;\">CRID: ReelTag / Description</td>\n");
      out.write("\t\t<td class=\"header\">Customer P/N</td>\n");
      out.write("\t\t<td class=\"header\">Serial #</td>\n");
      out.write("\t\t<td class=\"header\">Location</td>\n");
      out.write("\t\t<td class=\"header\">Status</td>\n");
      out.write("\t\t");
 tempURL = reel.getCompEntityDirectory() + "/" + reel.getPlQrCodeFile(); 
      out.write("\n");
      out.write("\t\t<td rowspan=\"");
      out.print( rowspan );
      out.write("\" width=\"250\"><img src=\"");
      out.print( tempURL );
      out.write("\" width=\"250\" height=\"250\" /></td>\n");
      out.write("\t</tr>\n");
      out.write("\t<tr>\n");
      out.write("\t\t<td class=\"value\" style=\"font-size:14px;\"><b>");
      out.print( reel.getCrId() );
      out.write(":</b> ");
      out.print( reel.getReelTag() );
      out.write("<br />");
      out.print( reel.getCableDescription() );
      out.write("</td>\n");
      out.write("\t\t<td class=\"value\">");
      out.print( reel.getCustomerPN() );
      out.write("</td>\n");
      out.write("\t\t<td class=\"value\">");
      out.print( reel.getReelSerial() );
      out.write("</td>\n");
      out.write("\t\t<td class=\"value\">");
      out.print( reel.getWharehouseLocation() );
      out.write("</td>\n");
      out.write("\t\t<td class=\"value\">");
      out.print( reel.getStatus() );
      out.write("</td>\n");
      out.write("\t</tr>\n");
      out.write("\t<tr>\n");
      out.write("\t\t<td class=\"header\" colspan=\"3\">&nbsp;</td>\n");
      out.write("\t\t<td class=\"header\">Type</td>\n");
      out.write("\t\t<td class=\"header\">Quantity</td>\n");
      out.write("\t</tr>\n");
      out.write("\t<tr>\n");
      out.write("\t\t<td class=\"value\" colspan=\"3\">&nbsp;</td>\n");
      out.write("\t\t<td class=\"value\">");
      out.print( reel.getReelType() );
      out.write("</td>\n");
      out.write("\t\t<td class=\"value\">");
      out.print( reel.getOnReelQuantity() );
      out.write("</td>\n");
      out.write("\t</tr>\n");
      out.write("\t<tr>\n");
      out.write("\t\t<td class=\"header\" colspan=\"3\">&nbsp;</td>\n");
      out.write("\t\t<td class=\"header\">Circuit Name</td>\n");
      out.write("\t\t<td class=\"header\">Length</td>\n");
      out.write("\t</tr>\n");
      out.write("\t");
 int total = 0; 
      out.write('\n');
      out.write('	');
 for (int c=0; c<circuits.howMany(); c++ ) { 
      out.write('\n');
      out.write('	');
 ReelCircuit circuit = (ReelCircuit)circuits.get(c); 
      out.write('\n');
      out.write('	');
 total += circuit.getLength(); 
      out.write("\n");
      out.write("\t<tr>\n");
      out.write("\t\t<td class=\"value\" colspan=\"3\">&nbsp;</td>\n");
      out.write("\t\t<td class=\"value\">");
      out.print( circuit.getName() );
      out.write("</td>\n");
      out.write("\t\t<td class=\"value\">");
      out.print( circuit.getLength() );
      out.write("</td>\n");
      out.write("\t</tr>\n");
      out.write("\t");
 } 
      out.write("\n");
      out.write("\t<tr>\n");
      out.write("\t\t<td class=\"value\" colspan=\"3\">&nbsp;</td>\n");
      out.write("\t\t<td class=\"value\"><b>Total</b></td>\n");
      out.write("\t\t<td class=\"value\">");
      out.print( total );
      out.write("</td>\n");
      out.write("\t</tr>\n");
      out.write("\t</table>\n");
      out.write("\t");
 } 
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("</body>\n");
      out.write("</html>\n");
      out.write("\n");
    } catch (java.lang.Throwable t) {
      if (!(t instanceof javax.servlet.jsp.SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try {
            if (response.isCommitted()) {
              out.flush();
            } else {
              out.clearBuffer();
            }
          } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
