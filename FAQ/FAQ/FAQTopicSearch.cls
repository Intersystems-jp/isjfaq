/// Created using the page template: タイトルページ
Class FAQ.FAQTopicSearch Extends %ZEN.Component.page
{

/// このページが属するアプリケーションのクラス名です。
Parameter APPLICATION = "FAQ.FAQApp";

/// このページの表示名です。
Parameter PAGENAME = "InterSystems FAQ";

/// ローカライズで使用されるドメインです。
Parameter DOMAIN;

/// Optional. This is the default value for the page's
/// <property>title</property>.
Parameter PAGETITLE = "InterSystems FAQ";

Property SearchOption As %String;

Property SearchId As %String;

Property SearchKey As %String;

Property SearchFacility As %String;

/// この Style ブロックにはページ固有のCSSスタイル定義が含まれます。
XData Style
{
<style type="text/css">

body {
	font-family:arial;
}

/* style for title bar */
#titlehgroup {
	background: url('images/background/header-gradient.gif');
	background-repeat: repeat-x;
	padding: 5px;
}

#title1 {
	color: #333399;
	font-family:arial;
	font-size: 33px;
	font-weight: bold;
	border: 0px;
}

#title2 {
	color: #333399;
	font-family:arial;
	font-size: 25px;
	border: 0px;
}

#tabGroup {
}

a:active {
	color:blue;
	font-weight:bold;
}

.link {
	font-size:14px;
}

.link:active {
	color:blue;
	font-weight:bold;
}


.expandoNode {
	font-size:16px;
	font-weight:bold;
}

.expandoNode a:hover {
	color:black;
	background:white;
}

.repeatingGroupSelected {
	color:#990099;
	background: #FFFFFF;
}

.checkboxCaption {
	font-size:0.9em;
}

#newTopicsGroup td {
	font-size:0.9em;
}

.searchLabel {
	font-size:16px;
}

.text {
	font-size:15px;
}
/* style for table pane */
#TopicTitleTable {
	border:1px solid #CCCCCC;
	color:blue;
}

#TopicTitleTable th {
	color: #30758C;
	font-size: 16px;
	font-family: arial;
	font-weight: bold;
	text-align: center;
	padding: 2px;
	overflow: hidden;
	background: #D4E0EF;
	background-image:  url('images/background/tblheader-gradient1.gif');;
	border:1px solid #CCCCCC;
	border-bottom-color:#30758C;
}

#TopicTitleTable td {
	height:2.5em;
	font-size: 15px;
	color:#30468C;
	border:1px solid #CCCCCC;
}

.tpEven {
	background: #F5F8FC;
	border:1px solid #CCCCCC;
}

.tpOdd {
	background: #FFFFFF;
	border:1px solid #CCCCCC;
}

#TopicTitleTable tr.tpSelected{
	color:darkblue;
	background:#FFFFCC;
	background-image:none;
}

.noteStyle {
	font-size:13px;
}

</style>
}

/// このXMLブロックはこのページのコンテンツを定義します。
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page id="page" xmlns="http://www.intersystems.com/zen" title="" height="100%">
<hgroup id="titlehgroup" width="99.3%">
<vgroup width="50%" align="left" height="100%">
<html align="left" ><a href="http://www.intersystems.co.jp" ><img src="images/logo/CompanyLogo.png" width="200" height="50" border="0"/></a></html>
</vgroup>
<vgroup width="50%" align="right" height="100%">
<html valign="bottom" align="right"><span id="title1" style="padding:0px 0px 0px 30px;">FAQ </span><span id="title2">(よくあるご質問)</span></html>
</vgroup>
</hgroup>
<hgroup id="tabhgroup" align="center" width="100%">
<vgroup id="tabvgroup" width="100%" height="100%">
<!-- <tabGroup id="tabGroup" showTabBar="true" showBody="true" width="100%" height="650px" onshowTab="zenPage.setTabSize();"> -->
<tabGroup id="tabGroup" showTabBar="true" showBody="true" width="100%" height="100%" >
<tab id="hometab" caption="Home" align="center" width="100%" height="100%">
<iframe id="homeframe" align="center" src="howto.CSP" width="99.8%" height="100%" scrolling="auto"/> 
</tab>
<tab id="gentab" caption="一般的質問" width="100%" height="100%">
<iframe id="genframe" align="center" src="FAQ.FAQTopicSearchBodyGeneral.cls" width="99.8%" height="100%" scrolling="auto"/> 
</tab>
<tab id="cachetab" caption="Caché" width="100%" height="100%">
<iframe id="cacheframe" align="center" src="FAQ.FAQTopicSearchBodyCache.cls" width="99.8%" height="100%" scrolling="auto"/> 
</tab>
<tab id="enstab" caption="Ensemble" width="100%" height="100%">
<iframe id="ensframe" align="center" src="FAQ.FAQTopicSearchBodyEnsemble.cls" width="99.8%" height="100%" scrolling="auto"/> 
</tab>
</tabGroup>
</vgroup>
</hgroup>
</page>
}

Method %OnAfterCreatePage() As %Status
{
	set admin = $roles["FAQAdministrator"
	set editor = $roles["FAQEditor"

	//テスト用
	//set admin=1
	//set editor=1
	
	if admin=1 {
		set %session.Data("roles")=1
	}elseif editor=1{
		set %session.Data("roles")=2
	}else {
		set %session.Data("roles")=0
	}

	if editor=1 {
		set homeframe=..%GetComponentById("homeframe")
		set homeframe.src= "howtoforeditors.csp"
	}	
		
	//FAQアプリへのアクセスカウント
	if $Get(%session.Data("Access"))="" {
		set ^AccessCount = $Increment(^AccessCount)
		set today=$zdate($h,8)
		set ^AccessCount(today) = $Increment(^AccessCount(today))
		set %session.Data("Access")=1
	}
	quit $$$OK
}

ClientMethod setTabSize() [ Language = javascript ]
{
	
	var tabgroup = zenPage.getComponentById('tabGroup');

	var winheight = zenGetWindowHeight();
				
	var titlehg = zenPage.getComponentById('titlehgroup');
	var divtitlehg = titlehg.getEnclosingDiv();
	var divtitleheight = divtitlehg.offsetHeight;
	
	var tabheight = winheight - divtitleheight - 30;
	
	var userAgent = window.navigator.userAgent.toLowerCase();
    var appVersion = window.navigator.appVersion.toLowerCase();
    
	/*
	if (userAgent.indexOf('msie') != -1 || userAgent.indexOf('trident') != -1) {
		if (appVersion.indexOf("msie 8.") != -1) {
		   tabgroup.setProperty('height',tabheight);
        } else if (appVersion.indexOf("msie 9.") != -1) {
		   tabgroup.setProperty('height',tabheight);
        } else if (appVersion.indexOf("msie 10.") != -1) {
		   tabgroup.setProperty('height',tabheight);
        } else if (appVersion.indexOf("rv:11.0") != -1) {
		   tabgroup.setProperty('height',tabheight);
        } else {
		   tabgroup.setBodySize(tabheight);
        }
	} else {
		tabgroup.setBodySize(tabheight);
	}
	*/
	
	tabgroup.setBodySize(tabheight);
}

ClientMethod onlayoutHandler(load) [ Language = javascript ]
{
	var tabgroup = zenPage.getComponentById('tabGroup');
	var gentab = zenPage.getComponentById('gentab');
	var cachetab = zenPage.getComponentById('cachetab');
	var enstab = zenPage.getComponentById('enstab');
	
	var homeframe = zenPage.getComponentById('homeframe');
	var genframe = zenPage.getComponentById('genframe');
	var cacheframe = zenPage.getComponentById('cacheframe');
	var ensframe = zenPage.getComponentById('ensframe');

	// find height of window
	var winheight = zenGetWindowHeight();
				
	// find divs for title & mainMenu
	var titlehg = zenPage.getComponentById('titlehgroup');
	var divtitlehg = titlehg.getEnclosingDiv();
	var divtitleheight = divtitlehg.offsetHeight;
	
	var tabheight = winheight - divtitleheight - 30;
	var frameheight = tabheight - 10;
	
	var userAgent = window.navigator.userAgent.toLowerCase();
    var appVersion = window.navigator.appVersion.toLowerCase();

	/*
	if (userAgent.indexOf('msie') != -1 || userAgent.indexOf('trident') != -1) {
		if (appVersion.indexOf("msie 8.") != -1) {
		   tabgroup.setProperty('height',tabheight);
        } else if (appVersion.indexOf("msie 9.") != -1) {
		   tabgroup.setProperty('height',tabheight);
        } else if (appVersion.indexOf("msie 10.") != -1) {
		   tabgroup.setProperty('height',tabheight);
        } else if (appVersion.indexOf("rv:11.0") != -1) {
		   tabgroup.setProperty('height',tabheight);
        } else {
		   tabgroup.setBodySize(tabheight);
        }
	} else {
		tabgroup.setBodySize(tabheight);
	}
	*/
	
	tabgroup.setBodySize(tabheight);
		
	homeframe.setProperty('height',frameheight);
	genframe.setProperty('height',frameheight);
	cacheframe.setProperty('height',frameheight);
	ensframe.setProperty('height',frameheight);
}

ClientMethod onresizeHandler() [ Language = javascript ]
{
	zenPage.setTabSize();
}

}