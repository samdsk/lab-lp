import scala.collection.immutable.LazyList

object es6 {

    def goldbach(n : Int) = {
        val p = primes(n)
        (for( i <- p if (p.exists(x => n - i == x )) ) yield {
            (i,p.find( x => n - i == x).getOrElse(0))
        }).head
    }

    def primes(n : Int) : List[Int] = {
        2 :: (LazyList.iterate(3)(_ + 2)
        .takeWhile(_ < n)
        .filter(
            x => LazyList.iterate(2)(_+1)
            .takeWhile(_<x)
            .filter(x%_ == 0).length == 0).toList)
    }

    def goldbach_list(n : Int, m : Int) = {
        for( x <- n to m if x%2 == 0){
            println(s"$x -> ${goldbach(x)}")
        }
    }
}