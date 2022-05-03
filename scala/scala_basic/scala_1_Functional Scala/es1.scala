
object es1{
    def is_palidrome(input: String) : Boolean = {
        val arr : Array[Char] = input.toLowerCase.toCharArray()
        val simbols : List[Char] = ' ' :: '?' :: '.' :: ',' :: Nil
        

        def is_palidrome(arr : Array[Char], i : Int, f : Int, simbols : List[Char]) : Boolean = {
            //println(arr(i)+" "+arr(f))
            if (i>f) return true 
            else {
                
                if (simbols.contains(arr(i))) is_palidrome(arr,i+1,f,simbols)
                else{
                    if (simbols.contains(arr(f))) is_palidrome(arr,i,f-1,simbols)
                    else{
                        if(arr(i) != arr(f)) return false
                        else is_palidrome(arr,i+1,f-1,simbols)
                    }
                }
            }
        }

        is_palidrome(arr,0,(arr.length-1),simbols)
    }

    def is_an_anagram(input : String, words : List[String]) : Boolean = {

        def is_anagram(input : String, words : List[String]) : Boolean = words match {
            case h :: t => if(sorted(h).equals(input)) return true else is_anagram(input,t)
            case _ => false
        }

        def sorted(input : String) : String = input.toList.sorted.mkString       

        is_anagram(sorted(input),words)
    }

    def factors(input : Int) : List[Int] = {
        def factors(n : Int, div : Int) : List[Int] = {
            for( x <- 2 until (n/2)  if )
        }
    }

    def main(args : Array[String]) : Unit = {
        println(is_an_anagram("ciao", List("asd", "ac", "ergs")))
    } 
}