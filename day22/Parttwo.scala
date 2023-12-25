import scala.util.control.Breaks._

object Parttwo{

    class Brick(sx:Int,sy:Int,sz:Int,ex:Int,ey:Int,ez:Int){
        var start_x: Int = sx
        var start_y: Int = sy
        var start_z: Int = sz
        var end_x: Int = ex
        var end_y: Int = ey
        var end_z: Int = ez
        var above: Vector[Int] = Vector()
        var below: Vector[Int] = Vector()

        def print_brick():Unit = {
            println(start_x,start_y,start_z)
            println(end_x,end_y,end_z)
            println("Above",above)
            println("Below",below)
        }

        def is_on_ground(): Boolean = {
            if(start_z == 1){
                return true
            };
            return false
        }

        def correct(): Unit = {
            if(start_x > end_x){
                val tmp = start_x
                start_x = end_x
                end_x = tmp
            }
            if(start_y > end_y){
                val tmp = start_y
                start_y = end_y
                end_y = tmp
            }
            if(start_z > end_z){
                val tmp = start_z
                start_z = end_z
                end_z = tmp
            }
        }

        def is_in(x:Int,y:Int,z:Int): Boolean = {
            if(x<start_x || x>end_x){
                return false
            };
            if(y<start_y || y>end_y){
                return false
            };
            if(z<start_z || z>end_z){
                return false
            };
            return true;
        }

        def move_down():Unit = {
            start_z = start_z - 1
            end_z = end_z - 1
        }

        def add_above(dep: Int):Unit = {
            above = above :+ dep
        }

        def add_below(dep: Int):Unit = {
            below = below :+ dep
        }
    }

    def main(args: Array[String]) = {
        val lines = scala.io.Source.fromFile("problem.txt").mkString.split("\n")
        var bricks : Vector[Brick] = Vector()
        var onground: Vector[Boolean] = Vector()
        var necessary: Vector[Boolean] = Vector()
        var total_bricks = 0
        for(line <- lines){
            val line_coords = line.split("~")
            val line_start_coords = line_coords(0).split(",")
            val line_end_coords = line_coords(1).split(",")
            val current_brick = new Brick(line_start_coords(0).toInt,line_start_coords(1).toInt,line_start_coords(2).toInt,line_end_coords(0).toInt,line_end_coords(1).toInt,line_end_coords(2).toInt)
            current_brick.correct()
            bricks = bricks :+ current_brick
            onground = onground :+ false
            necessary = necessary :+ false
            total_bricks = total_bricks + 1
        }
        // for(i <- 0 until total_bricks){
        //     if(bricks(i).is_on_ground()){
        //         onground = onground.updated(i,true);
        //     }else{
        //         var is_supp = false
        //         for(j <- 0 until total_bricks){
        //             if(i != j){
        //                 for(x <- bricks(i).start_x until (bricks(i).end_x+1)){
        //                     for(y <- bricks(i).start_y until (bricks(i).end_y+1)){
        //                         if (bricks(j).is_in(x,y,bricks(i).start_z-1)){
        //                             is_supp = true
        //                             if(onground(j)){
        //                                 onground = onground.updated(i,true)
        //                             }
        //                         }
        //                     }
        //                 }
        //             }
        //         }
        //         if(!is_supp){
        //             bricks(i).move_down()
        //         }
        //     }
        // }

        println("completing brick fall")

        while(onground.contains(false)){
            var bricks_to_move: Vector[Boolean] = Vector() 
            
            for(i <- 0 until total_bricks){
                bricks_to_move = bricks_to_move :+ false
                if(!onground(i)){
                    if(bricks(i).is_on_ground()){
                        onground = onground.updated(i,true);
                    }else{
                        var is_supp = false
                        for(j <- 0 until total_bricks){
                            if(i != j){
                                for(x <- bricks(i).start_x until (bricks(i).end_x+1)){
                                    for(y <- bricks(i).start_y until (bricks(i).end_y+1)){
                                        if (bricks(j).is_in(x,y,bricks(i).start_z-1)){
                                            is_supp = true
                                            if(onground(j)){
                                                onground = onground.updated(i,true)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if(!is_supp){
                            bricks_to_move = bricks_to_move.updated(i,true)
                            //bricks(i).move_down()
                        }
                    }
                }
            }
            for(i <- 0 until total_bricks){
                if(bricks_to_move(i)){
                    bricks(i).move_down()
                }
            }
        }

        println("computing necessary bricks")

        for(i <- 0 until total_bricks){
            for(j <- 0 until total_bricks){
                if(i!=j && !bricks(j).is_on_ground()){
                    var not_supp = true;
                    breakable{
                        for(k <- 0 until total_bricks){
                            if(k!=i && k!=j){
                                for(x <- bricks(j).start_x until (bricks(j).end_x+1)){
                                    for(y <- bricks(j).start_y until (bricks(j).end_y+1)){
                                        if (bricks(k).is_in(x,y,bricks(j).start_z-1)){
                                            not_supp = false;
                                            break
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if(not_supp){
                        necessary = necessary.updated(i,true);
                    }   
                }
            }
        }
        // println(necessary)
        println("computing dependencies")
        var groundbricks: Vector[Int] = Vector()
        for(i <- 0 until total_bricks){
            if(bricks(i).is_on_ground()){
                groundbricks = groundbricks :+ i
            }
            for(j <- 0 until total_bricks){
                if(i!=j){
                    breakable{
                        for(x <- bricks(i).start_x until (bricks(i).end_x+1)){
                            for(y <- bricks(i).start_y until (bricks(i).end_y+1)){
                                if (bricks(j).is_in(x,y,bricks(i).start_z-1)){
                                    bricks(j).add_above(i)
                                    bricks(i).add_below(j)
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }

        // var count = 0
        // for(brick <- bricks){
        //     println("#",count)
        //     count = count + 1
        //     brick.print_brick()
        // }

        println("checking bricks")
        
        var other_bricks_sum = 0
        for(i <- 0 until total_bricks){
            if(necessary(i)){
                var is_dependent_on_i: Vector[Boolean] = Vector()
                var visited: Vector[Boolean] = Vector()
                for(j <- 0 until total_bricks){
                    is_dependent_on_i = is_dependent_on_i :+ false
                    visited = visited :+ false
                }
                is_dependent_on_i = is_dependent_on_i.updated(i,true)
                visited = visited.updated(i,true)
                var other_bricks = 0
                var queue: List[Int] = List()
                var queue_length = 0
                for(dep <- bricks(i).above){
                    queue = queue ++ List(dep)
                    queue_length = queue_length + 1
                }
                while(queue_length!=0){
                    var current = queue(0)
                    //println(queue.map(n => bricks(n).start_z))
                    queue = queue.drop(1)
                    //println(queue.map(n => bricks(n).start_z))
                    queue_length = queue_length - 1
                    if(!visited(current)){
                        visited = visited.updated(current,true)
                        var is_dependent = true
                        for(j <- bricks(current).below){
                            if(!is_dependent_on_i(j)){
                                is_dependent = false
                            }
                        }
                        if(is_dependent){
                            is_dependent_on_i = is_dependent_on_i.updated(current,true)
                            other_bricks = other_bricks + 1
                            for(j <- bricks(current).above){
                                // change with insertion sort given by start_z
                                var inserted = false
                                for(k <- 0 until queue_length){
                                    if(bricks(queue(k)).start_z > bricks(j).start_z && !inserted){
                                        inserted = true;
                                        queue = queue.take(k) ++ List(j) ++ queue.drop(k)
                                    }
                                }
                                if(!inserted){
                                    queue = queue :+ j
                                }
                                queue_length = queue_length + 1
                            }
                        }
                    }
                }
                other_bricks_sum = other_bricks_sum + other_bricks
            }
        }
        println(other_bricks_sum)
    }
    
}