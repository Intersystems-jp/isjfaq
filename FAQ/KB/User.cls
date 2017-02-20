/// ���[�U
Class KB.User Extends %Persistent
{

/// ���[�U��
Property Name As %String(TRUNCATE = 1);

Index NameIndex On Name;

/// �p�X���[�h
Property Password As %String(TRUNCATE = 1) [ Private ];

/// �p�X���[�h�̈Í���
Method SetPassword(New As %String, Old As %String) As %Boolean
{
	If (..Password '= "")
	{
		If (Old '= $System.Encryption.AESCBCDecrypt(..Password,"1234567890")) Quit 0
	}
	Set ..Password = $System.Encryption.AESCBCEncrypt(New,"1234567890")
	Quit $$$OK
}

/// �p�X���[�h�̕�����
Method VerifyPassword(Arg1 As %String) As %Boolean
{
	If Arg1 = $System.Encryption.AESCBCDecrypt(..Password,"1234567890") 
	{Quit $$$OK}
	Else {Quit 0}
}

Query ByName(Name As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID FROM "User"
 WHERE (Name = :Name)
}

/// ����
Property Simei As %String(TRUNCATE = 1);

/// email�A�h���X
Property Email As %String(TRUNCATE = 1);

/// ��Ж�
Property Company As %String(TRUNCATE = 1);

/// ������
Property Dept As %String(TRUNCATE = 1);

/// �Ǘ��҃t���O
Property Admin As %Boolean;

Storage Default
{
<Data name="UserDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Password</Value>
</Value>
<Value name="4">
<Value>Company</Value>
</Value>
<Value name="5">
<Value>Dept</Value>
</Value>
<Value name="6">
<Value>Email</Value>
</Value>
<Value name="7">
<Value>Simei</Value>
</Value>
<Value name="8">
<Value>Admin</Value>
</Value>
</Data>
<DataLocation>^KB.UserD</DataLocation>
<DefaultData>UserDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^KB.UserD</IdLocation>
<IndexLocation>^KB.UserI</IndexLocation>
<StreamLocation>^KB.UserS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}