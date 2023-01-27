import scala.collection.mutable.HashMap
import scala.util.parsing.combinator._
import java.lang.Math

object Variables {
  val vars: HashMap[String, Double] = new HashMap()
}

class Term
case class Var(val name: String) extends Term
case class Value(val v: Double) extends Term

class CalcParser extends JavaTokenParsers {
  def expr: Parser[Value] = {{prefix | valOrVar} ~ rep(rest)} ^^ {
    case (init: Value) ~ lst => {
      var ris = init.v
      for((f, vv) <- lst) {
        ris = f(ris, vv.v)
      }
      new Value(ris)
    }
    //case (variable: Var) ~ lst => {
    //  val name = variable.name
    //  var ris = Variables.vars.getOrElse(name, 0)
    //  for((f, vv) <- lst) {
    //    f match {
    //      case (aa: ((String, Double) => Double)) => new Value(aa)
    //      case (aa: ((Double, Double) => Double)) => {
    //        if(!Variables.vars.contains(name)) throw new Exception
    //        else new Value(f(ris, vv))
    //      }
    //    }
    //  }
    //}
  }
  def prefix = {{"sqrt" | "sin" | "cos" | "tan"} ~ {"(" ~> expr <~ ")"}} ^^ { case ff ~ e =>
    val ris = ff match {
      case "sqrt" => Math.sqrt(e.v)
      case "sin" => Math.sin(e.v)
      case "cos" => Math.cos(e.v)
      case "tan" => Math.tan(e.v)
    }
    new Value(ris)
  }
  def valOrVar = number | variable
  def number = {floatingPointNumber | wholeNumber} ^^ {num => new Value(num.toDouble)}
  def variable = "\\w+".r ^^ {vaa => new Var(vaa)}
  def rest = {infix ~ {prefix | valOrVar | {"(" ~> expr <~ ")"}}} ^^ {
    case f ~ (value: Value) => (f, value)
    case f ~ (variable: Var) => {
      val vv: Option[Double] = Variables.vars.get(variable.name)
      vv match {
        case Some(aa) => (f, new Value(aa))
        case None => throw new Exception
      }
    }
  }
  def infix = {"+" | "-" | "*" | "/" | "^" | "="} ^^ { op =>
    op match {
      case "+" => {val sum: (Double, Double) => Double = _ + _; sum}
      case "-" => {val sub: (Double, Double) => Double = _ - _; sub}
      case "*" => {val mult: (Double, Double) => Double = _ * _; mult}
      case "/" => {val div: (Double, Double) => Double = _ / _; div}
      case "^" => {val pow: (Double, Double) => Double = Math.pow(_, _); pow}
      //case "=" => {val assign: (String, Double) => Double = { (name, value) =>
      //  Variables.vars += (name -> value)
      //  value
      //}; assign}
    }
  }
}

object Calculator {
  def main(args: Array[String]): Unit = {
    val input = "10 + sqrt(3 * 2 + 3)"
    val p = new CalcParser
    val res = p.parseAll(p.expr, input)
    println(res)
  }
}
