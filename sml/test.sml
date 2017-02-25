         (* functions *)

fun pow(x:int, y:int) = (* correct only for y>=0 *)
  if y=0
  then 1
  else x*pow(x,y-1)
	    
fun cube(x:int)=
  pow(x,3)

val ans = cube(4)



         (* pairs *)

fun swap(pr: int*bool) =
  (#2 pr, #1 pr)

fun sum_two_pairs (pr1 : int*int, pr2 : int*int) =
  (#1 pr1) + (#2 pr1) + (#1 pr2) + (#2 pr2)

fun div_mod (x : int, y : int) = (* note: returning a pair is a real pain in Java *)
  (x div y, x mod y)

fun sort_pair (pr : int*int) =
  if (#1 pr) < (#2 pr)
  then pr
  else ((#2 pr),(#1 pr))
	 
	   
	   (* lists *)
fun sum_list (xs : int list) =
  if null xs
  then 0
  else hd(xs) + sum_list(tl xs)

fun countdown (x : int) =
  if x=0
  then []
  else x :: countdown(x-1)

fun append (xs : int list, ys : int list) =
  if null xs
  then ys
  else (hd xs) :: append(tl xs, ys)

(* hello *)
fun countup_from1 (x:int) =
  let fun count (from:int, to:int) =
	if from=to
	then to::[]
	else from :: count(from+1,to)
  in
      count(1,x)
  end			

fun countup_from1_better (x:int) =
  let fun count (from:int) =
	if from=x
	then x::[]
	else from :: count(from+1)
  in
      count 1
  end

(* use let expression o avoid repeat evaluation *)
fun good_max (xs : int list) =
  if null xs
  then 0 (* note: bad style; see below *)
  else if null (tl xs)
  then hd xs
  else
      (* for style, could also use a let-binding for hd xs *)
      let val tl_ans = good_max(tl xs)
      in
	  if hd xs > tl_ans
	  then hd xs
	  else tl_ans
      end

(* OPTIONS *)	  
fun better_max (xs : int list) =
  if null xs
  then NONE
  else
      let val tl_ans = better_max(tl xs)
      in if isSome tl_ans andalso valOf tl_ans > hd xs
	 then tl_ans
	 else SOME (hd xs)
      end

	  
