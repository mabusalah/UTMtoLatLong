<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Test API</title>
</head>

<body>

<cftry>
	<cfoutput>
        <table align="center" width="50%">
        <tr><td align="center">Convert</td></tr>
		<form action="" method="post">
           	<tr><td align="center">Northing</td><td align="center"><input name="northing" size="15"></td></tr>
           	<tr><td align="center">Easting</td><td align="center"><input name="easting" size="15"></td></tr>
			<tr><td align="center">North/South Equator</td><td align="center"><select name="equator"><option value="N">North</option><option value="S">South</option></select></td></tr>
            <tr><td align="center">Zone:</td><td align="center"><select name="zone"><cfloop from="1" to="60" index="i"><cfoutput><option value="#i#">#i#</option></cfoutput></cfloop></select></td></tr>
            <tr><td align="left"><input  type="submit" value="Convert" name="Convert"></td></tr>
  	    </form>
        </table>
	</cfoutput>
<cfcatch type="any">
</cfcatch>
</cftry>

<cfif isdefined("form.Convert") and form.Convert NEQ "">

<cfhttp url="converttolatlon.cfc" method="post" username="username" password="password" result="conv">
				<cfhttpparam name="method" type="formfield" value="convert">
                <cfhttpparam name="NSLatitude" type="formfield" value="#form.equator#">
				<cfhttpparam name="LongitudeZone" type="formfield" value="#form.zone#">
                <cfhttpparam name="Northing" type="formfield" value="#form.northing#">
                <cfhttpparam name="Easting" type="formfield" value="#form.easting#">
                
</cfhttp>
<cfoutput>#conv.filecontent#</cfoutput>
</cfif>
</body>
</html>