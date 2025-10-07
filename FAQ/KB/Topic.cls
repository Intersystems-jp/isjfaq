Include FAQ

/// ナレッジベースのトピック
Class KB.Topic Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

/// Topic ID(FAQサイトへの表示ID)
Property TopicID As %String [ Calculated, SqlComputeCode = { Set {TopicID}=##class(KB.Topic).ComputeTopicID({ID})}, SqlComputed ];

/// 一般的質問用のSubID
Property TopicSubID As %String;

/// 製品名 (Caché/Ensemble/一般)
Property Product As KB.Product;

/// カテゴリ
Property Category As KB.Category;

/// 機能区分
Property Facility As KB.Facility;

/// 表題
Property Title As %Text(COLLATION = "SQLUPPER", LANGUAGECLASS = "%TextJapanese", MAXLEN = 1000) [ Required ];

/// 内容
Property Description As %Text(COLLATION = "SQLUPPER", LANGUAGECLASS = "%TextJapanese", MAXLEN = 1000000);

/// 稼動プラットフォーム
Property Platform As KB.Platform;

/// 適用開始バージョン
Property StartVersion As KB.Version;

/// 適用終了バージョン
Property EndVersion As KB.Version;

/// 適用バージョン範囲
Property VersionRange As %String;

/// 添付ファイルフラグ
Property FileFlg As %Boolean [ InitialExpression = 0 ];

/// 関連・参考トピック
Property RefTopic As %String;

/// 特記事項
Property Note As %String(MAXLEN = 1000, XMLPROJECTION = "NONE");

/// 完成フラグ
Property Completed As %Boolean [ InitialExpression = 0 ];

/// 公開フラグ
Property Visible As %Boolean [ InitialExpression = 0 ];

/// 削除可フラグ
Property DeleteFlg As %Boolean [ InitialExpression = 0 ];

/// Web公開フラグ
Property WebFlg As %String [ InitialExpression = 0 ];

/// 作成日
Property IssueDate As %Date;

/// 作成者
Property Creator As %String(XMLPROJECTION = "NONE");

/// 更新日付
Property UpdateDate As %Date;

/// 更新者
Property Updater As %String(XMLPROJECTION = "NONE");

/// Web公開日
Property OpenDate As %Date;

/// 参照回数・アンケート結果（※別グローバルにするためオブジェクト参照化）
Property UsersVoice As KB.UsersVoice;

/// 更新履歴
Relationship UpdateDetail As KB.UpdateHistory [ Cardinality = children, Inverse = Topic ];

/// 同じ内容のDC(Developer Community)記事URL
Property DCURL As %String(MAXLEN = 100, XMLPROJECTION = "NONE");

// Property DescriptionVector As %Vector(DATATYPE = "DOUBLE", LEN = 768);

Index IndexIssueDate On IssueDate;

Index IndexTitle On Title;

Parameter XMLDEFAULTREFERENCE = "ID";

Index IndexVisible On Visible [ Type = bitmap ];

Index IndexCompleted On Completed [ Type = bitmap ];

Index TitleIndex1 On (Title) As %iFind.Index.Basic(INDEXOPTION = 0, LANGUAGE = "ja", LOWER = 1);

Index DescriptionIndex1 On (Description) As %iFind.Index.Basic(INDEXOPTION = 0, LANGUAGE = "ja", LOWER = 1);

Index CreatorIndex On Creator;

// Index HNSWDescriptionIndex On (DescriptionVector) As %SQL.Index.HNSW(Distance = "DotProduct");

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called before 
/// any data is written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnBeforeSave(pInsert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
	
	If pInsert {
		If (..Product.ProductId = $$$General) {
		   Set ..TopicSubID = ..GetCurTopicSubID()
		}
	}
	
	if pInsert {
	  set ..Creator = $username
	  set ..IssueDate = +$h
	} 
	else {
	  if $Get(%session.Data("noAudit"))'=1{
	    set ..Updater = $username
		set ..UpdateDate = +$h
	  }
	}
	
    // 	スペースを取り除く、存在しないトピック番号があれば取り除く
	set ..RefTopic = ..RefListChk(..RefTopic)
	// 参照トピックリスト内に自分自身が入っていたら取り除く
	set ..RefTopic = ..RemoveRefNoForOwn(..RefTopic, ..%Id())
	// 参照トピックリスト内の重複を取り除く
	set ..RefTopic = ..RemoveDuplicatedRefNo(..RefTopic)
	
	// react経由の場合、イメージの記述形式がCSPとは異なるため、先頭のhttp://hostname:portを外して、相対パスに変更する
	
	set webserveraddress = ##class(KB.Config).getWebServerAddress()
	set protocol = ##class(KB.Config).getWebServerProtocol()
	set webserverport = ##class(KB.Config).getWebServerPort()
	if $data(%request) {
	  set webserver = %request.CgiEnvs("SERVER_NAME")
      set webserverport = %request.CgiEnvs("SERVER_PORT")
      if %request.CgiEnvs("SERVER_PORT_SECURE") {
        set protocol = "https"
      }
      else {
        set protocol = "http"
      }
	
	}

	set namespace = $ZCVT($namespace,"L")
	set apath = "/csp/"_namespace_"/images"
	set rpath = "./images"
	set ourl = protocol_"://"_webserveraddress_":"_webserverport_apath
	set rurl = "./images"
    set ..Description = $replace(..Description,ourl,rurl)

    //  for CSP/Zen版
	//トピック内の参照イメージのurlを絶対パスから相対パスに変更する
	//データ本番移行の際、namespaceの違いを考慮する必要をなくすため
	
	set ..Description = $replace(..Description,apath,rpath)

	// Codesnippetの言語名を表示するための処理
	set crlf = $char(13,10)
	set lf = $char(10)
	//二重に<div>を付加するのを防ぐ　ckeditorが自動的に<div>の後ろにcrlfまたはlfを付加することを想定
	set ..Description = $replace(..Description,"<div class=""hljs-wrap"">"_crlf_"<pre>","<pre>")
	set ..Description = $replace(..Description,"</pre>"_crlf_"</div>","</pre>")
	set ..Description = $replace(..Description,"<div class=""hljs-wrap"">"_lf_"<pre>","<pre>")
	set ..Description = $replace(..Description,"</pre>"_lf_"</div>","</pre>")
	set ..Description = $replace(..Description,"<pre>","<div class=""hljs-wrap""><pre>")
	set ..Description = $replace(..Description,"</pre>","</pre></div>")

	set ..VersionRange = ##class(KB.Version).SetVersionRange(..StartVersion, ..EndVersion)

    /*
	// タイトルとトピック内容からベクトル変数を生成する
	// ベクトル化にかなり処理時間がかかるため、インタラクティブな保存処理に組み込むかどうか検討要
	set statement = ##class(%SQL.Statement).%New()
	set sql = "select TO_VECTOR(?,DOUBLE,768) as embedding"
	set status = statement.%Prepare(sql)
	set description = ..RemoveHTMLTag(..Description)
	set title = ..Title
	set vector = $translate(..GetEmbedding(title_" "_description)," '[]")

	set rs = statement.%Execute(vector)
	while rs.%Next() {
	  set embedding = rs.%Get("embedding")
	  set ..DescriptionVector = embedding    	
	}
    */
	
	Quit $$$OK
}

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called after 
/// the object's data has been successfully written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnAfterSave(pInsert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
	set tSC = $$$OK
		
	Try {
	  if pInsert {
        set message = "作成トピック "_..%Id()
		// tSC = 0 となることがあるが、エラーとしない
        set tSC = $system.Security.Audit("FAQ","Create","Topic",message)
			
		//UsersVoiceの新規セット
   		set uv=##class(UsersVoice).%New()
		set ..UsersVoice=uv
		set uv.TopicId=..%Id()
	  }
	  else {
 	    if %session.Get("noAudit")'=1 {
		  set message = "修正トピック "_..%Id()
		  // tSC = 0 となることがあるが、エラーとしない
    	  set tSC = $system.Security.Audit("FAQ","Update","Topic",message)
 		}
	  }
	}
	Catch  tE {
		do tE.log()
		Set tSC = tE.AsStatus()
		set tSC2 = ##class(FAQ.Error).StoreErrorInformation(tE)
	}
	
	If (tSC = 0) Set tSC = $$$OK  // tSC = 0はエラー扱いしない
	Quit tSC
}

ClassMethod GetCurTopicSubID() As %String
{
	quit $translate($justify($Increment(^TopicSubID),3)," ","0")
	//以下の方法は、アトミック性を確保できないことが判明
	//&sql(select max(TopicSubID) into :tTopicSubID from KB.Topic )
	//quit $Translate($justify($increment(tTopicSubID),3)," ",0)
}

ClassMethod ResetTopicSubID() As %Status
{
	set tSC = $$$OK
	&sql(select max(TopicSubID) into :tTopicSubID from KB.Topic )
	set ^TopicSubID = tTopicSubID
	quit $$$OK
}

ClassMethod DecrementTopicSubID() As %String
{
	quit $translate($justify($Increment(^TopicSubID,-1),3)," ","0")
}

ClassMethod ComputeTopicID(pId As %Integer) As %String
{
	Try {
	  set tTopic = ##class(KB.Topic).%OpenId(pId,,.tSC)
	  
	  If $IsObject(tTopic) {
		  If tTopic.Product.ProductId = $$$General {
			  set tTopicId = $Translate("G-"_$Justify(tTopic.TopicSubID,3)," ",0)
		  }
		  Else {
			  set tTopicId = $Translate($Justify(tTopic.%Id(),$$$TopicDigitsNo)," ",0)
	      }
	  }
	  Else {
		  $$$ThrowStatus(tSC)
	  }
	}
	catch tE {
		set tSC = ##class(FAQ.Error).StoreErrorInformation(tE)
	}
	quit $Get(tTopicId)
}

ClassMethod RemoveDuplicatedRefNo(pRefNoList As %String) As %String
{
	//関連Topicリスト内の重複Topicを取り除く
	
	if pRefNoList = "" quit ""
	
	for i = 1:1:$length(pRefNoList,",") {
	  set refno = $piece(pRefNoList,",",i)
	  set ref(refno) = ""
	}
	
	set node = "", newref = ""
	
	for {
	  set node = $order(ref(node))
	  if node = "" quit
	  set newref = newref_","_node
	}
	
	quit $extract(newref,2,*)
}

ClassMethod RemoveRefNoForOwn(pRefNoList As %String, pTopicId As %Integer) As %String
{
	//関連Topicリスト内の本トピックがある場合取り除く
	
	if pRefNoList = "" quit ""
	
	for i = 1:1:$length(pRefNoList,",") {
	  set refno = $piece(pRefNoList,",",i)
	  if refno '= pTopicId {
	    set ref(refno) = ""
	  }
	}
	
	set node = "", newref = ""
	
	for {
	  set node = $order(ref(node))
	  if node = "" quit
	  set newref = newref_","_node
	}
	
	quit $extract(newref,2,*)
}

Method RefCheckLink(pDebug As %Boolean) As %Status
{
	//相互リンクを行う
	
	//リンクをはずすためにtopic番号を削除した場合については考慮していない
	
	set tSC = $$$OK
	
	Try {
		
		  set tId = ..%Id()

		  set tRefTopic = ..RefTopic
		  				
		  if pDebug Write "tRefTopic = "_tRefTopic,!
		  
		  If '$Length(tRefTopic) Quit
		  
		  for i =1:1:$Length(tRefTopic,",") {
			  set tOtherId = $Piece(tRefTopic,",",i)
			  set tOther = ##class(KB.Topic).%OpenId(tOtherId,,.tSC)
			  if '$IsObject(tOther) $$$ThrowStatus(tSC)
			  set tFindFlag = 0
	          set tORefTopic = tOther.RefTopic
			  for j = 1:1:$Length(tORefTopic,",") {
			    if tId = $Piece(tORefTopic,",",j) set tFindFlag = 1
			  }
			  if pDebug Write "tFindFlag = "_tFindFlag,!
			  if 'tFindFlag {
			      if pDebug Write "tOther.RefTopic = "_tOther.RefTopic,!
				  set tOther.RefTopic = tOther.RefTopic_","_tId
			      if pDebug Write "tOther.RefTopic = "_tOther.RefTopic,!
				  if $extract(tOther.RefTopic) = "," Set tOther.RefTopic = $Extract(tOther.RefTopic,2,*)
			      if pDebug Write "tOther.RefTopic = "_tOther.RefTopic,!
				  $$$THROWONERROR(tSC,tOther.%Save())
			  }
		  }
	}
	Catch tE {
		Set tSC = tE.AsStatus()
		set tSC2 = ##class(FAQ.Error).StoreErrorInformation(tE)
	}
	Quit tSC
}

ClassMethod RemoveLink(pId As %Integer, pOldValue As %String, pNewValue As %String) As %Status
{
	//現在設定されているリンク番号を削除する場合、相手Topicからの参照をはずす必要がある
		
	set tSC = $$$OK	
	
	Try {
		
	    If (pOldValue = pNewValue) Quit
	    
	    If '$Length(pOldValue) Quit
	    	     
	    For i = 1:1:$Length(pOldValue,",") {
		    set id = $Piece(pOldValue,",",i)
		    if '(id?.n) $$$ThrowStatus(0)
	    }
	    
	    For i = 1:1:$Length(pNewValue,",") {
		    set id = $Piece(pNewValue,",",i)
		    if '(id?.n) $$$ThrowStatus(0)
	    }

	    For i = 1:1:$Length(pOldValue,",") {
		    Set tTopicId(i) = $Piece(pOldValue,",",i)
		    Set tNoFindFlag = 1
		    
		    //古い値にはあるが新しい値に含まれないidを探す
		    For j = 1:1:$Length(pNewValue,",") {
			    Set tTopicId = $Piece(pNewValue,",",j)
			    If (tTopicId(i) = tTopicId) Set tNoFindFlag = 0
		    }
		    
		    If tNoFindFlag {
			    Set tReferedTopic = ##class(KB.Topic).%OpenId(tTopicId(i))
			    Set tRefTopic = tReferedTopic.RefTopic
			    Set count = 0
			    //新しい値からその削除されたidを取り除く
			    For k = 1:1:$Length(tRefTopic,",") {
				    Set tRefTopic2 = $Piece(tRefTopic,",",k)
				    If (tRefTopic2 '= pId) {
					    Set count = count + 1
					    Set tNoRemovedRefTopic(count) = tRefTopic2
				    }
			    }
			    
			    For l = 1:1:count {
				    Set tNewRefTopic = $Get(tNewRefTopic)_","_tNoRemovedRefTopic(l)
			    }
			    Set tReferedTopic.RefTopic = $extract($Get(tNewRefTopic),2,*)
			    Set tSC = tReferedTopic.%Save()
                Do tReferedTopic.%Reload()
		    }
	    }
	}
	Catch tE {
		Set tSC = tE.AsStatus()
		set tSC2 = ##class(FAQ.Error).StoreErrorInformation(tE)
	}
	Quit tSC
}

ClassMethod RefListChk(rlist As %String) As %String
{

  set rlist = $REPLACE(rlist," ","")
  set rlist = $REPLACE(rlist,"　","")

  set refchk=rlist
  If refchk = "" Quit refchk
  set rlen=$LENGTH(rlist,",")
  if rlen=1 {
	set reftopic=##class(KB.Topic).%OpenId(rlist)
	if '$IsObject(reftopic) {
	  set refchk=""
	}
  }
  else {
	for i=1:1:rlen {
	  set refid=$PIECE(rlist,",",i)
	  set reftopic=##class(KB.Topic).%OpenId(refid)
	  if '$IsObject(reftopic) {
	    set refchk=""
	  }
	}
  }

   //チェックNGの場合は""、チェックOKの場合は、スペースを抜いた文字列を返す
  quit refchk
}

ClassMethod ChangeUrlPathForImages()
{
   try {
     //ckeditorで追加したイメージは、絶対パスでhtmlに埋め込まれるため、本番移行、テスト移行等の際、ネームスペースが異なると表示されなくなるので、相対パスに変更する
     //今後は、トピックの保存の際、この変換を行うので、インストールの際には必要なくなる
     set sql = "select %ID,Description from KB.Topic where Description [ '/csp/knowledge/images/'"
     set newnamespace = $zcvt($namespace,"L")
     set statement = ##class(%SQL.Statement).%New()
     set status = statement.%Prepare(sql)
     if 'status $$$ThrowStatus(status)
     set rs = statement.%Execute()
     While rs.%Next() {
       set id = rs.%Get("ID")
       set topic = ##class(KB.Topic).%OpenId(id)
       set desc = topic.Description
       set topic.Description = $replace(desc,"/csp/knowledge/images/","./images/")
       set status = topic.%Save()
       if 'status $$$ThrowStatus(status)
      }
    }
    catch ex {
      set status = ##class(FAQ.Error).StoreErrorInformation(ex)  
    }
}

ClassMethod UpdatePropertyOfMultipleTopics(pTopicIdPropertyOBJ As %String) As %Status
{
   try {
     //TopicId, PropertyペアのArrayを入力とし、該当するTopicのPropertyを更新する
     // Property = [Product,Category,Facility,Completed,Visible,DeleteFlg]
     //
     set status = $$$OK
     set DynamicOBJ = {}
     set DynamicOBJ = DynamicOBJ.%FromJSON(pTopicIdPropertyOBJ)
     set PropertyName = DynamicOBJ.PropertyName
     set DynamicArray = DynamicOBJ.KVArray
     set it = DynamicArray.%GetIterator()
     while it.%GetNext(.i,.do) {
       set topicid = do."topicid"
       set PropertyValue = do."PropertyValue" 
       set topic = ##class(KB.Topic).%OpenId(topicid,,.status)
       if 'status $$$ThrowStatus(status)
       if (PropertyName = "Product") || (PropertyName = "Category") || (PropertyName = "Facility") {
         set classname = "KB."_PropertyName
         set oref = $classmethod(classname,"%OpenId",PropertyValue,,.status)
         if '$isobject(oref) $$$ThrowStatus(status)
         set $Property(topic,PropertyName) = oref
       }
       else {
         set $Property(topic,PropertyName) = $select(PropertyValue=1:1,1:0)
       }
       set status = topic.%Save() 
       if 'status  $$$ThrowStatus(status)             
     }
    }
    catch ex {
      set exstatus = ##class(FAQ.Error).StoreErrorInformation(ex)  
    }	
    
    quit status
}

ClassMethod CopyFromTopics(pTopicIdList As %List, Output pNewTopicIdList As %List) As %Status
{
   try {
     //パラメータpTopicIdListで指定されたtopicidのインスタンスをコピーして新しいトピックを生成する
     //新しいtopicidのリストを出力パラメータとして第2パラメータで返す
     //
     set status = $$$OK
     set pNewTopicIdList = ""
     for i = 1:1:$listlength(pTopicIdList) {
       set topicid = $list(pTopicIdList,i)
       set topic = ..%OpenId(topicid)
       if $isobject(topic) {
         set clone = topic.%ConstructClone(0)
         set status = clone.%Save(0)
         if 'status $$$ThrowStatus(status)
         set newid = clone.%Id()
         set $list(pNewTopicIdList,$listlength(pNewTopicIdList)+1) = newid
       }
     }
    }
    catch ex {
      set exstatus = ##class(FAQ.Error).StoreErrorInformation(ex)  
    }	
    
    quit status
}

/*
ClassMethod GetEmbedding(sentences) As %String [ Language = python, SqlProc ]
{
   from sentence_transformers import SentenceTransformer as ST
   # vector =  DOUBLE,768
   model = ST('stsb-xlm-r-multilingual')
   embeddings = model.encode(sentences,normalize_embeddings=True)
   # convert the embeddings to a string
   embeddings_list = [str(embedding.tolist()) for embedding in embeddings]
   return str(embeddings_list).replace('\'','')
}
*/

ClassMethod RemoveHTMLTag(text) As %String [ Language = python ]
{
  import re

  clean = re.compile('<.*?>')
  return re.sub(clean, '', text)
}

/*
ClassMethod BuildVectorForDescriptions() As %Status
{
  //　全トピックのDescriptionに対してベクター（エンべディング）を生成し、最後にHNSWインデックスを付加する	
  set status = $$$OK
  try {
	set statement = ##class(%SQL.Statement).%New()
	set sql = "select ID,TITLE,DESCRIPTION from kb.topic"
	set status = statement.%Prepare(sql)
	$$$ThrowOnError(status)
	set updatestatement = ##class(%SQL.Statement).%New()
	set updatesql = "update kb.topic set descriptionvector = TO_VECTOR(?,DOUBLE,768) where id = ?"
	$$$ThrowOnError(status)
	set rs = statement.%Execute()
	while rs.%Next() {
	  set id = rs.%Get("ID")
	  set description = ..RemoveHTMLTag(rs.%Get("DESCRIPTION"))
	  set title = rs.%Get("TITLE")
	  set vector = $translate(..GetEmbedding(title_" "_description)," '[]")
	  set rs2 = updatestatement.%ExecDirect(,updatesql,vector,id)    	
	}

    set status =  ..%BuildIndices($listbuild("HNSWDescriptionIndex"))
	$$$ThrowOnError(status)
  }
  Catch e {
	do e.Log()
	Set status = e.AsStatus()
	set status2 = ##class(FAQ.Error).StoreErrorInformation(e)
  }
  quit status
}
*/

}
