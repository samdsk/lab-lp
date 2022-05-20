object es2{
    def squared_numbers(list : List[Any]) : List[Any] = {

        (for( x <- list) yield x match{
            case i : Int => i*i
            case d : Double => d*d
            case l : List[Any] => squared_numbers(l)
            case t : Product => process_tuple(
                squared_numbers(t.productIterator.toList.filterNot(x => x match{ 
                case _:String => true
                case _:Char => true
                case _ => false})))
            case _ => Nil
        }).filterNot( _ == Nil )


    }

    def process_tuple(t : List[Any]) : Any = t match {
        case List(a) => (a)
        case List(a,b) => (a, b)
        case List(a,b,c) => (a, b, c)
        case List(a,b,c,d) => (a,b,c,d)
        case _ => throw new IllegalArgumentException("lunghezza non supportata")
    }

    def intersect[T](l1 : List[T], l2 : List[T]) : List[T] = {
        for(x <- l1 if l2.contains(x)) yield x
    }

    def symmetric_difference[T](l1 : List[T], l2 : List[T]) : List[T] = {
        (for( x <- l1 if !l2.contains(x)) yield x):::(for( x <- l2 if !l1.contains(x)) yield x)
    }
}