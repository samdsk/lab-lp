
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

    def is_palidrome_v2(str: String) : Boolean = {
        val cleaned = str.filterNot( x => List(' ', ',', '.', '!' , '?' , ' ').contains(x)).toLowerCase
        cleaned.equals(cleaned.reverse)
    }

    def is_an_anagram(input : String, words : List[String]) : Boolean = {

        def is_anagram(input : String, words : List[String]) : Boolean = words match {
            case h :: t => if(sorted(h).equals(input)) return true else is_anagram(input,t)
            case _ => false
        }

        def sorted(input : String) : String = input.toList.sorted.mkString       

        is_anagram(sorted(input),words)
    }

    def is_an_anagram_v2(s: String, words : List[String]) : Boolean = {
        words.map( word => word.toSeq.sorted.mkString)
        .filter(word => word.equals( s.toSeq.sorted.mkString))
        .length > 0

    }

    def factors(num : Int) : List[Int] = {

       def factors(div : Int, num : Int, limit:Int, lst : List[Int]) : List[Int] = 

            num%div match {
                case _ if div > limit => if (lst.isEmpty) num::lst else lst
                case 0 => factors(div,num/div,limit,div::lst)
                case _ => factors(div+1,num,limit,lst)
            }
       

       factors(2,num,num/2,Nil)
    }

    def is_proper(num : Int) : Boolean = {
        List.range(1,num/2 + 1).filter(x => num%x == 0).fold(0)((x, y) => x + y) == num
    }

    def main(args : Array[String]) : Unit = {
        //val words = List("abba","dog","iaoc", "prova")
        println(s"79 ${factors(79)}")
        println(s"16 ${factors(16)}")
        println(s"35 ${factors(35)}")
        println(s"81 ${factors(81)}")
        println(s"24 ${factors(24)}")
    } 
}