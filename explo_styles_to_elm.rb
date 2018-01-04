#!/usr/bin/env ruby

# explo_styles_to_elm.rb
# Author: Donald L. Merand
# Description: Converts explo_styles.json into an Elm module for dealing with styles.
# Usage:
#   (first export the file eg. `ruby explo_styles_to_elm.rb > lib/ExploStyles.elm`)
#   Then, in your Elm files:
#
#   import ExploStyles exposing(xc, xs, xr)
#   xc "link" #=> "link x-orange x-hover-darkorange pointer"

require 'json'

data = JSON.parse(File.read('explo_styles.json'))

puts <<~HEAD
module ExploStyles exposing (xc, xs, xr)
import Dict exposing (fromList, get)

HEAD

def outputLists(data, type)
  puts "#{type}List = ["
  data[type].each_with_index do |datum, index|
    index == 0 ? pre = "" : pre = ", "
    puts %{    #{pre}("#{datum[0]}", "#{datum[1]}")}
  end
  puts <<~CONVERSION
        ]
    #{type} = Dict.fromList #{type}List
  CONVERSION
end

outputLists data, "classes"
puts
outputLists data, "styles"

puts <<~FUNCTIONS

  {-| Get the eXplo Class string matching the passed key. 

      xc "link" == "link x-orange x-hover-darkorange pointer"
  -}
  xc : String -> String
  xc key =
      case Dict.get key classes of
          Just value -> value
          Nothing -> ""

  {-| Get the eXplo Style string matching the passed key.

      xs "opaque" == "opacity: .5;"
  -}
  xs : String -> String
  xs key =
      case Dict.get key styles of
          Just value -> value
          Nothing -> ""

  {-| Replace any instance of 'from' with 'to' in a given 'str'. 

      xr "wat" "are" "wat are this " == "are are this"
  -}
  xr : String -> String -> String -> String
  xr from to str =
      String.split from str
          |> String.join to
FUNCTIONS