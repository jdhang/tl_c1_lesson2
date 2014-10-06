# 1. @a=2  is an instance variable, and is a Fixnum object with a value 2
#    user = User.new  user is a local variable, is an instance of the User object
#    user.name  calls(getter) for the instance variable name of the User object (object state)
#    user.name="Joe"  assigns (setter) the instance variable name to "Joe"
# 2. you use the keyword include (module name) within the class definintion
# 3. class variables are at the class level and cannot be accessed from instances, such as number of instances of the class that have been created.
#   instance variables are at the instance level unique to each instance of the class.
# 4. it generates getter and setter methods for the variables you assign it to 
# 5. calling some_method from the Dog class
# 6. subclassing can create objects and will have instances while inheriting state and behavior from the superclass
# => mixing modules only mixin functions, they cannot create objects
# 7. def initialize(name)
# =>    @name = name
# => end
# 8. yes you can
# 9. rescue, binding.pry