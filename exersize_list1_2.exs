defmodule MyList do 
  def mapsum(list, f1) do 
    List.foldl(list, 0, fn (e, acc) -> f1.(e) + acc end) 
  end

  def myMax(list) do 
    myMax(list, -1)
  end 

  def myMax([], value) do 
    value
  end
  
  def myMax([head | tail], value) when value >= head do
    myMax(tail, value)
  end 

  def myMax([head | tail], value) when value < head do
    myMax(tail, head)
  end

  def caesar(list, value) do 
    caesar(list, value, [])
  end

  def caesar([head | tail], value, acc) do 
    caesar(tail, value, acc ++ [(head + value)])
  end

  def caesar([], _, acc) do 
 #   List.to_charlist(acc)
    List.to_string(List.to_charlist(acc))
  end
end 
