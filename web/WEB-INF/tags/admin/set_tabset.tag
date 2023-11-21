<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the necessary js to load proper UI elements for this jsp page" pageEncoding="UTF-8"%>
<%@ attribute name="url" required="true"%>
<%@ attribute name="content_id_for_tabset" required="false" type="java.lang.Object"%>
<%@ attribute name="parent_id_for_tabset" required="false" type="java.lang.Object"%>
<%@ attribute name="params" required="false" type="java.lang.Object"%>
<%@ attribute name="thispage" required="true"%>

<script>
loadTabset('${url}?content_id_for_tabset=${content_id_for_tabset}&parent_id_for_tabset=${parent_id_for_tabset}&${params}','${thispage}');
</script>
