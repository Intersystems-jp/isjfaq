Class KB.Product Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

/// 説明
Property ProductName As %String(TRUNCATE = 1);

Index ProductNameIndex On ProductName;

Query QueryAll() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID FROM Category
 ORDER BY %ID
}

Query ListProduct() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,ProductName FROM Product
}

ClassMethod Init()
{
	Do ##class(KB.Product).%KillExtent()
	&SQL(insert into KB.Product (ProductName) values ('一般'))
	&SQL(insert into KB.Product (ProductName) values ('Caché'))
	&SQL(insert into KB.Product (ProductName) values ('Ensemble'))
	&SQL(insert into KB.Product (ProductName) values ('HealthShare'))
	&SQL(insert into KB.Product (ProductName) values ('IRIS Data Platform'))
}

Storage Default
{
<Data name="ProductDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ProductName</Value>
</Value>
</Data>
<DataLocation>^KB.ProductD</DataLocation>
<DefaultData>ProductDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^KB.ProductD</IdLocation>
<IndexLocation>^KB.ProductI</IndexLocation>
<StreamLocation>^KB.ProductS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
