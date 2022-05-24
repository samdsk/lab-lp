import scala.languageFeature.postfixOps

class KWIC(private val list : List[String]){

    val titles = list.zipWithIndex
        .flatMap(l => {
            val p = new Title(l._1.trim, l._2+1)
            List.fill(p.words_count)(p)
    })

    val width = 40

    //def first_word(s : String, l : List[Title]) = l.map( t => (t.next(s),t)).sortWith( (x,y) => x._1._2 < y._1._2).head
    def first_word(s : String, l : List[Title]) = l.map( t => t.next(s) match{
        case data if data != null => (data,t)
        case _ => Nil
    }).filter(_ != ())
    //.filterNot(x => x == ()).sortWith( (x,y) => x._1._2 < y._1._2).head
    def align(data : (Int,String),t :Title) ={

        var output = ""
        val len = t.toString.length

        if(data._1 <= 18){
            output += "-" * (17-data._1) + t.toString 
        }else{
            output += t.toString.substring(data._1 - 17)
        }

        if(output.length > 36) output.substring(0,35)
        else output
    }

    def printline(data : (Int,String),t :Title) = {
        println(f"${t.n}%4d ${align(data,t)}")
    }

    def remove(t : Title, list : List[Title]) = {
        val i = list.indexOf(t)
        list.take(i) ++ list.drop(i+1)
    }

    def build() = {
        def build(input : List[Title], s :String) : Unit = input match{
            case h::t => {
                val ((i,str),t) = first_word(s,input)
                printline((i,str),t)
                //println(data._1._1,data._1._2,data._2)
                //printline((i,s),t)
                build(remove(t,input),str )
            }
            case _ => Unit
        }
        build(titles,"")
    }
}

class Title(val phrase : String, val n : Int){
    
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
            println(temp.length, i)
            if(temp.length > i) temp(i+1) 
            else temp(i)
        }
    }

    override def toString = phrase
    override def equals(that : Any) : Boolean = that match{
         case that : Title => that.n == this.n && that.phrase.equals(this.phrase)
         case _ => false
    }
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

        //println((new Title(list(3),3)).next("About"))

        val k = new KWIC(list)
        k.first_word("Nation",k.titles)
        //println(k.titles.length)
        //k.remove(k.titles(8),k.titles).length
        //k.build
        
    }
}