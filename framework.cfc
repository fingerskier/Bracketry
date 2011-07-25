<cfcomponent hint="2011.7.18.5.30" output="false">
	<cffunction name="action" returntype="String">
		<cfargument name="section" required="true" type="string">
		<cfargument name="item" required="true" type="string">
  		<cfargument name="query" default="" type="string" hint="extra context/query-string params">

		<cfset var result = ''>
  		<cfset result = application.URL & '?action=' & arguments.section & '.' & arguments.item>

		<cfif len(arguments.query)>
			<cfset result &= '&' & arguments.query>
		</cfif>

  		<cfreturn result>
	</cffunction>

	<cffunction name="addView" returntype="void">
		<cfargument name="section" required="true" type="string">
		<cfargument name="item" required="true" type="string">

		<cfset var newView = structNew()>
		<cfset newView.section = arguments.section>
		<cfset newView.item = arguments.item>
		<cfset arrayAppend(request.view, newView)>
	</cffunction>

	<cffunction name="cache">
		<cfargument name="section" required="true" type="string">

		<cfif isDefined('application.cache.#arguments.section#')>
	  		<cfreturn application.cache[arguments.section]>
		<cfelse>
  			<cfthrow detail="application.cache.#arguments.section# does not exist in the cache" message="there is no section #arguments.section#">
		</cfif>
	</cffunction>

	<cffunction name="cacheExists">
		<cfargument name="section" required="true" type="string">

		<cfreturn structKeyExists(application.cache, arguments.section)>
	</cffunction>

	<cffunction name="checkCache" returntype="void">
		<cfargument name="section" required="true" type="string">

		<cfif not cacheExists(arguments.section) or application.fwDefault.reloadApplicationOnEveryRequest>
  			<cfset setupSectionCache(arguments.section)>
		</cfif>
	</cffunction>

	<cffunction name="context">
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

	<cffunction name="dotPath" returntype="String">
		<cfargument name="filePath" required="true" type="string">

		<cfset var result = replaceNoCase(filePath, application.path, '')>
  		<cfset result = replace(result, '\', '/', "all")>
		<cfset result = listDeleteAt(result, listLen(result, '.'), '.')>
		<cfset result = listChangeDelims(result, '.', '/')>

  		<cfreturn result>
	</cffunction>

	<cffunction name="ignoredPath" returntype="boolean">
		<cfargument name="sectionName" required="true" type="string">

  		<cfreturn application.fwDefault.ignoredPaths contains arguments.sectionName>
	</cffunction>

	<cffunction name="onApplicationStart" output="true">
		<cfset application.path = getDirectoryFromPath(getBaseTemplatePath())>
  		<cfset application.path = replace(application.path, '\', '/', "all")>

		<cfif CGI.HTTPS is 'on'>
			<cfset application.URL = 'https://'>
   		<cfelse>
			<cfset application.URL = 'http://'>
		</cfif>
		<cfset application.URL &= CGI.HTTP_HOST & '/'>

 		<cfset application.fwDefault = structNew()>

		<cfset application.fwDefault.defaultSection = 'main'>
		<cfset application.fwDefault.actionDelimiter = '.'>
		<cfset application.fwDefault.defaultItem = 'default'>
		<cfset application.fwDefault.defaultAction = application.fwDefault.defaultSection & application.fwDefault.actionDelimiter & application.fwDefault.defaultItem>

		<cfset application.fwDefault.reloadApplicationOnEveryRequest = true>

  		<cfset application.fwDefault.reloadKey = 'restart'>
  		<cfset application.fwDefault.reloadVal = 'goober'>

		<cfset application.fwDefault.ignoredPaths = 'tests'>

  		<cfif fileExists(application.path & 'layout.cfm')>
			<cfset application.fwDefault.layoutPages = true>
   		<cfelse>
			<cfset application.fwDefault.layoutPages = false>
		</cfif>

		<cfset application.cache = structNew()>
		<cfset setupApplicationCache()>

		<cfif isDefined('setupApplication') and isCustomFunction(setupApplication)>
			<cfset setupApplication(fw=this)>
		</cfif>
	</cffunction>

	<cffunction name="onApplicationEnd">
		<cfargument name="applicationScope">

		<cfif isDefined('teardownApplication') and isCustomFunction(teardownApplication)>
			<cfset teardownApplication(fw=this)>
		</cfif>
	</cffunction>

	<cffunction name="onError" returnType="void">
	    <cfargument name="Exception" required="true">
	    <cfargument name="EventName" type="String" required="true">

		<div style="border: double red;">
		<cfdump var="#arguments#">
	</cffunction>

	<cffunction name="onMissingTemplate" returnType="boolean">
	    <cfargument type="string" name="targetPage" required=true>

	    <cfreturn true>
	</cffunction>

	<cffunction name="onRequestStart" output="true" returnType="boolean">
	    <cfargument type="String" name="targetPage" required=true>

		<cfset request.action = structNew()>
		<cfset request.context = structNew()>
		<cfset request.service = structNew()>

		<cfset request.context = structCopy(URL)>
		<cfset structAppend(request.context, structCopy(form))>
		<cfparam name="request.context.action" default="#application.fwDefault.defaultAction#">

		<cfset request.item = listLast(request.context.action, application.fwDefault.actionDelimiter)>
		<cfset request.section = listFirst(request.context.action, application.fwDefault.actionDelimiter)>

		<cfif application.fwDefault.reloadApplicationOnEveryRequest>
			<cfset onApplicationStart()>
		</cfif>

		<cfif isDefined('request.context.#application.fwDefault.reloadKey#') and (request.context[application.fwDefault.reloadKey] is application.fwDefault.reloadVal)>
			<cfset onApplicationStart()>
		</cfif>

		<cfif not ignoredPath(request.section)>
			<cfset setupSectionCache(request.section)>

			<cfset request.action = cache(request.section)>

			<cfif isDefined('request.action.service')>
	  			<cfset request.service = request.action.service>
			</cfif>

			<cfset request.view = arrayNew(1)>
			<cfset setView(request.section, request.item)>

			<cfif isDefined('setupRequest') and isCustomFunction(setupRequest)>
				<cfset setupRequest(fw=this, context=request.context, service=request.service)>
			</cfif>
		</cfif>

	    <cfreturn true>
	</cffunction>

	<cffunction name="onRequest" output="true" returnType="void">
	    <cfargument name="targetPage" type="String" required=true>

		<cfset var controller = ''>
	 	<cfset var thisView = "">

<cfdump var="#request#">

		<cfif ignoredPath(request.section)>
			<cfinclude template="#arguments.targetPage#">
		<cfelse>
			<cfif isDefined('application.cache.#request.section#.before')>
	  			<cfset beforeModule = application.cache[request.section].before>
				<cfinclude template="#beforeModule#">
			</cfif>

			<cfif isDefined('application.setup') and isDefined('application.setup.#request.section#')>
				<cfinvoke component="application.setup" method="#request.section#" fw=this context=request.context service=request.service>
			</cfif>

			<cfif isDefined('request.view')>
				<cfoutput>
					<cfloop array="#request.view#" index="thisView">#view(thisView.section, thisView.item, true)#</cfloop>
				</cfoutput>
			</cfif>

			<cfif isDefined('application.teardown') and isDefined('application.teardown.#request.section#')>
				<cfinvoke component="application.teardown" method="#request.section#" fw=this context=request.context service=request.service>
			</cfif>

			<cfif isDefined('application.cache.#request.section#.after')>
	  			<cfset afterModule = application.cache[request.section].after>
				<cfinclude template="#afterModule#">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="onRequestEnd" returnType="void">
	    <cfargument type="String" name="targetPage" required=true/>

		<cfif not ignoredPath(request.section)>
			<cfif isDefined('teardownRequest') and isCustomFunction(teardownRequest)>
				<cfset teardownRequest(fw=this, context=request.context, service=request.service)>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="onSessionStart" returnType="void">
 		<cfif isDefined('setupSession') and isCustomFunction(setupSession)>
	 		<cfset setupSession(fw=this)>
		</cfif>
	</cffunction>

	<cffunction name="onSessionEnd" returnType="void">
	    <cfargument name="SessionScope" required=True>
	    <cfargument name="ApplicationScope" required=False>

 		<cfif isDefined('teardownSession') and isCustomFunction(teardownSession)>
	 		<cfset teardownSession(fw=this)>
		</cfif>
	</cffunction>

	<cffunction name="sectionExists" returntype="boolean">
		<cfargument name="section" required="true" type="string">

  		<cfif directoryExists(application.path & arguments.section)>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<cffunction name="setupApplicationCache">
		<cfif fileExists(application.path & 'before.cfc')>
  			<cfobject type="component" name="application.before" component="before">
		</cfif>

		<cfif fileExists(application.path & 'after.cfc')>
  			<cfobject type="component" name="application.after" component="after">
		</cfif>
	</cffunction>

	<cffunction name="setupSectionCache">
		<cfargument name="sectionName" required="true" type="string">

		<cfset var sectionPath = application.path & arguments.sectionName & '/'>
  		<cfset sectionPath = replace(sectionPath, '\', '/', "all")>

		<cfset var servicePath = sectionPath & 'service.cfc'>
		<cfset var setupPath = sectionPath & 'setup.cfc'>
		<cfset var beforePath = sectionPath & 'before.cfm'>
  		<cfset var layoutPath = sectionPath & 'layout.cfm'>
		<cfset var viewPath = sectionPath & 'view.cfc'>
		<cfset var afterPath = sectionPath & 'after.cfm'>
		<cfset var teardownPath = sectionPath & 'teardown.cfc'>

		<cfset var beforeExists = fileExists(beforePath)>
		<cfset var serviceExists = fileExists(servicePath)>
		<cfset var setupExists = fileExists(setupPath)>
  		<cfset var layoutExists = fileExists(layoutPath)>
		<cfset var viewExists = fileExists(viewPath)>
		<cfset var teardownExists = fileExists(teardownPath)>
		<cfset var afterExists = fileExists(afterPath)>

		<cfif serviceExists or setupExists or viewExists or teardownExists>
			<cfset application.cache[arguments.sectionName] = structNew()>
			<cfset application.cache[arguments.sectionName].path = sectionPath>

			<cfif serviceExists>
   				<cftry>
	   				<cfobject type="component" name="application.cache.#arguments.sectionName#.service" component="#dotPath(servicePath)#">
   					<cfcatch type="any">
   						<cfthrow detail="Error instantiating service component #dotPath(servicePath)#">
   					</cfcatch>
   				</cftry>
			</cfif>

			<cfif beforeExists>
				<cfset application.cache[arguments.sectionName].before = beforePath>
			</cfif>

			<cfif setupExists>
   				<cftry>
	   				<cfobject type="component" name="application.cache.#arguments.sectionName#.setup" component="#dotPath(setupPath)#">
   					<cfcatch type="any">
   						<cfthrow detail="Error instantiating setup component #dotPath(setupPath)#">
   					</cfcatch>
   				</cftry>
			</cfif>

			<cfif layoutExists>
				<cfset application.cache[arguments.sectionName].layout = layoutPath>
			</cfif>

			<cfif viewExists>
   				<cftry>
	   				<cfobject type="component" name="application.cache.#arguments.sectionName#.view" component="#dotPath(viewPath)#">
   					<cfcatch type="any">
   						<cfthrow detail="Error instantiating view component #dotPath(viewPath)#">
   					</cfcatch>
   				</cftry>
			</cfif>

			<cfif teardownExists>
   				<cftry>
	   				<cfobject type="component" name="application.cache.#arguments.sectionName#.teardown" component="#dotPath(teardownPath)#">
   					<cfcatch type="any">
   						<cfthrow detail="Error instantiating teardown component #dotPath(teardownPath)#">
   					</cfcatch>
   				</cftry>
			</cfif>

			<cfif afterExists>
				<cfset application.cache[arguments.sectionName].after = afterPath>
			</cfif>
		<cfelseif not (serviceExists or setupExists or viewExists or teardownExists)>
  			<cfthrow detail="section #arguments.sectionName# is empty or non-existent" message="no section #arguments.sectionName#">
		</cfif>
	</cffunction>

	<cffunction name="setView" returntype="void">
		<cfargument name="section" required="true" type="string">
		<cfargument name="item" required="true" type="string">

		<cfset var thisView = structNew()>
  		<cfset thisView.section = arguments.section>
  		<cfset thisView.item = arguments.item>

		<cfset request.view[1] = thisView>
	</cffunction>

	<cffunction name="view" output="true">
		<cfargument name="section" required="true" type="string">
		<cfargument name="item" required="true" type="string">
		<cfargument name="doLayout" default="false" type="boolean">

		<cfset var layoutExists = isDefined('action.layout')>
  		<cfset var requiredServices = ''>
		<cfset var serviceMethod = ''>
		<cfset var viewExists = isDefined('action.view.#arguments.item#')>
  		<cfset var viewMetadata = ''>

		<cfset checkCache(request.section)>

		<cfset var action = cache(arguments.section)>

		<cfif viewExists>
			<cfset var thisView = action.view[arguments.item]>

			<cfset viewMetadata = getMetadata(thisView)>
			<cfif isDefined('viewMetadata.service')>
				<cfset requiredServices = viewMetadata.service>
			<cfelseif isDefined('viewMetadata.services')>
				<cfset requiredServices = viewMetadata.services>
			</cfif>
		</cfif>

		<cfif len(requiredServices)>
			<cfloop list="#requiredServices#" index="serviceMethod">
	  			<cftry>
	   				<cfinvoke component="#action.service#" method="#serviceMethod#" returnvariable="request.context.#serviceMethod#" argumentcollection="#request.context#">

	  				<cfcatch type="any">
	  					<cfthrow message="unable to invoke #serviceMethod#" detail="section: #arguments.section#; item: #arguments.item#; method: #serviceMethod#">
	  				</cfcatch>
	  			</cftry>
			</cfloop>
		</cfif>

		<cfif isDefined('action.setup.#arguments.item#')>
			<cfset var setupFn = action.setup[arguments.item]>
   			<cfset setupFn(context=request.context, service=request.service)>
		</cfif>

		<cfif viewExists and layoutExists and arguments.doLayout>
			<cfmodule template="#action.layout#">
				#thisView(context=request.context, service=request.service)#
  			</cfmodule>
  		<cfelseif viewExists>
			#thisView(context=request.context, service=request.service)#
  		</cfif>
	</cffunction>
</cfcomponent>

<!---
	Application Structure:
		Application.cfc
		bracketry.cfc
		bracketry.js
		index.cfm (must be blank)
		request.cfm
		layout.cfm
		dev_section
			layout.cfm
			service.cfc
			before.cfm
			setup.cfc
			view.cfc
			teardown.cfc
			after.cfm

		setupApplication()
			setupSession()
				<global_request>
					<global_layout>
						<section_action>
							<section_layout>
								<item_action>
									<item_view fw=this context=request.context service=request.service />
								</item_action>
							</section_layout>
						</section_action>
					</global_layout>
				<global_request>
			teardownSession()
		teardownApplication()

	Each plugin should be self-contained
 --->
