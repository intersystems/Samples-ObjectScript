Class ObjectScript.DataEntry2
{

/// Main loop section
ClassMethod Main()
{
  while ..Prompt() {
    do ..Display()
  }
}

/// prompt
ClassMethod Prompt() As %Boolean [ PublicList = (name, phone, dob) ]
{
  read !, "Name: ", name
  return:(name = "") 0  // user entered nothing so return FALSE and exit method
  read !, "Phone: ", phone
  read !, "DOB: ", dob
  return 1  // return true
}

/// display the data
ClassMethod Display() [ PublicList = (name, phone, dob) ]
{
  write !!, "========================================"
  write !, "Name:", ?20, name
  write !, "Phone:", ?20, phone
  write !, "DOB:", ?20, dob
  write !, "========================================", !
}

}
