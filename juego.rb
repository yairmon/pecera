#!/usr/bin/env ruby
require 'rubygems' rescue nil
$LOAD_PATH.unshift File.join(File.expand_path(__FILE__), "..", "..", "lib")
require 'chingu'
include Gosu
include Chingu

require_relative "logica/motor"
require_relative "objetos/fondo"

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
    self.input = {:esc => :exit} # Al presionar esc, se cierra la ventana

    switch_game_state(Fondo)
    push_game_state(Motor)
    # Pez.create
    # Pez.create
    # Pez.create
    # Pez.create
    # Pez.create
    # Pez.create
    # Pez.create
    # Pez.create
  end #def


  #
  # Override
  # Dice si se debe mostrar el cursor en la pantalla
  #
  def needs_cursor?
    return true
  end #def


end #class
