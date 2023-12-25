using System;

namespace MyNamespace{
    public class PartOne{

        private Problem problem;

        public PartOne(string inputfile){
            problem = new Problem(inputfile);
            System.Console.WriteLine(problem.score());
        }

        public void print(){
            System.Console.WriteLine("Problem 1");
        }
    }
}