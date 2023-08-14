require_relative '../services/bundle_calculator'
require_relative '../models/concerns/bundle_constants'

def parse_order(order)
  return_obj = {}
  order.each_slice(2) do |count, filetype|
    return_obj[filetype] = count.to_i
  end
  
  return_obj
end

def parse_output(output)
  return_text = ""

  output.each do |filetype, data|
    return_text += "#{data['count']} #{filetype} $#{data['total']}\n"
    data['bundles'].each do |bundle, quantity|
      return_text += "\t#{quantity} x #{bundle} $#{BundleConstants::PRICES[filetype][bundle.to_i]}\n"
    end
  end

  return_text
end

input_data = File.read("input.txt").split
input = parse_order(input_data)

calc = Tools::BundleCalculator.new(input)
output_data = calc.call

if calc.call
  File.write("output.txt", parse_output(output_data))
end

puts "Invalid input" if !calc.valid_input?
