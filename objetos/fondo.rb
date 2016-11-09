#!/usr/bin/env ruby
require 'rubygems' rescue nil
$LOAD_PATH.unshift File.join(File.expand_path(__FILE__), "..", "..", "lib")
require 'chingu'
include Gosu

#
# Fondo:
# Es el objeto que pinta en el fondo las figuras
#

class Fondo < Chingu::GameState
  def setup
    Chingu::Text.create("82x64 image with repeat_x and repeat_y set to TRUE", :x => 0, :y => 0, :size => 30, :color => Color::RED)
  end  #def
end #class
