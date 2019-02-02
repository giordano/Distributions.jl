"""
    LocationScale(μ,σ,ρ)

A location-scale transformed distribution with location parameter `μ`,
scale parameter `σ`, and given distribution `ρ`.

```math
f(x) = \\frac{1}{σ} ρ \\! \\left( \\frac{x-μ}{σ} \\right)
```

```julia
LocationScale(μ,σ,ρ) # location-scale transformed distribution
params(d)            # Get the parameters, i.e. (μ, σ, and the base distribution)
location(d)          # Get the location parameter
scale(d)             # Get the scale parameter
```

External links
[Location-Scale family on Wikipedia](https://en.wikipedia.org/wiki/Location%E2%80%93scale_family)
"""
struct LocationScale{T<:Real, D<:ContinuousUnivariateDistribution} <: ContinuousUnivariateDistribution
    μ::T
    σ::T
    ρ::D

    LocationScale{T,D}(μ::T,σ::T,ρ::D) where {T, D} = (@check_args(LocationScale, σ > zero(σ)); new{T,D}(μ,σ,ρ))
end

LocationScale(μ::T,σ::T,ρ::D) where {T<:Real, D<:ContinuousUnivariateDistribution} = LocationScale{T,D}(μ,σ,ρ)
LocationScale(μ::T,σ::T,ρ::D) where {T<:Integer, D<:ContinuousUnivariateDistribution} = LocationScale{Float64,D}(Float64(μ),Float64(σ),ρ)

minimum(d::LocationScale) = d.μ + d.σ * minimum(d.ρ)
maximum(d::LocationScale) = d.μ + d.σ * maximum(d.ρ)

#### Conversions

convert(::Type{LocationScale{T}}, μ::Real, σ::Real, ρ::D) where {T<:Real, D<:ContinuousUnivariateDistribution} = LocationScale(T(μ),T(σ),ρ)
convert(::Type{LocationScale{T}}, d::LocationScale{S}) where {T<:Real, S<:Real} = LocationScale(T(d.μ),T(d.σ),d.ρ)

#### Parameters

location(d::LocationScale) = d.μ
scale(d::LocationScale) = d.σ
params(d::LocationScale) = (d.μ,d.σ,d.ρ)
@inline partype(d::LocationScale{T}) where {T<:Real} = T

#### Statistics

mean(d::LocationScale) = d.μ + d.σ * mean(d.ρ)
median(d::LocationScale) = d.μ + d.σ * median(d.ρ)
mode(d::LocationScale) = d.μ + d.σ * mode(d.ρ)
modes(d::LocationScale) = d.μ .+ d.σ .* modes(d.ρ)

var(d::LocationScale) = d.σ^2 * var(d.ρ)
std(d::LocationScale) = d.σ * std(d.ρ)
skewness(d::LocationScale) = skewness(d.ρ)
kurtosis(d::LocationScale) = kurtosis(d.ρ)

isplatykurtic(d::LocationScale) = isplatykurtic(d.ρ)
isleptokurtic(d::LocationScale) = isleptokurtic(d.ρ)
ismesokurtic(d::LocationScale) = ismesokurtic(d.ρ)

entropy(d::LocationScale) = entropy(d.ρ) + log(d.σ)
mgf(d::LocationScale,t::Real) = exp(d.μ*t) * mgf(d.ρ,d.σ*t)

#### Evaluation & Sampling

pdf(d::LocationScale,x::Real) = pdf(d.ρ,(x-d.μ)/d.σ) / d.σ
logpdf(d::LocationScale,x::Real) = logpdf(d.ρ,(x-d.μ)/d.σ) - log(d.σ)
cdf(d::LocationScale,x::Real) = cdf(d.ρ,(x-d.μ)/d.σ)
logcdf(d::LocationScale,x::Real) = logcdf(d.ρ,(x-d.μ)/d.σ)
quantile(d::LocationScale,q::Real) = d.μ + d.σ * quantile(d.ρ,q)

rand(d::LocationScale) = d.μ + d.σ * rand(d.ρ)
cf(d::LocationScale, t::Real) = cf(d.ρ,t*d.σ) * exp(1im*t*d.μ)
gradlogpdf(d::LocationScale, x::Real) = gradlogpdf(d.ρ,(x-d.μ)/d.σ) / d.σ