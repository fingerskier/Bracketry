<cfcomponent displayname="" hint="" output="false">
	<cffunction access="public" name="context">
		<cfargument name="name" required="false" type="string">
		<cfargument name="value" required="false" type="any">

		<cfif not isDefined('request.context')>
  			<cfset request.context = structNew()>
		</cfif>

		<cfif isDefined('arguments.value')>
			<cfset request.context[arguments.name] = arguments.value>
		<cfelseif isDefined('arguments.name')>
  			<cfif not isDefined('request.context.#arguments.name#')>
				<cfreturn false>
			</cfif>

  			<cfreturn request.context[arguments.name]>
	 	<cfelse>
   			<cfreturn request.context>
		</cfif>
	</cffunction>

	<cffunction name="onApplicationStart" access="public" returntype="boolean" output="false">
 		<cfset application.brack.globalLayout = 'layout.cfm'>
		<cfif not fileExists(expandPath(application.brack.globalLayout))>
			<cfset application.brack.globalLayout = ''>
		</cfif>

		<cfset application.brack.globalAction = 'action.cfm'>
		<cfif not fileExists(expandPath(application.brack.globalAction))>
			<cfset application.brack.globalAction = ''>
		</cfif>

		<cfreturn true>
	</cffunction>

	<cffunction name="onApplicationEnd" access="public" returntype="void" output="false">
		<cfargument name="applicationScope" type="struct" required="false" default="#structNew()#"/>

		<cfreturn true>
	</cffunction>

	<cffunction name="onSessionStart" access="public" returntype="void" output="false">

	</cffunction>

	<cffunction name="onSessionEnd" access="public" returntype="void" output="false">
		<cfargument name="sessionScope" type="struct" required="true">
		<cfargument name="applicationScope" type="struct" required="false" default="#StructNew()#"/>

	</cffunction>

	<cffunction name="onRequestStart" access="public" returnType="boolean" output="true">
		<cfargument type="String" name="targetPage" required="true"/>

		<cfset request.context = structCopy(URL)>
		<cfset structAppend(request.context, structCopy(form))>
		<cfparam name="request.context.action" default="#application.fwDefault.defaultAction#">

		<cfif context('reset') is 'goober'>
			<cfset onApplicationStart()>
		</cfif>

		<cfif context('restart') is 'goober'>
			<cfset applicationStop()>
		</cfif>

		<cfset request.section = listFirst(context('action'), '.')>
		<cfset request.item = listLast(context('action'), '.')>

		<cfset request.sectionPath = expandPath(request.section)>
		<cfif directoryExists(request.sectionPath)>
			<cfset request.sectionAction = request.section & '/' & 'action.cfm'>
   			<cfif not fileExists(expandPath(request.sectionAction))>
				<cfset request.sectionAction = ''>
			</cfif>

			<cfset request.sectionLayout = request.sectionPath & 'layout.cfm'>
   			<cfif not fileExists(request.sectionLayout)>
				<cfset request.sectionLayout = ''>
			</cfif>

			<cfset request.itemPath = request.sectionPath & '/' & request.item>
   			<cfif directoryExists(request.itemPath)>
	  			<cfset request.itemAction = request.section & '/' & request.item & '/' & 'action.cfm'>
	  			<cfif not fileExists(expandPath(request.itemAction))>
	  				<cfset request.itemAction = ''>
				</cfif>

	  			<cfset request.itemView = request.section & '/' & request.item & '/' & 'view.cfm'>
	  			<cfif not fileExists(request.itemPath)>
					<cfset request.itemPath = ''>
				</cfif>
			<cfelse>
   				<cfthrow message="Item '#request.item#' does not exist" detail="Nil path at #request.itemPath#">
			</cfif>
   		<cfelse>
	 		<cfthrow message="Section '#request.section#' does not exist" detail="Nil path at #request.sectionPath#">
		</cfif>

	    <cfreturn true>
	</cffunction>

	<cffunction name="onRequest" access="public" returntype="void" output="true">
		<cfargument name="targetPage" type="string" required="true">

  		<cfset var doGlobalAction = len(application.brack.globalAction)>
		<cfset var doGlobalLayout = len(application.brack.globalLayout)>

		<cfoutput>
			<cfif doGlobalAction and doGlobalLayout>
	  			<cf_action context="#context#">
		 			<cf_layout context="#context#">
	  					<cf_section context="#context#" />
					</cf_layout>
				</cf_action>
			<cfelseif doGlobalAction>
	  			<cf_action context="#context#">
  					<cf_section context="#context#" />
				</cf_action>
			<cfelseif doGlobalLayout>
	 			<cf_layout context="#context#">
  					<cf_section context="#context#" />
				</cf_layout>
			<cfelse>
				<cf_section context="#context#" />
			</cfif>
		</cfoutput>
	</cffunction>

	<cffunction name="renderSection" output="true">
 		<cfargument name="request">

  		<cfset var doSectionAction = len(request.sectionAction)>
		<cfset var doSectionLayout = len(request.sectionLayout)>

		<cfoutput>
			<cfif doSectionAction and doSectionLayout>
	  			<cfmodule template="/auto-driller/#request.sectionAction#" context="#context#">
		 			<cfmodule template="/auto-driller/#request.sectionLayout#" context="#context#">
	  					#renderItem(request)#
					</cfmodule>
				</cfmodule>
			<cfelseif doSectionAction>
	  			<cfmodule template="/auto-driller/#request.sectionAction#" context="#context#">
  					#renderItem(request)#
				</cfmodule>
			<cfelseif doSectionLayout>
	 			<cfmodule template="/auto-driller/#request.sectionLayout#" context="#context#">
  					#renderItem(request)#
				</cfmodule>
			<cfelse>
				#renderItem(request)#
			</cfif>
		</cfoutput>
	</cffunction>

	<cffunction name="renderItem" output="true">
 		<cfargument name="request">

  		<cfset var doItemAction = len(request.itemAction)>
		<cfset var doItemView = len(request.itemView)>

		<cfoutput>
			<cfif doItemAction and doItemView>
	  			<cfmodule template="/auto-driller/#request.itemAction#" context="#context#">
		 			<cfmodule template="/auto-driller/#request.itemView#" context="#context#" />
				</cfmodule>
			<cfelseif doItemAction>
	  			<cfmodule template="/auto-driller/#request.itemAction#" context="#context#" />
			<cfelse>
	 			<cfmodule template="/auto-driller/#request.itemView#" context="#context#" />
			</cfif>
		</cfoutput>
	</cffunction>

	<cffunction name="onRequestEnd" access="public" returntype="void" output="true">

	</cffunction>

	<cffunction name="onError" access="public" returntype="void" output="true">
		<cfargument name="exception" type="any" required="true">
		<cfargument name="eventName" type="string" required="false" default="">

		<cfdump var="#arguments#">
	</cffunction>

	<cffunction name="onMissingTemplate" access="public" returnType="boolean" output="false">
   		<cfargument type="string" name="targetPage" required=true>

		<cfreturn true>
	</cffunction>
</cfcomponent>

<!---
	Application Structure:
		Application.cfc
			setupApplication()
			setupSession()
			teardownApplication()
			teardownSession()
		bracketry.cfc
		bracketry.js
		index.cfm (must be blank)
		action.cfm
		layout.cfm
		/section
			layout.cfm
			service.cfc
			action.cfm
			/item
				action.cfm
				view.cfm

		setupApplication()
			setupSession()
				<global_action>
					<global_layout>
						<section_action>
							<section_layout>
								<item_action>
									<item_view fw=this context=request.context service=request.service />
								</item_action>
							</section_layout>
						</section_action>
					</global_layout>
				<global_action>
			teardownSession()
		teardownApplication()

	Each plugin should be self-contained
	Philosophy
		the application & session scopes are the developers'
		the request scope belongs to the framework
 --->
