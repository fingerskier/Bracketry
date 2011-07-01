<cfparam name="projectID" min="1" type="numeric">
<cfparam name="moduleID" type="numeric">

<cfset thisProject = entityLoadByPK("project", projectID)>

<cfif moduleID gt 0>
	<cfset thisModule = entityLoadByPK("module", moduleID)>
<cfelseif moduleID lt 0>
	<cfset thisModule = entityNew("module")>
	<cfset thisModule.setProject(thisProject)>
	<cfset entitySave(thisModule)>
</cfif>

<cfset tags = entityLoad("tag", {module = thisModule})>

<cfif not arraylen(tags)>
	<cfset moduleExtension = listLast(thisModule.getName(), '.')>
	<cfset wrapperTag = entityNew("tag")>
	<cfset wrapperTag.setModule(thisModule)>

	<cfif moduleExtension is 'cfm'>
 		<cfset wrapperTag.setName('html')>
	<cfelseif moduleExtension is 'cfc'>
 		<cfset wrapperTag.setName('component')>
	<cfelse>
 		<cfset wrapperTag.setName('wrapper')>
	</cfif>
	<cfset entitySave(wrapperTag)>

	<cfset arrayPrepend(tags, wrapperTag)>
</cfif>

<cfset moduleName = thisModule.getName()>
<cfif not len(moduleName)>
	<cfset moduleName = 'new_module'>
</cfif>

<cfoutput>
	<form action="action/module.cfc?method=upsert" method="post">
		<input name="projectID" type="hidden" value="#projectID#">
		<input name="moduleID" type="hidden" value="#moduleID#">

		<label for="moduleName">Module:</label>
		<input id="moduleName" name="name" type="text" value="#thisModule.getName()#">
		<br>
		<input type="submit" value="Save Changes">
	</form>
	<br>
	<cfloop array="#tags#" index="tag">
 		<a href="tag.cfm?moduleID=#moduleID#&tagID=#tag.getID()#">#tag.getName()#</a>
		<br>
	</cfloop>
</cfoutput>
