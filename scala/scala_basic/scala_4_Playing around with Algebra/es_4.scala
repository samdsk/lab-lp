trait Monoid[T]{
    val set : Set[T]
    val add : (T,T) => T
    val i : T

    def is_associative(l : List[T]) : Boolean = l match{
        case a :: b :: tl => 
            if (add(a,b) == add(b,a)) is_associative(b::tl)
            else false
        case _ => true
    }

    def check_identity = (set.map(x => add(x,i) == x).find(x => x == false).isDefined)

    def is_monoid = check_identity && is_associative(set.toList)
}

trait Group[T] extends Monoit[T]{
    
}


class intMonoid extends Monoid[Int]{
    val set = Set(1,2,3,4)
    val i = 1
    val add = (x:Int,y:Int) => x+y
}

object Test{
    def main(args: String*) = {
        val a = new intMonoid()
        a.is_monoid
    }
}