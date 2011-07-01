<cfparam name="moduleID" min="1" type="numeric">
<cfparam name="tagID" type="numeric">

<cfset thisModule = entityload("module")>

<cfif tagID gt 0>
	<cfset thisTag = entityLoadByPK("tag", tagID)>
<cfelseif tagID lt 0>
	<cfset thisTag = entityNew("tag")>
	<cfset thisTag.setModule(thisModule)>
</cfif>

<cfset example_attr = entityNew("attr")>
<cfset example_attr.setTag(thisTag)>
<cfset attrs = entityLoadByExample(example_attr)>

<cfoutput>
	#thisTag.getName()#
	<form action="action/tag.cfc?method=upsert" method="post">
		<input name="moduleID" type="hidden" value="#moduleID#">
		<input name="tagID" type="hidden" value="#tagID#">
	</form>
	<br>
	<cfloop array="#attrs#" index="attr">
		<form action="action/tag.cfc?method=setAttr" method="post">
			<input name="tagID" type="hidden" value="#tagID#">
			<input name="attrID" type="hidden" value="#attr.getID()#">

			<input name="name" type="text" value="#attr.getName()#">
			<input name="value" type="text" value="#attr.getValue()#">
			<input type="submit" value="save">
		</form>
	</cfloop>
	<br>
	<form action="action/tag.cfc?method=setAttr" method="post">
		<input name="tagID" type="hidden" value="#tagID#">
		<input name="attrID" type="hidden" value="-7">

		<input name="name" type="text" value="">
		<input name="value" type="text" value="">
		<input type="submit" value="save">
	</form>
</cfoutput>
