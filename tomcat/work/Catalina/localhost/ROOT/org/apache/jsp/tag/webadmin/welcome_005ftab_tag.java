/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/8.0.15
 * Generated at: 2016-09-30 11:01:51 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.tag.webadmin;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class welcome_005ftab_tag
    extends javax.servlet.jsp.tagext.SimpleTagSupport
    implements org.apache.jasper.runtime.JspSourceDependent,
               javax.servlet.jsp.tagext.DynamicAttributes {


  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  private javax.servlet.jsp.JspContext jspContext;
  private java.io.Writer _jspx_sout;
  private javax.el.ExpressionFactory _el_expressionfactory;
  private org.apache.tomcat.InstanceManager _jsp_instancemanager;

  public void setJspContext(javax.servlet.jsp.JspContext ctx) {
    super.setJspContext(ctx);
    java.util.ArrayList _jspx_nested = null;
    java.util.ArrayList _jspx_at_begin = null;
    java.util.ArrayList _jspx_at_end = null;
    this.jspContext = new org.apache.jasper.runtime.JspContextWrapper(ctx, _jspx_nested, _jspx_at_begin, _jspx_at_end, null);
  }

  public javax.servlet.jsp.JspContext getJspContext() {
    return this.jspContext;
  }
  private java.util.HashMap _jspx_dynamic_attrs = new java.util.HashMap();
  private java.lang.String text;
  private java.lang.String action;
  private java.lang.String name;
  private java.lang.String align;
  private java.lang.String valign;

  public java.lang.String getText() {
    return this.text;
  }

  public void setText(java.lang.String text) {
    this.text = text;
    jspContext.setAttribute("text", text);
  }

  public java.lang.String getAction() {
    return this.action;
  }

  public void setAction(java.lang.String action) {
    this.action = action;
    jspContext.setAttribute("action", action);
  }

  public java.lang.String getName() {
    return this.name;
  }

  public void setName(java.lang.String name) {
    this.name = name;
    jspContext.setAttribute("name", name);
  }

  public java.lang.String getAlign() {
    return this.align;
  }

  public void setAlign(java.lang.String align) {
    this.align = align;
    jspContext.setAttribute("align", align);
  }

  public java.lang.String getValign() {
    return this.valign;
  }

  public void setValign(java.lang.String valign) {
    this.valign = valign;
    jspContext.setAttribute("valign", valign);
  }

  public void setDynamicAttribute(java.lang.String uri, java.lang.String localName, java.lang.Object value) throws javax.servlet.jsp.JspException {
    if (uri == null)
      _jspx_dynamic_attrs.put(localName, value);
  }
  public java.util.Map<java.lang.String,java.lang.Long> getDependants() {
    return _jspx_dependants;
  }

  private void _jspInit(javax.servlet.ServletConfig config) {
    _el_expressionfactory = _jspxFactory.getJspApplicationContext(config.getServletContext()).getExpressionFactory();
    _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(config);
  }

  public void _jspDestroy() {
  }

  public void doTag() throws javax.servlet.jsp.JspException, java.io.IOException {
    javax.servlet.jsp.PageContext _jspx_page_context = (javax.servlet.jsp.PageContext)jspContext;
    javax.servlet.http.HttpServletRequest request = (javax.servlet.http.HttpServletRequest) _jspx_page_context.getRequest();
    javax.servlet.http.HttpServletResponse response = (javax.servlet.http.HttpServletResponse) _jspx_page_context.getResponse();
    javax.servlet.http.HttpSession session = _jspx_page_context.getSession();
    javax.servlet.ServletContext application = _jspx_page_context.getServletContext();
    javax.servlet.ServletConfig config = _jspx_page_context.getServletConfig();
    javax.servlet.jsp.JspWriter out = jspContext.getOut();
    _jspInit(config);
    jspContext.getELContext().putContext(javax.servlet.jsp.JspContext.class,jspContext);
    if( getText() != null ) 
      _jspx_page_context.setAttribute("text", getText());
    if( getAction() != null ) 
      _jspx_page_context.setAttribute("action", getAction());
    if( getName() != null ) 
      _jspx_page_context.setAttribute("name", getName());
    if( getAlign() != null ) 
      _jspx_page_context.setAttribute("align", getAlign());
    if( getValign() != null ) 
      _jspx_page_context.setAttribute("valign", getValign());
    _jspx_page_context.setAttribute("attribs", _jspx_dynamic_attrs);
    try {
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
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("<div id=\"welcome_tab\" class=\"");
 if(valign != null && valign != "top") {
      out.write(" bottomWelcomeTab ");
 } 
 if(align != null && align != "left") {
      out.write(" rightWelcomeTab ");
 }else{ 
      out.write(" leftWelcomeTab ");
 } 
      out.write("\">  \n");
      out.write("\n");
 if(action != null){ 
      out.write("\n");
      out.write("<a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${action}", java.lang.String.class, (javax.servlet.jsp.PageContext)this.getJspContext(), null));
      out.write('"');
      out.write('>');
      out.write('\n');
 } else { 
      out.write("\n");
      out.write("<a>\n");
 } 
      out.write("\n");
      out.write("    <div class=\"t\"></div>\n");
      out.write("    <div class=\"content\">\n");
      out.write("\t\t");
 if(name == null){ 
      out.write("\n");
      out.write("\t\t\t<img width=\"14\" height=\"14\"  alt=\"\" border=\"0\" class=\"LogoutTabButton\" src=\"common/images/blank.gif\" />\n");
      out.write("\t\t");
 } 
      out.write("\n");
      out.write("          <!-- Your content goes here -->\n");
      out.write("          ");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${text}", java.lang.String.class, (javax.servlet.jsp.PageContext)this.getJspContext(), null));
      out.write('\n');
      out.write('	');
      out.write('	');
 if(action != null){ 
      out.write("\n");
      out.write("\t\t\t");
 if(name != null){ 
      out.write("\n");
      out.write("\t\t\t\t<em>[");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${name}", java.lang.String.class, (javax.servlet.jsp.PageContext)this.getJspContext(), null));
      out.write("]</em>\n");
      out.write("\t\t\t");
 } 
      out.write('\n');
      out.write('	');
      out.write('	');
 } 
      out.write("\n");
      out.write("    </div>\n");
      out.write("</a>\n");
      out.write("\n");
      out.write("</div>");
    } catch( java.lang.Throwable t ) {
      if( t instanceof javax.servlet.jsp.SkipPageException )
          throw (javax.servlet.jsp.SkipPageException) t;
      if( t instanceof java.io.IOException )
          throw (java.io.IOException) t;
      if( t instanceof java.lang.IllegalStateException )
          throw (java.lang.IllegalStateException) t;
      if( t instanceof javax.servlet.jsp.JspException )
          throw (javax.servlet.jsp.JspException) t;
      throw new javax.servlet.jsp.JspException(t);
    } finally {
      jspContext.getELContext().putContext(javax.servlet.jsp.JspContext.class,super.getJspContext());
      ((org.apache.jasper.runtime.JspContextWrapper) jspContext).syncEndTagFile();
    }
  }
}
