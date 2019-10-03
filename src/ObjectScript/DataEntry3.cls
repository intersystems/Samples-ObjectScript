Class ObjectScript.DataEntry3
{

/// Main loop section
ClassMethod Main()
{
  while ..Prompt(.answers) {       
    do ..Display(answers)
  }
}

/// prompt
ClassMethod Prompt(ByRef answers As %String) As %Boolean
{
  do {
    read !, "Name: ", name
    return:(name = "") 0  // user entered nothing so return FALSE, exit loop AND method
  } while '..ValidName(name)

  do {
    read !, "Phone (617): ", phone
  } while '..ValidPhone(.phone)

  do {
    read !, "DOB: ", dob
  } while '..ValidDOB(dob, .intdob)
  set answers = $listbuild(name, phone, intdob)
  return 1  // return true
}

/// use pattern match to validate a name in "Last,First" format.
/// write error message if invalid
ClassMethod ValidName(name As %String) As %Boolean
{
  if (name?1U.L1","1U.L) {
    return 1 
  }
  else {
    write !,"Last,First"
    return 0
  }
}

/// use RegEx ($match) to validate a phone in "###-####" or "###-###-####" format.
/// returns the converted phone by reference
/// write error message if invalid
ClassMethod ValidPhone(ByRef phone As %String) As %Boolean
{
  if $match(phone, "(\d{3}-)?\d{3}-\d{4}") {
    set:($match(phone, "\d{3}-\d{4}")) phone = "617-" _ phone  // add default area code
    return 1
  }
  else {
    write !, "###-###-#### or ###-####"
    return 0
  }
}

/// validate a date of birth using $zdateh and $horolog
/// returns the internal form of the date of birth by reference
/// write error message if invalid
ClassMethod ValidDOB(date As %String, Output convdate As %Date) As %Boolean
{
  set convdate = $zdateh(date, 5,,,,,,, -1)
  if (convdate = -1) {
    write !,"Must be a valid past date"
    return 0  // invalid date
  }
  elseif (convdate > $piece($horolog, ",", 1)) {
    write !,"Must be a valid past date"
    return 0  // invalid because it's in the future
  }
  else {
    return 1  // valid date
  }
}

/// display the data
ClassMethod Display(answers As %String)
{
  set $listbuild(name, phone, intdob) = answers
	/* the line above is equivalent to
  set name = $list(answers, 1),
  phone = $list(answers, 2),
  intdob = $list(answers, 3) */
  write !!, "========================================"
  write !, "Name:", ?20, name
  write !, "Phone:", ?20, phone
  write !, "DOB:", ?20, $zdate(intdob, 2)
  write !, "========================================", !
}

}
