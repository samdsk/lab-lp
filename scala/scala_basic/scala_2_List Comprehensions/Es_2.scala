object Es_2 {
    def squared_numbers (input:List[Any]):List[Any] = {
        (for(x <- input) yield x match{
            case i:Int => i*i
            case d:Double => d*d
            case l:List[Any] => squared_numbers(l)
            case t:Product => toTuple(squared_numbers(t.productIterator.toList))
            case _ => Nil
        }).filterNot( _ == Nil)
    }
    /*Creates a tuple class of given name at runtime*/
    def toTuple(list:List[Any]) : Product = {        
        Class.forName("scala.Tuple"+list.size).getConstructors.apply(0).newInstance(list:_*).asInstanceOf[Product]
    }

    def intersect : (List[Any],List[Any]) => List[Any] = (l1:List[Any],l2:List[Any]) => {
        for(x <- l1 if(l2.contains(x))) yield x
    }

    def symmetric_difference : (List[Any],List[Any]) => List[Any] 
        = (l1:List[Any],l2:List[Any]) => {
            (for(x <- l1 if(!l2.contains(x))) yield x):::(for(x <- l2 if(!l1.contains(x))) yield x)
    }

}