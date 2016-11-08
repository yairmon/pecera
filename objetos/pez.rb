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
  traits :collision_detection, :bounding_circle
  #
  # Constructor:
  # Inicializar todos los componentes y valores iniciales del pez
  #
  def initialize
    super
    @mode = :additive
    #print "Se crea un pez\n"
    @direccion = Direccion.new
    @image = Image["pez2.png"]
    @z = 1
    @nombre = rand.to_s
    @ultimo = self
    @genero = 1

  end #def

  #
  # Mover:
  # Traza una ruta al azar en la ventana
  #
  def mover
    @direccion.mover
    @x = @direccion.get_x
    @y = @direccion.get_y
    #print "corrds (" + @direccion.get_x.to_s + "," + @direccion.get_y.to_s + ")\n"
  end #def

  #
  # Definir_Genero:
  # Configura el genero del pez
  #
  def definir_genero(genero)
    @genero = genero
  end #def

  #
  # Get_Nombre:
  # Devuelve el nombre aleatorio del pez
  #
  def get_nombre
    return @nombre
  end #def

  #
  # Override
  # Esta funcion se ejecuta en cada frame
  # Con color blanco (WHITE) queda la imagen original
  #
  def update
    self.mover
    if @genero == 1
      @color = Color::FUCHSIA
    else
      @color = Color::GREEN
    end # if
    #sleep(1)
  end #def

  #
  # Colision_Pez
  # Se llama cuando el pez se encuentra con otro pez
  # El pez sólo colisiona con un pez diferente cada vez
  #
  def colision_pez(pez)
    if @ultimo != pez.get_nombre
      @ultimo = pez.get_nombre
      @color = Color::RED
      print rand(10).to_s + " Colision..." + @nombre + "\n"

    end # if
  end #def


end #class
