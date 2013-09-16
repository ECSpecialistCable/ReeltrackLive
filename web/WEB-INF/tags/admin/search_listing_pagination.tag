<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs an h2"  %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="text" required="true" %>
<%@ attribute name="url" required="true" %>
<%@ attribute name="pageIndex" required="true" %>
<%@ attribute name="column" required="true" %>
<%@ attribute name="ascending" required="true" %>

<%@ attribute name="howMany" required="true" %>
<%@ attribute name="count" required="true" %>
<%@ attribute name="skip" required="true" %>

<%@ attribute name="search_params" required="false" %>
<%@ attribute name="extra_params" required="false" %>

<% 
	int tagSkip = 0;
	int tagHowMany = 0;
	int tagCount = 0;
	int pageIdx = 0;
	try {
		tagSkip = Integer.parseInt(skip);
		tagHowMany = Integer.parseInt(howMany);
		tagCount = Integer.parseInt(count);	
		pageIdx = Integer.parseInt(pageIndex);					
	} catch(Exception e) { e.printStackTrace(); }
	
	
	String foundString = text;
	if(tagCount < tagHowMany + (tagSkip + 1)) {
		foundString += "  (" + (tagSkip + 1) + "-" + (tagCount) + ") of " + tagCount;
	} else {
		foundString += "  (" + (tagSkip + 1) + "-" + (tagHowMany + tagSkip) + ") of " + tagCount; 
	}
	
	
	int MAX = tagCount;
	int FIRST = 1;
	int LAST = (tagCount + (tagHowMany -1)) / tagHowMany;
	int LASTPAGE = 0;

	// Regular Case
	if(pageIdx >= 3) { 
		FIRST = pageIdx - 2;
		LASTPAGE = pageIdx + 2; 
	} 


	// At the beginning
	if(pageIdx < 3) {
		FIRST = 1;
		LASTPAGE = pageIdx;
		for(int i=pageIdx; i<5; i++) {
			LASTPAGE ++;
		}
	}
	
	// At the end
	if(pageIdx > LAST-2) {
		LASTPAGE = LAST;
		FIRST = pageIdx;
		for (int k=pageIdx-1; k>LAST-5; k--) {
			FIRST--;
		}
	}
	
	// If we have too few pages for the first and last arrows
	if(LAST < 6) {
		FIRST = 1;
		LASTPAGE = LAST;
	}
	
	String fullURLString = url + "?column=" + column + "&ascending=" + ascending;
	if(search_params != null && !search_params.equals("")) {
		fullURLString += "&search_param=" + search_params;
	}
	
	if(extra_params != null && !extra_params.equals("")) {
		fullURLString += "&" + extra_params;
	}
	
%>

<table>
	<tr>
		<td width="300"><h2><%= foundString %></h2></td>		
		<td width="415" align="right">
			<p align="right" >
				<% if(FIRST != LASTPAGE) { %>
					<% if(pageIdx != 1) { %>
						<a href="#" onclick="javascript:ADMIN.load.page('<%= fullURLString %>&pageIdx=<%= pageIdx - 1 %>'); return false;">&lt;&lt;</a>&nbsp;&nbsp;
					<% } %>
														
					<% for(int j=FIRST; j<=LASTPAGE; j++) { %>
						<% if(j==(pageIdx)) { %>
							<strong style="font-size: 14px "><a href="#" onclick="javascript:ADMIN.load.page('<%= fullURLString %>&pageIdx=<%= j %>'); return false;"><%= j %></a></strong>
						<% } else { %>
							<a href="#" onclick="javascript:ADMIN.load.page('<%= fullURLString %>&pageIdx=<%= j %>'); return false;"><%= j %></a>					
						<% } %>
					<% } %>		
					<% if(pageIdx != LAST) { %>
						&nbsp;&nbsp;<a href="#" onclick="javascript:ADMIN.load.page('<%= fullURLString %>&pageIdx=<%= pageIdx + 1 %>'); return false;">&gt;&gt;</a>
					<% } %>
					<% if(pageIdx == LAST) { %>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<% } %>
				<% } %>
			</p>
		</td>
	</tr>
</table>

