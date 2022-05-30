import java.lang.StringBuilder
import scala.collection.mutable.ListBuffer
import scala.languageFeature.postfixOps

trait Debug{
    def print(op : String, text : String, cursor : Int) : Unit = {
        println(f"$op%2s : $text")
        println(s"%${cursor+5}s".format("^"))
    }
}

trait UndoRedo{
    var history = new ListBuffer[(Int,StringBuilder)]
    var position : Int = 0
    def u : Unit
    def ctrlr : Unit
    def add : Unit
}

class Editor(private var str : String) extends Debug with UndoRedo{

    require(str != null, "String can't be null!")

    private var line = new StringBuilder(str)
    private var cursor_position = str.length

    override def toString = {
        line.toString + " " + cursor_position.toString
    }
    def add : Unit = {
        if(position != 0) {

            //println(position.toString +" prima "+history.length)
            history = history.drop(position+1)
            position = 0
            //println(position.toString +" dopo "+history.length)
        }

        (cursor_position,new StringBuilder(line.toString)) +=: history
        println("added to history")
    }
    
    override def u : Unit = {
        if(history.isEmpty) return

        println(position.toString + " " + history.length)

        if(position <= history.length && position >= 0){            
            position += 1
            val data = history(position)
            line = data._2
            cursor_position = data._1

            print("u",line.toString,cursor_position)
        }
    }

    override def ctrlr : Unit ={
        if(history.isEmpty) return

        println(position.toString + " " + history.length)

        if(position <= history.length && position > 0){
            position -= 1
            val data = history(position)
            line = data._2
            cursor_position = data._1

            print("r",line.toString,cursor_position)
        }
    }

    /*  x which deletes the character under the cursor 
        (does nothing if no characters are present) 
        and move the cursor on the character 
        on the right if present otherwise back of one;
    */
    def x = (line.charAt(cursor_position)) match{
        case _ if line.isEmpty => 
        case _ => {
            line.deleteCharAt(cursor_position);
            if(check(cursor_position + 1)) cursor_position += 1
            print("x",line.toString,cursor_position)
            add
        }
    }

    /*  dw which deletes from the character under the cursor (included) 
        to the next space (excluded) or to the end of the line 
        and moves the cursor on the character on the right if any or backwards otherwise;
    */
    def dw = {
        val next_space = line.indexOf(" ", cursor_position)
        println("next space "+next_space)
        if(next_space >= 0 ){
            line.delete(cursor_position - 1, next_space)
            
        }else{
            line.delete(cursor_position, line.length)
            cursor_position = line.length
        }
        add
        print("dw",line.toString,cursor_position)
    }

    /*  i which adds a character c after the character 
        under the cursor and moves the cursor under c
    */
    def i(c : Char) = {
    /*        
        if(check(cursor_position + 1)){
            line.insert(cursor_position,c)
        }else{
            line.append(c)
            cursor_position = line.length
        }*/
        line.insert(cursor_position,c)
        cursor_position += 1
        add
        print("i",line.toString,cursor_position)
        
    }

    /*  iw which adds a word w followed by a blank space 
        after the character under the cursor 
        and moves the cursor under the blank space;
    */
    def iw(s : String) = {

        line.insert(cursor_position,s + " ")
        cursor_position += s.length + 1
        add
        print("iw",line.toString,cursor_position)
    }

    /*  l which moves the cursor n (1 as default, i.e., when nothing is specified) 
        characters on the right from the current position 
        (it does nothing when at the end of the text or it moves less if it is close to the end);
    */
    def l(n : Int = 1) : Unit = {
        if(!check(cursor_position + n)) return
        
        cursor_position += n
        add
        print("l",line.toString,cursor_position)
    }

    /*  h which moves the cursor n (1 as default, i.e., when nothing is specified) 
        character on the left from the current position 
        (it does nothing when at the beginning of the text 
        or it moves less if it is close to the beginning).
    */
    def h(n : Int = 1) : Unit = {
        if(!check(cursor_position - n)) return
        cursor_position -= n
        add
        print("h",line.toString,cursor_position)
    }

    /*  RI : cursor position integrity check
    */
    def check(n : Int) : Boolean = {
        println(s"${line.length} : $n")
        if(line.isEmpty) false
        if(n<0) false
        if(line.length < n) false
        else true
    }


}

object es8 {
    def main : Unit = {
        val e = new Editor("4321")
        println(e)
        e.h()
        e.h()
        e.h()
        e.u
        e.u
        e.ctrlr
        e.l(2)
        e.u
    }
}

