defmodule Parallel do
  def pmap(collection, func) do
    me = self
    collection
    |> Enum.map(fn (elem) ->
      spawn_link fn -> (send me, { self, func.(elem) }) end
    end)
    |> Enum.reverse
    |> Enum.map(fn (pid) ->
      receive do { _pid, result } -> result end
    end)
  end
end
