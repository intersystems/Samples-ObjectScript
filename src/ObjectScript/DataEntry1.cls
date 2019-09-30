Class ObjectScript.DataEntry1
{

ClassMethod Main()
{
  Read !, "Name: " , name
  If name = "" { quit }  // user entered nothing
  Read !, "Phone: ", phone
  Read !, "DOB: ", dob

  // display the data
  Write !!!, "Name:", ?20, name
  Write !, "Phone:", ?20, phone
  Write !, "DOB:", ?20, dob
}

}
