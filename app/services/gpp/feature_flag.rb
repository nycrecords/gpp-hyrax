# frozen_string_literal: true
module Gpp
  # Resolves flags without the cookie strategy, which any client can set
  module FeatureFlag
    def self.enabled?(key)
      feature_set = Flipflop::FeatureSet.current
      feature_set.strategies.each do |strategy|
        next if strategy.is_a?(Flipflop::Strategies::CookieStrategy)
        value = strategy.enabled?(key)
        return value unless value.nil?
      end
      feature_set.feature(key).default
    end
  end
end