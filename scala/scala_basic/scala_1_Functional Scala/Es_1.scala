object Es_1{
    def is_palidrome(input : String) : Boolean = {
        val filtered = input.filterNot( (x) => List(' ', ',','.','!','?').contains(x)).toLowerCase()
        filtered.equals(filtered.reverse)
    }

    def is_an_anagram(str : String, words : List[String]) : Boolean = {
        words.map( word => word.toSeq.sorted.mkString)
        .filter(word => word.equals(str.toSeq.sorted.mkString))
        .length > 0
    }

    def factors(num : Int) : List[Int] = {
        def factors(num:Int,div:Int,limit:Int,acc:List[Int]):List[Int] = num%div match{
            case _ if div > limit => if (acc.isEmpty) num::acc else acc
            case 0 => factors(num/div,div,limit,div::acc)
            case _ => factors(num,div+1,limit,acc)
        }
        factors(num,2,num/2,Nil)
    }

    def is_proper(num : Int) : Boolean = {
        List.range(1,num/2 + 1).filter(x => num%x == 0).fold(0)((x,y)=>x+y)==num
    }

    def main(args:Array[String]) : Unit = {
        println(s"factors of 145 ${factors(145)}")
        println(s"is palindrome : ${is_palidrome("Do geese see God?")}")
        println(s"is an anagram : ${is_an_anagram("ciao",List("abba","dog","iaoc", "prova"))}")
        println(s"145 is proper ${is_proper(145)}")

    }
}