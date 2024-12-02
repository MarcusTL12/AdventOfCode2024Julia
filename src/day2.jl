
@inline function is_safe(it)
    inc = true
    dec = true

    last, rest = Iterators.peel(it)

    for x in rest
        small = -(reverse(minmax(x, last))...) <= 3

        inc &= x > last && small
        dec &= x < last && small

        last = x
    end

    inc || dec
end

function part1()
    count(is_safe(parse(UInt8, n)
                  for n in eachsplit(l))
          for l in eachline("$(homedir())/aoc-input/2024/day2/input"))
end

function part2()
    c = 0

    v = Int[]

    for l in eachline("$(homedir())/aoc-input/2024/day2/input")
        empty!(v)
        append!(v, parse(UInt8, n) for n in eachsplit(l))
        c += is_safe(v) ||
             any(is_safe((x for (i, x) in enumerate(v) if i != j))
                 for j in eachindex(v))
    end

    c
end
