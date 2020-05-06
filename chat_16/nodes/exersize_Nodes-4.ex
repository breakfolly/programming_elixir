defmodule Ticker do
#  @interval 2000   # 2 seconds
  @name :ticker

  def start do
    pid = spawn(__MODULE__, :generator, [[]])
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    send :global.whereis_name(@name), { :register, client_pid }
  end

  def generator(clients) do
    receive do
      { :register, pid } ->
        IO.puts "registering #{inspect pid}"
        added_clients = [pid|clients] 
        Enum.with_index(added_clients)
        |> Enum.each(fn {client, index} ->
          next = Enum.at(added_clients, Integer.mod((index + 1), length(added_clients)))
          send client, { :next, next }
        end)
        if length(added_clients) < 2 do
            IO.inspect "tick from server"
            send Enum.at(added_clients, 0), { :tick }
        end
        generator(added_clients)
    end
  end
end

defmodule Client do
  @interval 2000

  def start do
    pid = spawn(__MODULE__, :receiver, [nil])
    Ticker.register(pid)
  end

  def receiver(next_pid) do
    receive do
      { :tick } ->
        IO.puts "tock in #{inspect self()} client"
        send_to_next(next_pid)
        receiver(next_pid)
      { :next, next } ->
        receiver(next)
    end
  end


  defp send_to_next(next_pid) when next_pid == nil, do: nil
  defp send_to_next(next_pid) do
    receive do
    after
      @interval ->
        IO.inspect next_pid
        send next_pid, { :tick }
    end
  end
end
