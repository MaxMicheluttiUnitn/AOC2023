using System;
using System.Collections.Generic;
using System.IO;


namespace MyNamespace{
    public class Problem{
        private Card[] cards;
        private int size;

        public Problem(string inputfile){
            StreamReader reader = new StreamReader(inputfile);
            string line = "";
            List<Card> cards_list = new List<Card>();
            while ((line = reader.ReadLine()) != null) {
                cards_list.Add(new Card(line));
            }
            reader.Close();
            this.size = cards_list.Count;
            this.cards = cards_list.ToArray();
        }

        public int getSize(){return this.size;}

        public Card getCard(int i){return this.cards[i];}

        public void print_wins(){
            foreach(var c in this.cards){
                c.print();
                System.Console.WriteLine(c.count_wins());
            }
        }

        public int score(){
            int total_score = 0;
            foreach(var c in this.cards){
                int card_wins = c.count_wins();
                if(card_wins>0){
                    total_score+=(int)Math.Round(Math.Pow(2,card_wins-1));
                }
            }
            return total_score;
        }

        public void print(){
            foreach(var c in this.cards){
                c.print();
            }
        }
    }
}