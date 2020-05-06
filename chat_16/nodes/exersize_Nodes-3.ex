defmodule Ticker do
  @interval 2000   # 2 seconds
  @name     :ticker

  def start do
    pid = spawn(__MODULE__, :generator, [[]])
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    send :global.whereis_name(@name), { :register, client_pid }
  end

  def generator(clients) do
    generator(clients, 0)
  end

  def generator(clients, index) do
    receive do
      { :register, pid } ->
        IO.puts "registering #{inspect pid}"
        generator(clients ++ [pid], index)
    after
      @interval ->
        IO.puts "tick"
        if length(clients) > 0 do
          send Enum.at(clients, index), { :tick }
          generator(clients, Integer.mod(index + 1, length(clients)))
        end
        generator(clients, index)
    end
  end
end

defmodule Client do
  def start do
    pid = spawn(__MODULE__, :receiver, [])
    Ticker.register(pid)
  end

  def receiver do
    receive do
      { :tick } ->
        IO.puts "tock in client"
        receiver()
    end
  end
end
