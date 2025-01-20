(1..20).each do |num|
  case
  when (num % 15).zero?
    puts "FizzBuzz"
  when (num % 5).zero?
    puts "Buzz"
  when (num % 3).zero?
    puts "Fizz"
  else
    puts num
  end
end

