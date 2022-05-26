import java.lang.StringBuilder

class editor{
    val line : StringBuilder = new StringBuilder("")
    private var cursor_position : Int = 0
    

    def x = line(cursor_position) match{
        case _ if line.isEmpty => 
        case _ => {
            list.deleteCharAt(cursor_position);
            if(check(1,-)) cursor_position += 1
        }
    }

    def dw = {
        val next_space = list.indexOf(' ', cursor_position)
        if(next_space >=0 ){
            list.delete(cursor_position, next_space-1)
            cursor_position = next_space
        }else{
            list.delete(cursor_position, list.length -1)
            if(check(1, -)) cursor_position -=1
            else cursor_position = 0
        }
    }

    def i(c : Char) = {        
        if(check(1, +)){
            list.insert(cursor_position,c)
        }else{
            list.append(c)
            cursor_position = list.length - 1
        }
        
    }

    def iw(s : String) = {
        if(check(1, +)){
                list.insert(cursor_position+1,s + " ")
            }else{
                list.append(s + " ")
                cursor_position = list.length - 1
            }
    }

    def l(n : Int = 1) = {
        if(!check(n, + )) return
        cursor_position += n
    }

    def h(n : Int = 1) = {
        if(!check(n, - )) return
        cursor_position -= n
    }

    def check(n : Int, op : (Int,Int) => Int ) : Boolean = {
        if(line.isEmpty) false
        if(line.length <= (cursor_position op n)) false
        else true
    }

    def check : Boolean = {
        check(0, + )
    }

}