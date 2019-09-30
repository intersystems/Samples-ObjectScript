Class ObjectScript.Lookup2
{

/// main loop section, dispatch to different methods based on user input
ClassMethod Main()
{
  Do ..CurrentCount()
  While ..GetInput(.type, .search) {  
    If (type = "help") {do ..Help() set id = ""}
    ElseIf (type = "phone") {do ..Phone(search, .id)}
    ElseIf (type = "name") {do ..Name(search, .id)}
    ElseIf (type = "dob") {do ..DOB(search, .id)}
    If ((type '= "") && (id '= "")) {do ..TakeAction(id)}
  }
}

/// prompt user for a lookup string, return search type and search string
ClassMethod GetInput(Output type As %String, Output search As %String) As %Boolean
{
  Read !, "Lookup: ", lookup
  Return:(lookup = "") 0  // user entered nothing so return FALSE
  If (lookup = "?") {
    Set type = "help", search = ""
  }
  // the RegEx accepts ###- or ###-###-#### only
  ElseIf $Match(lookup, "\d{3}-(\d{3}-\d{4})?") {
    Set type = "phone", search = lookup	    
  }
    /* the $ZConvert converts the last name and first name entered to Last,First format
  the pattern match accepts Lastname only, or Lastname,Firstname */
  ElseIf ($ZConvert(lookup, "W")?1U.L.1(1","1U.L)) {
    Set type = "name", search = $ZConvert(lookup, "W")
  }
  ElseIf (##class(ObjectScript.DataEntry4).ValidDOB(lookup, .convdate)) {
    Set type = "dob", search = convdate
  }
  Else {
    // this is a hack for invalid input
    // ValidDOB() writes an error message, and the text below gets added to that
    Write ", name, or phone"
    Set (type, search) = ""
  }
  Return 1
}

/// display lookup options
ClassMethod Help()
{
  Write !, "You can enter:",
        !?10, "* date of birth",
        !?10, "* full phone number or area code only ""617-""",
        !?10, "* full name: Smith,John",
        !?10, "* last name: Smith",
        !?10, "* partial name: Sm,J or Smith,J or Sm,John", !
}

/// exact date of birth lookup
ClassMethod DOB(intdob As %Date, Output id As %Integer)
{
  Set id = ""
  // is the date of birth in the index?
  If '$Data(^PersonI("DOB", intdob) ) {
    Write "...no matches"
    Quit
  }

  Write "...finding birthday matches"
  // loop through IDs, and number them
  Set id = ""
  For count = 1:1 {
    Set id = $Order(^PersonI("DOB", intdob, id))
    Quit:(id = "")
    Set matches(count) = id  // keep track of matches
    Write !, count, ") "
    Do ..DisplayLine(id)
  }
  Do ..Select(.matches, .id)
}

/// lookup phone or area code
ClassMethod Phone(phone As %String, Output id As %Integer)
{
  Set id = ""
  Set count = 0
  // handle exact match first
  Set id = $Get(^PersonI("Phone", phone))
  If (id '= "") {
    Set count = 1
    Set matches(1) = id  // keep track of exact match
    Write !, "1) "
    Do ..DisplayLine(id)
    Quit
  }
  // handle area code matches next
  ElseIf (phone?3n1"-") {
    // use 3-argument $Order to get first matching phone number and its ID number
    Set ph = $Order(^PersonI("Phone", phone), 1, id)
    // loop through matching phones, and number them
    While ($Extract(ph, 1, $Length(phone)) = phone) {
      Write:(count = 0) "...finding area code matches"
      Set count = count + 1
      Set matches(count) = id   // keep track of matches
      Write !, count, ") "
      Do ..DisplayLine(id)
      // use 3-arg $Order to get the next phone number and its ID number
      Set ph = $Order(^PersonI("Phone", ph), 1, id)
    }
  }
  If (count = 0) {write "...no matches"}
  Else {do ..Select(.matches, .id)}
}

/// lookup names in these forms: Smith; Smith,John; Smith,J; Sm,John; Sm,J
ClassMethod Name(name As %String, Output id As %Integer)
{
  Set id = ""
  Set count = 0
  Set last = $Piece(name, ",", 1), first = $Piece(name, ",", 2)
  // last may be an exact match, so find preceding last name
  Set ln = $Order(^PersonI("Name", last), -1)
  // loop through last names
  For {
    Set ln = $Order(^PersonI("Name", ln))
    // quit as soon as last name doesn't match original
    Quit:($Extract(ln, 1, $Length(last)) '= last)
    // first may be "". Otherwise, it may be an exact match, so find preceding first name
    If (first = "") {set fn = ""}
    Else { set fn = $Order(^PersonI("Name", ln, first), -1)}
    // loop through first names
    For {
      Set fn = $Order(^PersonI("Name", ln, fn))
      // quit as soon as first name doesn't match original, or is ""
      Quit:(($Extract(fn, 1, $Length(first)) '= first) || (fn = ""))
      Set id = ""
      // loop through all IDs
      For {
        Set id = $Order(^PersonI("Name", ln, fn, id))
        Quit:(id = "")
        Write:(count = 0) "...finding name matches"
        Set count = count + 1
        Set matches(count) = id  // keep track of matches
        Write !, count, ") "
        Do ..DisplayLine(id)
      }
    }
  }
  If (count = 0) {write "...no matches"}
  Else {do ..Select(.matches, .id)}
}

/// given an ID, retrieve data and write it on a line
ClassMethod DisplayLine(id As %Integer)
{
  Set $Listbuild(name, phone, intdob) = ^PersonD(id)
	/* the line above is equivalent to
  Set answers = ^PersonD(id),
  name = $List(answers, 1),
  phone = $List(answers, 2),
  intdob = $List(answers, 3) */
  Write name, ?20, phone, ?35, $ZDate(intdob, 2)
}

/// count the "1" bits from the chunks of the Bitmap-ID index
ClassMethod CurrentCount()
{
  Set records = 0, chunk = ""
  For {
    // use the 3-argument $Order to get the next chunk and the bits stored there
    Set chunk = $Order(^PersonI("Bitmap-ID", chunk), 1, bits)
    Quit:(chunk = "")
    // add the "1" bits to the count
    Set records = records + $Bitcount(bits, 1)
  }
  Write !, "There are ", records, " records in the database."
}

/// user makes a choice from the matches array, return the corresponding ID or ""
ClassMethod Select(ByRef matches As %Integer, Output id As %Integer)
{
  Set id = ""
  For {
    Read !!, "Choose by number: ", choice
    Quit:(choice = "")
    Set id = $Get(matches(choice))
    Quit:(id '= "")  // stop looping if user makes a valid choice
    Write "...Invalid choice"
  }
}

/// display chosen record
ClassMethod TakeAction(id As %Integer)
{
  Set rec = ^PersonD(id) 
  Do ##class(ObjectScript.DataEntry4).Display(rec)
}

}
