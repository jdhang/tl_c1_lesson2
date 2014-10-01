# --- START: OOP Part I ---
# --- END: OOP Part I ---

# --- START: OOP Part II ---
# 3. The accessor is only a reader therefore no setter methods were created
# fix it by adding attr_accessor :name
# --- END: OOP Part II ---

# --- START: OOP Inheritance ---
# 1. 
module Towable
  def can_tow?(pounds)
    pounds < 2000 ? true : false
  end
end

class Vehicle
  @@vehicle_count = 0
  
  attr_accessor :color, :year, :model

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @current_speed = 0
    @@vehicle_count += 1
  end

  def self.gas_mileage(miles, gallons)
    puts "#{miles / gallons} mpg"  
  end

  def self.num_of_vehicles
    puts "#{vehicle_count} vehicles created"
  end

  def speed_up(speed)
    @current_speed += speed
  end

  def brake(speed)
    @current_speed -= speed  
  end

  def shut_off()
    @current_speed = 0
  end

  def current_speed()
    puts "#{@current_speed} mph"
  end

  def age
    puts "#{years_old} years old"
  end

  private

  def years_old
    Time.now.year - self.year
  end
end

class MyCar < Vehicle
  NUM_WHEELS = 4
end

class MyTruck < Vehicle
  NUM_WHEELS = 18
  include Towable
  def initialize
    @current_speed = 0
  end
end

puts MyTruck.ancestors
puts MyCar.ancestors
puts Vehicle.ancestors

civic = MyCar.new(2008, "Silver", "Civic")
civic.speed_up(15)
civic.current_speed
truck = MyTruck.new
truck.speed_up(10)
truck.current_speed
civic.current_speed
civic.age


class Student
  attr_accessor :name
  attr_writer :grade

  def initialize(name, grade)
    @name = name
    @grade = grade    
  end

  def better_grade_than?(student)
    grade > student.grade ? true : false
  end

  protected
  attr_reader :grade

end

jason = Student.new("Jason", 90)
bob = Student.new("Bob", 89)
puts jason.name
puts bob.name
puts "Well done!" if jason.better_grade_than?(bob)
# 8. the hi method is a private method, in order to change it, put it above the private calling
# --- END: OOP Inheritance ---