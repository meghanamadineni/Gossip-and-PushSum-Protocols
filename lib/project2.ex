defmodule Project2 do
    def main(args) do
        if(length(args)!=3) do              
              exit(0)
        end
            args
            |> parser 
            |> routeToAlgorithm
    end
    
    def parser([num, topo, algo]) do             
        case topo do
            "full" -> num = elem(Integer.parse(num), 0)
            "line" -> num = elem(Integer.parse(num), 0)
            "2D" -> num = Utility.upperSquareBound(elem(Integer.parse(num),0))
            "imp2D" -> num = Utility.upperSquareBound(elem(Integer.parse(num),0))
            _ -> 
                IO.inspect("Allowed Topology list: " <> "[full, 2D, line, imp2D]") 
                exit(0)
        end
        {num, topo, algo}
    end
    
    def routeToAlgorithm({numNodes, topology, algorithm}) do        
        case algorithm do
            "gossip" -> 
                nodeList = []
                nodeList = Utility.generateName(numNodes, nodeList)
                startGossipNodes(numNodes, nodeList, topology)
                initTime = System.monotonic_time(:millisecond)               
                GenServer.cast(String.to_atom(Enum.at(nodeList,0)), {:gossip, "message"})
                Utility.coverage(nodeList, initTime)
                
            "push-sum" ->
                nodeList = []
                nodeList = Utility.generateName(numNodes, nodeList)
                startPushSumNodes(numNodes, nodeList, topology)
                initTime = System.monotonic_time(:millisecond)
                :ets.new(:user_lookup, [:set, :public, :named_table])
                :ets.insert(:user_lookup, {"ProtocolInitiated",initTime})
                GenServer.cast(String.to_atom(Enum.at(nodeList,0)), {:pushsum, 1.0, 1.0})
                Utility.coverage(nodeList, initTime)
        end
        
    end
    
    def startPushSumNodes(n, list, topo_type) do
        if n > 0 do
            name = Enum.at(list, n-1)
            GenServer.start(PushSum.Node, %{message_count: 0, topo: topo_type, neighbors: list -- [name], id: name, s: n, w: 1.0}, name: String.to_atom(name))
            startPushSumNodes(n-1, list, topo_type)
        end
    end

    def startGossipNodes(n, list, topo_type) do
        if n > 0 do
            name = Enum.at(list, n-1)
            GenServer.start(Gossip.Node, %{message_count: 0, topo: topo_type, neighbors: list -- [name], id: name}, name: String.to_atom(name))
            startGossipNodes(n-1, list, topo_type) 
        end
    end
end
