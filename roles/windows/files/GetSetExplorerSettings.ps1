# ------------------------------------------------------------------------ 
# NAME: GetSetExplorerSettings.ps1 
# AUTHOR: ed wilson, Microsoft 
# DATE: 1/5/2009 
# 
# KEYWORDS: Get-Itemproperty, Set-Itemproperty 
# Registry, HSG 
# COMMENTS: This script uses psh cmdlets to get 
# and to set several values from the registry. The  
# one interesting thing is the way it retrieves an entire 
# registry key, stores it in a variable, and then uses 
# the properties directly. This avoids multiple reg 
# calls.  
# HSG 1/6/2009 
# 
# ------------------------------------------------------------------------ 
Param([switch]$get,[switch]$set) 
Function Get-ExplorerSettings() 
{ 
 $RegExplorer =  Get-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced 
"Display hidden files and folders is $($RegExplorer.SuperHidden)" 
"Hide File extensions is set to $($RegExplorer.HideFileExt)" 
"Show system files and folders is set to $($RegExplorer.ShowSuperHidden)" 
"Hide desktop icons $($RegExplorer.HideIcons)" 
"Use Web view for folders $($RegExplorer.WebView)" 
"Display correct file name capitalization $($RegExplorer.DontPrettyPath)" 
"Prevent automatically locate file shares and printers $($RegExplorer.NoNetCrawling)" 
} #end Get-ExplorerSettings 
 
Function Set-ExplorerSettings() 
{ 
 $RegValues = @{ 
                "SuperHidden" = 1 ; 
                "HideFileExt" = 0 ; 
                "ShowSuperHidden" = 0 ; 
                "HideIcons" = 0 ; 
                "WebView" = 0 ; 
                "DontPrettyPath" = 1 ; 
                "NoNetCrawling" = 1 
                                    } 
 $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" 
 ForEach ($key in $RegValues.Keys) 
  { 
    Set-ItemProperty -path $path -name $key -value $RegValues[$key] 
   "Setting $path $($key) to $($RegValues[$key])" 
  }  
 
} #end Set-ExplorerSettings 
# *** Entry Point to script *** 
 
if($get) { Get-ExplorerSettings } 
if($set) { Set-ExplorerSettings }
