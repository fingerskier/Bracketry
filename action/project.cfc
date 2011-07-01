<cfcomponent>
	<cffunction access="remote" name="upsert">
		<cfargument name="projectID" required="true" type="numeric">
  		<cfargument name="name" required="true" type="string">
		<cfargument name="path" required="true" type="string">

		<cfif len(arguments.name) and len(arguments.path)>
	  		<cfset var project = "">

	  		<cfif arguments.projectID gt 0>
				<cfset project = entityLoadByPK("project", arguments.projectID)>
	   			<cfset project.setName(arguments.name)>
		  		<cfset project.setPath(arguments.path)>
		 	<cfelseif arguments.projectID lt 0>
	   			<cfset project = entityNew("project")>
		  		<cfset project.setName(arguments.name)>
		 		<cfset project.setPath(arguments.path)>
			</cfif>

			<cfset entitySave(project)>
		</cfif>
	</cffunction>
</cfcomponent>
