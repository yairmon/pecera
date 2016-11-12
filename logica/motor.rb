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
      reproducir_veces = $configuracion[2][1].to_i
      vida_tiempo = $configuracion[3][1].to_i
    else
      # print "No hay configuracion establecida aun...\n"
      peces = 5
      reproducir_veces = 5
      vida_tiempo = 5
    end # if
    (peces/2).times { Pez.create.definir_parametros(1, vida_tiempo, reproducir_veces) }
    (peces/2).times { Pez.create.definir_parametros(2, vida_tiempo, reproducir_veces) }
    # Cuando es un numero impar de peces, se genera un pez con genero al azar
    Pez.create.definir_parametros(rand(2)+1, vida_tiempo, reproducir_veces) if peces % 2 != 0
  end # def

  #
  #  Override:
  #  Esta funcion se ejecuta en cada frame
  #
  def update
    super

    Pez.each_collision(Pez) do |pez1, pez2|
      # print rand(10).to_s + "Colision: pez1.rep=#{pez1.puede_reproducir?}, pez2.rep=#{pez1.puede_reproducir?}\n"
      if pez1.puede_reproducir? && pez2.puede_reproducir? && pez1.get_genero != pez2.get_genero
        pez1.reproducirse
        pez2.reproducirse
        reproducir_veces = $configuracion[2][1].to_i
        vida_tiempo = $configuracion[3][1].to_i
        Pez.create.definir_parametros2(pez1.get_x, pez2.get_y, rand(2)+1, vida_tiempo, reproducir_veces)
      end # if
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
