Include FAQ

/// Created using the page template: タイトルページ
Class FAQ.FAQTopicSearchBodyTemplate Extends %ZEN.Component.page [ Abstract ]
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

Property Product As %String;

Property SearchOption As %String;

Property SearchId As %String;

Property SearchKey As %String;

Property SearchFacility As %String;

Property crosschecked As %Boolean;

Property nonproduct As %Boolean;

Property cache As %Boolean;

Property ensemble As %Boolean;

/// この Style ブロックにはページ固有のCSSスタイル定義が含まれます。
XData Style
{
<style type="text/css">

/* style for title bar */

body {
	font-family:arial;
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

#LeftVgroup {
	border-right:1px solid gray;
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

table.tpTable tbody tr {
	height:1em;
}

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
<page xmlns="http://www.intersystems.com/zen" title="">
<hgroup id="WholeHgroup">
<vgroup id="LeftVgroup" valign="top" width="25%" height="100%">
<spacer height="20" />
<hgroup height="50%" valign="top">
<spacer width="20" />
<expando id="frequentTree" caption="特に参照の多いトピック" expanded="true" childIndent="20px" remember="false" imageExpanded="images/treeminus.gif" imageContracted="images/treeplus.gif">
<repeatingGroup id="frequentTopicsGroup1"
                  sql="SELECT Top 10 ID,Title,CASE WHEN LENGTH(Title)&lt;=25 then Title WHEN LENGTH(Title)&gt;25 then SUBSTR(Title,1,18)||'...' END As ShortTitle from KB.Topic where Completed=1 and Visible=1 and DeleteFlg!=1 and Product=? order by UsersVoice->RefFreq desc"
                  >
<parameter value="#(%page.Product)#" /> 
<spacer height="10" />
<hgroup>
<link href="javascript:zenPage.openResult(#(%query.ID)#)" caption="#(%query.ShortTitle)#" title="#(%query.Title)#"/>
</hgroup>
</repeatingGroup>
<repeatingGroup id="frequentTopicsGroup2"
                  sql="SELECT Top 10 ID,Title,CASE WHEN LENGTH(Title)&lt;=25 then Title WHEN LENGTH(Title)&gt;25 then SUBSTR(Title,1,18)||'...' END As ShortTitle from KB.Topic where Completed=1 and Visible=1 and DeleteFlg!=1 order by UsersVoice->RefFreq desc"
                  >
<spacer height="10" />
<hgroup>
<link href="javascript:zenPage.openResult(#(%query.ID)#)" caption="#(%query.ShortTitle)#" title="#(%query.Title)#"/>
</hgroup>
</repeatingGroup>
</expando>
</hgroup>
<spacer height="20" />
<hgroup height="50%" valign="top">
<spacer width="20" />
<expando caption="最近追加されたトピック" expanded="true" childIndent="20px" remember="true" imageExpanded="images/treeminus.gif" imageContracted="images/treeplus.gif">
<repeatingGroup id="newTopicsGroup1"
                  sql="SELECT ID,Title,CASE WHEN LENGTH(Title)&lt;=25 then Title WHEN LENGTH(Title)&gt;25 then SUBSTR(Title,1,18)||'...' END As ShortTitle from KB.Topic where Completed=1 and Visible=1 and DeleteFlg!=1 and IssueDate&gt;($Horolog-180) and Product=? order by IssueDate desc"
                  >
<parameter value="#(%page.Product)#" />
<spacer height="10" />
<hgroup>
<link href="javascript:zenPage.openResult(#(%query.ID)#)" caption="#(%query.ShortTitle)#" title="#(%query.Title)#" />
</hgroup>
</repeatingGroup>
<repeatingGroup id="newTopicsGroup2"
                  sql="SELECT ID,Title,CASE WHEN LENGTH(Title)&lt;=25 then Title WHEN LENGTH(Title)&gt;25 then SUBSTR(Title,1,18)||'...' END As ShortTitle from KB.Topic where Completed=1 and Visible=1 and DeleteFlg!=1 and IssueDate&gt;($Horolog-180) order by IssueDate desc"
                  >
<spacer height="10" />
<hgroup>
<link href="javascript:zenPage.openResult(#(%query.ID)#)" caption="#(%query.ShortTitle)#" title="#(%query.Title)#" />
</hgroup>
</repeatingGroup>
</expando>
</hgroup>
<spacer height="20" />
</vgroup>
<vgroup width="75%" valign="top" >
<hgroup height="100">
<spacer width="10" />
<form>
<hgroup label="*トピックID、または、キーワードで、トピックの検索ができます。*" labelStyle="color:olive; font-style:italic;">
<vgroup>
<spacer height="10" />
<hgroup>
<radioButton name="SearchOption" id="SearchOption" optionValue="tid" onchange="zenPage.searchOption();"/>
<label id="IdLabel" value="トピックIDで検索：" enclosingClass="searchLabel" />
<text name="SearchId" id="SearchId" size="5" title="検索ID(半角数字)を入力" onfocus="zenPage.autoCheck('tid');" onkeypress="zenPage.enterPress();" enclosingClass="searchTextBox"/>
<spacer width="20" />
<radioButton name="SearchOption" optionValue="keycate" onchange="zenPage.searchOption();"/>
<label id="KeyWordLabel" value="キーワードで検索：" enclosingClass="searchLabel"/>
<text name="SearchKey" id="SearchKey" size="30" maxlength="100" hint="*複数キーワード検索可*" hintStyle="color:dimgray;" title="検索キーワードを入力" onfocus="zenPage.autoCheck('keycate');" onkeypress="zenPage.enterPress();" enclosingClass="searchTextBox"/>
<checkbox id="CrossSeachCheck" caption="コアテクノロジを含む" label="" value="0"/>
<checkbox id="Nonproduct" caption="一般的質問" label="" value="0"/>
<checkbox id="Cache" caption="Caché" label="" value="0"/>
<checkbox id="Ensemble" caption="Ensemble" label="" value="0"/>

</hgroup>
</vgroup>
<spacer width="30" />
<vgroup valign="top">
<image src="./images/button/Search.gif" onclick="zenPage.executeQuery();" onkeypress="zenPage.executeQuery();" valign="middle"/>
</vgroup>
</hgroup>
</form>
</hgroup>
<hgroup height="70%">
<vgroup valign="top">
<hgroup>
<spacer width="30" />
<tableNavigator id="TableNavi" tablePaneId="TopicTitleTable" hidden="false"/>
</hgroup>
<hgroup width="95%">
<spacer width="30" />
<tablePane id="TopicTitleTable"
	      OnCreateResultSet="CreateTitleRS"
	      width="100%"
          maxRows="1000"
          pageSize="10"
          bodyHeight="26"
          useSnapshot="true"
	      nowrap="false"
          fixedHeaders="true"
          extraColumnWidth="0"
          showZebra="true"
	      valueColumn="ID"
	      initialExecute="true"
	      hidden="false"
	      ondblclick="zenPage.tableRowClick();"
	      >
<column colName="TopicID" width="10%" header="トピックID" title="項目名クリックでソート"/>
<column colName="Facility" width="10%" header="カテゴリ" title="項目名クリックでソート"/>
<column colName="Title" width="71%" header="タイトル" title="項目名クリックでソート" OnDrawCell="DrawTitleCell" seed=""/>
<column colName="Version" width="10%" header="バージョン" title="項目名クリックでソート" />
</tablePane>
<spacer width="10" />
</hgroup>
<spacer height="10" />
<hgroup id="NoteGroup" hidden="false" height="10%">
<spacer width="35" />
<vgroup>
<label id="VersionNote" enclosingClass="noteStyle"
	   value="※バージョン欄に記載のあるトピックは、記載のバージョン限定の内容です。記載の無いものについては、Caché5.1以降のバージョン全てが対象となります。"/>
<spacer height="7" />
<label id="ColTitleNote" enclosingClass="noteStyle"
	   value="※列タイトルをクリックすると、その項目でソートされます。"/>
</vgroup>
</hgroup>
<spacer height="10" />
</vgroup>
</hgroup>
</vgroup>
</hgroup>
</page>
}

ClientMethod searchOption() [ Language = javascript ]
{
	var so=this.getComponentById('SearchOption');
	var sovalue=so.getValue()
	
	if (sovalue=='tid') {
		
		var idlabel=this.getComponentById('IdLabel');
		var idkey=this.getComponentById('SearchId');
		idlabel.setProperty('enclosingStyle','color:black;');
		idkey.setProperty('controlStyle','color:black;');

		var keylabel=this.getComponentById('KeyWordLabel');
		var keyword=this.getComponentById('SearchKey');
		keylabel.setProperty('enclosingStyle','color:gray;');
		keyword.setProperty('controlStyle','color:gray;');
		keyword.setProperty('hintStyle','color:gray;');
	
	}else if (sovalue=='keycate') {
		
		var idlabel=this.getComponentById('IdLabel');
		var idkey=this.getComponentById('SearchId');
		idlabel.setProperty('enclosingStyle','color:gray;');
		idkey.setProperty('controlStyle','color:gray;');
		
		var keylabel=this.getComponentById('KeyWordLabel');
		var keyword=this.getComponentById('SearchKey');
		keylabel.setProperty('enclosingStyle','color:black;');
		keyword.setProperty('controlStyle','color:black;');
		keyword.setProperty('hintStyle','color:dimgray;');
		
	}
}

ClientMethod autoCheck(option, chkval) [ Language = javascript ]
{

	if (chkval==null || chkval==1) {
		var so=this.getComponentById('SearchOption');
		so.setProperty('value',option)
		
		this.searchOption();
	}
}

ClientMethod enterPress() [ Language = javascript ]
{
	if(zenEvent.keyCode == 13) {
		zenPage.executeQuery();
	}
}

ClientMethod executeQuery() [ Language = javascript ]
{
	var so=this.getComponentById('SearchOption');
	var soval=so.getValue();
	zenPage.setProperty('SearchOption',soval);

	var idkey=this.getComponentById('SearchId');
	var idval=idkey.getValue();
	zenPage.setProperty('SearchId',idval);
	
	var key=this.getComponentById('SearchKey');
	var keyval=key.getValue();
	zenPage.setProperty('SearchKey',keyval);
	
	var crossSearch=this.getComponentById('CrossSeachCheck');
	var crosschecked = crossSearch.getValue();
	zenPage.setProperty('crosschecked',crosschecked);
	
	var nonproduct=this.getComponentById('Nonproduct');
	var nonproductv = nonproduct.getValue();
	zenPage.setProperty('nonproduct',nonproductv);

	var cache=this.getComponentById('Cache');
	var cachev = cache.getValue();
	zenPage.setProperty('cache',cachev);

	var ensemble=this.getComponentById('Ensemble');
	var ensemblev = ensemble.getValue();
	zenPage.setProperty('ensemble',ensemblev);

	zen('TopicTitleTable').executeQuery();
}

Method CreateTitleRS(Output pSC As %Status, pInfo As %ZEN.Auxiliary.QueryInfo) As %ResultSet
{
	set pSC=$$$OK
	
	set admin = $roles["FAQEditor"
	
	set result = ##Class(%ResultSet).%New()
	set cond=""
	set keycond=""
	set facicond=""
	
	set searchoption=%page.SearchOption
	set searchid=%page.SearchId
	set keylist=%page.SearchKey
	set facilist=%page.SearchFacility
	set crosssearch=%page.crosschecked 
	
	set cache = %page.cache
	set nonproduct = %page.nonproduct
	set ensemble = %page.ensemble
	
	
	//Select節
	If crosssearch {
		
		// Ensembleタブで検索する場合のみCache（コアテクノロジー）を含めるオプションを持たせる
		// Product = 2 Cache 
		// Product = 3 Ensemble
		
	set sqlselect=" ID,TopicID,TopicSubID,Facility->Description Facility,Title,VersionRange As Version from KB.Topic where (Product = 2 OR Product = 3)"
	}
	Else {
	set sqlselect=" ID,TopicID,TopicSubID,Facility->Description Facility,Title,VersionRange As Version from KB.Topic where Product="_..Product
	}
	
	// 製品別にタブを分けない様に仕様変更。　その結果、一般的質問のTopicIDを使う必要がなくなったため、単にゼロパディングする。
	
	if (cache && nonproduct && ensemble) {
	  set sqlselect=" ID,LPAD(ID,5,'0') TopicID,TopicSubID,Facility->Description Facility,Title,VersionRange As Version from KB.Topic where (Product = 1 OR Product = 2 OR Product = 3)"
	}
	elseif (cache && nonproduct) {
	  set sqlselect=" ID,LPAD(ID,5,'0') TopicID,TopicSubID,Facility->Description Facility,Title,VersionRange As Version from KB.Topic where (Product = 1 OR Product = 2)"
	}
	elseif (cache && ensemble) {
	  set sqlselect=" ID,LPAD(ID,5,'0') TopicID,TopicSubID,Facility->Description Facility,Title,VersionRange As Version from KB.Topic where (Product = 2 OR Product = 3)"
	}
	elseif (nonproduct && ensemble) {
	  set sqlselect=" ID,LPAD(ID,5,'0') TopicID,TopicSubID,Facility->Description Facility,Title,VersionRange As Version from KB.Topic where (Product = 1 OR Product = 3)"
	}
	elseif (nonproduct) {
	  set sqlselect=" ID,LPAD(ID,5,'0') TopicID,TopicSubID,Facility->Description Facility,Title,VersionRange As Version from KB.Topic where (Product = 1)"
	}
	elseif (cache) {
	  set sqlselect=" ID,TopicID,TopicSubID,Facility->Description Facility,Title,VersionRange As Version from KB.Topic where (Product = 2)"
	}
	elseif (ensemble) {
	  set sqlselect=" ID,TopicID,TopicSubID,Facility->Description Facility,Title,VersionRange As Version from KB.Topic where (Product = 3)"
	}
	else {
	set sqlselect=" ID,LPAD(ID,5,'0') TopicID,TopicSubID,Facility->Description Facility,Title,VersionRange As Version from KB.Topic where Product="_..Product
	}

	//Guestユーザの参照共通条件のセット
	set comcond="Completed=1 and Visible=1 and DeleteFlg!=1"


	//SQL文の構築
	
	//全文検索条件のセット
	if keylist '= "" {
		set keycond = ..SetKeyCond(keylist)
	}

	//条件文の組み立て
	
	if searchoption="tid" {
		if searchid'="" {
			if ..Product=$$$General {
				set cond=" and (TopicSubID='"_$translate($justify(searchid,3)," ","0")_"' or TopicID='"_searchid_"') "
			}
			else {
				set cond=" and (TopicID='"_$translate($justify(searchid,$$$TopicDigitsNo)," ","0")_"' or ID='"_searchid_"') "
			}
		}
	}elseif searchoption="keycate"{
		if keycond'="" {
			set cond="and "_keycond
		}
	}
	
	if admin'=1 {
		if cond'="" {
			set cond = cond_" and "_comcond
		}else{
			set cond = "and "_comcond
		}
	}
	
	if ..Product = $$$General {
	  set orderclause=" order by TopicID"
	}
	Else {
	  set orderclause=" order by ID"
	}
	
	set sql="Select"_sqlselect_" "_cond_orderclause
			
	Do result.Prepare(sql)

	set pInfo.queryText=sql
	
	quit result
}

Method SetKeyCond(keylist As %String) As %String
{
	set keylist = $translate(keylist,"　"," ")   //全角スペース
	set keylist = $translate(keylist,","," ")    //コンマ
	set keylist = $translate(keylist,"、"," ")   //点
	set keylen = $length(keylist," ")
 	
 	set keyno=0
	for i=1:1:keylen{
 		set keyword = $piece(keylist," ",i) 
 		if keyword'= "" {
	 		set keyno=keyno+1
	 		set keyword(keyno) = keyword
 		}
	}
 	 	
 	//キーワード5個まで全文検索実施	 
	if keyno = 1 {
 		set ifindkey = "'"_keyword(1)_"'"
	}
	elseif keyno = 2 {
 		set ifindkey = "'"_keyword(1)_" "_keyword(2)_"'"
 	}
	elseif keyno = 3 {
 		set ifindkey = "'"_keyword(1)_" "_keyword(2)_" "_keyword(3)_"'"
	}
	elseif keyno = 4 {
 		set ifindkey = "'"_keyword(1)_" "_keyword(2)_" "_keyword(3)_" "_keyword(4)_"'"
	}
	else {
 		set ifindkey = "'"_keyword(1)_" "_keyword(2)_" "_keyword(3)_" "_keyword(4)_" "_keyword(5)_"'"
	}
	
	set keycond = "(%ID %FIND search_index(DescriptionIndex1,"_ifindkey_",0) or %ID %FIND search_index(TitleIndex1,"_ifindkey_",0))"

	quit keycond
}

Method DrawTitleCell(pTable As %ZEN.Component.tablePane, pName As %String, pSeed As %String) As %Status
{
 
 	set id = %query(pTable.valueColumn)
 	set pName=..EscapeHTML(%query(pName))
 	&html<<a href="javascript:zenPage.openResult(#(id)#)" >#(pName)#</a>>
	Quit $$$OK
}

ClientMethod tableRowClick() [ Language = javascript ]
{
	var table = this.getComponentById('TopicTitleTable');
	var id = table.getProperty('value');
	
	var st =  zenPage.openResult(id);
}

ClientMethod openResult(id) [ Language = javascript ]
{
	var url = 'result.csp?DocNo='+id;
  	
    window.open(url,'TopicDescription'+id,'width=1000,height=600,left='+(window.screen.width-1000)/2+',top='+(window.screen.height-600)/2+',scrollbars=1');
}

ClientMethod showNewTopic(id) [ Language = javascript ]
{
	var url = 'result.csp?DocNo='+id
  	
    window.open(url,'TopicDescription'+id,'width=1000,height=600,left='+(window.screen.width-1000)/2+',top='+(window.screen.height-600)/2+',scrollbars=1');
}

ClientMethod openPrivateWindow(cspname) [ Language = javascript ]
{
	var url = zenPage.SetURL(cspname);
	 	
    window.open(url,'','width=1000,height=600,left='+(window.screen.width-1000)/2+',top='+(window.screen.height-600)/2+',scrollbars=1');
}

ClassMethod SetURL(cspname) As %String [ ZenMethod ]
{
	set url = ..Link(cspname_".csp")
	
	quit url
}

ClientMethod onloadHandler() [ Language = javascript ]
{
}

ClientMethod onlayoutHandler(load) [ Language = javascript ]
{
	var winheight = zenGetWindowHeight();
	var leftvg = zenPage.getComponentById('LeftVgroup');
	leftvg.setProperty('height',winheight);
}

ClientMethod onresizeHandler() [ Language = javascript ]
{
}

// Parameter HTMLDTD As BOOLEAN = 1;

/// If true, draw an HTML Document Type Declaration at the start of this page.
/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	
	set frequentTopicsGroup2 = %page.%GetComponentById("frequentTopicsGroup2")
	set frequentTopicsGroup2.enclosingStyle="display:none;"  //="visibility: hidden;"

	set newTopicsGroup2 = %page.%GetComponentById("newTopicsGroup2")
	set newTopicsGroup2.enclosingStyle="display:none;"  //="visibility: hidden;"
	
	set nonproduct = %page.%GetComponentById("Nonproduct")
	set nonproduct.enclosingStyle="display:none;"  //="visibility: hidden;"

	set cache = %page.%GetComponentById("Cache")
	set cache.enclosingStyle="display:none;"  //="visibility: hidden;"

	set ensemble = %page.%GetComponentById("Ensemble")
	set ensemble.enclosingStyle="display:none;"  //="visibility: hidden;"
	
	If (..Product = $$$General) || (..Product = $$$Cache) {

		Set CrossSeachCheck = %page.%GetComponentById("CrossSeachCheck")
	    Set CrossSeachCheck.enclosingStyle="display:none;"  //="visibility: hidden;"
	}
	ElseIf ..Product = $$$Ensemble {

		Set CrossSeachCheck = %page.%GetComponentById("CrossSeachCheck")
		Set CrossSeachCheck.value = 1
		Set %page.crosschecked = CrossSeachCheck.value
		
	}
	
	ElseIf (..Product = $$$All) {

	    set frequentTopicsGroup1 = %page.%GetComponentById("frequentTopicsGroup1")
	    set frequentTopicsGroup1.enclosingStyle="display:none;"  //="visibility: hidden;"
	    set newTopicsGroup1 = %page.%GetComponentById("newTopicsGroup1")
	    set newTopicsGroup1.enclosingStyle="display:none;"  //="visibility: hidden;"

	    set frequentTopicsGroup2 = %page.%GetComponentById("frequentTopicsGroup2")
	    set frequentTopicsGroup2.enclosingStyle="display:block;"  //="visibility: yes;"
	    set newTopicsGroup2 = %page.%GetComponentById("newTopicsGroup2")
	    set newTopicsGroup2.enclosingStyle="display:block;"  //="visibility: yes;"

		Set CrossSeachCheck = %page.%GetComponentById("CrossSeachCheck")
	    Set CrossSeachCheck.enclosingStyle="display:none;"  //="visibility: hidden;"

		Set nonproduct = %page.%GetComponentById("Nonproduct")
	    Set nonproduct.enclosingStyle="display:block;"  //="visibility: hidden;"
		Set nonproduct.value = 0
		Set %page.nonproduct = nonproduct.value

		Set cache = %page.%GetComponentById("Cache")
	    Set cache.enclosingStyle="display:block;"  //="visibility: hidden;"
		Set cache.value = 1
		Set %page.cache = cache.value

		Set ensemble = %page.%GetComponentById("Ensemble")
	    Set ensemble.enclosingStyle="display:block;"  //="visibility: hidden;"
		Set ensemble.value = 1
		Set %page.ensemble = ensemble.value
	    }
	else {
			
		Set CrossSeachCheck = %page.%GetComponentById("CrossSeachCheck")
	    Set CrossSeachCheck.enclosingStyle="display:none;"  //="visibility: hidden;"

		Set nonproduct = %page.%GetComponentById("Nonproduct")
		Set nonproduct.enclosingStyle="display:none;"  //="visibility: hidden;"

		Set cache = %page.%GetComponentById("Cache")
		Set cache.enclosingStyle="display:none;"  //="visibility: hidden;"

		Set ensemble = %page.%GetComponentById("Ensemble")
		Set ensemble.enclosingStyle="display:none;"  //="visibility: hidden;"

		}

	Quit $$$OK
}

}
