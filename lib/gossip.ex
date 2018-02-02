defmodule Gossip.Node do
    
    use GenServer
    def init(state) do
        list = Utility.updateNeighbourList(state.neighbors, state.id, state.topo)       
        #IO.inspect(state.id <> " started!")
        {:ok, send_map({0, list, state.id})}
    end

    def send_map({mcount, n, node_id}), do:  %{message_count: mcount, neighbors: n, id: node_id}

    def handle_cast({:gossip, message}, state) do
        count = state.message_count
        count = count+1       
        if(count == 1) do
            spawn_link(__MODULE__, :gossip, [state.neighbors, state.id, message])
        end
        if(count == 10) do          
            Process.exit(self(), :normal)    
        end        
        {:noreply, send_map({count, state.neighbors, state.id})}
    end

    def handle_cast({:UPDATE_STATE, list}, state) do
        {:noreply, send_map({state.message_count, list, state.id})}
    end

    def gossip(list, name, message) do
        {to_node, list} = Utility.getNeighbourNode(list, name)
        GenServer.cast(String.to_atom(to_node), {:gossip, message})       
        gossip(list, to_node, message)
    end  
   
end