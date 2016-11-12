#!/usr/bin/env ruby
require 'rubygems' rescue nil
$LOAD_PATH.unshift File.join(File.expand_path(__FILE__), "..", "..", "lib")
require 'chingu'
include Gosu

#
# Comida:
# Es el objeto que aparece para que el pez se lo coma
#

class Comida < Chingu::GameObject
  traits :collision_detection, :bounding_circle
  #
  # Constructor:
  # Inicializar todos los componentes y valores iniciales
  #
  def initialize
    super
    @mode = :additive
    #print "Se crea un pez\n"
    @image = Image["comida2.png"]
    @x = rand($window.width)
    @y = rand($window.height)
    @z = 1
  end # def

  #
  # Override
  # Esta funcion se ejecuta en cada frame
  # Con color blanco (WHITE) queda la imagen original
  #
  def update
    @color = Color::WHITE
  end # def

  # _______________________________
  #        GETTERS & SETTERS
  # _______________________________
  def get_x; @x; end
  def get_y; @y; end

end #class
