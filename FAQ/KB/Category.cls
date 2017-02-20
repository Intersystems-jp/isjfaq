/// ���敪
Class KB.Category Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

/// ����
Property Description As %String(TRUNCATE = 1);

Index DescriptionIndex On Description;

Query QueryAll() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID FROM Category
 ORDER BY %ID
}

Query ListDescription() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Description FROM Category
}

ClassMethod Init()
{
	Do ##class(KB.Category).%KillExtent()
	&SQL(insert into KB.Category (Description) values ('�Z�p���'))
	&SQL(insert into KB.Category (Description) values ('�T���v���R�[�h'))
	&SQL(insert into KB.Category (Description) values ('��������'))
	&SQL(insert into KB.Category (Description) values ('�A���[�g'))
	&SQL(insert into KB.Category (Description) values ('���̑�'))
}

Storage Default
{
<Data name="CategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^KB.CategoryD</DataLocation>
<DefaultData>CategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^KB.CategoryD</IdLocation>
<IndexLocation>^KB.CategoryI</IndexLocation>
<StreamLocation>^KB.CategoryS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}