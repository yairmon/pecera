#!/usr/bin/env ruby
require 'rubygems' rescue nil
$LOAD_PATH.unshift File.join(File.expand_path(__FILE__), "..", "..", "lib")
require 'chingu'
include Gosu
include Chingu

require_relative "../objetos/pez"
require_relative "../objetos/comida"
require_relative "../objetos/tiburon"
require_relative "../objetos/burbuja"


#
# Motor:
# Clase encargada de las colisiones entre los objetos
# Multiplicación, Eliminación...
#

class Motor < Chingu::GameState
  traits :collision_detection, :bounding_circle
  #
  # Constructor:
  # Inicializar los objetos en la pecera
  # Empezando con 6 peces
  #
  def setup
    @parallax = Chingu::Parallax.create(:x => 0, :y => 0, :z => -1, :rotation_center => :top_left)
    @parallax << { :image => "fondo.bmp", :repeat_x => true, :repeat_y => true}
    # @image = Image["fondo.png"]
    # @x = 0
    # @y = 0
    # @z = 0
    @comida_inicio = Time.now
    if $configuracion != nil
      peces = $configuracion[0][1].to_i
      tiburones = $configuracion[1][1].to_i
      reproducir_veces = $configuracion[2][1].to_i
      pez_vida_tiempo = $configuracion[3][1].to_i
      tiburon_vida_tiempo = $configuracion[4][1].to_i
      @comida_tasa = $configuracion[5][1].to_i
      pez_reproducir_tiempo = $configuracion[6][1].to_i
    else
      # print "No hay configuracion establecida aun...\n"
      peces = 5
      tiburones = 1
      reproducir_veces = 5
      pez_vida_tiempo = 5
      tiburon_vida_tiempo = 5
      @comida_tasa = 1
      pez_reproducir_tiempo = 2
    end # if
    (peces/2).times { Pez.create.definir_parametros(1, pez_vida_tiempo, reproducir_veces, pez_reproducir_tiempo) }
    (peces/2).times { Pez.create.definir_parametros(2, pez_vida_tiempo, reproducir_veces, pez_reproducir_tiempo) }
    tiburones.times { Tiburon.create.definir_parametros(tiburon_vida_tiempo) }

    # Cuando es un numero impar de peces, se genera un pez con genero al azar
    Pez.create.definir_parametros(rand(2)+1, pez_vida_tiempo, reproducir_veces, pez_reproducir_tiempo) if peces % 2 != 0

    @tiempo_burbuja = Time.now

  end # def

  #
  #  Override:
  #  Esta funcion se ejecuta en cada frame
  #
  def update
    super

    # Cuando un pez encuentra comida
    Pez.each_collision(Comida) do |pez, comida|
      pez.comer
      comida.destroy
    end # each

    #Cuando se generan las burbujas
    if (Time.now - @tiempo_burbuja) > 1
      Burbuja.create
      @tiempo_burbuja = Time.now
    end # if





    # Cuando ha pasado el tiempo necesario, se genera comida
    if (Time.now - @comida_inicio) > @comida_tasa
      Comida.create
      @comida_inicio = Time.now
    end # if

    # Cuando un pez encuentra otro pez
    Pez.each_collision(Pez) do |pez1, pez2|
      # print rand(10).to_s + "Colision: pez1.rep=#{pez1.puede_reproducir?}, pez2.rep=#{pez1.puede_reproducir?}\n"
      if pez1.puede_reproducir? && pez2.puede_reproducir? && pez1.get_genero != pez2.get_genero
        pez1.reproducirse
        pez2.reproducirse
        reproducir_veces = $configuracion[2][1].to_i
        pez_vida_tiempo = $configuracion[3][1].to_i
        pez_reproducir_tiempo = $configuracion[6][1].to_i
        Pez.create.definir_parametros2(pez1.get_x, pez2.get_y, rand(2)+1, pez_vida_tiempo, reproducir_veces, pez_reproducir_tiempo)
      end # if
    end # each

    # Cuando un tiburon encuentra con un pez
    Tiburon.each_collision(Pez) do |tiburon, pez|
      tiburon.comer_pez(pez)
      pez.destroy
    end # each

    # Los peces buscan particulas de comida y pareja al azar
    Pez.each do |pez|
      if pez.get_libre
        # 50 % de probabilidad de ir a buscar comida o buscar pareja
        pareja = rand(2)

        contador = 0
        if pareja == 1
          # los peces macho son la segunda mitad, por lo tanto si el pez
          # ... es hembra debe buscar solo los peces de la segunda mitad
          tam_pez = Pez.size / 2
          sumar = pez.get_genero == 1 ? tam_pez : 0
          elegido = rand(tam_pez) + sumar
          Pez.each do |pez2|
            if contador == elegido
              pez.buscar(pez2.get_x, pez2.get_y)
            end # if
            contador += 1
          end # each
        else
          elegido = rand(Comida.size)
          Comida.each do |comida|
            if contador == elegido
              pez.buscar(comida.get_x, comida.get_y)
            end # if
            contador += 1
          end # each
        end #if
      end # if

      # El pez tiende a evitar un tiburon al azar
      contador = 0
      elegido = rand(Tiburon.size)
      Tiburon.each do |tiburon|
        if contador == elegido
          pez.evitar(tiburon.get_x, tiburon.get_y)
        end # if
        contador += 1
      end # each
    end # each

    # Los tiburones buscan peces al azar
    Tiburon.each do |tiburon|
      contador = 0
      if tiburon.get_libre
        elegido = rand(Pez.size)
        Pez.each do |pez|
          if contador == elegido
            tiburon.buscar(pez.get_x, pez.get_y)
          end # if
          contador += 1
        end # each
      end #if
    end # each

    $window.caption = "FPS: #{$window.fps} - Objetos: #{current_game_state.game_objects.size} - Peces: #{Pez.size} - Tiburones: #{Tiburon.size}"
  end # def

  #
  #  Override:
  #  Esta funcion se ejecuta cuando se abandona el estado actual
  #
  def finalize
      Pez.destroy_all
      Comida.destroy_all
      Tiburon.destroy_all
  end # def

end # class
