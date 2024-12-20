
function bfs(mat, cheat, start, stop)
    queue = [(start, 0)]
    seen = Set([start])

    dirs = (
        (1, 0),
        (-1, 0),
        (0, 1),
        (0, -1),
    )

    while !isempty(queue)
        pos, l = popfirst!(queue)

        for d in dirs
            npos = pos .+ d

            if npos == stop
                return l + 1
            end

            if (npos == cheat || mat[npos...] != '#') && npos ∉ seen
                push!(queue, (npos, l + 1))
                push!(seen, npos)
            end
        end
    end
end

function part1()
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

    normal_len = bfs(mat, (0, 0), start, stop)

    c = 0

    for cy in 2:h-1, cx in 2:w-1
        l = bfs(mat, (cx, cy), start, stop)

        if l <= normal_len - 100
            c += 1
        end
    end

    c
end

function bfs3(mat, start, stop)
    queue = [(start, start)]
    seen = Dict([start => start])

    dirs = (
        (1, 0),
        (-1, 0),
        (0, 1),
        (0, -1),
    )

    while !isempty(queue)
        pos, from = popfirst!(queue)

        for d in dirs
            npos = pos .+ d

            if npos == stop
                seen[npos] = pos
                break
            end

            if mat[npos...] != '#' && !haskey(seen, npos)
                push!(queue, (npos, pos))
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

function part2()
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

    path = bfs3(mat, start, stop)

    c = 0

    for i in eachindex(path), j in (i+1):length(path)
        from = path[i]
        to = path[j]
        cheat_dist = sum(abs, to .- from)

        if cheat_dist > 20
            continue
        end

        saved_dist = (j - i) - cheat_dist

        if saved_dist >= 100
            c += 1
        end
    end

    c
end
