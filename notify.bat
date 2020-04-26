@if(@X)==(@Y) @end /* JScript comment
@echo off

setlocal
del /q /f %~n0.exe >nul 2>&1
for /f "tokens=* delims=" %%v in ('dir /b /s /a:-d  /o:-n "%SystemRoot%\Microsoft.NET\Framework\*jsc.exe"') do (
   set "jsc=%%v"
)

if not exist "%~n0.exe" (
    "%jsc%" /nologo /out:"%~n0.exe" "%~dpsfnx0"
)

if exist "%~n0.exe" (
    "%~n0.exe" %*
)

endlocal & exit /b %errorlevel%

end of jscript comment*/

import System;
import System.Windows;
import System.Windows.Forms;
import System.Drawing;
import System.Drawing.SystemIcons;

// ex: call notify.bat -tooltip warning -time 3000 -title "Woow" -text "Boom" -icon question

var arguments: String[] = Environment.GetCommandLineArgs();

var tooltips = {
    "error": System.Windows.Forms.ToolTipIcon.Error,
    "none": System.Windows.Forms.ToolTipIcon.None,
    "warning": System.Windows.Forms.ToolTipIcon.Warning,
    "info": System.Windows.Forms.ToolTipIcon.Info
};

var icons = {
    "hand" : System.Drawing.SystemIcons.Hand,
    "application" : System.Drawing.SystemIcons.Application,
    "asterisk" : System.Drawing.SystemIcons.Asterisk,
    "error" : System.Drawing.SystemIcons.Error,
    "exclamation" : System.Drawing.SystemIcons.Exclamation,
    "information" : System.Drawing.SystemIcons.Information,
    "question" : System.Drawing.SystemIcons.Question,
    "shield" : System.Drawing.SystemIcons.Shield,
    "warning" : System.Drawing.SystemIcons.Warning,
    "winlogo" : System.Drawing.SystemIcons.WinLogo
};

function getKeys(obj) {var z = ""; for (var k in obj) z += k + "|"; return z.substring(0,z.length-1)}

function printHelp() {
    print(arguments[0] + " [-tooltip "+getKeys(tooltips)+"] [-time milliseconds] [-title title] [-text text] [-icon "+getKeys(icons)+"]");
}

var notification = new System.Windows.Forms.NotifyIcon();

var tooltip = null;
var timeInMS: Int32 = 5000;

notification.Icon = System.Drawing.SystemIcons.Hand;
notification.BalloonTipText = "Warning";
notification.BalloonTipTitle = "";
notification.Visible = true;

if (arguments.length == 1 || arguments[1] == "-help") {
	printHelp();
	Environment.Exit(0);
}

if (arguments.length % 2 == 0) {
	print("Wrong number of arguments");
	Environment.Exit(1);
}

var patterns = {
	"-text": function(arg) {notification.BalloonTipText = arg;},
	"-title": function(arg) {notification.BalloonTipTitle = arg;},
	"-time": function(arg) {timeInMS = isNaN(parseInt(arg)) ? 2000 : parseInt(arg)},
	"-tooltip": function(arg) {if(arg in tooltips) tooltip = tooltips[arg]; else print("Warning: invalid tooltip value: " + arg);},
	"-icon": function(arg) {if(arg in icons) notification.Icon = icons[arg]; else print("Warning: invalid icon value: " + arg);}
}

for (var i = 1; i < arguments.length - 1; i = i + 2) try {
		if(arguments[i] in patterns) patterns[arguments[i]](arguments[i + 1]); else Console.WriteLine("Invalid Argument " + arguments[i]);
	} catch (e) {
		print("Error Message: " + e.message + "\nError Code: " + (e.number & 0xFFFF) + "\nError Name: " + e.name);
		Environment.Exit(11);
	}

if (tooltip !== null) {
	notification.BalloonTipIcon = tooltip;
    notification.ShowBalloonTip(timeInMS, notification.BalloonTipTitle, notification.BalloonTipText, tooltip);
} else 
	notification.ShowBalloonTip(timeInMS);

System.Threading.Thread.Sleep((Int32)(timeInMS + 100));
notification.Dispose();
