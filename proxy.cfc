<cfcomponent>
	<cffunction access="remote" name="set">
		<cfargument name="name" required="true">
		<cfargument name="value" required="true">

		<cfset "session.model.#arguments.name#" = arguments.value>
	</cffunction>
</cfcomponent>