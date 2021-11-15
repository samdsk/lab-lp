class FunctionalScala {

  val is_palindrome = (s: String) => {
    val s1 = s.filterNot(x => List('.', ',', ';', '!', '?', ' ').contains(x)).toLowerCase
    s1.equals(s1.reverse)
  }

  val is_an_anagram = (s:String, dict:List[String]) => {
    dict
      .map( x => x.toSeq.sorted.unwrap )
      .filter( x => x.equals(s.toSeq.sorted.unwrap) )
      .lengthIs > 1
  }

  def factors (number:BigInt, start:BigInt=2, list:List[BigInt]=Nil):List[BigInt] = {
    LazyList
      .iterate(start)(i => i + 1)
      .takeWhile(n => n <= number)
      .find(n => number % n == 0)
      .map(n => factors(number/n, n, list :+ n))
      .getOrElse(list)
  }

  val is_perfect = (n:Int) =>{
    ((2 until n).collect {case x if n % x == 0 => x }).sum == (n-1)
  }

}

object FunctionalScala {
  def main(args: Array[String]) = {

    val fs = new FunctionalScala()
    val dict = 
       List("tar", "rat", "arc", "car", "elbow", "below", "state", "taste", 
       "cider", "cried", "dusty", "study", "night", "thing", "inch", 
       "chin", "brag", "grab", "cat", "act", "bored", "robed", "save", 
       "vase", "angel", "glean", "stressed", "desserts")

    List("detartrated", "Do geese see God?", "Rise to vote, sir.")
      .map(x => f"[is_palindrome] $x :- ${fs.is_palindrome(x)}\n")
      .foreach(print(_))
    
    List("rat", "stressed", "elbow", "house", "thing", "desserts", "teaching")
      .map(x => f"[is_an_anagram] $x :- ${fs.is_an_anagram(x, dict)}\n")
      .foreach(print(_))

    List(25, 400, 1970, 42, 32523, 7, 534587)
      .map(x => f"[factors] $x :- ${fs.factors(x)}\n")
      .foreach(print(_))

    List(6, 7, 28, 41, 100, 496, 500, 8128)
      .map(x => f"[is_perfect] $x :- ${fs.is_perfect(x)}\n")
      .foreach(print(_))
  }
}


