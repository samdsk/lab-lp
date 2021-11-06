import scala.util.matching.Regex
import scala.util.parsing.combinator.JavaTokenParsers
import scala.collection.mutable

object BrainfuckInterpreter {
  def exec(program: Program, env: Environment): Unit = {
    def _exec(expressions: List[Command], env: Environment): Unit = {
      expressions.foreach {
        case IncrementPointer() => env.incrementPointer()
        case DecrementPointer() => env.decrementPointer()
        case IncrementData() => env.increment()
        case DecrementData() => env.decrement()
        case Loop(innerExpressions) => while (env.get() > 0) _exec(innerExpressions, env)
        case Print() => print(env.get().toChar)
        case PrintState() => println(env)
        case Input() => env.put(Console.in.read())
        case _ => throw new IllegalArgumentException
      }
    }
    _exec(program.expressions, env)
  }
}

class Environment {
  private val data = new mutable.HashMap[Int, Int].withDefault(_ => 0)
  private var pointer = 0

  def incrementPointer(): Unit = pointer += 1
  def decrementPointer(): Unit = pointer -= 1
  def increment(): Unit = data(pointer) += 1
  def decrement(): Unit = data(pointer) -= 1
  def get(): Int = data(pointer)
  def get(n: Int): Int = data(n)
  def put(n: Int): Unit = data(pointer) = n

  override def toString: String = f"^$pointer, " + data.toString()
}

sealed trait Command
case class IncrementPointer() extends Command
case class DecrementPointer() extends Command
case class IncrementData() extends Command
case class DecrementData() extends Command
case class Print() extends Command
case class PrintState() extends Command
case class Input() extends Command
case class Loop(expressions: List[Command]) extends Command
case class Program(expressions: List[Command])

object BrainfuckParser extends JavaTokenParsers {
  override protected val whiteSpace: Regex = """[^><\+\-\[\]\.#,]*""".r

  def loop: Parser[Loop] = "[" ~> rep(command) <~ "]" ^^ { Loop }

  def command: Parser[Command] = ("<" | ">" | "+" | "-" | "." | "," | "#" | loop) ^^ {
    case ">" => IncrementPointer()
    case "<" => DecrementPointer()
    case "+" => IncrementData()
    case "-" => DecrementData()
    case "." => Print()
    case "," => Input()
    case "#" => PrintState()
    case Loop(expressions) => Loop(expressions)
  }

  def program: Parser[Program] = rep(command) ^^ { Program }
}

object BrainfuckEvaluator {
  def main(args: Array[String]): Unit = {

    args.foreach { filename =>
       val src = scala.io.Source.fromFile(filename)
       val lines = src.mkString

       BrainfuckParser.parseAll(BrainfuckParser.program, lines) match {
           case BrainfuckParser.Success(t,_) =>
               BrainfuckInterpreter.exec(t, new Environment)
           case x => print(x.toString)
       }
       src.close()
     }
  }
}
