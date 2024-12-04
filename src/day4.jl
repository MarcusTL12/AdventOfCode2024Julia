
function part1()
    w = 0
    h = 0
    mat = Char[]

    for l in eachline("$(homedir())/aoc-input/2024/day4/input")
        w = length(l)
        h += 1
        append!(mat, l)
    end

    mat = reshape(mat, w, h)

    @assert w == h

    c = 0

    for j in 1:h, i in 1:w
        if get(mat, (i, j), ' ') == 'X' &&
           get(mat, (i + 1, j), ' ') == 'M' &&
           get(mat, (i + 2, j), ' ') == 'A' &&
           get(mat, (i + 3, j), ' ') == 'S'
            c += 1
        end

        if get(mat, (i, j), ' ') == 'X' &&
           get(mat, (i - 1, j), ' ') == 'M' &&
           get(mat, (i - 2, j), ' ') == 'A' &&
           get(mat, (i - 3, j), ' ') == 'S'
            c += 1
        end

        if get(mat, (i, j), ' ') == 'X' &&
           get(mat, (i, j + 1), ' ') == 'M' &&
           get(mat, (i, j + 2), ' ') == 'A' &&
           get(mat, (i, j + 3), ' ') == 'S'
            c += 1
        end

        if get(mat, (i, j), ' ') == 'X' &&
           get(mat, (i, j - 1), ' ') == 'M' &&
           get(mat, (i, j - 2), ' ') == 'A' &&
           get(mat, (i, j - 3), ' ') == 'S'
            c += 1
        end

        if get(mat, (i, j), ' ') == 'X' &&
           get(mat, (i + 1, j + 1), ' ') == 'M' &&
           get(mat, (i + 2, j + 2), ' ') == 'A' &&
           get(mat, (i + 3, j + 3), ' ') == 'S'
            c += 1
        end

        if get(mat, (i, j), ' ') == 'X' &&
           get(mat, (i - 1, j + 1), ' ') == 'M' &&
           get(mat, (i - 2, j + 2), ' ') == 'A' &&
           get(mat, (i - 3, j + 3), ' ') == 'S'
            c += 1
        end

        if get(mat, (i, j), ' ') == 'X' &&
           get(mat, (i + 1, j - 1), ' ') == 'M' &&
           get(mat, (i + 2, j - 2), ' ') == 'A' &&
           get(mat, (i + 3, j - 3), ' ') == 'S'
            c += 1
        end

        if get(mat, (i, j), ' ') == 'X' &&
           get(mat, (i - 1, j - 1), ' ') == 'M' &&
           get(mat, (i - 2, j - 2), ' ') == 'A' &&
           get(mat, (i - 3, j - 3), ' ') == 'S'
            c += 1
        end
    end

    c
end

function part2()
    w = 0
    h = 0
    mat = Char[]

    for l in eachline("$(homedir())/aoc-input/2024/day4/input")
        w = length(l)
        h += 1
        append!(mat, l)
    end

    mat = reshape(mat, w, h)

    @assert w == h

    c = 0

    for j in 1:h, i in 1:w
        if get(mat, (i, j), ' ') == 'A' &&
           get(mat, (i + 1, j + 1), ' ') == 'M' &&
           get(mat, (i - 1, j - 1), ' ') == 'S' &&
           get(mat, (i + 1, j - 1), ' ') == 'M' &&
           get(mat, (i - 1, j + 1), ' ') == 'S'
            c += 1
        end

        if get(mat, (i, j), ' ') == 'A' &&
           get(mat, (i + 1, j + 1), ' ') == 'M' &&
           get(mat, (i - 1, j - 1), ' ') == 'S' &&
           get(mat, (i + 1, j - 1), ' ') == 'S' &&
           get(mat, (i - 1, j + 1), ' ') == 'M'
            c += 1
        end

        if get(mat, (i, j), ' ') == 'A' &&
           get(mat, (i + 1, j + 1), ' ') == 'S' &&
           get(mat, (i - 1, j - 1), ' ') == 'M' &&
           get(mat, (i + 1, j - 1), ' ') == 'M' &&
           get(mat, (i - 1, j + 1), ' ') == 'S'
            c += 1
        end

        if get(mat, (i, j), ' ') == 'A' &&
           get(mat, (i + 1, j + 1), ' ') == 'S' &&
           get(mat, (i - 1, j - 1), ' ') == 'M' &&
           get(mat, (i + 1, j - 1), ' ') == 'S' &&
           get(mat, (i - 1, j + 1), ' ') == 'M'
            c += 1
        end
    end

    c
end
