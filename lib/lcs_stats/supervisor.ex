defmodule LcsStats.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    LcsStats.EsWriter.build_index
    File.write("game2.json", "", [:write])

    children = [
      worker(LcsStats.WebSocketReader, [], [name: WebSocketReader]),
      worker(LcsStats.Publisher, [], [])
    ]

    # supervise/2 is imported from Supervisor.Spec
    supervise(children, strategy: :one_for_one)
  end
end
