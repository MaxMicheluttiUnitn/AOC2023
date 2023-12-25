#![allow(dead_code)]
use std::{fs, vec};

struct Roll{
    red: i32,
    green: i32,
    blue: i32
}

impl Roll{
    pub fn new(r: i32,g:i32,b: i32) -> Self{
        Self { red: r, green: g, blue: b }
    }

    pub fn get_green(&self) -> i32{self.green}
    pub fn get_red(&self) -> i32{self.red}
    pub fn get_blue(&self) -> i32{self.blue}

    pub fn is_valid(&self,max_roll: &Roll) -> bool{
        if max_roll.get_green() < self.get_green(){return false;}
        if max_roll.get_red() < self.get_red(){return false;}
        if max_roll.get_blue() < self.get_blue(){return false;}
        true
    }

    pub fn from_string(input: &str) -> Result<Self,String>{
        let res: Vec<&str> = input.split(",").collect(); 
        if res.len() > 3 {return Err("Too many colors of cubes".to_string());}
        let mut red :i32= 0;
        let mut green:i32 = 0;
        let mut blue :i32= 0;
        let mut found_red = false;
        let mut found_green = false;
        let mut found_blue= false;
        for color_data in res{
            let color_split: Vec<&str> = color_data.split(" ").collect();
            if color_split.len() != 3 {return Err("Color not well formatted".to_string());}
            if color_split.get(0).unwrap().to_string() != ""{return Err("Color not well formatted".to_string());}
            let color_qty = match color_split.get(1).unwrap().parse::<i32>(){
                Err(_)=>{
                    return Err("Expected a number before the color name".to_string());
                },
                Ok(x)=>{x}
            };
            if color_split.get(2).unwrap().to_string() == "green" && !found_green {
                found_green = true;
                green = color_qty;
            }
            else if color_split.get(2).unwrap().to_string() == "red" && !found_red {
                found_red = true;
                red = color_qty;
            }
            else if color_split.get(2).unwrap().to_string() == "blue" && !found_blue {
                found_blue = true;
                blue = color_qty;
            }else{
                return Err("Invalid or repeated color found".to_string());
            }
        }
        Ok(Self::new(red,green,blue))
    }
}

struct Game{
    id: i32,
    rolls: Vec<Roll>
}

impl Game{
    pub fn new(id: i32) -> Self{
        Self { id, rolls: vec!() }
    }

    pub fn get_id(&self) ->i32{self.id}

    pub fn is_valid(&self, max_roll: &Roll) -> bool{
        for roll in self.rolls.iter(){
            if !roll.is_valid(max_roll){return false;}
        }
        true
    }

    pub fn from_string(input: &str) -> Result<Self,String>{
        let res: Vec<&str> = input.split(':').collect();
        if res.len() != 2{
            return Err(": has too many tokens".to_string());
        }
        let mut id_info = res.get(0).unwrap().chars();
        if id_info.as_str().len() < 6 {
            return Err("left part is too short".to_string());
        }
        if id_info.nth(0).unwrap() != 'G' ||
            id_info.nth(0).unwrap() != 'a' ||
            id_info.nth(0).unwrap() != 'm' ||
            id_info.nth(0).unwrap() != 'e' ||
            id_info.nth(0).unwrap() != ' ' {
            return Err("left part does not start as Game".to_string());
        }
        let game_id = match id_info.as_str().parse::<i32>(){
            Err(_)=>{
                return Err("Expected a number before :".to_string());
            },
            Ok(x)=>{x}
        };
        let mut all_rolls :Vec<Roll>= vec!();
        let rolls_info: Vec<&str> = res.get(1).unwrap().split(";").collect();
        for roll_info in rolls_info.iter(){
            match Roll::from_string(&roll_info){
                Err(e)=>{return Err(e);},
                Ok(roll) => {all_rolls.push(roll);}
            }
        }

        Ok(Self{
            id: game_id,
            rolls: all_rolls
        })
    }

    pub fn power(&self) -> i32{
        return self.red_power() * self.blue_power() * self.green_power()
    }

    fn red_power(&self) -> i32{
        let mut best_roll = self.rolls.get(0).unwrap().get_red();
        for roll in self.rolls.iter(){
            if roll.get_red() > best_roll{
                best_roll = roll.get_red();
            }
        }
        best_roll
    }

    fn green_power(&self) -> i32{
        let mut best_roll = self.rolls.get(0).unwrap().get_green();
        for roll in self.rolls.iter(){
            if roll.get_green() > best_roll{
                best_roll = roll.get_green();
            }
        }
        best_roll
    }

    fn blue_power(&self) -> i32{
        let mut best_roll = self.rolls.get(0).unwrap().get_blue();
        for roll in self.rolls.iter(){
            if roll.get_blue() > best_roll{
                best_roll = roll.get_blue();
            }
        }
        best_roll
    }
}

pub fn part_two(){
    let input = fs::read_to_string("problem.txt").unwrap();
    let inputs: Vec<&str> = input.split('\n').collect();
    let mut sum = 0;
    for line in inputs{
        let g = match Game::from_string(line){
            Err(e) =>{
                println!("{}",e);
                std::process::exit(1);
            },
            Ok(game)=>{
                game
            }
        };
        sum+=g.power();
    }
    println!("{}",sum);
}