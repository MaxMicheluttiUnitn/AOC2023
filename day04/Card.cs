using System;
using System.Collections.Generic;
using System.IO;

namespace MyNamespace{
    public class Card{
        int id;
        private HashSet<int> myNums;
        private HashSet<int> winningNums;

        public Card(){
            this.myNums = new HashSet<int>();
            this.winningNums = new HashSet<int>();
            id = 0;
        }

        public Card(string card_str){
            this.myNums = new HashSet<int>();
            this.winningNums = new HashSet<int>();
            this.id = 0;
            string[] parts = card_str.Split(':');
            if(parts.Length != 2)
                System.Environment.Exit(1);

            // Parse card number
            string card_name = parts[0].Trim();
            if(!card_name.StartsWith("Card"))
                System.Environment.Exit(1);
            card_name = card_name.Remove(0,4).Trim();
            try{
                this.id = int.Parse(card_name);
            }catch(System.Exception e){
                System.Environment.Exit(1);
            }

            // parse card nums/wins
            string card_data = parts[1].Trim();
            parts = card_data.Split('|');
            if(parts.Length != 2)
                System.Environment.Exit(1);
            string[] card_numbers = parts[0].Trim().Split(' ', StringSplitOptions.RemoveEmptyEntries);
            string[] card_winning_numbers = parts[1].Trim().Split(' ', StringSplitOptions.RemoveEmptyEntries);
            foreach(var s in card_numbers){
                try{
                    int num = int.Parse(s);
                    this.myNums.Add(num);
                }catch(System.Exception e){
                    System.Environment.Exit(1);
                }
            }
            foreach(var s in card_winning_numbers){
                try{
                    int num = int.Parse(s);
                    this.winningNums.Add(num);
                }catch(System.Exception e){
                    System.Environment.Exit(1);
                }
            }
        }

        public void print(){
            System.Console.WriteLine(this.id);
            foreach(var x in this.myNums){
                System.Console.Write(x);
                System.Console.Write(", ");
            }
            System.Console.Write("\n");
            foreach(var x in this.winningNums){
                System.Console.Write(x);
                System.Console.Write(", ");
            }
            System.Console.Write("\n");
        }

        public int count_wins(){
            int winCount = 0;
            foreach(var num in this.myNums){
                foreach(var winner in this.winningNums){
                    if(winner==num)
                        winCount++;
                }
            }
            return winCount;
        }
    }
}