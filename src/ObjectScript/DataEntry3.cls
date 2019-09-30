Class ObjectScript.DataEntry3
{

/// Main loop section
ClassMethod Main()
{
  While ..Prompt(.answers) {       
    Do ..Display(answers)
  }
}

/// prompt
ClassMethod Prompt(ByRef answers As %String) As %Boolean
{
  Do {
    Read !, "Name: ", name
    Return:(name = "") 0  // user entered nothing so return FALSE, exit loop AND method
  }
  While '..ValidName(name)

  Do {
    Read !, "Phone (617): ", phone
  }
  While '..ValidPhone(.phone)

  Do {
    Read !, "DOB: ", dob
  }
  While '..ValidDOB(dob, .intdob)
  Set answers = $Listbuild(name, phone, intdob)
  Return 1  // return true
}

/// use pattern match to validate a name in "Last,First" format.
/// write error message if invalid
ClassMethod ValidName(name As %String) As %Boolean
{
  If (name?1U.L1","1U.L) {
    Return 1 }
    Else {
      Write !,"Last,First"
      Return 0
    }
}

/// use RegEx ($Match) to validate a phone in "###-####" or "###-###-####" format.
/// returns the converted phone by reference
/// write error message if invalid
ClassMethod ValidPhone(ByRef phone As %String) As %Boolean
{
  If $Match(phone, "(\d{3}-)?\d{3}-\d{4}") {
    Set:($Match(phone, "\d{3}-\d{4}")) phone = "617-" _ phone  // add default area code
    Return 1
  }
  Else {
    Write !, "###-###-#### or ###-####"
    Return 0
  }
}

/// validate a date of birth using $ZDateh and $Horolog
/// returns the internal form of the date of birth by reference
/// write error message if invalid
ClassMethod ValidDOB(date As %String, Output convdate As %Date) As %Boolean
{
  Set convdate = $ZDateh(date, 5,,,,,,, -1)
  If (convdate = -1) {
    Write !,"Must be a valid past date"
    Return 0  // invalid date
  }
  ElseIf (convdate > $Piece($Horolog, ",", 1)) {
    Write !,"Must be a valid past date"
    Return 0  // invalid because it's in the future
  }
  Else {
    Return 1  // valid date
  }
}

/// display the data
ClassMethod Display(answers As %String)
{
  Set $Listbuild(name, phone, intdob) = answers
	/* the line above is equivalent to
  Set name = $List(answers, 1),
  phone = $List(answers, 2),
  intdob = $List(answers, 3) */
  Write !!, "========================================"
  Write !, "Name:", ?20, name
  Write !, "Phone:", ?20, phone
  Write !, "DOB:", ?20, $ZDate(intdob, 2)
  Write !, "========================================", !
}

}
