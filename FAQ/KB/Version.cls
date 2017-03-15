Class KB.Version Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

/// 表示用バージョン番号
Property ExternalVersion As %String(MAXLEN = 20, TRUNCATE = 1);

/// 内部バージョン（大小比較用）
Property InternalVersion As %Integer;

/// 時系列順ID
Property OrderId As %Integer;

Index ExternalVersionIndex On ExternalVersion;

Index InternalVersionIndex On InternalVersion;

Index OrderIdIndex On OrderId;

Query QueryAll() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID FROM Version
 ORDER BY %ID
}

Query ListDescription() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,ExternalVersion FROM Version ORDER BY OrderId
}

// Parameter XMLSUMMARY = ID;

Parameter XMLDEFAULTREFERENCE = "ID";

ClassMethod Init()
{
	Do ##class(KB.Version).%KillExtent()
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('300','3.0'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('310','3.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('320','3.2.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('400','4.0.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('410','4.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('500','5.0.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('510','5.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('520','5.2.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20071','2007.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20081','2008.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20082','2008.2.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20091','2009.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20101','2010.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20102','2010.2.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20111','2011.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20121','2012.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20122','2012.2.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20131','2013.1.x'))
	&SQL(insert into KB.Version (InternalVersion,ExternalVersion) values ('20141','2014.1.x'))
}

Storage Default
{
<Data name="VersionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExternalVersion</Value>
</Value>
<Value name="3">
<Value>InternalVersion</Value>
</Value>
<Value name="4">
<Value>OrderId</Value>
</Value>
</Data>
<DataLocation>^KB.VersionD</DataLocation>
<DefaultData>VersionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^KB.VersionD</IdLocation>
<IndexLocation>^KB.VersionI</IndexLocation>
<StreamLocation>^KB.VersionS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
