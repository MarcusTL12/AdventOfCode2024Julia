
function part1()
    reg = r"""Register A: (\d+)
Register B: 0
Register C: 0

Program: (.+)"""

    inp = read("$(homedir())/aoc-input/2024/day17/input", String)

    m = match(reg, inp)

    # a = parse(Int, m.captures[1])
    a = 37222273957364
    b, c = 0, 0

    ip = 1

    program = parse.(Int, eachsplit(m.captures[2], ','))

    function eval_combo(i)
        x = program[i]
        if 0 <= x <= 3
            x
        elseif x == 4
            a
        elseif x == 5
            b
        elseif x == 6
            c
        else
            error("!!!")
        end
    end

    out_buf = Int[]

    while ip <= length(program)
        opcode = program[ip]

        if opcode == 0
            d = eval_combo(ip + 1)
            a >>= d
            ip += 2
        elseif opcode == 1
            b ⊻= program[ip+1]
            ip += 2
        elseif opcode == 2
            x = eval_combo(ip + 1)
            b = x % 8
            ip += 2
        elseif opcode == 3
            if a != 0
                ip = program[ip+1] + 1
            else
                ip += 2
            end
        elseif opcode == 4
            b ⊻= c
            ip += 2
        elseif opcode == 5
            push!(out_buf, eval_combo(ip + 1) % 8)
            ip += 2
        elseif opcode == 6
            d = eval_combo(ip + 1)
            b = a >> d
            ip += 2
        elseif opcode == 7
            d = eval_combo(ip + 1)
            c = a >> d
            ip += 2
        end
    end

    join(out_buf, ",")
end

function eval_combo(i, a, b, c, program)
    x = program[i]
    if 0 <= x <= 3
        x
    elseif x == 4
        a
    elseif x == 5
        b
    elseif x == 6
        c
    else
        0
    end
end

function checka(a, program)
    out_n = 1

    b, c = 0, 0
    ip = 1

    while ip <= length(program)
        opcode = program[ip]

        if opcode == 0
            d = eval_combo(ip + 1, a, b, c, program)
            a >>= d
            ip += 2
        elseif opcode == 1
            b ⊻= program[ip+1]
            ip += 2
        elseif opcode == 2
            x = eval_combo(ip + 1, a, b, c, program)
            b = x % 8
            ip += 2
        elseif opcode == 3
            if a != 0
                ip = program[ip+1] + 1
            else
                ip += 2
            end
        elseif opcode == 4
            b ⊻= c
            ip += 2
        elseif opcode == 5
            if out_n > length(program)
                return out_n
            end
            if eval_combo(ip + 1, a, b, c, program) % 8 == program[out_n]
                out_n += 1
            else
                return out_n
            end
            ip += 2
        elseif opcode == 6
            d = eval_combo(ip + 1, a, b, c, program)
            b = a >> d
            ip += 2
        elseif opcode == 7
            d = eval_combo(ip + 1, a, b, c, program)
            c = a >> d
            ip += 2
        end
    end

    out_n
end

function part2()
    reg = r"""Register A: (\d+)
Register B: 0
Register C: 0

Program: (.+)"""

    inp = read("$(homedir())/aoc-input/2024/day17/input", String)

    m = match(reg, inp)
    program = parse.(Int, eachsplit(m.captures[2], ','))

    # s = 0

    # for a in 0:2^3 - 1

    # end

    # s

    # working
    # 37222273957364
    # 37222278740468
    # 37222278740468
    # 37222278756852

    # as = [4, 6, 7, 4, 7, 7, 4, 5]
    as = (4, 6, 7, 6, 3, 5, 2, 3)
    # as = (4, 6, 7, 4, 3, 7, 4, 5)

    # a0 = 4
    # a1 = 6
    # a2 = 7
    # a3 = 4
    # a4 = 3 # eller 7
    # a5 = 7
    # a6 = 4
    # a7 = 5

    # a3 = 6 # eller 4
    # a4 = 3
    # a5 = 5

    # for a in 0:2^25
    #     ax = a
    #     for x in reverse(as)
    #         ax = (ax << 3) | x
    #     end
    #     if checka(ax, program) >= 17
    #         # @show a % 8
    #         @show a
    #     end
    # end

    # a = (4437240 << 23) | a0 | (a1 << 3) | (a2 << 6) | (a3 << 9) | (a4 << 12) |
    #     (a5 << 15) | (a6 << 18) | (a7 << 21)

    ax = 2218620
    for x in reverse(as)
        ax = (ax << 3) | x
    end
    ax
end
