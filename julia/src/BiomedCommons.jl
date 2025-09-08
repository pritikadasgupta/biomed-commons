#!/usr/bin/env julia
# File: julia/src/BiomedCommons.jl
# Author: Rose (Pritika) Dasgupta
# Description: Julia test skeleton
#
# Style:

module BiomedCommons

export clean_colnames, tabulate_oneway, tabulate_by_group

clean_colnames(names::Vector{AbstractString}) = begin
    names = replace.(names, r"[ \-/\(\)>\:\=\;\,]|__|&|\[|\]|\.|\?|\"|#|\+|@|\*" => "_")
    names = replace.(names, r"_+" => "_")
    names = replace.(names, r"_$" => "")
    lowercase.(names)
end

# TODO: implement with DataFrames for parity
function tabulate_oneway(var::AbstractString, strata::AbstractString, df)
    throw(ErrorException("Not implemented yet"))
end

function tabulate_by_group(var::AbstractString, grp::AbstractString, df)
    throw(ErrorException("Not implemented yet"))
end

end # module
