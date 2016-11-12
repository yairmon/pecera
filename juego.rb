#!/usr/bin/env ruby
require 'rubygems' rescue nil
$LOAD_PATH.unshift File.join(File.expand_path(__FILE__), "..", "..", "lib")
require 'chingu'
include Gosu
include Chingu

require_relative "logica/motor"
require_relative "objetos/fondo"
require_relative "objetos/menu"

#
# Juego:
# Ventana que aparece en la pantalla
#

class Juego < Chingu::Window
  #
  # Constructor:
  # Inicializa la ventana con el tamaño y acciones del teclado
  #
  def initialize
    super(800,800)
    self.caption = "Proyecto Vida Artificial" # Titulo de la ventana
    self.input = {:esc => :exit, [:q, :enter, :space] => method(:cambiar_estado)} # Al presionar esc, se cierra la ventana

    push_game_state(Fondo)
    push_game_state(Motor)
    push_game_state(Menu)
  end #def

  #
  # Cambiar_Estado:
  # Para intercambiar entre el menú y la pecera
  #
  def cambiar_estado
    if current_game_state.class == Motor
      switch_game_state(Menu)
    else
      switch_game_state(Motor)
    end # if
  end # def

  #
  # Override
  # Dice si se debe mostrar el cursor en la pantalla
  #
  def needs_cursor?
    return true
  end #def


end #class
