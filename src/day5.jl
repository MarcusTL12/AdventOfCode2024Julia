
function part1()
    inp = read("$(homedir())/aoc-input/2024/day5/input", String)

    s1, s2 = split(inp, "\n\n")

    orderings = Set{NTuple{2,Int}}()

    for l in eachsplit(s1, '\n')
        a, b = eachsplit(l, '|')
        push!(orderings, (parse(Int, a), parse(Int, b)))
    end

    lt = (x, y) -> (x, y) ∈ orderings

    s = 0

    for l in eachsplit(s2, '\n', keepempty=false)
        v = parse.(Int, split(l, ','))

        if issorted(v, lt=lt)
            s += v[length(v)÷2+1]
        end
    end

    s
end

function part2()
    inp = read("$(homedir())/aoc-input/2024/day5/input", String)

    s1, s2 = split(inp, "\n\n")

    orderings = Set{NTuple{2,Int}}()

    for l in eachsplit(s1, '\n')
        a, b = eachsplit(l, '|')
        push!(orderings, (parse(Int, a), parse(Int, b)))
    end

    lt = (x, y) -> (x, y) ∈ orderings

    s = 0

    for l in eachsplit(s2, '\n', keepempty=false)
        v = parse.(Int, split(l, ','))

        if issorted(v, lt=lt)
            continue
        end

        sort!(v; lt=(x, y) -> (x, y) ∈ orderings)

        s += v[length(v)÷2+1]
    end

    s
end
