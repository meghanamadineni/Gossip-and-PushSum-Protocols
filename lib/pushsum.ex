defmodule PushSum.Node do
    
    use GenServer
    def init(state) do
        list = Utility.updateNeighbourList(state.neighbors, state.id, state.topo) 
        {:ok, send_map({0, list, state.id, state.s, state.w})}
    end

    def send_map({mcount, n, node_id, s_val, w_val}), do:  %{message_count: mcount, neighbors: n, id: node_id, s: s_val, w: w_val}
    
    def handle_cast({:pushsum, s_message, w_message}, state) do
        s = state.s + s_message
        w = state.w + w_message
        count = state.message_count
        import Kernel
        change = Kernel.abs(s/w - state.s/state.w)
        if change  < :math.pow(10,-10) do
            count = count+1
        end     

        if(count == 3) do
            IO.inspect("----- CONVERGED ------ ")
            IO.inspect("Name: " <> state.id)
            IO.inspect("Threshold reached: 3")
            #IO.inspect("[s, w] ratio: [#{state.s}, #{state.w}]")
            IO.inspect("Difference in ratios: #{change}")
            pushsum(state.neighbors, state.id, {s/2 , w/2})             
            [{_, protocolInitiated}] = :ets.lookup(:user_lookup, "ProtocolInitiated")       
            IO.inspect("Converging Time: #{System.monotonic_time(:millisecond) - protocolInitiated} ms")
            System.halt(0)
            
        else            
            pushsum(state.neighbors, state.id, {s/2 , w/2})
        end
        
        {:noreply, send_map({count, state.neighbors, state.id, s/2, w/2})}
    end
    
    def handle_cast({:UPDATE_STATE, list}, state) do
        {:noreply, send_map({state.message_count, list, state.id, state.s, state.w})}
    end

    def pushsum(list, name, {s, w}) do
        {to_node, list} = Utility.getNeighbourNode(list, name)
        GenServer.cast(String.to_atom(to_node), {:pushsum, s, w})        
    end 
end