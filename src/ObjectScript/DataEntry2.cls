Class ObjectScript.DataEntry2
{

/// Main loop section
ClassMethod Main()
{
  While ..Prompt() {
    Do ..Display()
  }
}

/// prompt
ClassMethod Prompt() As %Boolean [ PublicList = (name, phone, dob) ]
{
  Read !, "Name: ", name
  Return:(name = "") 0  // user entered nothing so return FALSE and exit method
  Read !, "Phone: ", phone
  Read !, "DOB: ", dob
  Return 1  // return true
}

/// display the data
ClassMethod Display() [ PublicList = (name, phone, dob) ]
{
  Write !!, "========================================"
  Write !, "Name:", ?20, name
  Write !, "Phone:", ?20, phone
  Write !, "DOB:", ?20, dob
  Write !, "========================================", !
}

}
