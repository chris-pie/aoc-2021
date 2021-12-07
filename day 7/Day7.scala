import scala.annotation.tailrec
import scala.collection.immutable.SortedMap
import scala.io.Source
import scala.util.{Failure, Success, Using}
object Day7 {
  @tailrec
  def findOptimalPoint(crabs: SortedMap[Int, Int], crabsLeft: Int, fuelLeft: Int, crabsRight: Int, fuelRight: Int, bestScore: Int): Int =
    if (crabs.tail.isEmpty) {
      (fuelRight + fuelLeft) min bestScore
    } else {
      val crabPos = crabs.head._1
      val crabNum = crabs.head._2
      val moreCrabs = crabs.tail
      val nextCrab = moreCrabs.head._1
      val posDif = nextCrab - crabPos
      findOptimalPoint(moreCrabs, crabsLeft + crabNum, fuelLeft + (crabsLeft + crabNum) * posDif,
        crabsRight - crabNum, fuelRight - (crabsRight - crabNum) * posDif, bestScore min (fuelRight + fuelLeft))
    }

  def part1(crabs: Array[Int]): Int = {
    val counts = SortedMap[Int, Int]() ++ crabs.groupMapReduce(identity)(_ => 1)(_ + _)
    val fuel = counts.foldLeft(0)((a, b) => a + b._1 * b._2)
    findOptimalPoint(counts, 0, 0, crabs.length, fuel, Int.MaxValue)
  }

  def main(args: Array[String]): Unit = {
    val inStr = Using(Source.fromFile("day 7.txt")) {
      source => source.mkString
    }
    val inNum = inStr match {
      case Success(value) => value.strip().split(',').map(s => s.toInt)
      case Failure(exception) => throw exception
    }

    print(part1(inNum))
  }
}