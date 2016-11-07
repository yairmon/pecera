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
    @parallax = Chingu::Parallax.create(:x => 150, :y => 150, :rotation_center => :top_left)
    @parallax << { :image => "wood.png", :repeat_x => true, :repeat_y => true}
  end  #def
end #class
