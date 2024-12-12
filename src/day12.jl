
function part1()
    w = 0
    h = 0
    mat = Char[]

    for l in eachline("$(homedir())/aoc-input/2024/day12/input")
        w = length(l)
        h += 1
        append!(mat, l)
    end

    mat = reshape(mat, w, h)

    visited = falses(w, h)

    dirs = (
        (1, 0),
        (-1, 0),
        (0, 1),
        (0, -1),
    )

    s = 0

    for j in 1:h, i in 1:w
        if !visited[i, j]
            a, p = 0, 0

            queue = [(i, j)]
            visited[i, j] = true

            while !isempty(queue)
                pos = popfirst!(queue)
                a += 1

                for d in dirs
                    npos = pos .+ d
                    if get(mat, npos, ' ') == mat[pos...]
                        if !visited[npos...]
                            push!(queue, npos)
                            visited[npos...] = true
                        end
                    else
                        p += 1
                    end
                end
            end

            s += a * p
        end
    end

    s
end

function part2()
    w = 0
    h = 0
    mat = Char[]

    for l in eachline("$(homedir())/aoc-input/2024/day12/input")
        w = length(l)
        h += 1
        append!(mat, l)
    end

    mat = reshape(mat, w, h)

    ids = zeros(Int, w, h)

    dirs = (
        (1, 0),
        (-1, 0),
        (0, 1),
        (0, -1),
    )

    otherdirs = (
        ((0, -1), (1, -1)),
        ((0, -1), (-1, -1)),
        ((-1, 0), (-1, 1)),
        ((-1, 0), (-1, -1)),
    )

    s = 0

    nextid = 1

    for j in 1:h, i in 1:w
        if ids[i, j] == 0
            a, p = 0, 0

            queue = [(i, j)]
            ids[i, j] = nextid

            interior = NTuple{2,Int}[]

            while !isempty(queue)
                pos = popfirst!(queue)
                push!(interior, pos)
                a += 1

                for d in dirs
                    npos = pos .+ d
                    if get(mat, npos, ' ') == mat[pos...]
                        if ids[npos...] == 0
                            push!(queue, npos)
                            ids[npos...] = nextid
                        end
                    end
                end
            end

            for pos in interior
                for (di, d) in enumerate(dirs)
                    npos = pos .+ d
                    if ids[pos...] != get(ids, npos, 0)
                        (back, diag) = otherdirs[di]
                        if get(mat, pos .+ back, ' ') == mat[pos...] &&
                           get(mat, pos .+ diag, ' ') == mat[pos...] ||
                           get(mat, pos .+ back, ' ') != mat[pos...]
                            p += 1
                        end
                    end
                end
            end

            nextid += 1

            s += a * p
        end
    end

    s
end
