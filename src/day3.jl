
function part1()
    inp = read("$(homedir())/aoc-input/2024/day3/input", String)

    reg = r"mul\((\d{1,3}),(\d{1,3})\)"

    s = 0

    for m in eachmatch(reg, inp)
        a = parse(Int, m.captures[1])
        b = parse(Int, m.captures[2])

        s += a * b
    end

    s
end

function part2()
    inp = read("$(homedir())/aoc-input/2024/day3/input", String)

    reg = r"(mul)\((\d{1,3}),(\d{1,3})\)|(do)\(\)|(don't)\(\)"

    s = 0

    active = true

    for m in eachmatch(reg, inp)
        if active && m.captures[1] == "mul"
            a = parse(Int, m.captures[2])
            b = parse(Int, m.captures[3])

            s += a * b
        end

        if m.captures[5] == "don't"
            active = false
        elseif m.captures[4] == "do"
            active = true
        end
    end

    s
end
