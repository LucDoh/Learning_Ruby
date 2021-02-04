# How to use basic functions and define a class in Ruby (RubyMonk)
puts 2.to_s + " people were here."

# Ternary Operator
def check_sign(number)
    puts number > 0 ? "#{number} is positive" : "#{number} is negative"
end

num = -1000
check_sign(num)

# Book class
class Book
    attr_accessor :title, :author
    # Constructor
    def initialize(title, author)
        @title = title
        @author = author
    end
    def readBook()
        puts "Reading #{self.title} by #{self.author}"
    end
end

# Novel subclass
class Novel < Book
    def is_novel()
        puts "True"
    end
end


# Now
booka = Book.new('Stranger' , 'Heinlin')
booka.readBook()
puts booka.title
puts " "
puts "Novel testing"

novel = Novel.new('Stranger' , 'Heinlin')
novel.readBook()
puts booka.title
novel.is_novel

# Array stuff
puts "\n\n"
arr = 10.times.map{Random.rand(11)}
puts arr.join(" ")

puts '\n\n'

def range(min, max)
    min + (max-min)*Random.rand()
end
puts range(-5,5)