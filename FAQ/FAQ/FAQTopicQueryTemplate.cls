Class FAQ.FAQTopicQueryTemplate Extends %ZEN.Mojo.Component.contentTemplate
{

Parameter NAMESPACE = "http://www.intersystems.com/zen/mojo/faq";

/// Domain used for localization.
Parameter DOMAIN = "Zen Mojo FAQ";

/// Server-side method to provide content to JSON providers.<br/>
/// <var>pWhich</var> is the name of the provider.<br/>
/// <var>pKey</var> is an app-defined key that is used to indicate which content is to be served.<br/>
/// <var>pCriteria</var>is an object containing search criteria. This is used for searching.<br/>
/// <var>pParms</var> is an array of additional parameters from the JSON provider. (not current used).<br/>
/// <var>pObject</var> is the object that will be served to the client in JSON format.<br/>
/// <var>pLoad</var> is true is this is called when the page is first being served. In this case, this method will be 
/// called even though there may a client-side method used to load the content.<br/>
ClassMethod %OnGetJSONContent(pWhich As %String, pKey As %String, ByRef pParms, Output pObject As %RegisteredObject, pCriteria As %RegisteredObject, pLoad As %Boolean = 0) As %Status
{
	#dim sql As %String = ""
	#dim tsc As %Status = $$$OK
	#dim result As %SQL.StatementResult
		
	set pObject = ##class(%ZEN.proxyObject).%New()
	
	if (pKey = "query-entry") {
		set pObject.sectionHeader = "InterSystems製品FAQ"
		set pObject.inputPrompt = "検索キーワードを入力して下さい: "
		set pObject.buttonLabel = "検索 "
		
	} elseif (pKey = "list-topics") {
		
		set pObject.topicList = ##class(%ListOfObjects).%New()
		
		set pObject.sectionHeader = "検索結果リスト"

		set statement = ##class(%SQL.Statement).%New()
		set sql = "select ID,Title,Description from KB.Topic where %ID %FIND search_index(DescriptionIndex1,'?',0) OR %ID %FIND search_index(TitleIndex1,'?',0)"
		set tsc = statement.%Prepare(sql)
		if ($$$ISERR(tsc)) {
			quit $$$OK
		}
		
		set result = statement.%Execute(pCriteria.queryText,pCriteria.queryText)
		
		while result.%Next() {
			set topic = ##class(%ZEN.proxyObject).%New()
			set topic.id = result.%Get("ID")
			set topic.title = result.%Get("Title")
			set topic.sdesc = $extract(result.%Get("Description"),1,40)
			do pObject.topicList.Insert(topic)
		}
	} elseif (pKey = "show-topic") {
		
		set pObject.topicList = ##class(%ListOfObjects).%New()

		set pObject.sectionHeader = "トピック詳細"
		
		set statement = ##class(%SQL.Statement).%New()
		// Get any additional details now
		set sql = "select ID,Title,Description from KB.Topic where id = ?"
		set tsc  = statement.%Prepare(sql)
		if ($$$ISERR(tsc)) {
			quit $$$OK
		}
		set result = statement.%Execute(pCriteria.id)
		
		while result.%Next() {
			set pObject.id = result.%Get("id")
			set pObject.title = result.%Get("Title")
			set crlf = $Char(13,10)
			set tDescription = $Replace(result.%Get("Description"),crlf,"<br>")
			
			set sc = ##class(KB.Utility).PickupTags(tDescription,"URL",.url)
			
			for i = 1:1:url {
				set current = "<URL>"_url(i)_"</URL>"
				set new = "<A href="""_url(i)_""" target=""_blank"">"_url(i)_"</A>"
				set tDescription = $Replace(tDescription,current,new)
				set current = "<Url>"_url(i)_"</Url>"
				set tDescription = $Replace(tDescription,current,new)
				set current = "<url>"_url(i)_"</Url>"
				set tDescription = $Replace(tDescription,current,new)
			}

			set sc = ##class(KB.Utility).PickupTags(tDescription,"COMMAND",.command)
			
			for i = 1:1:command {
				set current = "<COMMAND>"_command(i)_"</COMMAND>"
				set new = "<DIV class=divcommand><PRE><CODE>"_command(i)_"</CODE></PRE></DIV>"
				set tDescription = $Replace(tDescription,current,new)
				set current = "<Command>"_command(i)_"</Command>"
				set tDescription = $Replace(tDescription,current,new)
				set current = "<command>"_command(i)_"</command>"
				set tDescription = $Replace(tDescription,current,new)
			}
			
			set pObject.description = tDescription

		}
	}
	
	quit $$$OK
}

/// Client-side content provider method.
/// <var>which</var> is the name of the content to return.
/// <var>key</var> is the key value associated with the request.
/// <var>criteria</var> is the search criteria associated with the request.
ClientMethod onGetContent(which, key, criteria) [ Language = javascript ]
{
	//console.log(which + ' - ' + key + ' - ' + criteria);
	switch (which)
	{
		case 'layout':
			return this.getLayout(key,criteria);
		case 'data':
			// always fetch data from server for this sample
	}
	
	// returning null -> fetch data from server
	return null;
}

/// Creates the layout object for the page
ClientMethod getLayout(key, criteria) [ Language = javascript ]
{
	var content = null;
	
    
    switch(key) {
	    case 'query-entry' :
	     	content = {
		     	children:[
		     		{type:'$header',caption:'=[sectionHeader]'},
				    { type: '$div', style: 'text-align: center;', children: [
				      { type: '$grid', showBox: false, children: [
				        { 
					      type: '$text', placeHolder: '=[inputPrompt]', fieldcontain: false,
					      key: 'query-text', label: '=[inputPrompt]', apply: true
				        },
				      ]},
				      { type: '$grid', showBox: false, children: [
					    { type: '$button', caption: '=[buttonLabel]', key: 'query-button' }
				      ]},
				    ]}
		     	]
		     };
	     	break;
	    case 'list-topics' :
	     	content = {
		     	children:[
		     		{type:'$header',caption:'=[sectionHeader]'},
		     		{type:'$listview',value:'=[topicList]',filter:true,children:[
		     			{type:'$listviewitem',key:'drill-topic',value:'=[id]',label:'=[title]',content:'=[sdesc]',clickable:true,labelNoWrapper:true }
		     		]}
		     	]
		     };
	     	break;
	     case 'show-topic' :
	     	content = {
		     	children:[
		     		{type:'$header',caption:'=[sectionHeader]'},
		     		{type:'$h1',$content:'=[title]'},
		     		{type:'$content',content:'=[description]',style: 'word-wrap: break-word;'},
	     		]
		     };
	     	break;
    } 
           				
    return content;
}

ClientMethod onselect(key, value, docViewId) [ Language = javascript ]
{
	console.log('select '+key);
	var mainView = zen(docViewId);
	var realKey = key.split(':')[0];
	switch(realKey) {
		case 'query-button':
       	    var qt=zen('mainView').getItemByKey('query-text');
			mainView.pushDocument('list-topics',{queryText:qt.value},'list-topics',{queryText:qt.value});
			break;
		case 'drill-topic':
			mainView.pushDocument('show-topic',{id:value},'show-topic',{id:value});
			break;
	}
}

ClientMethod onchange(key, value, final, docViewId) [ Language = javascript ]
{
	console.log('change ' + key + ' to ' + value);
	var view = zen(docViewId);
	switch(key) {
	}
}

/// Submit data handler for content provider.<br/>
/// Overridden by subclasses.
ClassMethod %OnSubmitData(pKey As %String, pID As %String, pSubmitObject As %RegisteredObject, ByRef pResponseObject As %RegisteredObject) As %Status
{
}

}
