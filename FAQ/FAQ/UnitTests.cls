Class FAQ.UnitTests Extends %UnitTest.TestCase
{

Method TestExceptionError()
{
 set tCurErrId = $get(^FAQ.ErrorD)	
 do $$$AssertStatusOK(##class(FAQ.Test).ExceptionError(), "Genarating Exception error")
 do $$$AssertEquals($get(^FAQ.ErrorD),tCurErrId+1, "Comfirming a FAQ.Error object has been produced")
}

Method TestCurrentTopicSubId()
{
 set tTopicSubId = $Get(^TopicSubID) + 1	
 do $$$AssertEquals(##class(FAQ.Test).CurrentTopicSubId(),tTopicSubId, "Getting ^TopicSubID + 1")
}

Method TestTopicId()
{
 set tTopicId = "G-003"	
 do $$$AssertEquals(##class(FAQ.Test).TopicId(1),tTopicId, "Getting a Topicid in G- format")
 set tTopicId = "00100"	
 do $$$AssertEquals(##class(FAQ.Test).TopicId(100),tTopicId, "Getting a TopicId in as is format")
}

Method TestReflink()
{
 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic2 = ##class(KB.Topic).%OpenId(2)
 set tTopic1.RefTopic = ""
 set tTopic2.RefTopic = ""
 set tSC = tTopic1.%Save()
 set tSC = tTopic2.%Save()
 set tResult = "2;1"	
 do $$$AssertEquals(##class(FAQ.Test).Reflink2(1,2),tResult, "Linking RefTopic 1 & 2")
 do $$$AssertEquals(##class(FAQ.Test).Reflink2(1,2),tResult, "Linking RefTopic 1 & 2 (already linked)")
 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic2 = ##class(KB.Topic).%OpenId(2)
 set tTopic1.RefTopic = ""
 set tTopic2.RefTopic = ""
 set tSC = tTopic1.%Save()
 set tSC = tTopic2.%Save()
 set tResult = "2,3;1;1"	
 do $$$AssertEquals(##class(FAQ.Test).Reflink3(1,2,3),tResult, "Linking RefTopic 1 & 2 & 3")
 do $$$AssertEquals(##class(FAQ.Test).Reflink3(1,2,3),tResult, "Linking RefTopic 1 & 2 & 3 (aleady linked")
 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic2 = ##class(KB.Topic).%OpenId(2)
 set tTopic3 = ##class(KB.Topic).%OpenId(3)
 set tTopic1.RefTopic = ""
 set tTopic2.RefTopic = ""
 set tTopic3.RefTopic = ""
 set tSC = tTopic1.%Save()
 set tSC = tTopic2.%Save()
 set tSC = tTopic3.%Save()
 set tResult1 = "3;2"
 set tResult2 = "2;3,1"
 do $$$AssertEquals(##class(FAQ.Test).Reflink2(2,3),tResult1, "Linking RefTopic 2 & 3")
 do $$$AssertEquals(##class(FAQ.Test).Reflink2(1,2),tResult2, "Linking RefTopic 1 & 2 2 has already a link")
 do $$$AssertEquals(##class(FAQ.Test).Reflink2(1,2),tResult2, "Linking RefTopic 1 & 2 2 has already a link aleady linked")
 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic2 = ##class(KB.Topic).%OpenId(2)
 set tTopic3 = ##class(KB.Topic).%OpenId(3)
 set tTopic1.RefTopic = ""
 set tTopic2.RefTopic = ""
 set tTopic3.RefTopic = ""
 set tSC = tTopic1.%Save()
 set tSC = tTopic2.%Save()
 set tSC = tTopic3.%Save()
}

Method TestRemoveLink()
{

 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic1.RefTopic = "2,3"
 set tSC = tTopic1.%Save()
 do tTopic1.RefCheckLink(0)
 Set tSC = ##class(KB.Topic).RemoveLink(1,"2,3","3")
 Set tTopic2 = ##class(KB.Topic).%OpenId(2)
 Set tResult = tTopic2.RefTopic
 do $$$AssertEquals("",tResult, "Remove id 2 of the id 1")
 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic2 = ##class(KB.Topic).%OpenId(2)
 set tTopic3 = ##class(KB.Topic).%OpenId(3)
 set tTopic1.RefTopic = ""
 set tTopic2.RefTopic = ""
 set tTopic3.RefTopic = ""
 set tSC = tTopic1.%Save()
 set tSC = tTopic2.%Save()
 set tSC = tTopic3.%Save()
 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic1.RefTopic = "3,2"
 set tSC = tTopic1.%Save()
 do tTopic1.RefCheckLink(0)
 Set tSC = ##class(KB.Topic).RemoveLink(1,"3,2","3")
 Set tTopic2 = ##class(KB.Topic).%OpenId(2)
 Set tResult = tTopic2.RefTopic
 do $$$AssertEquals("",tResult, "Remove id 2 of the id 1")

 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic2 = ##class(KB.Topic).%OpenId(2)
 set tTopic3 = ##class(KB.Topic).%OpenId(3)
 set tTopic1.RefTopic = ""
 set tTopic2.RefTopic = ""
 set tTopic3.RefTopic = ""
 set tSC = tTopic1.%Save()
 set tSC = tTopic2.%Save()
 set tSC = tTopic3.%Save()
 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic1.RefTopic = "3,2"
 set tSC = tTopic1.%Save()
 do tTopic1.RefCheckLink(0)
 Set tSC = ##class(KB.Topic).RemoveLink(1,"3,2","3,2")
 Set tTopic2 = ##class(KB.Topic).%OpenId(2)
 Set tResult = tTopic2.RefTopic
 do $$$AssertEquals("1",tResult, "No Change")

 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic2 = ##class(KB.Topic).%OpenId(2)
 set tTopic3 = ##class(KB.Topic).%OpenId(3)
 set tTopic1.RefTopic = ""
 set tTopic2.RefTopic = ""
 set tTopic3.RefTopic = ""
 set tSC = tTopic1.%Save()
 set tSC = tTopic2.%Save()
 set tSC = tTopic3.%Save()
 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic1.RefTopic = "3,2"
 set tSC = tTopic1.%Save()
 do tTopic1.RefCheckLink(0)
 Set tSC = ##class(KB.Topic).RemoveLink(1,"3,2","")
 Set tTopic2 = ##class(KB.Topic).%OpenId(2)
 Set tResult = tTopic2.RefTopic
 do $$$AssertEquals("",tResult, "Remove id 2 of the id 1")
 Set tTopic3 = ##class(KB.Topic).%OpenId(2)
 Set tResult = tTopic3.RefTopic
 do $$$AssertEquals("",tResult, "Remove id 3 of the id 1")

 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic2 = ##class(KB.Topic).%OpenId(2)
 set tTopic3 = ##class(KB.Topic).%OpenId(3)
 set tTopic1.RefTopic = ""
 set tTopic2.RefTopic = ""
 set tTopic3.RefTopic = ""
 set tSC = tTopic1.%Save()
 set tSC = tTopic2.%Save()
 set tSC = tTopic3.%Save()
 set tTopic1 = ##class(KB.Topic).%OpenId(1)
 set tTopic1.RefTopic = "3,2"
 set tSC = tTopic1.%Save()
 do tTopic1.RefCheckLink(0)
 Set tSC = ##class(KB.Topic).RemoveLink(1,"3,2","3;2")
 do $$$AssertStatusNotOK(tSC, "Format Error")
}

Method TestFindKatakanaWord()
{
 set tString = "�J�^�J�i"	
 set tResult = 1
 do $$$AssertEquals(##class(Text.MecabJapanese2).FindKatakanaWord(tString,3),tResult, "Found a Katakana Word")
 set tString = "�J�^�J�i"	
 set tResult = 0
 do $$$AssertEquals(##class(Text.MecabJapanese2).FindKatakanaWord(tString),tResult, "The length is short")
 set tString = "abc�J�^�J�i"	
 set tResult = 1
 do $$$AssertEquals(##class(Text.MecabJapanese2).FindKatakanaWord(tString,3),tResult, "Found a Katakana Word")
 set tString = "�J�^�J�iabc"	
 set tResult = 1
 do $$$AssertEquals(##class(Text.MecabJapanese2).FindKatakanaWord(tString,3),tResult, "Found a Katakana Word")
 set tString = "�J�^abc�J�^�J�i"	
 set tResult = 1
 do $$$AssertEquals(##class(Text.MecabJapanese2).FindKatakanaWord(tString,3),tResult, "Found a Katakana Word")
 set tString = "��������"	
 set tResult = 0
 do $$$AssertEquals(##class(Text.MecabJapanese2).FindKatakanaWord(tString,3),tResult, "Not Found a Katakana Word")
}

Method TestSpritKatakanaKeyWord()
{
 set tString = "�A���C���X�g�[��"	
 set tResult = "�A�� �C���X�g�[�� "
 do $$$AssertEquals(##class(Text.MecabJapanese2).SpritKatakanaKeyWord(tString,20),tResult, "Found a Katakana KeyWord")
 set tString = "�A���C���X�g�[��"	
 set tResult = "�A���C���X�g�[��"
 do $$$AssertEquals(##class(Text.MecabJapanese2).SpritKatakanaKeyWord(tString,7),tResult, "The length is long")
 set tString = "�A���C���X�g�[�����|�[�g"	
 set tResult = "�A�� �C���X�g�[�� ���|�[�g "
 do $$$AssertEquals(##class(Text.MecabJapanese2).SpritKatakanaKeyWord(tString,20),tResult, "Found Katakana KeyWords")
 set tString = "�A���C���X�g�[�����|"	
 set tResult = "�A�� �C���X�g�[�� ���|"
 do $$$AssertEquals(##class(Text.MecabJapanese2).SpritKatakanaKeyWord(tString,20),tResult, "Found a Katakana KeyWord")
 set tString = "abc�A���C���X�g�[�����|"	
 set tResult = "abc�A�� �C���X�g�[�� ���|"
 do $$$AssertEquals(##class(Text.MecabJapanese2).SpritKatakanaKeyWord(tString,20),tResult, "Found a Katakana KeyWords")
 set tString = "�A���C���X�g�[�����|abc"	
 set tResult = "�A�� �C���X�g�[�� ���|abc"
 do $$$AssertEquals(##class(Text.MecabJapanese2).SpritKatakanaKeyWord(tString,20),tResult, "Found a Katakana KeyWord")
}

}