<cfcomponent>
	<cffunction access="remote" name="upsert">
		<cfargument name="projectID" required="true" type="numeric">
		<cfargument name="moduleID" required="true" type="numeric">
  		<cfargument name="name" required="true" type="string">

		<cfif len(arguments.name)>
			<cfset var module = "">
	  		<cfset var project = entityLoadByPK("project", arguments.projectID)>

	  		<cfif arguments.moduleID gt 0>
				<cfset module = entityLoadByPK("project", arguments.moduleID)>
	   			<cfset module.setName(arguments.name)>
		 	<cfelseif arguments.moduleID lt 0>
	   			<cfset module = entityNew("module")>
		  		<cfset module.setProject(project)>
		  		<cfset module.setName(arguments.name)>
			</cfif>

			<cfset entitySave(module)>
		</cfif>
	</cffunction>
</cfcomponent>
