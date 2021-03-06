@testset "Core Functions" begin
    # 6 data samples with 2 variables belonging to 2 classes
    X = [-1.0 -2.0 -3.0 1.0 2.0 3.0;
         -1.0  -1.0 -2.0 1.0 1.0 2.0]
    y = [1, 1, 1, 2, 2, 2]

    @testset "Multinomial NB" begin
        m = MultinomialNB([:a, :b, :c], 5)
        X1 = [1 2 5 2;
             5 3 -2 1;
             0 2 1 11;
             6 -1 3 3;
             5 7 7 1]
        y1 = [:a, :b, :a, :c]
        fit(m, X1, y1)
        @test predict(m, X1) == y1
    end

    @testset "Gaussian NB" begin
        m = GaussianNB(unique(y), 2)
        fit(m, X, y)
        @test predict(m, X) == y
    end

    @testset "Hybrid NB" begin

        # a test to check that HybridNB successfully replaces KernelNB
        m1 = HybridNB(y, 2)
        fit(m1, X, y)
        @test predict(m1, X) == y

        N1 = 100000
        N2 = 160000
        Np = 1000

        srand(0)

        perm = randperm(N1+N2)
        labels = [ones(Int, N1); zeros(Int, N2)][perm]
        f_c1 = [0.35randn(N1); 3.0 + 0.2randn(N2)][perm]
        f_c2 = [-4.0 + 0.35randn(N1); -3.0 + 0.2randn(N2)][perm]
        f_d = [rand(1:10, N1); rand(12:25, N2)][perm]

        training_c = Vector{Vector{Float64}}()
        predict_c = Vector{Vector{Float64}}()
        push!(training_c, f_c1[1:end-Np], f_c2[1:end-Np])
        push!(predict_c, f_c1[end-Np:end], f_c2[end-Np:end])

        training_d = Vector{Vector{Int}}()
        predict_d = Vector{Vector{Int}}()
        push!(training_d, f_d[1:end-Np])
        push!(predict_d, f_d[end-Np:end])

        model = HybridNB(labels[1:end-Np], length(training_c), length(training_d))
        fit(model, training_c, training_d, labels[1:end-Np])
        y_h = predict(model, predict_c, predict_d)
        @test all(y_h .== labels[end-Np:end])

    end

    @testset "restructure features" begin
        M = rand(3,4)
        V = restructure_matrix(M)
        Mp = to_matrix(V)
        @test all(M .== Mp)
    end
end
