/// Persistent class for Persons
Class ObjectScript.Person Extends %Persistent
{

Property Name As %String(PATTERN = "1U.L1"",""1U.L");

Property LastName As %String [ Calculated, SqlComputeCode = {set {LastName}=$p({Name},",",1)}, SqlComputed ];

Property FirstName As %String [ Calculated, SqlComputeCode = {set {FirstName}=$p({Name},",",2)}, SqlComputed ];

Property Phone As %String(PATTERN = "3n1""-""3n1""-""4n");

Property DOB As %Date(MAXVAL = "$piece($horolog, "","", 1)");

/// Index for LastName,FirstName
Index NameIndex On (LastName, FirstName);

/// Uniqueness index for property Phone
Index PhoneIndex On Phone [ Unique ];

/// Index for property DOB
Index DOBIndex On DOB;

/// Bitmap index of ID numbers
Index IDIndex [ Extent, Type = bitmap ];

Storage Default
{
<Data name="PersonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Phone</Value>
</Value>
<Value name="4">
<Value>DOB</Value>
</Value>
</Data>
<DataLocation>^ObjectScript.PersonD</DataLocation>
<DefaultData>PersonDefaultData</DefaultData>
<IdLocation>^ObjectScript.PersonD</IdLocation>
<IndexLocation>^ObjectScript.PersonI</IndexLocation>
<StreamLocation>^ObjectScript.PersonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
