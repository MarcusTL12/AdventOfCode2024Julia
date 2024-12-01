
function part1()
    inp = read("$(homedir())/aoc-input/2024/day1/input", String)

    a = Int[]
    b = Int[]

    for l in eachline("$(homedir())/aoc-input/2024/day1/input")
        x, y = split(l)

        push!(a, parse(Int, x))
        push!(b, parse(Int, y))
    end

    sort!(a)
    sort!(b)

    sum(abs.(b .- a))
end

function part2()
    a = Int[]

    counts = Dict{Int,Int}()

    for l in eachline("$(homedir())/aoc-input/2024/day1/input")
        x, y = split(l)

        push!(a, parse(Int, x))

        y = parse(Int, y)

        counts[y] = get(counts, y, 0) + 1
    end

    sum(n * get(counts, n, 0) for n in a)
end
