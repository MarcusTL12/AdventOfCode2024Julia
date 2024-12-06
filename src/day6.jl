
function part1()
    w = 0
    h = 0
    mat = Char[]

    for l in eachline("$(homedir())/aoc-input/2024/day6/input")
        w = length(l)
        h += 1
        append!(mat, l)
    end

    mat = reshape(mat, w, h)

    @assert w == h

    pos = (0, 0)

    for y in 1:h, x in 1:w
        if mat[x, y] == '^'
            pos = (x, y)
        end
    end

    states = Set{NTuple{2,NTuple{2,Int}}}()
    visited = falses(w, h)
    visited[pos...] = true

    dir = (0, -1)

    while (pos, dir) ∉ states
        visited[pos...] = true
        push!(states, (pos, dir))

        while get(mat, pos .+ dir, ' ') == '#'
            dir = (-dir[2], dir[1])
        end

        if get(mat, pos .+ dir, ' ') == ' '
            break
        end

        pos = pos .+ dir
    end

    count(visited)
end


function part2()
    w = 0
    h = 0
    mat = Char[]

    for l in eachline("$(homedir())/aoc-input/2024/day6/input")
        w = length(l)
        h += 1
        append!(mat, l)
    end

    mat = reshape(mat, w, h)

    @assert w == h

    pos = (0, 0)

    for y in 1:h, x in 1:w
        if mat[x, y] == '^'
            pos = (x, y)
        end
    end

    startpos = pos

    c = 0

    states = Set{NTuple{2,NTuple{2,Int}}}()

    for y in 1:h, x in 1:w
        if mat[x, y] == '#'
            continue
        end

        mat[x, y] = '#'

        empty!(states)

        dir = (0, -1)

        pos = startpos

        isloop = true

        while (pos, dir) ∉ states
            push!(states, (pos, dir))

            while get(mat, pos .+ dir, ' ') == '#'
                dir = (-dir[2], dir[1])
            end

            if get(mat, pos .+ dir, ' ') == ' '
                isloop = false
                break
            end

            pos = pos .+ dir
        end

        if isloop
            c += 1
        end

        mat[x, y] = '.'
    end

    c
end
