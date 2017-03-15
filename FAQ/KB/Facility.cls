Class KB.Facility Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

/// 説明
Property Description As %String(TRUNCATE = 1);

Index DescriptionIndex On Description;

Parameter XMLDEFAULTREFERENCE = "ID";

Query QueryAll() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID FROM Facility
 ORDER BY %ID
}

Query ListDescription() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Description FROM Facility
}

ClassMethod Init()
{
	Do ##class(KB.Facility).%KillExtent()
	&SQL(insert into KB.Facility (Description) values ('一般的質問'))
	&SQL(insert into KB.Facility (Description) values ('Caché ObjectScript'))
	&SQL(insert into KB.Facility (Description) values ('Object'))
	&SQL(insert into KB.Facility (Description) values ('SQL'))
	&SQL(insert into KB.Facility (Description) values ('CSP'))
	&SQL(insert into KB.Facility (Description) values ('Java'))
	&SQL(insert into KB.Facility (Description) values ('.NET'))
	&SQL(insert into KB.Facility (Description) values ('言語バインディング'))
	&SQL(insert into KB.Facility (Description) values ('XML'))
	&SQL(insert into KB.Facility (Description) values ('Web Service'))
	&SQL(insert into KB.Facility (Description) values ('システム'))
	&SQL(insert into KB.Facility (Description) values ('その他'))
	&SQL(insert into KB.Facility (Description) values ('Ensemble'))
	&SQL(insert into KB.Facility (Description) values ('DeepSee'))
	&SQL(insert into KB.Facility (Description) values ('iKnow'))
}

Storage Default
{
<Data name="FacilityDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^KB.FacilityD</DataLocation>
<DefaultData>FacilityDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^KB.FacilityD</IdLocation>
<IndexLocation>^KB.FacilityI</IndexLocation>
<StreamLocation>^KB.FacilityS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
