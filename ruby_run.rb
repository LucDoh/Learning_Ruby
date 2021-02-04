require 'ruby2d'

# A simple 2D game where the objective is to pick up as many
# gems as possible without getting hit by the moving explosive
# Use WASD to move

def rand_range(min, max)
    return min + (max-min)*Random.rand()
end

def dist(x1, y1, x2, y2)
    return Math.sqrt((x2 - x1)**2 + (y2 - y1)**2)
end

def make_boom(w, h, curr_x, curr_y)
    r1 = rand_range(-h, h)
    r2 = rand_range(-w, w)
    boom = Sprite.new(
    'static/boom.png',
    clip_width: 127,
    time: 75,
    x: curr_x + r1,
    y: curr_y + r2
    )
    boom.play
    return curr_x + r1, curr_y + r2

end

def spawn_gem(w, h)
    spinning_ruby = 'static/rubyspinning.png'
    gem = Sprite.new(spinning_ruby,
    clip_width: 30*2,
    time: 3,
    x: Random.rand(w),
    y: Random.rand(h))
    gem.play loop: false
    return gem
end

def gem_collisions(gem_array, hero)
    index = 0
    found = -1
    gem_array.each do |i|
        index += 1
        if dist(i.x, i.y, hero.x, hero.y) < i.clip_width
            i.remove
            found = 1
            break
        end
    end
    return found == 1 ? index : -1
end


# Parameters
w = 900
h = 900
set title: "Ruby Run 2D", width: w, height: h
set background: 'navy'
#set width: 300, height: 200


# Running (100 loops ~= 1 s)
t = Time.now
tick, i, currency, range = 0, 1, 0, 1
game_over = false

t_txt = Text.new("0s", x: w - 50, y: h - 50, color: 'red', size: 20)
score = Text.new("#{currency} gems", x: 10, y: h - 50, color: 'blue', size: 20)
gem_array = []

# This Ruby2D will rerun
if i == 1
    # hero
    @hero = Sprite.new(
        'static/hero.png',
        width: 78,
        height: 99,
        clip_width: 78,
        time: 250,
        animations: {
          walk: 1..2,
          climb: 3..4,
          cheer: 5..6
        }
      )
    
    @x_speed = 0 
    @y_speed = 0
    boom_x = 250
    boom_y = 250

    on :key_down do |event|
        case event.key
          when 'left'
            @x_speed = -4
            @y_speed = 0
            @hero.play animation: :walk, loop: false, flip: :horizontal
          when 'right'
            @x_speed = 4
            @y_speed = 0
            @hero.play animation: :walk, loop: false
          when 'up'
            @y_speed = -4
            @x_speed = 0
            @hero.play animation: :climb, loop: false
          when 'down'
            @y_speed = 4
            @x_speed = 0
            @hero.play animation: :climb, loop: true, flip: :vertical
          when 'c'
            @hero.play animation: :cheer
        end
    end

    5.times do
        gem_array << spawn_gem(w,h)
    end
    
    # Run game loop
    update do 

        # Spawn bombs, spawn gems
        if i > 10 and i % 10 == 0
            range += i*(10e-7)
            boom_x, boom_y = make_boom(70*range, 100*range, boom_x, boom_y)
            if i % 1000000000000
                boom_x, boom_y = 250,250
            end
        end
        # Destroy gems periodically, or if encountered
        if i % 1000 == 0
            puts i
            3.times do
                gem_array << spawn_gem(w,h)
            end
        end
        if i%10 == 0
            index = gem_collisions(gem_array, @hero) 
            if index != -1
                #if gem_array[index]
                #    gem_array[index].remove
                #end
                gem_array.delete_at(index)
                currency += 1
            end
        end
        
        if !game_over
            # Control hero speed based on input
            @hero.x += @x_speed 
            @hero.y += @y_speed 
            if dist(boom_x, boom_y, @hero.x, @hero.y) < @hero.width
                puts "BooM"
                set title: 'Game Over', background: 'darkblue'
                @hero.remove
                Text.new("You lost...",
                x: w.to_f/2 - 0.05*w.to_f, 
                y: h.to_f/2 - 0.05*h.to_f,
                size: 26
                )
                game_over = true
            end
        end
        
        # Score and time update
        i += 1
        t_txt.remove
        score.remove
        t_txt = Text.new("#{i/60}s", x: w - 50, y: h -50, color: 'red', size: 40)
        score = Text.new("#{currency} gems", x: 10, y: h - 50, color: 'green', size: 40)
    end
end

show
puts 'DONE.'