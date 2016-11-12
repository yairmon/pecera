#!/usr/bin/env ruby
require 'rubygems' rescue nil
$LOAD_PATH.unshift File.join(File.expand_path(__FILE__), "..", "..", "lib")
require 'chingu'
include Gosu

require_relative "../logica/direccion"

#
# Tiburon:
# Es el objeto que se mueve dentro de la ventana libre y aleatoriamente
# En busca de peces que pueda comer
#

class Tiburon < Chingu::GameObject
  traits :collision_detection, :bounding_circle
  #
  # Constructor:
  # Inicializar todos los componentes y valores iniciales
  #
  def initialize
    super
    @mode = :additive
    @image = Image["tiburon1.png"]
    @direccion = Direccion.new($window.width, $window.height, 10, @image.width, @image.height)
    @tiburon_hambriento = false
    @z = 1
    @vida = 5
    @vida_inicio = Time.now
  end # def

  #
  # Mover:
  # Traza una ruta al azar en la ventana
  #
  def mover
    if @tiburon_hambriento
      @direccion.aumentar_velocidad
    end # if
    @direccion.mover
    @x = @direccion.get_x
    @y = @direccion.get_y
  end # def

  #
  # Definir Parametros:
  # Configura todas las opciones del tiburon
  # int vida_tiempo: Es el número de segundos que vive espera el pez sin comer
  # .. para aumentar su velocidad
  #
  def definir_parametros(vida_tiempo)
    @vida = vida_tiempo
  end #def

  #
  # Override
  # Esta funcion se ejecuta en cada frame
  #
  def update
    self.mover
    vivo = Time.now - @vida_inicio
    if vivo > @vida
      @tiburon_hambriento = true
    end # if
  end # def

  #
  # Comer Pez
  # Se llama cuando el tiburon se encuentra con un pez
  #
  def comer_pez(pez)
    @vida_inicio = Time.now
    @tiburon_hambriento = false
    @direccion.disminuir_velocidad
  end # def

  # _______________________________
  #        GETTERS & SETTERS
  # _______________________________
  def get_nombre; @nombre; end
  def get_genero; @genero; end
  def get_x; @x; end
  def get_y; @y; end

end #class
