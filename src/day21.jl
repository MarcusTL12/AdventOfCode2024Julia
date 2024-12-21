
function pad2lookup(pad)
    lookup = Dict{Int,NTuple{2,Int}}()

    for j in axes(pad, 2), i in axes(pad, 1)
        if pad[i, j] != -1
            lookup[pad[i, j]] = (i, j)
        end
    end

    lookup
end

function find_shortest_seq(lookup, seq, start=lookup[10])
    pos = start

    n = 0

    for x in seq
        npos = lookup[x]
        n += sum(abs, npos .- pos) + 1
        pos = npos
    end

    n
end

function bfs(seq)
    keypad = [
        7 8 9
        4 5 6
        1 2 3
        -1 0 10
    ]

    dirpad = [
        -1 1 10
        2 3 4
    ]

    key_lookup = pad2lookup(keypad)
    dir_lookup = pad2lookup(dirpad)

    r1 = key_lookup[10]
    r2 = dir_lookup[10]
    r3 = dir_lookup[10]

    queue = [(r1, r2, r3, 1, Int[], 0)]
    seen = Set([(r1, r2, r3, 1)])

    dirs = (
        (-1, 0),
        (0, -1),
        (1, 0),
        (0, 1),
    )

    while !isempty(queue)
        r1, r2, r3, curcode, curpath, l = popfirst!(queue)

        # @show r1, r2, r3, curcode

        # You pressing directions
        for (i, d) in enumerate(dirs)
            npos = r3 .+ d
            if get(dirpad, npos, -1) != -1
                k = (r1, r2, npos, curcode)
                if k ∉ seen
                    push!(seen, k)
                    push!(queue, (k..., [curpath; i], l + 1))
                end
            end
        end

        # You pressing A
        key = get(dirpad, r3, -1)
        if 1 <= key <= 4
            # Robot 3 pressing dirkey
            d = dirs[key]
            npos = r2 .+ d
            if get(dirpad, npos, -1) != -1
                k = (r1, npos, r3, curcode)
                if k ∉ seen
                    push!(seen, k)
                    push!(queue, (k..., [curpath; 10], l + 1))
                end
            end
        elseif key == 10
            # Robot 3 pressing A
            key = get(dirpad, r2, -1)
            if 1 <= key <= 4
                # Robot 2 pressing dirkey
                d = dirs[key]
                npos = r1 .+ d
                if get(keypad, npos, -1) != -1
                    k = (npos, r2, r3, curcode)
                    if k ∉ seen
                        push!(seen, k)
                        push!(queue, (k..., [curpath; 10], l + 1))
                    end
                end
            elseif key == 10
                # Robot 2 pressing A
                key = get(keypad, r1, -1)
                if key == seq[curcode]
                    if curcode == length(seq)
                        println(String(["^<v>     A"[x] for x in [curpath; 10]]))
                        return l + 1
                    else
                        k = (r1, r2, r3, curcode + 1)
                        if k ∉ seen
                            push!(seen, k)
                            push!(queue, (k..., [curpath; 10], l + 1))
                        end
                    end
                end
            end
        end
    end
end

function part1()
    s = 0
    for l in eachline("$(homedir())/aoc-input/2024/day21/input")
        n = parse(Int, l[1:end-1])

        seq = map(collect(l)) do c
            if c == 'A'
                10
            else
                c - '0'
            end
        end

        len = bfs(seq)

        @show len

        s += n * len
    end
    s
end

function bfs2(seq, n_dir)
    keypad = [
        7 8 9
        4 5 6
        1 2 3
        -1 0 10
    ]

    dirpad = [
        -1 1 10
        2 3 4
    ]

    r1 = (4, 3)
    dir_robots = [(1, 3) for _ in 1:n_dir]

    queue = [(r1, dir_robots, 1, 0)]
    seen = Set([(r1, dir_robots, 1)])

    dirs = (
        (-1, 0),
        (0, -1),
        (1, 0),
        (0, 1),
    )

    while !isempty(queue)
        r1, dir_robots, curcode, l = popfirst!(queue)

        function rec(i, key)
            if i == 0
                if 1 <= key <= 4
                    d = dirs[key]
                    npos = r1 .+ d
                    if get(keypad, npos, -1) != -1
                        k = (npos, dir_robots, curcode)
                        if k ∉ seen
                            push!(seen, k)
                            push!(queue, (k..., l + 1))
                        end
                    end
                elseif key == 10
                    key = get(keypad, r1, -1)
                    if key == seq[curcode]
                        if curcode == length(seq)
                            return l + 1
                        else
                            k = (r1, dir_robots, curcode + 1)
                            if k ∉ seen
                                push!(seen, k)
                                push!(queue, (k..., l + 1))
                            end
                        end
                    end
                end
                nothing
            elseif 1 <= key <= 4
                d = dirs[key]
                npos = dir_robots[i] .+ d
                if get(dirpad, npos, -1) != -1
                    local_robots = copy(dir_robots)
                    local_robots[i] = npos
                    k = (r1, local_robots, curcode)
                    if k ∉ seen
                        push!(seen, k)
                        push!(queue, (k..., l + 1))
                    end
                end
                nothing
            elseif key == 10
                rec(i - 1, get(dirpad, dir_robots[i], -1))
            end
        end

        for code in (1, 2, 3, 4, 10)
            x = rec(length(dir_robots), code)
            if !isnothing(x)
                return x
            end
        end
    end
end

dirpad::Matrix{Int} = [
    -1 1 10
    2 3 4
]

dir_lookup::Dict{Int,NTuple{2,Int}} = pad2lookup(dirpad)

keypad::Matrix{Int} = [
    7 8 9
    4 5 6
    1 2 3
    -1 0 10
]

key_lookup::Dict{Int,NTuple{2,Int}} = pad2lookup(keypad)

function add_delta_to_path!(path, dy, dx)
    while dx < 0
        dx += 1
        push!(path, 2)
    end
    while dx > 0
        dx -= 1
        push!(path, 4)
    end
    while dy < 0
        dy += 1
        push!(path, 1)
    end
    while dy > 0
        dy -= 1
        push!(path, 3)
    end
end

function make_path_from_path(lookup, target_path)
    pos = lookup[10]

    path = Int[]

    for key in target_path
        target = lookup[key]
        add_delta_to_path!(path, (target .- pos)...)
        pos = target
        push!(path, 10)
    end

    target = lookup[10]

    path
end

function rec(depth, pos, target)
    dy, dx = target .- pos

    @show depth, pos, target

    if depth == 0
        return abs(dy) + abs(dx) + 1
    end

    pos = (1, 3)

    n = 0

    if dx != 0
        target = if dx < 0
            (2, 1)
        else
            (2, 3)
        end

        n += rec(depth - 1, pos, target)
        n += abs(dx) - 1

        pos = target
    end

    if dy != 0
        target = if dy < 0
            (1, 2)
        else
            (2, 2)
        end

        n += rec(depth - 1, pos, target)
        n += abs(dy) - 1

        pos = target
    end

    n += rec(depth - 1, pos, (1, 3))

    n
end

function solve_rec(depth, path)
    pos = (4, 3)

    n = 0

    for key in path
        target = key_lookup[key]

        n += rec(depth, pos, target)
        pos = target
    end

    n
end

function part2()
    s = 0
    for l in eachline("$(homedir())/aoc-input/2024/day21/ex1")
        n = parse(Int, l[1:end-1])

        seq = map(collect(l)) do c
            if c == 'A'
                10
            else
                c - '0'
            end
        end

        lookup = key_lookup

        for _ in 0:2
            seq = make_path_from_path(lookup, seq)
            lookup = dir_lookup
        end

        @show length(seq)

        s += n * length(seq)
    end
    s
end
