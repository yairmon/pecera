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
  traits :collision_detection, :bounding_circle, :velocity
  #
  # Constructor:
  # Inicializar todos los componentes y valores iniciales
  #
  def initialize
    super
    @image = Image["tiburon1.png"]
    # Hacer que el tiburon se mueva
    @animation = Chingu::Animation.new(:file => "tiburoncompleto_180x73.bmp")
    @animation.frame_names = { :izquierda => 0...2, :derecha => 2...4, :izquierda_come => 4...6, :derecha_come => 6...8 }
    @frame_name = :izquierda

    @direccion = Direccion.new($window.width, $window.height, 10, @image.width, @image.height)
    @tiburon_hambriento = false
    @z = 1
    @vida = 5
    @vida_inicio = Time.now
    @libre = true # Es para saber si el tiburon se puede mover hacia otro pez
  end # def

  #
  # Rango:
  # Devuelve verdadero si se encuentra en el rango de la imagen
  #
  def rango?(x, y)
    izq = @x - (@image.width / 2)
    der = @x + (@image.width / 2)
    arriba = @y - (@image.height / 2)
    abajo = @y + (@image.height / 2)

    return x > izq && x < der && y > arriba && y < abajo
  end # def

  #
  # Mover:
  # Traza una ruta al azar en la ventana
  #
  def mover
    if !@libre && !self.rango?(@buscarx, @buscary)
      @direccion.buscar(@buscarx, @buscary)
    elsif @libre
      @direccion.mover
    else
      @libre = true
    end # if

    if @tiburon_hambriento
      @direccion.aumentar_velocidad
    end # if
    # @direccion.mover
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

    @image = @animation[@frame_name].next
    @frame_name = @direccion.izquierda? ? :izquierda : :derecha


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
    @libre = true

    @frame_name = @direccion.izquierda? ? :izquierda_come : :derecha_come
    @image = @animation[@frame_name].next
    @image = @animation[@frame_name].next
  end # def

  #
  # Buscar:
  #   Un tiburon puede ir a buscar un pez
  # int x: posicion x a ir a buscar
  # int y: posicion y a ir a buscar
  #
  def buscar(x, y)
    @buscarx = x
    @buscary = y
    @libre = false
    print "Tiburon en busca del pez\n" if $modo_debug
  end # def

  # _______________________________
  #        GETTERS & SETTERS
  # _______________________________
  def get_nombre; @nombre; end
  def get_genero; @genero; end
  def get_libre; @libre; end
  def get_x; @x; end
  def get_y; @y; end

end #class
