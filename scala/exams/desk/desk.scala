import scala.util.parsing.combinator._

class DeskParser(var map : HashMap[Char,Int]) extends JavaTokenParsers {
  def program = "print" ~> expr ~ ("where" rep1sep(init_var, ",")) ^^ {
    case f ~ d => println(f()); map 
  }

  def expr:Parser[() => Int] = (
    (( (num ~ ("+" ~> expr)) 
      | (x ~ ("+" ~> expr))
    ) ^^ {
    case f1 ~ f2 => () => f1() + f2()
    }):Parser[() => Int] | x | num)

  def x = """[a-z]""".r ^^ {c => () => map(c.charAt(0))}
  def num = wholeNumber ^^ {n => () => n.toInt}

  def init_var = """[a-z]""".r ~ "=" ~ wholeNumber ^^ {    
    case c~n => map(c.chatAt(0)) = n.toInt
  }



}
