Include %occInclude

/// %Installer Manifest FAQ.Installer
Class FAQ.Installer
{

/// マニフェスト定義.
XData FAQManifest [ XMLNamespace = INSTALLER ]
{
<Manifest>

<Namespace Name="${NAMESPACE}" 
           Create="no">
<CSPApplication 
    Url="${CSPUrl}"
    Description=""
    Directory="${CSPDirectory}"
    Resource=""
    Grant="%DB_%DEFAULT"
    Recurse="true"
    LoginClass=""
    CookiePath="${CSPUrl}"
    AuthenticationMethods="${AuthenticationMethods}"
     CustomErrorPage="${CustomErrorPage}"/>
 <If Condition='$L("${ClassFileName}")>0'>
<Invoke Class="%SYSTEM.OBJ" Method="Load" CheckStatus="0" Return="RetVal"> 
    <Arg Value="${ClassFileName}"/>
    <Arg Value="ck"/>
</Invoke>
</If>
<If Condition='$L("${SetupType}")=1'>
<Invoke Class="KB.Setup" Method="masterSetup" CheckStatus="0" Return="RetVal"> 
</Invoke>
</If>
<If Condition='$L("${GlobalFileName}")>0'>
<Invoke Class="%SYSTEM.OBJ" Method="Load" CheckStatus="0" Return="RetVal"> 
    <Arg Value="${GlobalFileName}"/>
</Invoke>
</If>
<If Condition='$L("${KatakanaWordsFileName}")>0'>
<Invoke Class="%SYSTEM.OBJ" Method="Load" CheckStatus="0" Return="RetVal"> 
    <Arg Value="${KatakanaWordsFileName}"/>
</Invoke>
</If>
<Invoke Class="KB.Text" Method="ExcludeCommonTerms" CheckStatus="0" Return="RetVal"> 
    <Arg Value="100"/>
</Invoke>
<Invoke Class="KB.Topic" Method="%BuildIndices" CheckStatus="0" Return="RetVal"> 
</Invoke>
<!--
<If Condition='$L("${ResetTopicSubID}")>0'>
<Invoke Class="KB.Topic" Method="ResetTopicSubID" CheckStatus="0" Return="RetVal"> 
</Invoke>
</If>
-->
</Namespace>
</Manifest>
}

/// これは XGL により生成されたメソッド・ジェネレーターです。.
ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
 #; XGL ドキュメントでこのメソッドのコードを生成する.
 Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "FAQManifest")
}

// envID(環境ID)：クラウド(本番)環境＝1、jpnfilesrv＝2、クラウド(テスト)環境＝3、その他＝4

// setuptype：初期セットアップ＝1、更新＝2

// datestr：セットアップキットのディレクトリ名に使った日付(YYYYMMDD)　※ディレクトリ名が今日の日付の場合は空でOK

ClassMethod runInstaller(datestr As %String) As %Status
{
	write "★実行する対象のenvIDを入力してください。",!,"  [クラウド(本番)環境＝1、jpnfilesrv＝2、クラウド(テスト)環境＝3、その他＝4]：",!
	read envID,!
	
	write "★setuptypeを入力してください。[setuptype：初期セットアップ＝1、データとソースの更新＝2、データのみ更新＝3、アプリケーションソースのみ更新＝4]：",!
	read setuptype,!
	
	if envID=1 {
		set envname="クラウド(本番)環境"
	}elseif envID=2 {
		set envname="jpnfilesrv"
	}elseif envID=3 {
		set envname="クラウド(テスト)環境"
	}else {
		set envname="その他環境"
	}
	
	if setuptype=1 {
		set setuptypename="初期セットアップ"
	} elseif setuptype=2 {
		set setuptypename="データとソースの更新"
	} elseif setuptype=3 {
		set setuptypename="データのみ更新"
	} elseif setuptype=4 {
		set setuptypename="アプリケーションソースのみ更新"
	}
	
	write envname_" の "_setuptypename_" を実行します。よろしいですか？(Y/N)："
	read answer,!
	
	if $zconvert(answer,"U") = "Y" {
		
		if setuptype=1 {
			do ##class(KB.Setup).setConfigParams(envID)
		}
		
		if $get(datestr)="" {
			set datestr=$zdate($h,8)
		}
		
		set setupdir = ^Techinfo("SetupDirectory")_^Techinfo("DirectorySeparator")_datestr_^Techinfo("DirectorySeparator")
		
		if setuptype=1 {
			set vars("ClassFileName") = setupdir_^Techinfo("ClassFileName")
			set vars("GlobalFileName") = setupdir_^Techinfo("GlobalFileName")
		}elseif setuptype=2 {
			set vars("ClassFileName") = setupdir_^Techinfo("ClassFileName")
			set vars("GlobalFileName") = setupdir_^Techinfo("GlobalFileName")
		}elseif setuptype=3 {
			set vars("ClassFileName") = ""
			set vars("GlobalFileName") = setupdir_^Techinfo("GlobalFileName")
		}elseif setuptype=4 {
			set vars("ClassFileName") = setupdir_^Techinfo("ClassFileName")
			set vars("GlobalFileName") = ""
		}			
				
		set vars("SetupType")			  = setuptype
		set vars("NAMESPACE")			  = ^Techinfo("Namespace")
		set vars("CSPUrl")				  = ^Techinfo("CSPUrl") 
		set vars("CSPDirectory") 		  = ^Techinfo("CSPDirectory") 
		set vars("CustomErrorPage") 	  = ^Techinfo("ErrorPage")
		set vars("AuthenticationMethods") = ^Techinfo("AuthenticationMethods")
		set vars("KatakanaWordsFileName") = ^Techinfo("KatakanaWordsFileName")
		//set vars("ResetTopicSubID") 	  = ^Techinfo("ResetTopicSubID") 
    
    	if (vars("ClassFileName")'="") && (##class(%File).Exists(vars("ClassFileName"))'=1) {
	    	w vars("ClassFileName"),"は存在しません。ファイルを確認してください。",!
	    	quit 0
    	}
    	
    	if (vars("GlobalFileName")'="") && (##class(%File).Exists(vars("GlobalFileName"))'= 1) {
    		w vars("GlobalFileName"),"は存在しません。ファイルを確認してください。",!
	    	quit 0
    	}
    
		do ..setup(.vars,3)
		
	}else{
		w !,"Installerの実行を中止しました"
	}
	
	w "Installerの実行が完了しました",!
}

ClassMethod getVersion() As %String
{
	quit "1.0.004"
}

}
