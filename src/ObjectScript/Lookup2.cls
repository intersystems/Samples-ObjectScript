Class ObjectScript.Lookup2
{

/// main loop section, dispatch to different methods based on user input
ClassMethod Main()
{
  do ..CurrentCount()
  while ..GetInput(.type, .search) {  
    if (type = "help") { do ..Help() set id = "" }
    elseif (type = "phone") { do ..Phone(search, .id) }
    elseif (type = "name") { do ..Name(search, .id) }
    elseif (type = "dob") { do ..DOB(search, .id) }
    if ((type '= "") && (id '= "")) { do ..TakeAction(id) }
  }
}

/// prompt user for a lookup string, return search type and search string
ClassMethod GetInput(Output type As %String, Output search As %String) As %Boolean
{
  read !, "Lookup: ", lookup
  return:(lookup = "") 0  // user entered nothing so return FALSE
  if (lookup = "?") {
    set type = "help", search = ""
  }
  // the RegEx accepts ###- or ###-###-#### only
  elseif $match(lookup, "\d{3}-(\d{3}-\d{4})?") {
    set type = "phone", search = lookup	    
  }
    /* the $zconvert converts the last name and first name entered to Last,First format
  the pattern match accepts Lastname only, or Lastname,Firstname */
  elseif ($zconvert(lookup, "W")?1U.L.1(1","1U.L)) {
    set type = "name", search = $zconvert(lookup, "W")
  }
  elseif (##class(ObjectScript.DataEntry4).ValidDOB(lookup, .convdate)) {
    set type = "dob", search = convdate
  }
  else {
    // this is a hack for invalid input
    // ValidDOB() writes an error message, and the text below gets added to that
    write ", name, or phone"
    set (type, search) = ""
  }
  return 1
}

/// display lookup options
ClassMethod Help()
{
  write !, "You can enter:",
        !?10, "* date of birth",
        !?10, "* full phone number or area code only ""617-""",
        !?10, "* full name: Smith,John",
        !?10, "* last name: Smith",
        !?10, "* partial name: Sm,J or Smith,J or Sm,John", !
}

/// exact date of birth lookup
ClassMethod DOB(intdob As %Date, Output id As %Integer)
{
  set id = ""
  // is the date of birth in the index?
  if '$data(^PersonI("DOB", intdob) ) {
    write "...no matches"
    quit
  }

  write "...finding birthday matches"
  // loop through IDs, and number them
  set id = ""
  for count = 1:1 {
    set id = $order(^PersonI("DOB", intdob, id))
    quit:(id = "")
    set matches(count) = id  // keep track of matches
    write !, count, ") "
    do ..DisplayLine(id)
  }
  do ..Select(.matches, .id)
}

/// lookup phone or area code
ClassMethod Phone(phone As %String, Output id As %Integer)
{
  set id = ""
  set count = 0
  // handle exact match first
  set id = $get(^PersonI("Phone", phone))
  if (id '= "") {
    set count = 1
    set matches(1) = id  // keep track of exact match
    write !, "1) "
    do ..DisplayLine(id)
    quit
  }
  // handle area code matches next
  elseif (phone?3n1"-") {
    // use 3-argument $order to get first matching phone number and its ID number
    set ph = $order(^PersonI("Phone", phone), 1, id)
    // loop through matching phones, and number them
    while ($extract(ph, 1, $length(phone)) = phone) {
      write:(count = 0) "...finding area code matches"
      set count = count + 1
      set matches(count) = id   // keep track of matches
      write !, count, ") "
      do ..DisplayLine(id)
      // use 3-arg $order to get the next phone number and its ID number
      set ph = $order(^PersonI("Phone", ph), 1, id)
    }
  }
  if (count = 0) { write "...no matches" }
  else { do ..Select(.matches, .id) }
}

/// lookup names in these forms: Smith; Smith,John; Smith,J; Sm,John; Sm,J
ClassMethod Name(name As %String, Output id As %Integer)
{
  set id = ""
  set count = 0
  set last = $piece(name, ",", 1), first = $piece(name, ",", 2)
  // last may be an exact match, so find preceding last name
  set ln = $order(^PersonI("Name", last), -1)
  // loop through last names
  for {
    set ln = $order(^PersonI("Name", ln))
    // quit as soon as last name doesn't match original
    quit:($extract(ln, 1, $length(last)) '= last)
    // first may be "". Otherwise, it may be an exact match, so find preceding first name
    if (first = "") { set fn = "" }
    else { set fn = $order(^PersonI("Name", ln, first), -1) }
    // loop through first names
    for {
      set fn = $order(^PersonI("Name", ln, fn))
      // quit as soon as first name doesn't match original, or is ""
      quit:(($extract(fn, 1, $length(first)) '= first) || (fn = ""))
      set id = ""
      // loop through all IDs
      for {
        set id = $order(^PersonI("Name", ln, fn, id))
        quit:(id = "")
        write:(count = 0) "...finding name matches"
        set count = count + 1
        set matches(count) = id  // keep track of matches
        write !, count, ") "
        do ..DisplayLine(id)
      }
    }
  }
  if (count = 0) { write "...no matches" }
  else { do ..Select(.matches, .id) }
}

/// given an ID, retrieve data and write it on a line
ClassMethod DisplayLine(id As %Integer)
{
  set $listbuild(name, phone, intdob) = ^PersonD(id)
	/* the line above is equivalent to
  set answers = ^PersonD(id),
  name = $list(answers, 1),
  phone = $list(answers, 2),
  intdob = $list(answers, 3) */
  write name, ?20, phone, ?35, $zdate(intdob, 2)
}

/// count the "1" bits from the chunks of the Bitmap-ID index
ClassMethod CurrentCount()
{
  set records = 0, chunk = ""
  for {
    // use the 3-argument $order to get the next chunk and the bits stored there
    set chunk = $order(^PersonI("Bitmap-ID", chunk), 1, bits)
    quit:(chunk = "")
    // add the "1" bits to the count
    set records = records + $bitcount(bits, 1)
  }
  write !, "There are ", records, " records in the database."
}

/// user makes a choice from the matches array, return the corresponding ID or ""
ClassMethod Select(ByRef matches As %Integer, Output id As %Integer)
{
  set id = ""
  for {
    read !!, "Choose by number: ", choice
    quit:(choice = "")
    set id = $get(matches(choice))
    quit:(id '= "")  // stop looping if user makes a valid choice
    write "...Invalid choice"
  }
}

/// display chosen record
ClassMethod TakeAction(id As %Integer)
{
  set rec = ^PersonD(id) 
  do ##class(ObjectScript.DataEntry4).Display(rec)
}

}
