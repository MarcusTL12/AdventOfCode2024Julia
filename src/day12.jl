
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

    area = Int[]
    perimeter = Int[]

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
