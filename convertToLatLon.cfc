<--- --------------------------------------------------------------------------------------- ----
	
	Author: Dr. Abusalah	
	Date Posted:
	Feb 4, 2013 at 10:15 AM
	About: Convert Easting and Northing points to Latitude Longitude and returns JSON Format.
		   This code is based on the work of Steve Dutch https://stevedutch.net/
	
---- --------------------------------------------------------------------------------------- --->


<cfcomponent
	output="false"
	hint="I am a remote-access testing component.">
 
	<!---
		Set up required credentials for API calls.
 
		NOTE: This is not really the place to do this, but I am
		doing this for the demo. Normally, you would want this
		in some sort of application-centric area or management
		system integration.
	--->
	<cfset THIS.Credentials = {
		Username = "username",
		Password = "password"
		} />
 
 
	<!--- ------------------------------------ --->
 
 
	<!--- Check request authorization for every request. --->
	<cfset THIS.CheckAuthentication() />
 
 
	<cffunction
		name="CheckAuthentication"
		access="public"
		returntype="void"
		output="false"
		hint="I check to see if the request is authenticated. If not, then I return a 401 Unauthorized header and abort the page request.">
 
		<!---
			Check to see if user is authorized. If NOT, then
			return a 401 header and abort the page request.
		--->
		<cfif NOT THIS.CheckAuthorization()>
 
			<!--- Set status code. --->
			<cfheader
				statuscode="401"
				statustext="Unauthorized"
				/>
 
			<!--- Set authorization header. --->
			<cfheader
				name="WWW-Authenticate"
				value="basic realm=""API"""
				/>
 
			<!--- Stop the page from loading. --->
			<cfabort />
 
		</cfif>
 
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
 
	<cffunction
		name="CheckAuthorization"
		access="public"
		returntype="boolean"
		output="false"
		hint="I check to see if the given request credentials match the required credentials.">
 
		<!--- Define the local scope. --->
		<cfset var LOCAL = {} />
 
		<!---
			Wrap this whole thing in a try/catch. If any of it
			goes wrong, then the credentials were either non-
			existent or were not in the proper format.
		--->
		<cftry>
 
			<!---
				Get the authorization key out of the header. It
				will be in the form of:
 
				Basic XXXXXXXX
 
				... where XXXX is a base64 encoded value of the
				users credentials in the form of:
 
				username:password
			--->
			<cfset LOCAL.EncodedCredentials = ListLast(
				GetHTTPRequestData().Headers.Authorization,
				" "
				) />
 
			<!---
				Convert the encoded credentials from base64 to
				binary and back to string.
			--->
			<cfset LOCAL.Credentials = ToString(
				ToBinary( LOCAL.EncodedCredentials )
				) />
 
			<!--- Break up the credentials. --->
			<cfset LOCAL.Username = ListFirst( LOCAL.Credentials, ":" ) />
			<cfset LOCAL.Password = ListLast( LOCAL.Credentials, ":" ) />
 
			<!---
				Check the users request credentials against the
				known ones on file.
			--->
			<cfif (
				(LOCAL.Username EQ THIS.Credentials.Username) AND
				(LOCAL.Password EQ THIS.Credentials.Password)
				)>
 
				<!--- The user credentials are correct. --->
				<cfreturn true />
 
			<cfelse>
 
				<!--- The user credentials are not correct. --->
				<cfreturn false />
 
			</cfif>
 
 
			<!--- Catch any errors. --->
			<cfcatch>
 
				<!---
					Something went wrong somewhere with the
					credentials, so we have to assume user is
					not authorized.
				--->
				<cfreturn false />
 
			</cfcatch>
 
		</cftry>
	</cffunction>
 	<cffunction name="convert" access="remote" returntype="string" output="no" hint="Convert Easting and Northing points to Latitude Longitude and returns JSON Format">
		<cfargument name="NSLatitude" type="string" required="yes" default="N" hint="Please enter whether your location is North or South the Equator">
        <cfargument name="LongitudeZone" type="numeric" required="yes" hint="Please enter the Zone Number UTM">
        <cfargument name="Northing" type="numeric" required="yes">
        <cfargument name="Easting" type="numeric" required="yes">
        <cfset coordinates=structnew()>
        <!--- Constants Definition --->
		<!--- Scale --->
		<cfset k0=0.9996>
        <!--- ecc --->
        <cfset e=0.081819191>
        <!--- Equ Rad --->
        <cfset a=6378137>
        <!--- e'2 --->
        <cfset e1sq=0.006739497>
        <!--- Calculate Footprint Latitude --->
        <cfset e1 = 0.00167922>
        <cfset C1 = 0.002518827>	
        <cfset C2 = 3.70095E-06>
        <cfset C3 = 7.44781E-09>	
        <cfset C4 = 1.7036E-11>
        <!--- Corrected Northing--->
		<cfif NSLatitude is "N">
            <cfset CNorthing=Northing>
        <cfelse>
            <cfset CNorthing=10000000-Northing>
        </cfif>
        
        <!--- East Prime --->
        <cfset EastPrime=500000-Easting>
        
        <!--- Arc Length --->
        <cfset ArcLength=CNorthing/k0>
        
        <!--- mu --->
        <cfset mu=ArcLength/(a*(1-e^2/4-3*e^4/64-5*e^6/256))>
        
        <!--- Footprint Latitude (phi) --->
        <cfset phi=mu+C1*SIN(2*mu)+C2*SIN(4*mu)+C3*SIN(6*mu)+C4*SIN(8*mu)>
        
        <!--- C1 --->
        <cfset C01=e1sq*COS(phi)^2>
        
        <!--- T1 --->
        <cfset T1=TAN(phi)^2>
        
        <!--- N1 --->
        <cfset N1=a/(1-(e*SIN(phi))^2)^(1/2)>
        
        <!--- R1 --->
        <cfset R1=a*(1-e*e)/(1-(e*SIN(phi))^2)^(3/2)>
        
        <!--- D --->
        <cfset D=EastPrime/(N1*k0)>
        
        <!--- Fact 1 --->
        <cfset Fact1=N1*TAN(phi)/R1>
        
        <!--- Fact 2 --->
        <cfset Fact2=D*D/2>
        
        <!--- Fact 3 --->
        <cfset Fact3=(5+3*T1+10*C01-4*C01*C01-9*e1sq)*D^4/24>
        
        <!--- Fact 4 --->
        <cfset Fact4=(61+90*T1+298*C01+45*T1*T1-252*e1sq-3*C01*C01)*D^6/720>
        
        <!--- LoFact 1--->
        <cfset LoFact1=D>
        
        <!--- LoFact 2--->
        <cfset LoFact2=(1+2*T1+C01)*D^3/6>
        
        <!--- LoFact 3 --->
        <cfset LoFact3=(5-2*C01+28*T1-3*C01^2+8*e1sq+24*T1^2)*D^5/120>
        
        <!--- Delta-Long --->
        <cfset DeltaLong=(LoFact1-LoFact2+LoFact3)/COS(phi)>
        
        <!--- Zone CM --->
        <cfset ZoneCM=6*LongitudeZone-183>
        
        <!--- Raw Latitude --->
        <cfset RawLatitude=180*(phi-Fact1*(Fact2+Fact3+Fact4))/PI()>
        
        <!--- Latitude --->
        <cfif NSLatitude is "N">
            <cfset coordinates.Latitude=RawLatitude>
        <cfelse>
            <cfset coordinates.Latitude=-RawLatitude>
        </cfif>
        
        <!--- Longitude --->
        <cfset coordinates.Longitude=ZoneCM-DeltaLong*180/PI()>
        <cfset coordinates.Degrees.LatDegrees=fix(coordinates.Latitude)>
        <cfset coordinates.Degrees.LatMinutes=ABS(INT(60*(coordinates.Latitude-coordinates.Degrees.LatDegrees)))>
        <cfset coordinates.Degrees.LatSecond=3600*(ABS(coordinates.Latitude)-ABS(coordinates.Degrees.LatDegrees)-coordinates.Degrees.LatMinutes/60)>
        <cfset coordinates.Degrees.LonDegrees=fix(coordinates.Longitude)>
        <cfset coordinates.Degrees.LonMinutes=INT(ABS((60*(coordinates.Longitude-coordinates.Degrees.LonDegrees))))>
        <cfset coordinates.Degrees.LonSecond=3600*(ABS(coordinates.Longitude)-ABS(coordinates.Degrees.LonDegrees)-coordinates.Degrees.LonMinutes/60)>
		<cfset myResult=SerializeJSON(coordinates)>
		<cfreturn myResult>
	</cffunction>

</cfcomponent>