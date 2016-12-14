#!/usr/bin/env ruby
require 'rubygems' rescue nil
$LOAD_PATH.unshift File.join(File.expand_path(__FILE__), "..", "..", "lib")
require 'chingu'
include Gosu

#
# Burbuja:
# Es el objeto que imita el comportamiento de las burbujas
#

class Burbuja < Chingu::GameObject
  traits :collision_detection, :bounding_circle
  #
  # Constructor:
  # Inicializar todos los componentes y valores iniciales
  #
  def initialize
    super
    @mode = :additive
    #print "Se crea una burbuja"
    @image = Image["burbuja2.png"]
    @x = rand($window.width)
    @y = rand(50) + $window.height - 50
    @z = 1
  end # def

  #
  # Override
  # Esta funcion se ejecuta en cada frame
  # Con color blanco (WHITE) queda la imagen original
  #
  def update
    # @color = Color::WHITE
    @y -= 1
    if @y < 0
      self.destroy
    end # if
  end # def

  # _______________________________
  #        GETTERS & SETTERS
  # _______________________________
  def get_x; @x; end
  def get_y; @y; end

end #class
