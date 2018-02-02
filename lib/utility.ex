defmodule Utility do
    def ifAlive(name) do
        try do
            pid = Process.whereis(String.to_atom(name))
            pid != nil && Process.alive?(pid) == true
        rescue
            _e in ArgumentError -> false
        end
    end

    def updateNeighbourList(list, name, topo) do
        case topo do
            "full" -> list -- [name]
            "2D" -> Topology.twoD(list, name)
            "line" -> Topology.line(list, name)
            "imp2D" -> Topology.imp2D(list, name)
        end
    end

    def getNeighbourNode([], name) do
        try do
            Process.exit(self(), :normal)
        rescue
            _e in ArgumentError -> false 
        end   
    end

    def getNeighbourNode(list, name) do
        random_name = Enum.random(list)
        if(ifAlive(random_name)) do
            {random_name, list}
        else
            list = list -- [random_name]
            GenServer.cast(String.to_atom(name), {:UPDATE_STATE, list})
            getNeighbourNode(list, name)
        end
    end

    def upperSquareBound(num) do
        if :math.sqrt(num) != round(:math.sqrt(num)) do
            upperSquareBound(num+1)
        else
            num
        end
    end

    def coverage(list, initTime) do
        aliveCount = numberOfNodesAlive(list, length(list), 0)      
        if aliveCount < round(length(list)*0.1)  || aliveCount <= 2 do
            endTime = System.monotonic_time(:millisecond) 
            IO.inspect ("Total time: #{endTime - initTime} milliseconds")  
            Process.exit(self(), :normal)
        else
            coverage(list, initTime)
        end
    end

    def numberOfNodesAlive(_list, 0, count) do
        count
    end

    def numberOfNodesAlive(list, index, count) do
        if Utility.ifAlive(Enum.at(list, index-1)) do
            numberOfNodesAlive(list, index-1, count+1)
        else
            numberOfNodesAlive(list, index-1, count) 
        end      
    end

    def generateName(0, list) do 
        list
    end

    def generateName(n, list) do
        list = ["node#{n}" | list]
        generateName(n-1, list) 
    end

end
