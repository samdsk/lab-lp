import scala.collection.immutable.LazyList

object Goldbach{
    def goldbach(n:Int) : Product = {
        val p = primes(n)
        (for( i <- p if(p.exists(x => n - i == x))) yield {            
            (i,p.find(x => n-i == x).getOrElse(0))
        }).head
    }

    def primes(n:Int) = {
        2::(LazyList.iterate(3)(_+2)
        .takeWhile(_ < n).filter(
            x => ((LazyList.iterate(2)(_+1)
            .takeWhile(_<x)).filter(x % _ == 0)).length == 0 )).toList
    }

    def goldbach(n:Int,m:Int) : Seq[Product] = {
        for(i <- n to m if((i % 2 == 0) && (i>2))) yield {
            println(s" $i -> ${goldbach(i)}")
            goldbach(i)
        }
    }

}