#!/usr/bin/env ruby
require 'rubygems' rescue nil
$LOAD_PATH.unshift File.join(File.expand_path(__FILE__), "..", "..", "lib")
require 'chingu'
include Gosu

#
# Menu:
# Es la parte principal donde se seleccionan las condiciones iniciales
# de la pecera
#

class Menu < Chingu::GameState
  #
  # Override:
  # Se activa cuando se selecciona el GameState
  #
  def setup
    @texto_menu = [["-> Peces: ", "5"],
                  [" Tiburones: ", "1"],
                  [" Peces se reproducen máximo (veces): ", "5"],
                  [" Peces viven (seg): ", "20"],
                  [" Tiburon hambriento (seg): ", "10"],
                  [" Tasa de comida (seg): ", "2"],
                  [" Peces se reproducen cada (seg): ", "1"]]

    # En caso de que se devuelva al menu, tener los valores previos configurados
    if $configuracion != nil
      (0...@texto_menu.size).each do |i|
        @texto_menu[i][1] = $configuracion[i][1]
      end # each
    else
      $configuracion = @texto_menu
    end # if

    @posicion = 0
    @font = Font.new($window, default_font_name(), 40)
    $window.caption = "Pecera - Proyecto Vida Artificial"
  end  #def

  #
  # Agregar Numero:
  # Esta funcion se usa para añadir un numero en la cadena
  # str num: Es el numero que se agrega al final
  #
  def agregar_numero(num)
    @texto_menu[@posicion][1] = ((@texto_menu[@posicion][1] + num).to_i).to_s
  end # def

  #
  #  Override:
  #  Esta funcion se ejecuta cada vez que se pulsa una tecla
  #
  def button_down(id)
    if id == Button::KbDown
      @posicion += 1
      if @posicion > @texto_menu.size - 1
        @posicion = 0
      end # if
    elsif id == Button::KbUp
      @posicion -= 1
      if @posicion < 0
        @posicion = @texto_menu.size - 1
      end # if
    elsif id == Button::KbRight
      @texto_menu[@posicion][1] = (@texto_menu[@posicion][1].to_i + 1).to_s
    elsif id == Button::KbLeft
      if @texto_menu[@posicion][1] != "0"
        @texto_menu[@posicion][1] = (@texto_menu[@posicion][1].to_i - 1).to_s
      end # if
    elsif id == Button::Kb0; agregar_numero("0")
    elsif id == Button::Kb1; agregar_numero("1")
    elsif id == Button::Kb2; agregar_numero("2")
    elsif id == Button::Kb3; agregar_numero("3")
    elsif id == Button::Kb4; agregar_numero("4")
    elsif id == Button::Kb5; agregar_numero("5")
    elsif id == Button::Kb6; agregar_numero("6")
    elsif id == Button::Kb7; agregar_numero("7")
    elsif id == Button::Kb8; agregar_numero("8")
    elsif id == Button::Kb9; agregar_numero("9")
    elsif id == Button::KbBackspace
      if @texto_menu[@posicion][1].length > 1
        @texto_menu[@posicion][1] = @texto_menu[@posicion][1].chop
      else
        @texto_menu[@posicion][1] = "0"
      end # if
    elsif id == 40 # Tecla Enter (No se reconoce el comando Button::KbEnter)
      switch_game_state(Motor)
    # else
    #   print "Se ha presionado la tecla: " + id.to_s + "\n"

    end # if

    # Dependiendo de la posicion colocar la guia
    (0...@texto_menu.size).each do |i|
      @texto_menu[i][0] = @texto_menu[i][0].delete '->'
    end # each
    @texto_menu[@posicion][0] = '->' + @texto_menu[@posicion][0]

    $configuracion = @texto_menu
  end # def
  def posicion
    "Esta es una posicion al azar"
  end
  #
  #  Override:
  #  Esta funcion dibuja en el plano
  #
  def draw
    super
    separacion = 100
    @texto_menu.each do |i|
      # mostrar = @texto_menu[i]['texto'].to_s + @texto_menu[i]['cantidad'].to_s
      @font.draw(i[0] + i[1], 100, separacion.to_i, 0)
      separacion += 70
    end # each
  end # def

  #
  #  Override:
  #  Esta funcion se ejecuta cuando se abandona el estado actual
  #
  def finalize
    print "Se sale de menu...\n" if $modo_debug
  end # def

end #class
