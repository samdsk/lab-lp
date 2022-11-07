module type IntervalI = sig
  type interval
  type endpoint
  val create : endpoint -> endpoint -> interval
  val is_empty : interval -> bool
  val contains : interval -> endpoint -> bool
  val intersect : interval -> interval -> interval
  val tostring : interval -> string
  exception WrongInterval
end