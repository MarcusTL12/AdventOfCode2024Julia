
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

        # if l < normal_len
        #     @show l
        # end

        if l <= normal_len - 100
            c += 1
        end
    end

    c
end

function bfs2(mat, cheat_in, cheat_out, start, stop)
    queue = [(start, 0, false)]
    seen = Set([(start, false)])

    dirs = (
        (1, 0),
        (-1, 0),
        (0, 1),
        (0, -1),
    )

    cheat_len = sum(abs, cheat_out .- cheat_in)

    while !isempty(queue)
        pos, l, cheated = popfirst!(queue)

        if pos == cheat_in && !cheated
            if cheat_out == stop
                return l + cheat_len
            end
            push!(queue, (cheat_out, l + cheat_len, true))
            push!(seen, (cheat_out, true))
        end

        for d in dirs
            npos = pos .+ d

            if npos == stop
                return l + 1
            end

            if mat[npos...] != '#' && (npos, cheated) ∉ seen
                push!(queue, (npos, l + 1, cheated))
                push!(seen, (npos, cheated))
            end
        end
    end
end

function part2()
    w = 0
    h = 0
    mat = Char[]

    for l in eachline("$(homedir())/aoc-input/2024/day20/ex1")
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

    c = Threads.Atomic{Int}(0)
    t = Threads.Atomic{Float64}(time())

    all_from = [(cx, cy) for cy in 2:h-1 for cx in 2:w-1]

    filter!(all_from) do from
        mat[from...] != '#'
    end

    Threads.@threads for (cx, cy) in all_from
        from = (cx, cy)
        if get(mat, from, '#') == '#'
            continue
        end

        for dy in -20:20, dx in -(20 - abs(dy)):(20-abs(dy))

            to = from .+ (dx, dy)
            if get(mat, to, '#') == '#'
                continue
            end
            l = bfs2(mat, from, to, start, stop)

            if l <= normal_len - 50
                Threads.atomic_add!(c, 1)

                if time() - t[] > 1.0
                    Threads.atomic_add!(t, 1.0)
                    @show c
                end
            end
        end
    end

    c
end
