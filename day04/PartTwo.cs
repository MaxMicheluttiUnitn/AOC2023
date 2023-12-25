using System;

namespace MyNamespace{
    public class PartTwo{

        private Problem problem;

        public PartTwo(string inputfile){
            this.problem = new Problem(inputfile);
            this.solve();
        }

        private void solve(){
            int total_cards = 0;
            int[] card_counter = new int[this.problem.getSize()];
            Array.Clear(card_counter, 0, this.problem.getSize());
            for(int card_id=0;card_id<this.problem.getSize();card_id++){
                card_counter[card_id] = 1;
            }
            for(int card_id=0;card_id<this.problem.getSize();card_id++){
                int matches = this.problem.getCard(card_id).count_wins();
                for(int j=card_id+1;j<=card_id+matches && j<this.problem.getSize();j++){
                    card_counter[j] += card_counter[card_id];
                }    
                total_cards += card_counter[card_id];               
            }
            System.Console.WriteLine(total_cards);
        }

        public void print(){
            System.Console.WriteLine("Problem 2");
        }
    }
}