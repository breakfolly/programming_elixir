defmodule FredBetty do
  def fred(next_pid) do
    receive do
      token ->
        IO.inspect token
        send next_pid, "f_token"
    end
  end

  def betty(next_pid) do
    receive do
      token ->
        IO.inspect token
        send next_pid, "b_token"
     #   fred({self(), token})
    end
  end

  def run(n) do
    code_to_run = fn (index, send_to) ->
      case rem(index, 2) do
        0 -> spawn(FredBetty, :fred, [send_to])
        _ -> spawn(FredBetty, :betty, [send_to])
      end
    end

    last = Enum.reduce(1..n, self(), code_to_run)

    send(last, "t")
       
    receive do
      token ->
       IO.inspect token 
    end 
  end
end


