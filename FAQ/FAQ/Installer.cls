Include %occInclude

/// %Installer Manifest FAQ.Installer
Class FAQ.Installer
{

/// �}�j�t�F�X�g��`.
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

/// ����� XGL �ɂ�萶�����ꂽ���\�b�h�E�W�F�l���[�^�[�ł��B.
ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
 #; XGL �h�L�������g�ł��̃��\�b�h�̃R�[�h�𐶐�����.
 Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "FAQManifest")
}

// envID(��ID)�F�N���E�h(�{��)����1�Ajpnfilesrv��2�A�N���E�h(�e�X�g)����3�A���̑���4

// setuptype�F�����Z�b�g�A�b�v��1�A�X�V��2

// datestr�F�Z�b�g�A�b�v�L�b�g�̃f�B���N�g�����Ɏg�������t(YYYYMMDD)�@���f�B���N�g�����������̓��t�̏ꍇ�͋��OK

ClassMethod runInstaller(datestr As %String) As %Status
{
	write "�����s����Ώۂ�envID����͂��Ă��������B",!,"  [�N���E�h(�{��)����1�Ajpnfilesrv��2�A�N���E�h(�e�X�g)����3�A���̑���4]�F",!
	read envID,!
	
	write "��setuptype����͂��Ă��������B[setuptype�F�����Z�b�g�A�b�v��1�A�f�[�^�ƃ\�[�X�̍X�V��2�A�f�[�^�̂ݍX�V��3�A�A�v���P�[�V�����\�[�X�̂ݍX�V��4]�F",!
	read setuptype,!
	
	if envID=1 {
		set envname="�N���E�h(�{��)��"
	}elseif envID=2 {
		set envname="jpnfilesrv"
	}elseif envID=3 {
		set envname="�N���E�h(�e�X�g)��"
	}else {
		set envname="���̑���"
	}
	
	if setuptype=1 {
		set setuptypename="�����Z�b�g�A�b�v"
	} elseif setuptype=2 {
		set setuptypename="�f�[�^�ƃ\�[�X�̍X�V"
	} elseif setuptype=3 {
		set setuptypename="�f�[�^�̂ݍX�V"
	} elseif setuptype=4 {
		set setuptypename="�A�v���P�[�V�����\�[�X�̂ݍX�V"
	}
	
	write envname_" �� "_setuptypename_" �����s���܂��B��낵���ł����H(Y/N)�F"
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
	    	w vars("ClassFileName"),"�͑��݂��܂���B�t�@�C�����m�F���Ă��������B",!
	    	quit 0
    	}
    	
    	if (vars("GlobalFileName")'="") && (##class(%File).Exists(vars("GlobalFileName"))'= 1) {
    		w vars("GlobalFileName"),"�͑��݂��܂���B�t�@�C�����m�F���Ă��������B",!
	    	quit 0
    	}
    
		do ..setup(.vars,3)
		
	}else{
		w !,"Installer�̎��s�𒆎~���܂���"
	}
	
	w "Installer�̎��s���������܂���",!
}

ClassMethod getVersion() As %String
{
	quit "1.0.004"
}

}