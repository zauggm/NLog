# restore and builds all projects as release.
# creates NuGet package at \artifacts
dotnet --version

# dotnet restore .\src\NLog\
# dotnet pack .\src\NLog\  --configuration release --include-symbols -o ..\..\artifacts

$versionPrefix = "4.5.11"
$versionSuffix = ""
$versionFile = $versionPrefix + "." + ${env:APPVEYOR_BUILD_NUMBER}
$versionProduct = $versionPrefix;
if (-Not $versionSuffix.Equals(""))
	{ $versionProduct = $versionProduct + "-" + $versionSuffix }

if ($env:APPVEYOR_PULL_REQUEST_NUMBER)
{
   $versionPrefix = $versionPrefix + "." + ${env:APPVEYOR_BUILD_NUMBER}
   $versionSuffix = "PR" + $env:APPVEYOR_PULL_REQUEST_NUMBER
}

# download nuget.exe

$sourceNugetExe = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
$targetNugetExe = "tools\nuget.exe"
Invoke-WebRequest $sourceNugetExe -OutFile $targetNugetExe

msbuild /t:Restore,Pack .\src\NLog\ /p:targetFrameworks='"net45;net40-client;net35;netstandard1.3;netstandard1.5;netstandard2.0;sl4;sl5;wp8;monoandroid44;xamarinios10"' /p:VersionPrefix=$versionPrefix /p:VersionSuffix=$versionSuffix /p:FileVersion=$versionFile /p:ProductVersion=$versionProduct /p:Configuration=Release /p:IncludeSymbols=true /p:PackageOutputPath=..\..\artifacts /verbosity:minimal
if (-Not $LastExitCode -eq 0)
	{ exit $LastExitCode }

msbuild /t:Restore,Pack .\src\NLog.Extended\ /p:VersionPrefix=$versionPrefix /p:VersionSuffix=$versionSuffix /p:FileVersion=$versionFile /p:ProductVersion=$versionProduct /p:Configuration=Release /p:IncludeSymbols=true /p:PackageOutputPath=..\..\artifacts /verbosity:minimal
if (-Not $LastExitCode -eq 0)
	{ exit $LastExitCode }

msbuild /t:Restore,Pack .\src\NLog.Wcf\ /p:VersionPrefix=$versionPrefix /p:VersionSuffix=$versionSuffix /p:FileVersion=$versionFile /p:ProductVersion=$versionProduct /p:Configuration=Release /p:IncludeSymbols=true /p:PackageOutputPath=..\..\artifacts /verbosity:minimal
if (-Not $LastExitCode -eq 0)
	{ exit $LastExitCode }

msbuild /t:Restore,Pack .\src\NLog.WindowsEventLog\ /p:VersionPrefix=$versionPrefix /p:VersionSuffix=$versionSuffix /p:FileVersion=$versionFile /p:ProductVersion=$versionProduct /p:Configuration=Release /p:IncludeSymbols=true /p:PackageOutputPath=..\..\artifacts /verbosity:minimal
if (-Not $LastExitCode -eq 0)
	{ exit $LastExitCode }

msbuild /t:Restore,Pack .\src\NLog.WindowsIdentity\ /p:VersionPrefix=$versionPrefix /p:VersionSuffix=$versionSuffix /p:FileVersion=$versionFile /p:ProductVersion=$versionProduct /p:Configuration=Release /p:IncludeSymbols=true /p:PackageOutputPath=..\..\artifacts /verbosity:minimal
if (-Not $LastExitCode -eq 0)
	{ exit $LastExitCode }

msbuild /t:xsd /t:NuGetSchemaPackage /t:NuGetConfigPackage .\src\NLog.proj /p:Configuration=Release /p:BuildNetFX45=true /p:BuildVersion=$versionProduct /p:Configuration=Release /p:BuildLabelOverride=NONE /verbosity:minimal

exit $LastExitCode
