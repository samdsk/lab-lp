import scala.util.parsing.combinator.JavaTokenParsers
import scala.util.matching.Regex
import scala.collection.mutable

object BrainfuckInterpreter{
    def exec(program: Program, env: Enviroment) : Unit = {
        def _exec(expressions: List[Command],env : Enviroment) : Unit = {
            expressions.foreach{
                case IncrementPointer() => env.IncrementPointer()
                case DecrementPointer() => env.DecrementPointer()
                case IncrementData() => env.IncrementData()
                case DecrementData() => env.DecrementData()
                case Loop(innerExpression) => while(env.get() > 0) _exec(innerExpression,env)
                case Print() => print(env.get().toChar)
                case PrintState() => print(env)
                case Input() => env.put(Console.in.read())
                case _ => throw new IllegalArgumentException
            }
        }
        _exec(program.expressions,env)
    }
}

class Enviroment{
    private val data = new mutable.HashMap[Int,Int].withDefault(_ => 0)
    private var pointer = 0
    def IncrementPointer() : Unit = pointer += 1
    def DecrementPointer() : Unit = pointer -= 1
    def IncrementData() : Unit = data(pointer) += 1
    def DecrementData() : Unit = data(pointer) -= 1
    def get() : Int = data(pointer)
    def get(n : Int) : Unit = data(n)
    def put(n : Int) : Unit = data(pointer) = n
    override def toString(): String = f"^$pointer, "+ data.toString()
}

sealed trait Command
case class IncrementPointer() extends Command
case class DecrementPointer() extends Command
case class IncrementData() extends Command
case class DecrementData() extends Command
case class Print() extends Command
case class PrintState() extends Command
case class Input() extends Command
case class Loop(expressions : List[Command]) extends Command
case class Program(expressions : List[Command]) extends Command

object BrainfuckParser extends JavaTokenParsers{
    override protected val whiteSpace : Regex = """[^><\+\-\[\]\.#,]*""".r

    def loop: Parser[Loop] = "[" ~> rep(command) <~ "]" ^^ {Loop}

    def command: Parser[Command] = ("<" | ">" | "+" | "-" | "." | "," | "#" | loop) ^^ {
        case "<" => IncrementPointer()
        case ">" => DecrementPointer()
        case "+" => IncrementData()
        case "." => DecrementData()
        case "," => Print()
        case "#" => PrintState()
        case Loop(expressions) => Loop(expressions)
    }

    def program: Parser[Program] = rep(command) ^^ {Program}
}

object BrainfuckEval{
    def main(args: Array[String]) : Unit = {
        args.foreach(filename => {
            val src = scala.io.Source.fromFile(filename)
            val lines = src.mkString

            BrainfuckParser.parseAll(BrainfuckParser.program,lines) match {
                case BrainfuckParser.Success(t,_) => BrainfuckInterpreter.exec(t, new Enviroment)
                case x => print(x.toString)
            }
            src.close()
        })
    }
}