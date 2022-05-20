//DOESN'T WORK

// import scala.actors.Actor
// import scala.actors.Actor._

// class MasterProcess extends Actors{

//     def act() = {
//         while(true){
//             receive {                
//                 case ("reversed", s: String, n : Int, slave_n : Int) => 
//                     println(s"$n - $s from $slave_n")
                
//             }
//         }
//     }

//     def long_reverse_string(s : String) : String = {
//         val n = s.length%10
//         var len = s.length/10

//         val list = substring(s,0,len,0,n)
//         var sn = 0
//         for(l <- list){
//             val slave = new SlaveProcess(sn)
//             slave.start
//             slave ! ("job",l,sn,Actor.self)
//         }
//     }

//     private def substring(s :String, i : Int, len : Int, n : Int, start : Int) : List[String] = s match{
//        case _ if i > s.length => Nil;
//        case _ if start < n => s.slice(i,i+len) :: substring(i+len+1, len, start+1,n)
//        case _ => s.slice(i,i+len-1) :: substring(i+len, len, start+1,n)
//     }

// }

// class SlaveProcess(val slave_n : Int) extends Actors {
//     def act() = {
//         while(true){
//             receive {
//                 case ("job", s :String,n : Int, from : Actor) => from ! ("reversed", s.reverse, n, slave_n)
//                 case ("exit") => exit()
//                 case _ => println("idk")
//             }
//         }
//     }
// }

// class ClientProcess(val s : String) extends Actors{
//     def act() ={
//         val master = new MasterProcess()
//         master.start
//         master.long_reverse_string(s)

//     }
// }

import scala.actors.Actor
import scala.actors.Actor._

class Ping(count: Int, pong: Actor) extends Actor {
  def act() = {
    var pingsLeft = count - 1
    pong ! Ping
    while (true) {
      receive {
        case Pong =>
          if (pingsLeft % 1000 == 0)
            Console.println("Ping: pong")
          if (pingsLeft > 0) {
            pong ! Ping
            pingsLeft -= 1
          } else {
            Console.println("Ping: stop")
            pong ! Stop
            exit()
          }
      }
    }
  }
}

class Pong extends Actor {
  def act() = {
    var pongCount = 0
    while (true) {
      receive {
        case Ping =>
          if (pongCount % 1000 == 0)
            Console.println("Pong: ping "+pongCount)
          sender ! Pong
          pongCount = pongCount + 1
        case Stop =>
          Console.println("Pong: stop")
          exit()
      }
    }
  }
}
