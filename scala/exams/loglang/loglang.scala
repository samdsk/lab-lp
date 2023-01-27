import scala.util.parsing.combinator._
import java.io.FileInputStream
import java.io.FileOutputStream
import  java.io.File
import util.Try

class LogLangParser_V2 extends JavaTokenParsers{
    def program = rep(task)
    
    def task = "task" ~> ident ~ ("{" ~> rep(op) <~ "}")

    def op = remove | rename | backup | merge

    def remove = "remove" ~> unquote ^^ {
        filename => Try((new File(filename)).delete()).getOrElse(false)
    }

    def rename = "rename" ~> unquote ~ unquote ^^ {
        case from~to => Try(new File(from).renameTo(new File(to))).getOrElse(false)
    }

    def backup = "backup" ~> unquote ~ unquote ^^ {
        case from~to  => 
            Try({
                new FileOutputStream(new File(to)).getChannel().transferFrom(
                    new FileInputStream(new File(from)).getChannel(),0,Long.MaxValue
                );
                true
            }
            ).getOrElse(false)
    }

    def merge = "merge" ~> unquote ~ unquote ~ unquote ^^ {
        case src1 ~ src2 ~ name => 
            Try({
                new FileOutputStream(new File(name)).getChannel().transferFrom(
                    new FileInputStream(new File(src1)).getChannel(),0,Long.MaxValue
                );

                new FileOutputStream(new File(name)).getChannel().transferFrom(
                    new FileInputStream(new File(src2)).getChannel,0,Long.MaxValue
                );
                true

            }).getOrElse(false)
    }

    def unquote = stringLiteral ^^ {
        case s => s.substring(1,s.length-1)
    }
}

object LogLangEval_V2{
    def main(args:Array[String]): Unit = {
        val p = new LogLangParser_V2()


        args.foreach {
            filename => {
                val src = scala.io.Source.fromFile(filename)
                val lines = src.mkString
                
                p.parseAll(p.program,lines) match {
                    case p.Success(s,_) =>
                        s.foreach {
                            _ match {
                                case p.~(task,list) =>
                                    println("Task "+task)
                                    list.zipWithIndex.foreach {
                                        case (item,index) => 
                                            println(" [op"+index+"] "+item)
                                    }
                            }
                        }
                    case x => println("Something went wrong!\n"+x.toString)
                }

            }
        }
    }
}