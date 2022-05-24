import scala.languageFeature.postfixOps

class KWIC(private val list : List[String]){

    val titles = list.zipWithIndex
        .flatMap(l => {
            val p = new Title(l._1.trim, l._2+1)
            List.fill(p.words_count)(p)
    })

    val width = 40

    def first_word(s : String, l : List[Title]) = ({
        def first_word(s : String, l : List[Title], acc : List[((Int,String),Title)]) : List[((Int,String),Title)] = l match{
            case h :: t if h.next(s) != null =>  first_word(s,t, (h.next(s),h) :: acc)
            case h :: t if h.next(s) == null =>  first_word(s,t, acc)
            case _ => acc
        }

        first_word(s,l,Nil)
    }).sortWith( (x,y) => x._1._2 < y._1._2)

    def align(data : (Int,String),t :Title) ={

        var output = ""
        val len = t.toString.length

        if(data._1 < 18){
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
                val a = first_word(s,input)
                var s_1 = ""
                //println(a)
                if(!a.isEmpty){

                    val ((i,str),t) = a.head
                    s_1 = str
                    printline((i,str),t)
                    //println((i,str),t)
                    //println(data._1._1,data._1._2,data._2)
                    //printline((i,s),t)
                    build(remove(t,input),str )
                }else{
                    build(input,s_1)
                }
                
                
            }
            case _ => Unit
        }
        build(titles,"")
    }
}

class Title(val phrase : String, val n : Int){
    
    if (phrase == null | n <= 0) 
        throw new IllegalArgumentException("Phrase can't be null or n == 0")

    val filter_words_list = List("to", "and", "the","for", "of","but")
    
    val positions = {
        var i = 0
        var prev = 0
        (for(w <- this.phrase.split(' ')
            .toList
            )  
        yield {
            if(prev == 0){
                prev = w.length
                (0,w)
            }else{
                i = i + prev +1 
                prev = w.length
                (i,w)
            }
        }).filterNot( x => filter_words_list.contains(x._2.toLowerCase)).sortWith((x,y) => x._2 < y._2)
    }

    val words_count = positions.length

    def next(s : String) : (Int,String) = s match {
        case _ if s.equals("") => positions.head
        case _ => {val temp = ((-1,s) :: positions).sortWith((x,y) => x._2 < y._2)
            val i = temp.indexOf((-1,s))
            //println(temp)
            //println(s"prima - ${temp.length}, $i")
            
            if(temp.length > i+1) {
                if(s.equals(temp(i+1)._2)) {
                    //println(s"trovato dup - ${i+1}"); 

                    
                    if(temp.length > i+2){
                        //println(temp(i+2)); 
                        return temp(i+2) 
                    }else{
                        return  null 
                    }
                    
                }
                //println(s"trovato - ${i+1}"); 
                //println(temp(i+1)); 
                temp(i+1) 
            }
            else {
                //println("Null"); 
                //println(temp);
                null
            }
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
        println("ciao")
/*
        try{
            println(k.first_word("Nation",k.titles))
        }catch{
            case e : Exception => e.printStackTrace
        }
 */       
        //println(k.titles.length)
        //k.remove(k.titles(8),k.titles).length
        k.build
        
    }
}