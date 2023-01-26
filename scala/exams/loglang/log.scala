import scala.util.parsing.combinator._
import scala.collection.mutable._
import java.io.{File,FileInputStream,FileOutputStream}
import scala.language.postfixOps
import util.Try


class LogLangParser() extends JavaTokenParsers{
    def program = rep1(task)
    def task = "task" ~> ident ~ ("{" ~> rep1(stmt) <~ "}")
    def stmt = remove | rename | backup | merge
    def remove = "remove" ~> unquoted ^^ {
        case s => Try(new File(s).delete()).getOrElse(false)
    }
    
    def rename = "rename" ~> unquoted ~ unquoted ^^ {
        case s ~ t => Try(new File(s).renameTo(new File(t))).getOrElse(false)
    }

    def backup = "backup" ~> unquoted ~ unquoted ^^{
        case s ~ t => 
            Try ((
                () => {
                    new FileOutputStream(new File(t)).getChannel().transferFrom(
                        new FileInputStream(new File(s)).getChannel,0,Long.MaxValue);
                    true
                })()
            ).getOrElse(false)
    }


    def merge = "merge" ~> unquoted ~ unquoted ~ unquoted ^^ {
        case s1 ~ s2 ~ d =>
            Try(
                (()=>{
                    new FileOutputStream(new File(d)).getChannel().transferFrom(
                        new FileInputStream(new File(s1)).getChannel(),0,Long.MaxValue
                    );

                    new FileOutputStream(new File(d)).getChannel().transferFrom(
                        new FileInputStream(new File(s2)).getChannel(),0,Long.MaxValue
                    );
                    true
                })()
            ).getOrElse(false)
    }

    def unquoted = stringLiteral ^^ {
        case s => s.substring(1,s.length-1)
    }
}

object LogLangEval{
    def main(args:Array[String]) : Unit = {
        val parser = new LogLangParser()

        args.foreach(
            (filename) => {
                val src = scala.io.Source.fromFile(filename)
                val lines = src.mkString
                parser.parseAll(parser.program, lines) match {
                    case parser.Success(s,_) =>
                        s.foreach {
                            _ match {
                                case p.~(s1,l) => {
                                    println()
                                }
                            }
                        }
                    case x => println("Else"+x)
                }
            }
        )
    }
}