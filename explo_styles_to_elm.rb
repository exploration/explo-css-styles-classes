#!/usr/bin/env ruby

# explo_styles_to_elm.rb
# Author: Donald L. Merand
# Description: Converts explo_styles.json into an Elm module for dealing with styles.
# Usage:
#   (first export the file eg. `explo_styles_to_elm.rb > lib/ExploStyles.elm`)
#   Then, in your Elm files:
#
#   import ExploStyles exposing(xc, xs)
#   xc "link" #=> "link x-orange x-hover-darkorange pointer"

require 'json'

data = JSON.parse(File.read('explo_styles.json'))

puts "module ExploStyles exposing (xc, xs)"
puts "import Dict exposing (fromList, get)"
puts

def outputLists(data, type)
  puts "#{type}List = ["
  data[type].each_with_index do |datum, index|
    index == 0 ? pre = "" : pre = ", "
    puts "    #{pre}(\"#{datum[0]}\", \"#{datum[1]}\")"
  end
  puts "    ]"
  puts "#{type} = Dict.fromList #{type}List"
end

outputLists data, "classes"
puts
outputLists data, "styles"

puts """
xc : String -> String
xc key =
    case Dict.get key classes of
        Just value -> value
        Nothing -> \"\"

xs : String -> String
xs key =
    case Dict.get key styles of
        Just value -> value
        Nothing -> \"\"
"""