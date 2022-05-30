import java.lang.StringBuilder
import scala.collection.mutable.ListBuffer

trait Debug{
    def print(op : String, text : String, cursor : Int) : Unit = {
        println(f"$op%2s : $text")
        println(s"%${cursor+5}s".format("^"))
    }
}

trait UndoRedo{
    var history = new ListBuffer[(Int,StringBuilder)]
    var position : Int = 0
    protected def u : Unit
    protected def ctrlr : Unit
    protected def add : Unit
}

class Editor(private var str : String) extends Debug with UndoRedo{

    require(str != null, "String can't be null!")

    private var line = new StringBuilder(str)
    private var cursor_position = str.length

    override def toString = {
        line.toString + " " + cursor_position.toString
    }
    protected def add : Unit = {
        if(position != 0) history.drop(position)

        (cursor_position,line) +=: history
    }
    
    protected override def u : Unit = {
        if(history.isEmpty) return

        if(position < history.length - 1  && position > 0){
            position += 1
            val data = history(position)
            line = data._2
            cursor_position = data._1

            print("u",line.toString,cursor_position)
        }
    }

    protected override def ctrlr : Unit ={
        if(history.isEmpty) return

        if(position < history.length && position > 0){
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
        if(next_space < line.length ){
            line.delete(cursor_position - 1, next_space)
            cursor_position = next_space
        }else{
            line.delete(cursor_position, line.length -1)
            if(check(cursor_position - 1)) cursor_position -=1
            else cursor_position = 0
        }
        add
        print("dw",line.toString,cursor_position)
    }

    /*  i which adds a character c after the character 
        under the cursor and moves the cursor under c
    */
    def i(c : Char) = {        
        if(check(cursor_position + 1)){
            line.insert(cursor_position,c)
        }else{
            line.append(c)
            cursor_position = line.length
        }
        add
        print("i",line.toString,cursor_position)
        
    }

    /*  iw which adds a word w followed by a blank space 
        after the character under the cursor 
        and moves the cursor under the blank space;
    */
    def iw(s : String) = {
        if(check(cursor_position + 1)){
                line.insert(cursor_position+1,s + " ")
        }else{
            line.append(s + " ")
            cursor_position = line.length - 1
        }
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
        println(s"${line.length} : $cursor_position")
        if(line.isEmpty) false
        if(line.length <= n) false
        else true
    }


}

object es8 {
    def main : Unit = {
        val e = new Editor("ciao mondo come va")
        println(e)
        e.i('z')
        e.h(10)
        e.dw
    }
}

