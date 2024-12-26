
function part1()
    inp = read("$(homedir())/aoc-input/2024/day25/input", String)

    data = falses(0)

    n = 0
    w = 0
    h = 0

    for block in eachsplit(inp, "\n\n")
        h_loc = 0
        for l in eachsplit(block, "\n")
            if !isempty(l)
                w = length(l)
                h_loc += 1
                append!(data, (x == '#' for x in l))
            end
        end

        h = h_loc

        n += 1

    end

    data = reshape(data, w, h, n)

    # display(data)

    locks = Int[]
    keys = Int[]

    for (i, mat) in enumerate(eachslice(data, dims=3))
        if mat[1, 1]
            push!(locks, i)
        elseif mat[end, end]
            push!(keys, i)
        end
    end

    c = 0

    for i in locks, j in keys
        if !any(data[:, :, i] .& data[:, :, j])
            c += 1
        end
    end

    c
end
