Class ObjectScript.DataEntry4
{

/// Main loop section
ClassMethod Main()
{
  While ..Prompt(.answers) {       
    Do ..Display(answers)
    Do ..Store(answers)
  }
}

/// prompt
ClassMethod Prompt(ByRef answers As %String) As %Boolean
{
  Do {
    Read !, "Name: ", name
    Return:(name = "") 0  // user entered nothing so return FALSE, exit loop AND method
  } While '..ValidName(name)

  Do {
    Read !, "Phone (617): ", phone
  } While '..ValidPhone(.phone)

  Do {
    Read !, "DOB: ", dob
  } While '..ValidDOB(dob, .intdob)

  Set answers = $Listbuild(name, phone, intdob)
  Return 1  // return true
}

/// use pattern match to validate a name in "Last,First" format.
/// write error message if invalid
ClassMethod ValidName(name As %String) As %Boolean
{
  If (name?1U.L1","1U.L) {
    Return 1 
  }
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
    // is phone already taken?
    If $Data(^PersonI("Phone", phone)) {
      Write !, "Phone number already in use"
      Return 0
    }
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

/// store the data
ClassMethod Store(answers As %String)
{
  Read !, "Store? (y/n): ", yn  // ask if user wants to store
  // only go on if user says yes
  If ((yn '= "y") && (yn '= "Y")) {
    Write "...not stored."
    Quit
  }

  Set id = $Increment(^PersonD)  // use $Increment to generate a new ID
  // change all globals inside a transaction
  TStart
  Set ^PersonD(id) = answers  // store the answers

  Set $Listbuild(name, phone, intdob) = answers
  // split name into last and first for storage in index
  Set last = $Piece(name, ",", 1), first = $Piece(name, ",", 2)

	/* the next three statements store data in subscripts.
  because of the automatic sorting of subscripts,
  this has the effect of building 3 indices: name, phone, and DOB */
  Set ^PersonI("Name", last, first, id) = ""  // index last and first name
  Set ^PersonI("Phone", phone) = id           // index the UNIQUE phone
  Set ^PersonI("DOB", intdob, id) = ""        // index the internal DOB

	/* these statements turn the id into a "chunk #" and a "position #"
  and set a bit into the bitmap index */
  Set chunk = (id\64000) + 1, position = (id#64000) + 1
  Set $Bit(^PersonI("Bitmap-ID", chunk), position) = 1
  TCommit
  Write "...stored"
}

/// load some test records
ClassMethod Load()
{
  Kill ^PersonD, ^PersonI
  Do ##class(ObjectScript.Person).%KillExtent()
  Set answers = $Listbuild("Jones,Cleon","111-111-1111",37105)
  Do ..Store(answers)
  Set person = ##class(ObjectScript.Person).%New()
  Set person.Name = $List(answers, 1), person.Phone = $List(answers, 2), person.DOB = $List(answers, 3)
  Write person.%Save(),!
  Set answers = $Listbuild("Agee,Tommie","617-333-3333",37110)
  Do ..Store(answers)
  Set person = ##class(ObjectScript.Person).%New()
  Set person.Name = $List(answers, 1), person.Phone = $List(answers, 2), person.DOB = $List(answers, 3)
  Write person.%Save(),!
  Set answers = $Listbuild("Swoboda,Ron","222-222-2222",37779)
  Do ..Store(answers)
  Set person = ##class(ObjectScript.Person).%New()
  Set person.Name = $List(answers, 1), person.Phone = $List(answers, 2), person.DOB = $List(answers, 3)
  Write person.%Save(),!
  Set answers = $Listbuild("Jones,Bobby","333-444-5555",47157)
  Do ..Store(answers)	
  Set person = ##class(ObjectScript.Person).%New()
  Set person.Name = $List(answers, 1), person.Phone = $List(answers, 2), person.DOB = $List(answers, 3)
  Write person.%Save(),!
}

}
