
class Trajectory
    def m
        @m
    end
    def q
        @q
    end

    def initialize(m,q)
        @m = m
        @q = q
    end

    def value_of(x)
        return @m * x + @q
    end

    def inverse_of(y)
        return (y - @q) / @m
    end

    def time_and_coord_of_collision(other)
        if @m == other.m
            if @q == other.q
                return "all","all"
            else
                return "never","never"
            end
        end
        time_of_collision = (other.q - @q)/(@m - other.m)
        coord_of_collision = @m * time_of_collision + @q
        return time_of_collision,coord_of_collision
    end

    def print_traj()
        puts "y = "+m.to_s+"*x + "+q.to_s
    end
end

class Particle
    def posx
        @posx
    end
    def posy
        @posy
    end
    def posz
        @posz
    end
    def velx
        @velx
    end
    def vely
        @vely
    end
    def velz
        @velz
    end

    def initialize(x,y,z,vx,vy,vz)
        @posx = x
        @posy = y
        @posz = z
        @velx = vx
        @vely = vy
        @velz = vz
    end

    def get_x_trajectory()
        return Trajectory.new(@velx,@posx)
    end

    def get_y_trajectory()
        return Trajectory.new(@vely,@posy)
    end

    def get_z_trajectory()
        return Trajectory.new(@velz,@posz)
    end

    def get_m_xy()
        return @vely / @velx
    end

    def get_q_xy()
        return @posy - get_m_xy() * @posx
    end

    def get_xy_traj()
        return Trajectory.new(get_m_xy(),get_q_xy())
    end

    def print_particle()
        puts "pos: ("+posx.to_s+", "+posy.to_s+", "+posz.to_s+") vel: ("+velx.to_s+", "+vely.to_s+", "+velz.to_s+")"
    end
end

MIN_COORD = 200000000000000
MAX_COORD = 400000000000000
#MIN_COORD = 7
#MAX_COORD = 27

fileObj = File.new("problem.txt", "r")
particles = []
while (line = fileObj.gets)
    line.delete! ","
    pos,speed = line.split("@")
    posx,posy,posz = pos.split(" ")
    vx,vy,vz = speed.split(" ")
    particles.append(Particle.new(posx.to_f,posy.to_f,posz.to_f,vx.to_f,vy.to_f,vz.to_f))
end
fileObj.close

traj_collisions_in_test_area = 0
for i in 0..(particles.length()-1) do
    ix_traj = particles[i].get_x_trajectory()
    iy_traj = particles[i].get_y_trajectory

    itraj = particles[i].get_xy_traj()
    
    for j in (i+1)..(particles.length()-1) do
        jx_traj = particles[j].get_x_trajectory()
        jy_traj = particles[j].get_y_trajectory()
        jtraj = particles[j].get_xy_traj()
        
        x,y = itraj.time_and_coord_of_collision(jtraj)

        # particles[i].print_particle()
        # particles[j].print_particle()
        # itraj.print_traj()
        # jtraj.print_traj()
        # puts x, y

        if x=="never"
            next
        end
        if x=="all"
            img0 = value_of(MIN_COORD)
            img1 = value_of(MAX_COORD)
            if img0*img1 < 0
                traj_collisions_in_test_area += 1
            end
            next
        end
        if MIN_COORD <= x and MAX_COORD >= x and MIN_COORD <= y and MAX_COORD >= y
            time_of_ix = ix_traj.inverse_of(x)
            time_of_jx = jx_traj.inverse_of(x)
            # puts time_of_ix
            # puts time_of_jx
            if time_of_ix<0 or time_of_jx<0
                next
            end
            traj_collisions_in_test_area += 1
        end
    end
end

puts traj_collisions_in_test_area