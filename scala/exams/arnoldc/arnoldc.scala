import scala.util.parsing.combinator._
import scala.collection.mutable._

class ArnoldParser(var stack:Stack[Int], var map : HashMap[String,Int]) extends JavaTokenParsers {
  
  def program = "IT'S"~>"SHOW"~>"TIME" ~> data <~ "YOU"<~"HAVE"<~"BEEN"<~"TERMINATED" ^^ {
    _ => (stack,map)
  }
  def data:Parser[Any] = rep(statement)
  def statement = print | declearing | assignment | conditional | loop 

  def print = "TALK"~>"TO"~>"THE"~>"HAND" ~> (idvalue|stringLiteral) ^^ {
    println(_)
  }

  def declearing = "HEY"~>"CHRISTMAS"~>"TREE" ~> ident ~ 
    ("YOU"~>"SET"~>"US"~>"UP" ~> value) ^^ {
    case s ~ n => map(s) = n
  }

  def value = wholeNumber ^^ (n => n.toInt)
  def initial_value = (value|idvalue) ^^ {n=> stack.push(n)}
  def a_value:Parser[Int] = value | idvalue
  def block = """(?s)\[.*?\]""".r ^^ {
    s => s.substring(1,s.length-1)
  }

  def conditional = "BEACAUSE"~>"I'M"~>"GOING"~>"TO"~>"SAY"~>"PLEASE" 
  ~> idvalue ~ block ~ 
  ("BULLSHIT" ~> block <~ "YOU"<~ "HAVE"<~"NO"<~"RESPECT"<~"FOR"<~"LOGIC") ^^ {
    case e~b1~b2 => 
      if(e != 0) parseAll(data,b1)
      else parseAll(data,b2)
  }
  
  def loop = "STICK"~>"AROUND"~> ident ~ block <~ "CHILL" ^^ {
    case id ~ b1 => while(map(id) != 0 ) parseAll(data,b1)
  }

  def exprs = expr ~ rep(expr)
  def expr = (arithmetic | logic) ^^ {
    (f:(Int => Int)) => stack.push(f(stack.pop))
  }
  
  def arithmetic = 
  (  "GET"~>"UP"~> a_value ^^ {n => (a:Int) => a+n}
  | "GET"~>"DOWN"~> a_value ^^ {n => (a:Int) => a-n}
  | "YOU'RE"~>"FIRED"~> a_value ^^ {n => (a:Int) => a*n}
  | "HE" ~> "HAD" ~> "TO" ~> "SPLIT" ~> a_value ^^ {n => (a:Int) => a/n }
  )

  def logic = (
    "YOU"~>"ARE"~>"NOT"~>"YOU"~>"YOU"~>"ARE"~>"ME"~> a_value ^^ {
      n => (a:Int) => if (n==a) 1 else 0
    }
  | "LET"~>"OFF"~>"SOME"~>"STEAM"~>"BENNET"~> a_value ^^ {
    n => (a:Int) => if(a>n) 1 else 0
    }
  | "CONSIDER"~>"THAT"~>"A"~>"DIVORCE"~> a_value ^^ {
      n => (a:Int) => a*n
    }
  | "KNOCK"~>"KNOCK" ~> a_value ^^ {
      n => (a:Int) => a+n
    }
  )

  def idvalue = ident ^^ {map(_)}

  def assignment = "GET"~>"TO"~>"THE"~>"CHOPPER"~> ident <~
    ("HERE" ~> "IS" ~> "MY" ~> "INVITATION" ~> initial_value) <~ exprs <~ "ENOUGH" <~ "TALK" ^^ {
      case e => map(e) = stack.pop
    }
}


object ArnoldEval{
  def main(args: Array[String]) : Unit = {
    val parser = new ArnoldParser(new Stack[Int](),new HashMap[String,Int]())

    args.foreach { filename => 
      val src = scala.io.Source.fromFile(filename)
      val lines = src.mkString

      parser.parseAll(parser.program,lines) match {
        case parser.Success((s,t),_) =>
          println(s)
          println("Symbol Table = ")
          t.foreach(m => println("\t"+m))

        case x => println(x.toString)
      }  
    }
  }
}
