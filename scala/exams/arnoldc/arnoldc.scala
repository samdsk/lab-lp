import scala.util.parsing.combinator._

class ArnorldParser extends JavaTokenParser {
  def start = "IT'S SHOW TIME" ~> data <~ "YOU HAVE BEEN TERMINATED"
  def data = print | declearing | assigning | arithmethic | logical | conditional | loop 

  def print = "TALK TO THE HAND" ~> unquoted ^^ {
    case str => println(str)
  }

  def declearing = "HEY CHRISTMAS TREE" ~> variable <~ ^^ {
    
  }


}
