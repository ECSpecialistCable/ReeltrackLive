/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/8.0.15
 * Generated at: 2016-08-30 10:36:40 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.tag.weblisting;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class header_005fcell_tag
    extends javax.servlet.jsp.tagext.SimpleTagSupport
    implements org.apache.jasper.runtime.JspSourceDependent,
               javax.servlet.jsp.tagext.DynamicAttributes {


  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  static {
    _jspx_dependants = new java.util.HashMap<java.lang.String,java.lang.Long>(2);
    _jspx_dependants.put("/WEB-INF/lib/standard.jar", Long.valueOf(1472002170000L));
    _jspx_dependants.put("jar:file:/www/new/tomcat/webapps/../../web/WEB-INF/lib/standard.jar!/META-INF/c.tld", Long.valueOf(1098725490000L));
  }

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
  private java.lang.String name;
  private java.lang.String align;
  private java.lang.String url;
  private java.lang.String ascending;
  private java.lang.String first;
  private java.lang.String column;
  private java.lang.String match;
  private java.lang.String width;
  private java.lang.String colspan;
  private java.lang.String cssClass;
  private java.lang.String toggleTarget;
  private java.lang.String toggleOpen;
  private java.lang.String id;
  private java.lang.String setWidth;

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

  public java.lang.String getUrl() {
    return this.url;
  }

  public void setUrl(java.lang.String url) {
    this.url = url;
    jspContext.setAttribute("url", url);
  }

  public java.lang.String getAscending() {
    return this.ascending;
  }

  public void setAscending(java.lang.String ascending) {
    this.ascending = ascending;
    jspContext.setAttribute("ascending", ascending);
  }

  public java.lang.String getFirst() {
    return this.first;
  }

  public void setFirst(java.lang.String first) {
    this.first = first;
    jspContext.setAttribute("first", first);
  }

  public java.lang.String getColumn() {
    return this.column;
  }

  public void setColumn(java.lang.String column) {
    this.column = column;
    jspContext.setAttribute("column", column);
  }

  public java.lang.String getMatch() {
    return this.match;
  }

  public void setMatch(java.lang.String match) {
    this.match = match;
    jspContext.setAttribute("match", match);
  }

  public java.lang.String getWidth() {
    return this.width;
  }

  public void setWidth(java.lang.String width) {
    this.width = width;
    jspContext.setAttribute("width", width);
  }

  public java.lang.String getColspan() {
    return this.colspan;
  }

  public void setColspan(java.lang.String colspan) {
    this.colspan = colspan;
    jspContext.setAttribute("colspan", colspan);
  }

  public java.lang.String getCssClass() {
    return this.cssClass;
  }

  public void setCssClass(java.lang.String cssClass) {
    this.cssClass = cssClass;
    jspContext.setAttribute("cssClass", cssClass);
  }

  public java.lang.String getToggleTarget() {
    return this.toggleTarget;
  }

  public void setToggleTarget(java.lang.String toggleTarget) {
    this.toggleTarget = toggleTarget;
    jspContext.setAttribute("toggleTarget", toggleTarget);
  }

  public java.lang.String getToggleOpen() {
    return this.toggleOpen;
  }

  public void setToggleOpen(java.lang.String toggleOpen) {
    this.toggleOpen = toggleOpen;
    jspContext.setAttribute("toggleOpen", toggleOpen);
  }

  public java.lang.String getId() {
    return this.id;
  }

  public void setId(java.lang.String id) {
    this.id = id;
    jspContext.setAttribute("id", id);
  }

  public java.lang.String getSetWidth() {
    return this.setWidth;
  }

  public void setSetWidth(java.lang.String setWidth) {
    this.setWidth = setWidth;
    jspContext.setAttribute("setWidth", setWidth);
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
    if( getName() != null ) 
      _jspx_page_context.setAttribute("name", getName());
    if( getAlign() != null ) 
      _jspx_page_context.setAttribute("align", getAlign());
    if( getUrl() != null ) 
      _jspx_page_context.setAttribute("url", getUrl());
    if( getAscending() != null ) 
      _jspx_page_context.setAttribute("ascending", getAscending());
    if( getFirst() != null ) 
      _jspx_page_context.setAttribute("first", getFirst());
    if( getColumn() != null ) 
      _jspx_page_context.setAttribute("column", getColumn());
    if( getMatch() != null ) 
      _jspx_page_context.setAttribute("match", getMatch());
    if( getWidth() != null ) 
      _jspx_page_context.setAttribute("width", getWidth());
    if( getColspan() != null ) 
      _jspx_page_context.setAttribute("colspan", getColspan());
    if( getCssClass() != null ) 
      _jspx_page_context.setAttribute("cssClass", getCssClass());
    if( getToggleTarget() != null ) 
      _jspx_page_context.setAttribute("toggleTarget", getToggleTarget());
    if( getToggleOpen() != null ) 
      _jspx_page_context.setAttribute("toggleOpen", getToggleOpen());
    if( getId() != null ) 
      _jspx_page_context.setAttribute("id", getId());
    if( getSetWidth() != null ) 
      _jspx_page_context.setAttribute("setWidth", getSetWidth());
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
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
if(url!=null){
      out.write('\n');
      out.write('	');
boolean selected = false;
      out.write('\n');
      out.write('	');
if(column!=null && match!=null && column.equals(match)) {
      out.write('\n');
      out.write('	');
      out.write('	');
selected = true;
      out.write('\n');
      out.write('	');
}
      out.write('\n');
      out.write('	');
String operator = "?";
      out.write('\n');
      out.write('	');
if(url.contains("?")) {
      out.write('\n');
      out.write('	');
      out.write('	');
operator = "&";
      out.write('\n');
      out.write('	');
}
      out.write('\n');
      out.write('\n');
      out.write('	');
if(selected) {
      out.write("\n");
      out.write("        ");
if(ascending.equals("true")) {
      out.write("\n");
      out.write("        \t<th><i class=\"glyphicon glyphicon-sort-by-attributes\"></i><a style=\"text-decoration:none;color:black;\" href=\"javascript:loadTab('");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${url}", java.lang.String.class, (javax.servlet.jsp.PageContext)this.getJspContext(), null));
      out.print( operator + "column=" + column + "&ascending=false" );
      out.write("');\"> ");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${name}", java.lang.String.class, (javax.servlet.jsp.PageContext)this.getJspContext(), null));
      out.write("</a></th>\n");
      out.write("        ");
} else {
      out.write("\n");
      out.write("        \t<th><i class=\"glyphicon glyphicon-sort-by-attributes-alt\"></i><a style=\"text-decoration:none;color:black;\" href=\"javascript:loadTab('");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${url}", java.lang.String.class, (javax.servlet.jsp.PageContext)this.getJspContext(), null));
      out.print( operator + "column=" + column + "&ascending=true" );
      out.write("');\"> ");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${name}", java.lang.String.class, (javax.servlet.jsp.PageContext)this.getJspContext(), null));
      out.write("</a></th>\n");
      out.write("        ");
}
      out.write("\n");
      out.write("    ");
} else {
      out.write("\n");
      out.write("        <th><a style=\"text-decoration:none;color:black;\" href=\"javascript:loadTab('");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${url}", java.lang.String.class, (javax.servlet.jsp.PageContext)this.getJspContext(), null));
      out.print( operator + "column=" + column + "&ascending=true" );
      out.write("');\">");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${name}", java.lang.String.class, (javax.servlet.jsp.PageContext)this.getJspContext(), null));
      out.write("</a></th>\n");
      out.write("    ");
}
      out.write('\n');
}else{
      out.write("\n");
      out.write("\t<th ");
 if(setWidth!=null) { 
      out.write("style=\"width:");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${setWidth}", java.lang.String.class, (javax.servlet.jsp.PageContext)this.getJspContext(), null));
      out.write("px;\"");
 } 
      out.write('>');
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${name}", java.lang.String.class, (javax.servlet.jsp.PageContext)this.getJspContext(), null));
      out.write("</th>\n");
}
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
