
function part1()
    w = 0
    h = 0
    mat = Char[]

    for l in eachline("$(homedir())/aoc-input/2024/day8/input")
        w = length(l)
        h += 1
        append!(mat, l)
    end

    mat = reshape(mat, w, h)

    @assert w == h

    antenna = Dict{Char,Vector{NTuple{2,Int}}}()

    for y in 1:h, x in 1:w
        if isletter(mat[x, y]) || isdigit(mat[x, y])
            push!(get!(antenna, mat[x, y], NTuple{2,Int}[]), (x, y))
        end
    end

    for (k, v) in antenna
        for i in eachindex(v), j in 1:i-1
            pos1 = v[i]
            pos2 = v[j]

            dp = pos2 .- pos1

            n1 = pos2 .+ dp
            n2 = pos1 .- dp

            if get(mat, n1, ' ') != ' '
                mat[n1...] = '#'
            end

            if get(mat, n2, ' ') != ' '
                mat[n2...] = '#'
            end
        end
    end

    count(==('#'), mat)
end

function part2()
    w = 0
    h = 0
    mat = Char[]

    for l in eachline("$(homedir())/aoc-input/2024/day8/ex1")
        w = length(l)
        h += 1
        append!(mat, l)
    end

    mat = reshape(mat, w, h)

    @assert w == h

    antenna = Dict{Char,Vector{NTuple{2,Int}}}()

    for y in 1:h, x in 1:w
        if isletter(mat[x, y]) || isdigit(mat[x, y])
            push!(get!(antenna, mat[x, y], NTuple{2,Int}[]), (x, y))
        end
    end

    for (k, v) in antenna
        for i in eachindex(v), j in 1:i-1
            pos1 = v[i]
            pos2 = v[j]

            dp = pos2 .- pos1

            n1 = pos2
            n2 = pos1

            while get(mat, n1, ' ') != ' '
                mat[n1...] = '#'
                n1 = n1 .+ dp
            end

            while get(mat, n2, ' ') != ' '
                mat[n2...] = '#'
                n2 = n2 .- dp
            end
        end
    end

    count(==('#'), mat)
end
