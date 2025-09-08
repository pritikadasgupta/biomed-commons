#!/usr/bin/env julia
# File: julia/test/runtests.jl
# Author: Rose (Pritika) Dasgupta
# Description: Julia test skeleton
#
# Style:

using Test
using BiomedCommons

@testset "BiomedCommons basics" begin
    @test clean_colnames(["A b", "C/D", "end_"]) == ["a_b","c_d","end"]
end
