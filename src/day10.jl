
function part1()
    w = 0
    h = 0
    mat = Char[]

    for l in eachline("$(homedir())/aoc-input/2024/day10/input")
        w = length(l)
        h += 1
        append!(mat, l)
    end

    mat = reshape(mat, w, h)

    dirs = [
        (1, 0),
        (-1, 0),
        (0, 1),
        (0, -1),
    ]

    s = 0

    for j in 1:h, i in 1:w
        if mat[i, j] == '0'
            queue = [(i, j)]
            seen = Set([(i, j)])

            while !isempty(queue)
                pos = popfirst!(queue)
                h1 = mat[pos...]

                for d in dirs
                    npos = pos .+ d
                    h2 = get(mat, npos, '0')

                    if h2 - h1 == 1 && npos ∉ seen
                        push!(seen, npos)
                        push!(queue, npos)
                    end
                end
            end

            score = count(mat[p...] == '9' for p in seen)

            s += score
        end
    end

    s
end

function count_n_trails(mat, pos)
    if mat[pos...] == '9'
        return 1
    end

    dirs = (
        (1, 0),
        (-1, 0),
        (0, 1),
        (0, -1),
    )

    s = 0

    h1 = mat[pos...]

    for d in dirs
        npos = pos .+ d
        h2 = get(mat, npos, '0')

        if h2 - h1 == 1
            s += count_n_trails(mat, npos)
        end
    end

    s
end

function part2()
    w = 0
    h = 0
    mat = Char[]

    for l in eachline("$(homedir())/aoc-input/2024/day10/input")
        w = length(l)
        h += 1
        append!(mat, l)
    end

    mat = reshape(mat, w, h)

    s = 0

    for j in 1:h, i in 1:w
        if mat[i, j] == '0'
            s += count_n_trails(mat, (i, j))
        end
    end

    s
end
