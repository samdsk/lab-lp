
class editor{
    val line :List[Char]
    private var cursor_position : Int

    def x = {

    }

    def dw = {

    }

    def i(c : Char) = {
        
    }

    def l(n : Int = 1) = {
        if(!check(cursor_position+n)) return
        cursor_position += n
    }

    def h(n : Int = 1) = {
        if(!check(cursor_position-n)) return
        cursor_position -= n
    }

    def check(n : Int) : Boolean = {
        if(line.isEmpty) false
        if(line.length - 1 < n) false
        else true
    }

}