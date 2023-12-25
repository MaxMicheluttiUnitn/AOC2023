require 'set'

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

fileObj = File.new("problem.txt", "r")
particles = []
while (line = fileObj.gets)
    line.delete! ","
    pos,speed = line.split("@")
    posx,posy,posz = pos.split(" ")
    vx,vy,vz = speed.split(" ")
    particles.append(Particle.new(posx.to_i,posy.to_i,posz.to_i,vx.to_i,vy.to_i,vz.to_i))
end
fileObj.close

# code for part two adapted from Reddit user TheZigerionScammer's solution

potential_x_set = "None"
potential_y_set = "None"
potential_z_set = "None"
for i in 0..(particles.length()-1) do
    for j in (i+1)..(particles.length()-1) do
        if particles[i].velx == particles[j].velx
            new_set = Set[]
            difference = (particles[j].posx - particles[i].posx).abs
            for v in -1000..1000
                if v == particles[i].velx
                    next
                elsif difference % (v-particles[i].velx) == 0
                    new_set.add(v)
                end
            end
            if potential_x_set == "None"
                potential_x_set = new_set
            else
                potential_x_set = potential_x_set & new_set
            end
        end

        if particles[i].vely == particles[j].vely
            new_set = Set[]
            difference = (particles[j].posy - particles[i].posy).abs
            for v in -1000..1000
                if v == particles[i].vely
                    next
                elsif difference % (v-particles[i].vely) == 0
                    new_set.add(v)
                end
            end
            if potential_y_set == "None"
                potential_y_set = new_set
            else
                potential_y_set = potential_y_set & new_set
            end
        end

        if particles[i].velz == particles[j].velz
            new_set = Set[]
            difference = (particles[j].posz - particles[i].posz).abs
            for v in -1000..1000
                if v == particles[i].velz
                    next
                elsif difference % (v-particles[i].velz) == 0
                    new_set.add(v)
                end
            end
            if potential_z_set == "None"
                potential_z_set = new_set
            else
                potential_z_set = potential_z_set & new_set
            end
        end
    end
end

velx = 0
for i in potential_x_set do
    velx = i
end
vely = 0
for i in potential_y_set do
    vely = i
end
velz = 0
for i in potential_z_set do
    velz = i
end

m0 = (particles[0].vely - vely).to_f / (particles[0].velx - velx).to_f
m1 = (particles[1].vely - vely).to_f / (particles[1].velx - velx).to_f

q0 = particles[0].posy.to_f - (m0 * particles[0].posx.to_f)
q1 = particles[1].posy.to_f - (m1 * particles[1].posx.to_f)

xpos = ((q1-q0)/(m0-m1)).to_i
ypos = (m0*xpos + q0).to_i
time = (xpos - particles[0].posx) / (particles[0].velx - velx)
zpos = particles[0].posz + (particles[0].velz - velz) * time

puts (xpos+ypos+zpos).to_s