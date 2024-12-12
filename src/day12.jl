
function part1()
    w = 0
    h = 0
    mat = Char[]

    for l in eachline("$(homedir())/aoc-input/2024/day12/ex2")
        w = length(l)
        h += 1
        append!(mat, l)
    end

    mat = reshape(mat, w, h)

    area = Dict{Char,Int}()
    perimeter = Dict{Char,Int}()

    dirs = (
        (1, 0),
        (-1, 0),
        (0, 1),
        (0, -1),
    )

    for j in 1:h, i in 1:w
        c = mat[i, j]

        area[c] = get(area, c, 0) + 1

        for d in dirs
            if get(mat, ((i, j) .+ d), ' ') != mat[i, j]
                perimeter[c] = get(perimeter, c, 0) + 1
            end
        end
    end

    s = 0

    for (k, v) in area
        @show k, v, perimeter[k]

        s += v * perimeter[k]
    end

    s
end
