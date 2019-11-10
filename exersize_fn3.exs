fz = fn
	(n, 0, 0) -> "FizzBuzz"
	(n, 0, _) -> "Fizz"
	(n, _, 0) -> "Buzz"
	(n, _, _) -> n
end 

result = Enum.map [10, 11, 12, 13, 14, 15, 16, 17], &(
	IO.puts(fz.(&1, rem(&1, 3), rem(&1, 5))) 
)

