<cfcomponent>
	<cffunction access="remote" name="upsert">
		<cfargument name="moduleID" required="true" type="numeric">
		<cfargument name="tagID" required="true" type="numeric">
  		<cfargument name="name" required="true" type="string">

		<cfif len(name)>
			<cfset var tag = "">
	  		<cfset var module = entityLoadByPK("module", arguments.moduleID)>

	  		<cfif arguments.tagID gt 0>
				<cfset tag = entityLoadByPK("module", arguments.tagID)>
	   			<cfset tag.setName(arguments.name)>
		 	<cfelseif arguments.tagID lt 0>
	   			<cfset tag = entityNew("tag")>
		  		<cfset tag.setModule(module)>
		  		<cfset tag.setName(arguments.name)>
			</cfif>

			<cfset entitySave(tag)>
		</cfif>
	</cffunction>

	<cffunction access="remote" name="setAttr">
		<cfargument name="tagID" required="true" type="numeric">
		<cfargument name="attrID" required="true" type="numeric">
		<cfargument name="name" required="true" type="string">
		<cfargument name="value" required="true" type="string">

		<cfif len(arguments.name)>
			<cfset var attr = "">
			<cfset var tag = entityLoadByPK("tag", arguments.tagID)>

			<cfif arguments.attrID gt 0>
	  			<cfset attr = entityLoadByPK("attr", arguments.attrID)>
		 		<cfset attr.setName(arguments.name)>
				<cfset attr.setValue(arguments.value)>
	  		<cfelseif arguments.attrID lt 0>
				<cfset attr = entityNew("attr")>
		 		<cfset attr.setName(arguments.name)>
				<cfset attr.setValue(arguments.value)>
			</cfif>

			<cfset entitySave(attr)>
		</cfif>
	</cffunction>
</cfcomponent>
