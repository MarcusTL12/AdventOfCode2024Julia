
function dgts2num(dgts)
    n = 0
    for d in dgts
        n = 10n + d
    end
    n
end

function part1()
    inp = read("$(homedir())/aoc-input/2024/day11/input", String)

    stones = parse.(Int, eachsplit(inp))

    for _ in 1:25
        for i in reverse(eachindex(stones))
            s = stones[i]

            if s == 0
                stones[i] = 1
            elseif iseven(ndigits(s))
                dgts = digits(s)

                a = dgts2num(reverse(dgts[1:length(dgts)÷2]))
                b = dgts2num(reverse(dgts[length(dgts)÷2+1:end]))

                stones[i] = b
                insert!(stones, i + 1, a)
            else
                stones[i] = s * 2024
            end
        end
    end

    length(stones)
end

function n_stones(memo, s, depth)
    if depth == 0
        return 1
    end

    k = (s, depth)

    if haskey(memo, k)
        return memo[k]
    end

    memo[k] = if s == 0
        n_stones(memo, 1, depth - 1)
    elseif iseven(ndigits(s))
        dgts = digits(s)

        a = dgts2num(reverse(dgts[1:length(dgts)÷2]))
        b = dgts2num(reverse(dgts[length(dgts)÷2+1:end]))

        n_stones(memo, a, depth - 1) +
        n_stones(memo, b, depth - 1)
    else
        n_stones(memo, s * 2024, depth - 1)
    end
end

function part2()
    inp = read("$(homedir())/aoc-input/2024/day11/input", String)

    stones = parse.(Int, eachsplit(inp))

    memo = Dict{NTuple{2,Int},Int}()

    sum(n_stones(memo, s, 75) for s in stones)
end
