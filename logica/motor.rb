#!/usr/bin/env ruby
require 'rubygems' rescue nil
$LOAD_PATH.unshift File.join(File.expand_path(__FILE__), "..", "..", "lib")
require 'chingu'
include Gosu
include Chingu

require_relative "../objetos/pez"

#
# Motor:
# Clase encargada de las colisiones entre los objetos
# Multiplicación, Eliminación...
#

class Motor < Chingu::GameState
  #
  # Constructor:
  # Inicializar los objetos en la pecera
  # Empezando con 6 peces
  #
  def setup
    if $configuracion != nil
      peces = $configuracion[0][1].to_i
      vida_tiempo = $configuracion[3][1].to_i
    else
      print "No hay configuracion establecida aun...\n"
      peces = 5
      vida_tiempo = 5
    end # if
    (peces/2).times { Pez.create.definir_parametros(1, vida_tiempo) }
    (peces/2).times { Pez.create.definir_parametros(2, vida_tiempo) }
    # Cuando es un numero impar de peces, se genera un pez con genero al azar
    Pez.create.definir_parametros(rand(2)+1, vida_tiempo) if peces % 2 != 0
  end # def

  #
  #  Override:
  #  Esta funcion se ejecuta en cada frame
  #
  def update
    super

    Pez.each_collision(Pez) do |pez1, pez2|
      pez1.colision_pez(pez2)
    end # each

    $window.caption = "FPS: #{$window.fps} - Objetos: #{current_game_state.game_objects.size} - Peces: #{Pez.size}"
  end # def

  #
  #  Override:
  #  Esta funcion se ejecuta cuando se abandona el estado actual
  #
  def finalize
      Pez.each do |pez|
        pez.destroy
      end
  end # def

end # class
