
function part1()
    inp = read("$(homedir())/aoc-input/2024/day9/input", String)

    disk = Int[]

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
                push!(disk, -1)
            end
        end

        freespace = !freespace
    end

    i = 1

    while i < length(disk)
        while i < length(disk) && disk[i] < 0
            disk[i] = pop!(disk)
        end

        i += 1
    end

    while last(disk) < 0
        pop!(disk)
    end

    sum((i - 1) * x for (i, x) in enumerate(disk))
end

function part2()
    inp = read("$(homedir())/aoc-input/2024/day9/input", String)

    disk = Tuple{Int,Int}[]

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
            push!(disk, (-1, n))
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
                    if to[1] < 0 && to[2] >= from[2]
                        disk[j] = (id, from[2])

                        disk[i] = (-1, from[2])
                        if i + 1 <= length(disk) && disk[i+1][1] < 0
                            disk[i] = (-1, disk[i][2] + disk[i+1][2])
                            deleteat!(disk, i + 1)
                        end
                        if disk[i-1][1] < 0
                            disk[i-1] = (-1, disk[i-1][2] + disk[i][2])
                            deleteat!(disk, i)
                        end

                        if to[2] > from[2]
                            insert!(disk, j + 1, (-1, to[2] - from[2]))
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
        if x >= 0
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
