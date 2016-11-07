#!/usr/bin/env ruby
require 'rubygems' rescue nil
$LOAD_PATH.unshift File.join(File.expand_path(__FILE__), "..", "..", "lib")
require 'chingu'
include Gosu

require_relative "../logica/direccion"

#
# Pez:
# Es el objeto que se mueve dentro de la ventana libre y aleatoriamente
#

class Pez < Chingu::GameObject
  #
  # Constructor:
  # Inicializar todos los componentes y valores iniciales del pez
  #
  def initialize
    super
    print "Se crea un pez\n"
    @direccion = Direccion.new
    @image = Image["pez2.png"]
    @z = 1
  end #def

  #
  # Mover:
  # Traza una ruta al azar en la ventana
  #
  def mover
    @direccion.mover
    @x = @direccion.get_x
    @y = @direccion.get_y
    print "corrds (" + @direccion.get_x.to_s + "," + @direccion.get_y.to_s + ")\n"
  end #def

  #
  # Override
  # Esta funcion se ejecuta en cada frame
  #
  def update
    self.mover
    #sleep(1)
  end #def


end #class
