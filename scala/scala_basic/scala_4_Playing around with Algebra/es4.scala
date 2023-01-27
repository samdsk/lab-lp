trait Monoid[T] {
    val set : Set[T]
    val identity : T
    def op(a : T, b : T) : T
    //wrong
    def is_associative(l : List[T]) : Boolean = l match {
        case List(a,b,c) => if ( op(op(a,b), c) == op(a, op(b,c))) is_associative(l.tail) 
            else false
        case _ => true
    }

    protected def check_identity = !(set.map(x => op(x , identity) == x).find( x => x == false).isDefined)
    def is_monoid = check_identity && is_associative(set.toList)


}

trait Group[T] extends Monoid[T]{
    def inverse(a :T) : T
    def is_invertible = !(set.map(x => op(x, inverse(x)) == identity).find(x => x == false).isDefined)

    def is_abelian(l : List[T]) : Boolean = l match {
        case List(a,b) => if ( op(a,b) == op(b,a)) is_abelian(l.tail) 
            else false
        case _ => true
    }

    def is_group = is_monoid && is_invertible

}

trait Ring[T] extends Group[T]{
    val monoid : Monoid[T]
    def is_ring = monoid.is_monoid && is_abelian(set.toList)
}

class intMonoid extends Monoid[Int]{     
    val set = Set(1,2,3,4)
    val identity = 1
    def op (a : Int, b : Int) : Int = a * b
}

class intGroup extends Group[Int]{     
    val set = Set(1,2,3,4)
    val identity = 0
    def inverse(a : Int) = (-a)
    def op (a : Int, b : Int) : Int = a + b
}

class intRing extends Ring[Int]{
    val set = Set(1,2,3,4)
    val identity = 0    
    def inverse(a : Int) = (-a)
    def op (a : Int, b : Int) : Int = a + b
    val monoid = new intMonoid
}


object Test {

    def main(args : String*) = {

        val a = new intRing;
        a.is_invertible
    }
}
