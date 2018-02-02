
defmodule Topology do
    def line(list, name) do
        no = String.to_integer(String.slice(name, 4..String.length(name) - 1))
        if no == 0 do
            ["node#{1}"]
        else
            if(no == length(list)-1) do
                ["node#{length(list)-2}"]
            else
                ["node#{no-1}", "node#{no+1}"]
            end
        end
    end

    def imp2D(list, name) do
        #IO.inspect(list)
        newList = twoD(list, name)
        list = list -- newList
        list = list -- [name]
        unless(length(list) == 0) do
            newList ++ [Enum.random(list)]
        else
            newList
        end
    end

    def twoD(list, name) do
        no = String.to_integer(String.slice(name, 4..String.length(name) - 1))
        cols = round(:math.floor(:math.sqrt(length(list))))
        row = div(no, cols)
        col = rem(no, cols)
        neighboursList = []
        neighboursList = validateGridAndAdd(row-1, col, cols, length(list)-1, neighboursList)
        neighboursList = validateGridAndAdd(row+1, col, cols, length(list)-1, neighboursList)
        neighboursList = validateGridAndAdd(row, col-1, cols, length(list)-1, neighboursList)
        neighboursList = validateGridAndAdd(row, col+1, cols, length(list)-1, neighboursList)
    end

    def validateGridAndAdd(row, col, cols, max, list) do
        maxRow = div(max, cols)
        maxCol = cols-1
        if row >= 0 && col >= 0 do
            if row <= maxRow && col <= maxCol && row*cols + col <= max do
                ["node#{row*cols + col}" | list]
            else
                list
            end
        else
            list
        end
    end
end