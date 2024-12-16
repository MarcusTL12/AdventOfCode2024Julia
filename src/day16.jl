using DataStructures

function part1()
    w = 0
    h = 0
    mat = Char[]

    for l in eachline("$(homedir())/aoc-input/2024/day16/input")
        w = length(l)
        h += 1
        append!(mat, l)
    end

    mat = reshape(mat, w, h)

    dir = (1, 0)
    pos = (0, 0)
    target = (0, 0)

    for y in 1:h, x in 1:w
        if mat[x, y] == 'S'
            pos = (x, y)
        end
        if mat[x, y] == 'E'
            target = (x, y)
        end
    end

    # display(mat)

    pq = PriorityQueue()

    pq[(pos, dir)] = 0

    seen = Set([(pos, dir)])

    while !isempty(pq)
        (pos, dir), len = dequeue_pair!(pq)
        push!(seen, (pos, dir))

        if pos .+ dir == target
            return len + 1
        end

        if mat[(pos .+ dir)...] != '#' && (pos .+ dir, dir) ∉ seen
            pq[(pos .+ dir, dir)] = len + 1
        end

        ndir = (dir[2], -dir[1])
        if (pos, ndir) ∉ seen
            pq[(pos, ndir)] = len + 1000
        end
        ndir = (-dir[2], dir[1])
        if (pos, ndir) ∉ seen
            pq[(pos, ndir)] = len + 1000
        end
    end
end

function part2()
    w = 0
    h = 0
    mat = Char[]

    for l in eachline("$(homedir())/aoc-input/2024/day16/input")
        w = length(l)
        h += 1
        append!(mat, l)
    end

    mat = reshape(mat, w, h)

    dir = (1, 0)
    start = (0, 0)
    target = (0, 0)

    for y in 1:h, x in 1:w
        if mat[x, y] == 'S'
            start = (x, y)
        end
        if mat[x, y] == 'E'
            target = (x, y)
        end
    end

    # display(mat)

    pq = PriorityQueue()

    pq[[(start, dir)]] = 0

    pathlen = part1()

    all_path = Set([start, target])

    seen = Dict([(start, dir) => 0])

    while !isempty(pq)
        cur_path, len = dequeue_pair!(pq)

        pos, dir = cur_path[end]

        seen[(pos, dir)] = len

        if cur_path[end][1] == target
            for (pos, _) in cur_path
                push!(all_path, pos)
            end

            continue
        end

        if mat[(pos .+ dir)...] != '#' && len + 1 <= pathlen
            k = (pos .+ dir, dir)
            if !haskey(seen, k) || seen[k] == len + 1
                pq[[cur_path; k]] = len + 1
            end
        end

        if len + 1000 <= pathlen
            ndir = (dir[2], -dir[1])
            if !haskey(seen, (pos, ndir)) || seen[(pos, ndir)] == len + 1000
                pq[[cur_path; (pos, ndir)]] = len + 1000
            end
            ndir = (-dir[2], dir[1])
            if !haskey(seen, (pos, ndir)) || seen[(pos, ndir)] == len + 1000
                pq[[cur_path; (pos, ndir)]] = len + 1000
            end
        end
    end

    all_path
end

function showstate(mat, pos, target, all_path)
    w, h = size(mat)

    for y in 1:h
        for x in 1:w
            if (x, y) == pos
                print('S')
            elseif (x, y) == target
                print('E')
            elseif (x, y) ∈ all_path
                print('O')
            else
                print(mat[x, y])
            end
        end
        println()
    end
end
