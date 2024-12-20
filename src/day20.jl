
function bfs(mat, start, stop)
    queue = [start]
    seen = Dict([start => start])

    dirs = (
        (1, 0),
        (-1, 0),
        (0, 1),
        (0, -1),
    )

    while !isempty(queue)
        pos = popfirst!(queue)

        for d in dirs
            npos = pos .+ d

            if npos == stop
                seen[npos] = pos
                break
            end

            if mat[npos...] != '#' && !haskey(seen, npos)
                push!(queue, npos)
                seen[npos] = pos
            end
        end
    end

    path = [stop]
    while path[end] != start
        push!(path, seen[path[end]])
    end
    reverse!(path)
end

function solve(n_cheat)
    w = 0
    h = 0
    mat = Char[]

    for l in eachline("$(homedir())/aoc-input/2024/day20/input")
        w = length(l)
        h += 1
        append!(mat, l)
    end

    mat = reshape(mat, w, h)

    start = (0, 0)
    stop = (0, 0)

    for y in 1:h, x in 1:w
        if mat[x, y] == 'S'
            start = (x, y)
        elseif mat[x, y] == 'E'
            stop = (x, y)
        end
    end

    path = bfs(mat, start, stop)

    c = 0

    for i in eachindex(path), j in (i+1):length(path)
        from = path[i]
        to = path[j]
        cheat_dist = sum(abs, to .- from)

        if cheat_dist > n_cheat
            continue
        end

        saved_dist = (j - i) - cheat_dist

        if saved_dist >= 100
            c += 1
        end
    end

    c
end

function part1()
    solve(2)
end

function part2()
    solve(20)
end
