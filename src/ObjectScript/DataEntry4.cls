Class ObjectScript.DataEntry4
{

/// Main loop section
ClassMethod Main()
{
  while ..Prompt(.answers) {       
    do ..Display(answers)
    do ..Store(answers)
  }
}

/// prompt
ClassMethod Prompt(ByRef answers As %String) As %Boolean
{
  do {
    read !, "Name: ", name
    return:(name = "") 0  // user entered nothing so return FALSE, exit loop AND method
  } While '..ValidName(name)

  do {
    read !, "Phone (617): ", phone
  } While '..ValidPhone(.phone)

  do {
    read !, "DOB: ", dob
  } While '..ValidDOB(dob, .intdob)

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
    // is phone already taken?
    if $data(^PersonI("Phone", phone)) {
      write !, "Phone number already in use"
      return 0
    }
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

/// store the data
ClassMethod Store(answers As %String)
{
  read !, "Store? (y/n): ", yn  // ask if user wants to store
  // only go on if user says yes
  if ((yn '= "y") && (yn '= "Y")) {
    write "...not stored."
    quit
  }

  set id = $increment(^PersonD)  // use $increment to generate a new ID
  // change all globals inside a transaction
  tstart
  set ^PersonD(id) = answers  // store the answers

  set $listbuild(name, phone, intdob) = answers
  // split name into last and first for storage in index
  set last = $piece(name, ",", 1), first = $piece(name, ",", 2)

	/* the next three statements store data in subscripts.
  because of the automatic sorting of subscripts,
  this has the effect of building 3 indices: name, phone, and DOB */
  set ^PersonI("Name", last, first, id) = ""  // index last and first name
  set ^PersonI("Phone", phone) = id           // index the UNIQUE phone
  set ^PersonI("DOB", intdob, id) = ""        // index the internal DOB

	/* these statements turn the id into a "chunk #" and a "position #"
  and set a bit into the bitmap index */
  set chunk = (id\64000) + 1, position = (id#64000) + 1
  set $bit(^PersonI("Bitmap-ID", chunk), position) = 1
  tcommit
  write "...stored"
}

/// load some test records
ClassMethod Load()
{
  kill ^PersonD, ^PersonI
  do ##class(ObjectScript.Person).%KillExtent()
  set answers = $listbuild("Jones,Cleon","111-111-1111",37105)
  do ..Store(answers)
  set person = ##class(ObjectScript.Person).%New()
  set person.Name = $list(answers, 1), person.Phone = $list(answers, 2), person.DOB = $list(answers, 3)
  write person.%Save(),!
  set answers = $listbuild("Agee,Tommie","617-333-3333",37110)
  do ..Store(answers)
  set person = ##class(ObjectScript.Person).%New()
  set person.Name = $list(answers, 1), person.Phone = $list(answers, 2), person.DOB = $list(answers, 3)
  write person.%Save(),!
  set answers = $listbuild("Swoboda,Ron","222-222-2222",37779)
  do ..Store(answers)
  set person = ##class(ObjectScript.Person).%New()
  set person.Name = $list(answers, 1), person.Phone = $list(answers, 2), person.DOB = $list(answers, 3)
  write person.%Save(),!
  set answers = $listbuild("Jones,Bobby","333-444-5555",47157)
  do ..Store(answers)	
  set person = ##class(ObjectScript.Person).%New()
  set person.Name = $list(answers, 1), person.Phone = $list(answers, 2), person.DOB = $list(answers, 3)
  write person.%Save(),!
}

}
