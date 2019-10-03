Class ObjectScript.DataEntry1
{

ClassMethod Main()
{
  read !, "Name: " , name
  if name = "" { quit }  // user entered nothing
  read !, "Phone: ", phone
  read !, "DOB: ", dob

  // display the data
  write !!!, "Name:", ?20, name
  write !, "Phone:", ?20, phone
  write !, "DOB:", ?20, dob
}

}
