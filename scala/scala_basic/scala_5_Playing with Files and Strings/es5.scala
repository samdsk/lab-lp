import scala.languageFeature.postfixOps

class KWIC(private val list : List[String]){    
    val titles = list.zipWithIndex
        .flatMap(l => {
            val p = new Phrase(l._1.trim, l._2+1)
            List.fill(p.words_count)(p)
    })

    

}

class Phrase(val phrase : String, val n : Int){
    
    if (phrase == null | n <= 0) 
        throw new IllegalArgumentException("Phrase can't be null or n == 0")

    val filter_words_list = List("to", "and", "the")    
    
    val positions = {
        var i = 0
        var prev = 0
        (for(w <- this.phrase.split(' ')
            .toList
            .filterNot( x => filter_words_list.contains(x)) )  
        yield {
            if(prev == 0){
                prev = w.length
                (0,w)
            }else{
                i = i + prev +1 
                prev = w.length
                (i,w)
            }
        }).sortWith((x,y) => x._2 < y._2)
    }

    val words_count = positions.length

    def next(s : String) : (Int,String) = s match {
        case _ if s.equals("") => positions.head
        case _ => {val temp = ((0,s) :: positions).sortWith((x,y) => x._2 < y._2)
                val i = temp.indexOf((0,s))
            if(temp.length > i+1) temp(i+1) 
            else null
        }
    }

    override def toString = phrase
}

object Test {
    def main() = {
        val list = List(
            "My Big Fat Greek Wedding",
            "One Flew Over the Cuckoo's Nest",
            "Star Wars: Revenge of the Sith",
            "Everything You Always Wanted To Know About Sex But Were Too Afraid To Ask",
            "Borat: Cultural Learnings of America for Make Benefit Glorious Nation of Kazakhstan"
        );

        val k = new KWIC(list)
        println(k.titles)
    }
}