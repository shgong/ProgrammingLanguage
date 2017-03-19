
fun is_older(a:int * int * int, b:int * int * int) =
  (#1 a)<(#1 b)
  orelse (#1 a)=(#1b)
	 andalso ((#2 a)<(#2 b)
		  orelse (#2 a)=(#2 b)
			 andalso (#3 a)<(#3 b)
		 )
	   
fun number_in_month(dates: (int * int * int) list, month:int) =
  if null dates
  then 0
  else
      let val k = if (#2 (hd dates))=month then 1 else 0
      in
	  k + number_in_month(tl dates, month)
      end

fun number_in_months(dates: (int*int*int) list, months:int list) =
  if null months
  then 0
  else number_in_month(dates, hd months) +
       number_in_months(dates, tl months)
							   
fun dates_in_month(dates:(int*int*int)list,month:int)=
  if null dates then []
  else
      let val first = hd dates in
	  let val rest = dates_in_month(tl dates, month) in
	      if (#2 first)=month then first::rest
	      else rest
	  end
      end
	  
 
fun dates_in_months(dates: (int*int*int) list, months:int list) =
  if null months
  then []
  else dates_in_month(dates, hd months) @
       dates_in_months(dates, tl months)
	      
fun get_nth(list: string list, n:int) =
  if n=1 then hd list
  else
      get_nth(tl list, n-1)

fun date_to_string(date: int*int*int) =
  let val months = ["January", "February", "March", "April",
		"May", "June", "July", "August",
		"September", "October", "November", "December"]
  in
      get_nth(months, (#2 date)) ^ " "
      ^ Int.toString(#3 date) ^ ", " ^ Int.toString(#1 date)
  end

fun number_before_reaching_sum(sum:int, nums: int list) =
  if sum<=0
  then 0-1
  else 1 + number_before_reaching_sum(sum - (hd nums), tl nums)
	       
    
fun what_month(day:int) =
  let val months=[31,28,31,30,31,30,31,31,30,31,30,31]
  in
      1+ number_before_reaching_sum(day, months)
  end

fun array(l:int, r:int) =
  if(l=r) then [r]
  else l::array(l+1,r)
	       
fun month_range(day1:int,day2:int)=
  if day1>day2 then []
  else
      what_month(day1)::month_range(day1+1,day2)

fun oldest(dates:(int*int*int)list)=
  if null dates
  then NONE
  else
      let val rest = oldest(tl dates)
      in
	  if isSome rest andalso is_older(valOf rest, hd dates) then rest
	  else SOME (hd dates)
      end
	  
	  
  
      
  
	       
