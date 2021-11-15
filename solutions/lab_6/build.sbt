ThisBuild / scalaVersion := "2.13.2"
ThisBuild / organization := "cazzola@adapt-lab"

lazy val brainfuck = (project in file("."))
  .settings(
    name := "Brainfuck Interpreter",
    scalacOptions += "-deprecation",
    libraryDependencies += "org.scala-lang.modules" %% "scala-parser-combinators" % "1.1.2",
  )
