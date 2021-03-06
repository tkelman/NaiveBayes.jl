
module NaiveBayes

using Distributions
using KernelDensity
using Grid
using StatsBase

export NBModel,
        MultinomialNB,
        GaussianNB,
        KernelNB,
        HybridNB,
        fit,
        predict,
        predict_proba,
        predict_logprobs,
        restructure_matrix,
        to_matrix

include("nbtypes.jl")
include("common.jl")
include("hybrid.jl")
include("gaussian.jl")
include("multinomial.jl")

end
