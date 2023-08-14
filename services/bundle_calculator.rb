require_relative '../models/concerns/bundle_constants'

module Tools
  class BundleCalculator
    include BundleConstants

    def initialize(input)
      @input = input
    end
    
    def call
      output_hash = {}

      @input.each do |filetype, count|
        remaining = count
        output_hash[filetype] = {}

        bundles = BundleConstants::PRICES[filetype].keys.map(&:to_i).sort.reverse
        next if bundles.nil?

        bundles.each do |bundle|
          count = remaining / bundle

          if count.nonzero?
            output_hash[filetype][bundle] = remaining / bundle
            remaining = remaining - (bundle * count)
          end
        end
      end

      parse_output output_hash
    end

    def valid_input?
      @input.all?{ |k,v| BundleConstants::PRICES.keys.include? k.to_s }
    end

    def parse_output(output)
      return_obj = {}

      output.each do |filetype, bundles|
        return_obj[filetype] = {}
        total = 0

        bundles.each do |bundle, quantity|
          total += (BundleConstants::PRICES[filetype][bundle.to_i] * quantity)
        end
        
        return_obj[filetype]["bundles"] = bundles
        return_obj[filetype]["count"] = @input[filetype]
        return_obj[filetype]["total"] = total
      end

      return_obj
    end
  end
end