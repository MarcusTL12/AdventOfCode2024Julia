
function is_possible_rec(towels, design)
    if design ∈ towels
        return true
    end

    for n in 1:length(design)
        if design[1:n] ∈ towels && is_possible_rec(towels, design[n+1:end])
            return true
        end
    end

    false
end

function part1()
    lines = Iterators.Stateful(
        eachline("$(homedir())/aoc-input/2024/day19/input")
    )

    towels = popfirst!(lines)
    popfirst!(lines)

    towels = split(towels, ", ")

    c = 0

    for l in lines
        c += is_possible_rec(towels, l)
    end

    c
end


function count_designs_rec(memo, towels, design)
    if haskey(memo, design)
        return memo[design]
    end

    c = 0

    if design ∈ towels
        c += 1
    end

    for n in 1:length(design)
        if design[1:n] ∈ towels
            c += count_designs_rec(memo, towels, design[n+1:end])
        end
    end

    memo[design] = c
end

function part2()
    lines = Iterators.Stateful(
        eachline("$(homedir())/aoc-input/2024/day19/input")
    )

    towels = popfirst!(lines)
    popfirst!(lines)

    towels = split(towels, ", ")

    memo = Dict{String,Int}()

    c = 0

    for l in lines
        c += count_designs_rec(memo, towels, l)
    end

    c
end
