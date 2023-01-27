import scala.util.parsing.combinator._

object ArithmeticParser extends JavaTokenParsers {
  def operation: Parser[(List[BigInt], BigInt)] = 
    wholeNumber ~ rep1(number) ~ result ^^ {case f~n~r => (BigInt(f) :: n, r)}

  private def number: Parser[BigInt]  = ("+" | "-") ~ wholeNumber ^^ {case s~n => BigInt(s+n)}

  private def result: Parser[BigInt] = "=" ~ "-+".r ~> opt("-") ~ wholeNumber ^^ {
    case None~n    => BigInt(n)
    case Some(_)~n => BigInt("-" + n)
  }
}

object ArithmeticEvaluator {
  def check(operation: (List[BigInt], BigInt)): Boolean = operation._1.sum == operation._2

  def main(args: Array[String]): Unit = {
    args.foreach { path =>
      val lines = io.Source.fromFile(path).mkString
      ArithmeticParser.parseAll(ArithmeticParser.operation, lines) match {
        case ArithmeticParser.Success(t, _) => println(s"is the result in $path correct? ${ArithmeticEvaluator.check(t)}")
        case e                              => println(s"Error while parsing $path: $e")
      }
    }
  }
}
