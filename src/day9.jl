
function part1()
    inp = read("$(homedir())/aoc-input/2024/day9/input", String)

    disk = Union{Int,Nothing}[]

    freespace = false
    id = 0

    for x in inp
        if x == '\n'
            continue
        end

        n = x - '0'

        if !freespace
            for _ in 1:n
                push!(disk, id)
            end
            id += 1
        else
            for _ in 1:n
                push!(disk, nothing)
            end
        end

        freespace = !freespace
    end

    i = 1

    while i < length(disk)
        while i < length(disk) && isnothing(disk[i])
            disk[i] = pop!(disk)
        end

        i += 1
    end

    while isnothing(last(disk))
        pop!(disk)
    end

    sum((i - 1) * x for (i, x) in enumerate(disk))
end

function part2()
    inp = read("$(homedir())/aoc-input/2024/day9/input", String)

    disk = Tuple{Union{Int,Nothing},Int}[]

    freespace = false
    id = 0

    for x in inp
        if x == '\n'
            continue
        end

        n = x - '0'

        if !freespace
            if n > 0
                push!(disk, (id, n))
            end
            id += 1
        elseif n > 0
            push!(disk, (nothing, n))
        end

        freespace = !freespace
    end

    id -= 1
    while id > 0
        for i in reverse(eachindex(disk))
            did_something = false
            from = disk[i]
            if from[1] == id
                for j in 1:i-1
                    to = disk[j]
                    if isnothing(to[1]) && to[2] >= from[2]
                        # println("Moving id $id from $i to $j")

                        disk[j] = (id, from[2])

                        disk[i] = (nothing, from[2])
                        if !isnothing(get(disk, i + 1, nothing)) &&
                           isnothing(disk[i+1][1])
                            disk[i] = (nothing, disk[i][2] + disk[i+1][2])
                            deleteat!(disk, i + 1)
                        end
                        if isnothing(disk[i-1][1])
                            disk[i-1] = (nothing, disk[i-1][2] + disk[i][2])
                            deleteat!(disk, i)
                        end

                        if to[2] > from[2]
                            insert!(disk, j + 1, (nothing, to[2] - from[2]))
                        end

                        did_something = true
                        break
                    end
                end
            end
            if did_something
                break
            end
        end
        id -= 1
    end

    i = 0
    s = 0
    for (x, n) in disk
        if !isnothing(x)
            for _ in 1:n
                s += x * i
                i += 1
            end
        else
            i += n
        end
    end
    s
end
