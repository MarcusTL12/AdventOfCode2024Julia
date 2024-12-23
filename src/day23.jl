
function part1()
    computers = Set{String}()

    connections = Dict{String,Vector{String}}()

    for l in eachline("$(homedir())/aoc-input/2024/day23/input")
        a, b = eachsplit(l, '-')

        push!(computers, a)
        push!(computers, b)

        if !haskey(connections, a)
            connections[a] = [b]
        else
            push!(connections[a], b)
        end

        if !haskey(connections, b)
            connections[b] = [a]
        else
            push!(connections[b], a)
        end
    end

    triplets = Set{Vector{String}}()

    for c in computers
        if startswith(c, "t")
            for a in connections[c]
                for b in connections[a]
                    if b != c && b ∈ connections[c]
                        push!(triplets, sort!([a, b, c]))
                    end
                end
            end
        end
    end

    length(triplets)
end

function part2()
    computers = Set{String}()

    connections = Dict{String,Set{String}}()

    for l in eachline("$(homedir())/aoc-input/2024/day23/input")
        a, b = eachsplit(l, '-')

        push!(computers, a)
        push!(computers, b)

        if !haskey(connections, a)
            connections[a] = Set([b])
        else
            push!(connections[a], b)
        end

        if !haskey(connections, b)
            connections[b] = Set([a])
        else
            push!(connections[b], a)
        end
    end

    # groups = Set{Vector{String}}()
    # queue = [[c] for c in computers]

    # while !isempty(queue)
    #     cur_group = popfirst!(queue)

    #     for c in cur_group
    #         for a in connections[c]
    #             if a ∉ cur_group && cur_group ⊆ connections[a]
    #                 new_group = [cur_group; a]
    #                 sort!(new_group)

    #                 if new_group ∉ groups
    #                     push!(groups, new_group)
    #                     push!(queue, new_group)
    #                 end
    #             end
    #         end
    #     end
    # end

    # max_group = String[]

    # for g in groups
    #     if length(g) > length(max_group)
    #         max_group = g
    #     end
    # end

    # join(max_group, ",")

    join(sort!(collect(bron_kerbosh(connections,
            Set{String}(), computers, Set{String}()))), ',')
end

function bron_kerbosh(connections, R, P, X)
    if isempty(P) && isempty(X)
        return R
    end

    max_clique = Set{eltype(R)}()

    for v in P
        sv = Set([v])

        c = bron_kerbosh(connections,
            R ∪ sv, P ∩ connections[v], X ∩ connections[v])

        P = setdiff(P, sv)
        X = X ∪ sv

        if length(c) > length(max_clique)
            max_clique = c
        end
    end

    max_clique
end
