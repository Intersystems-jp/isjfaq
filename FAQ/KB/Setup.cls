Class KB.Setup
{

ClassMethod createAccentTable()
{
	kill ^KB.accent
	set ^KB.accent("é") = "&eacute;"
	set ^KB.accent("à") = "&agrave;"
	set ^KB.accent("è") = "&egrave;"
	set ^KB.accent("ù") = "&ugrave;"
	set ^KB.accent("â") = "&acirc;"
	set ^KB.accent("ê") = "&ecirc;"
	set ^KB.accent("î") = "&icirc;"
	set ^KB.accent("ô") = "&ocirc;"
	set ^KB.accent("û") = "&ucirc;"
	set ^KB.accent("ë") = "&euml;"
	set ^KB.accent("ï") = "&iuml;"
	set ^KB.accent("ü") = "&uuml;"
	set ^KB.accent("ç") = "&ccedil;"
	set ^KB.accent("œ") = "&oelig;"
	set ^KB.accent("æ") = "&aelig;"
	set ^KB.accent("É") = "&Eacute;"
	set ^KB.accent("À") = "&Agrave;"
	set ^KB.accent("È") = "&Egrave;"
	set ^KB.accent("Ù") = "&Ugrave;"
	set ^KB.accent("Â") = "&Acirc;"
	set ^KB.accent("Ê") = "&Ecirc;"
	set ^KB.accent("Î") = "&Icirc;"
	set ^KB.accent("Ô") = "&Ocirc;"
	set ^KB.accent("Û") = "&Ucirc;"
	set ^KB.accent("Ë") = "&Euml;"
	set ^KB.accent("Ï") = "&Iuml;"
	set ^KB.accent("Ü") = "&Uuml;"
	set ^KB.accent("Ç") = "&Ccedil;"
	set ^KB.accent("Œ") = "&OElig;"
	set ^KB.accent("Æ") = "&AElig;"
}

ClassMethod setConfigParams(envID As %Integer) As %Status
{
	//運用パラメータ設定
	// envID(環境ID)：クラウド(本番)環境＝1、jpnfilesrv＝2、クラウド(テスト)環境＝3

	//クラウド(本番)環境
	if envID=1 {
		set ns = "FAQ"
		set auth = "64"		//認証なし
		set separator = "/"
		set cspdir = "/intersystems/cache/csp/faq"
		set cspurl = "/csp/faq"
		set ftpdir = "/intersystems/cache/csp/faq/downloads"
		set setupdir = "/usr/FAQsetup"
		set classfiledir = "FAQ"
		set globalfilename = "TopicD.xml"
		
	//jpnfilesrv
	} elseif envID=2 {
		set ns = "Knowledge"
		set auth = "32"		//パスワード認証
		set separator = "\"
		set cspdir = "D:\InterSystems\Ensemble\CSP\knowledge"
		set cspurl = "/csp/knowledge"
		set ftpdir = "D:\InterSystems\Ensemble\CSP\knowledge\downloads"
		set setupdir = "P:\Public\Tech\FAQ\NewKB\FAQsetup"
		set classfiledir = "FAQ"
		set globalfilename = "TopicD.xml"
		
	//クラウド(テスト)環境
	} elseif envID=3 {
		set ns = "FAQ"
		set auth = "64"
		set separator = "/"
		set cspdir = "/intersystems/cache/csp/user"
		set cspurl = "/csp/user"
		set ftpdir = "/intersystems/cache/csp/user/downloads"
		set setupdir = "/usr/FAQsetup"
		set classfiledir = "FAQ"
		set globalfilename = "TopicD.xml"
		
	//その他、ローカルに環境を作りたいときなどに使用(上の3つの内容を変更せずにここを利用)
	} else {
		set ns = "FAQ"
		set auth = "64"		
		set separator = "\"
		set cspdir = "c:\InterSystems\Ensemble\CSP\faq"
		set cspurl = "/csp/faq"
		set ftpdir = "c:\InterSystems\Ensemble\CSP\faq\downloads"
		set setupdir = "e:\Work\FAQ"
		set classfiledir = "FAQ"
		set globalfilename = "TopicD.xml"
	}
	
	do ##class(KB.Config).setAttachedFileName("Attached")
	do ##class(KB.Config).setMailSender("jpnsup@intersystems.com")
	do ##class(KB.Config).setSMTPServer("xxx.intersystems.com")
	do ##class(KB.Config).setStartYear("2003")
	do ##class(KB.Config).setNamespace(ns)
	do ##class(KB.Config).setAuthenticationMethods(auth)
	do ##class(KB.Config).setDirectorySeparator(separator)
	do ##class(KB.Config).setCSPDirectory(cspdir)
	do ##class(KB.Config).setCSPUrl(cspurl)
	do ##class(KB.Config).setErrorPage(cspurl_"/FAQ.FAQError.cls")
	do ##class(KB.Config).setFTPDirectory(ftpdir)
	do ##class(KB.Config).setSetupDirectory(setupdir)
	do ##class(KB.Config).setClassFileDir(classfiledir)
	do ##class(KB.Config).setGlobalFileName(globalfilename)

	quit $$$OK
}

ClassMethod masterSetup() As %Status
{
	//マスタ初期化
	do ##class(KB.Facility).Init()
	do ##class(KB.Version).Init()
	do ##class(KB.Platform).Init()
	do ##class(KB.Category).Init()
	do ##class(KB.Product).Init()
	quit $$$OK
}

ClassMethod copyDownloadFiles(pSetupDir As %String) As %Status
{
	//ダウンロードファイルをFTPディレクトリーにコピーする
	set ftpDir = ##class(KB.Config).getFTPDirectory()
	set dirSep = ##class(KB.Config).getDirectorySeparator()
	//ディレクトリがなければコピーしない
	if '##class(%File).Exists(pSetupDir_dirSep_"downloads") quit $$$OK
	
	set sourcedir = pSetupDir_dirSep_"downloads"
	set dest = ftpDir
	set overlay = 1
	set boolean = ##class(%File).CopyDir(sourcedir,dest,overlay)
	quit $$$OK  
}

ClassMethod copyImages(pSetupDir As %String) As %Status
{
	//参照用イメージファイルをimagesディレクトリーにコピーする
	set dirSep = ##class(KB.Config).getDirectorySeparator()
	//ディレクトリがなければコピーしない
	if '##class(%File).Exists(pSetupDir_dirSep_"images") quit $$$OK
	  
	set sourcedir = pSetupDir_dirSep_"images"
	set dest = ##class(KB.Config).getCSPDirectory()_dirSep_"images"
	set overlay = 1
	set boolean = ##class(%File).CopyDir(sourcedir,dest,overlay)  

	set sourcedir = pSetupDir_dirSep_"images"_dirSep_"background"
	set dest = ##class(KB.Config).getCSPDirectory()_dirSep_"images"_dirSep_"background"
	set overlay = 1
	set boolean = ##class(%File).CopyDir(sourcedir,dest,overlay)  

	set sourcedir = pSetupDir_dirSep_"images"_dirSep_"button"
	set dest = ##class(KB.Config).getCSPDirectory()_dirSep_"images"_dirSep_"button"
	set overlay = 1
	set boolean = ##class(%File).CopyDir(sourcedir,dest,overlay)  

	set sourcedir = pSetupDir_dirSep_"images"_dirSep_"logo"
	set dest = ##class(KB.Config).getCSPDirectory()_dirSep_"images"_dirSep_"logo"
	set overlay = 1
	set boolean = ##class(%File).CopyDir(sourcedir,dest,overlay)  

	set sourcedir = pSetupDir_dirSep_"images"_dirSep_"others"
	set dest = ##class(KB.Config).getCSPDirectory()_dirSep_"images"_dirSep_"others"
	set overlay = 1
	set boolean = ##class(%File).CopyDir(sourcedir,dest,overlay)
	
	quit $$$OK  
}

ClassMethod copyCSSs(pCSPFileDir As %String) As %Status
{
	//cssファイルをcspディレクトリーにコピーする
	set CSPDir = ##class(KB.Config).getCSPDirectory()
	set dirSep = ##class(KB.Config).getDirectorySeparator()
	//ディレクトリがなければコピーしない
	if '##class(%File).Exists(pCSPFileDir) quit $$$OK
	
	set from = pCSPFileDir_dirSep_"style.css"
	set to = CSPDir_dirSep  
    set status = ##class(%File).CopyFile(from,to)
       
	set from = pCSPFileDir_dirSep_"FAQ.js"
	set to = CSPDir_dirSep  
    set status = ##class(%File).CopyFile(from,to)
    
	set from = pCSPFileDir_dirSep_"styleedit.css"
	set to = CSPDir_dirSep  
    set status = ##class(%File).CopyFile(from,to)
    
	set from = pCSPFileDir_dirSep_"stylehowto.css"
	set to = CSPDir_dirSep  
    set status = ##class(%File).CopyFile(from,to)

    quit $$$OK
}

}
