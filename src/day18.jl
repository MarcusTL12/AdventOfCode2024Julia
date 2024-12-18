
function part1()
    w = 71
    grid = falses(w, w)

    for l in Iterators.take(eachline("$(homedir())/aoc-input/2024/day18/input"), 1024)
        x, y = parse.(Int, eachsplit(l, ','))

        grid[x+1, y+1] = true
    end

    start = (1, 1)
    target = (w, w)

    queue = [(start, 0)]

    dirs = (
        (1, 0),
        (-1, 0),
        (0, 1),
        (0, -1),
    )

    seen = falses(size(grid))

    while !isempty(queue)
        (pos, l) = popfirst!(queue)

        for d in dirs
            npos = pos .+ d

            if !get(grid, npos, true) && !seen[npos...]
                if npos == target
                    return l + 1
                end
                push!(queue, (npos, l + 1))
                seen[npos...] = true
            end
        end
    end
end

function has_path(grid)
    start = (1, 1)
    target = size(grid)

    queue = [start]

    dirs = (
        (1, 0),
        (-1, 0),
        (0, 1),
        (0, -1),
    )

    seen = falses(size(grid))

    while !isempty(queue)
        pos = popfirst!(queue)

        for d in dirs
            npos = pos .+ d

            if !get(grid, npos, true) && !seen[npos...]
                if npos == target
                    return true
                end
                push!(queue, npos)
                seen[npos...] = true
            end
        end
    end

    false
end

function part2()
    w = 71
    grid = falses(w, w)

    for l in eachline("$(homedir())/aoc-input/2024/day18/input")
        x, y = parse.(Int, eachsplit(l, ','))

        grid[x+1, y+1] = true

        if !has_path(grid)
            return l
        end
    end
end
