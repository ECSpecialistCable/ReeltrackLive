<%@ attribute name="align" required="false" %>
<%@ attribute name="padding" required="false" %>

<% if(align.equals("right")) { %>
<td align="${align}"  style="padding-${align}: ${padding+10}px">
<% } else  { %>    
<td align="${align}" style="padding-${align}: ${padding}px">
<% } %> 