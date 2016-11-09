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
    # self.input = { :pad_button_1 => :tecla }
    @spinner = ["|", "/", "-", "\\", "|", "/", "-", "\\"]
    @spinner_index = 0.0
    @posicion = 0
    @texto0 = "-> Peces: "
    @texto1 = "Tiburones: "
    @texto2 = "Reproduccion cada: "
    @cantidad0 = "0"
    @cantidad1 = "0"
    @cantidad2 = "0"
    # @font = Chingu::Text.new("82x64 image with repeat_x and repeat_y set to TRUE", :x => 0, :y => @cantidad, :z => 1, :size => 30, :color => Color::RED)
    # @font = Font.new($window, default_font_name(), 20)
    # @rectangulo = Chingu::Rect[:x => 0, :y => 0, :z => 1, :width => 100, :height => 200, :color => Color::GREEN]

    @font = Font.new($window, default_font_name(), 50)

    $window.caption = "Pecera - Proyecto Vida Artificial"
  end  #def

  #
  #  Override:
  #  Esta funcion se ejecuta cada vez que se pulsa una tecla
  #
  def button_down(id)
    if id == Button::KbDown
      @posicion += 1
      if @posicion > 2
        @posicion = 0
      end # if
      print "Se ha presionado la tecla: Abajo\n"
    elsif id == Button::KbUp
      @posicion -= 1
      if @posicion < 0
        @posicion = 2
      end # if
      print "Se ha presionado la tecla: Arriba\n"
    elsif id == Button::KbRight
      if @posicion == 0; @cantidad0 = (@cantidad0.to_i + 1).to_s;
      elsif @posicion == 1; @cantidad1 = (@cantidad1.to_i+1).to_s
      elsif @posicion == 2; @cantidad2 = (@cantidad2.to_i+1).to_s
      end # if
      print "Se ha presionado la tecla: Derecha\n"
    elsif id == Button::KbLeft
      if @posicion == 0 && @cantidad0 != "0"; @cantidad0 = (@cantidad0.to_i-1).to_s
      elsif @posicion == 1 && @cantidad1 != "0"; @cantidad1 = (@cantidad1.to_i-1).to_s
      elsif @posicion == 2 && @cantidad2 != "0"; @cantidad2 = (@cantidad2.to_i-1).to_s
      end # if
      print "Se ha presionado la tecla: Izquierda\n"
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
      print "cantidad0 = #{@cantidad0.length},cantidad1 = #{@cantidad1.length},cantidad2 = #{@cantidad2.length}\n"
      if @posicion == 0
        if @cantidad0.length > 1
          @cantidad0 = @cantidad0.chop
        else
          @cantidad0 = "0"
        end # if
      elsif @posicion == 1
        if @cantidad1.length > 1
          @cantidad1 = @cantidad1.chop
        else
          @cantidad1 = "0"
        end # if
      elsif @posicion == 2
        if @cantidad2.length > 1
          @cantidad2 = @cantidad2.chop
        else
          @cantidad2 = "0"
        end # if
      end # if
      print "Se ha presionado la tecla: Backspace\n"
    elsif id == 40 # Tecla Enter (No se reconoce el comando Button::KbEnter)
      print "Se ha presionado la tecla: Enter\n"
    # else
    #   print "Se ha presionado la tecla: " + id.to_s + "\n"

    end # if

    #
    # Agregar Numero:
    # Esta funcion se usa para añadir un numero en la cadena
    # str num: Es el numero que se agrega al final
    #
    def agregar_numero(num)
      if @posicion == 0; @cantidad0 = ((@cantidad0 + num).to_i).to_s
      elsif @posicion == 1; @cantidad1 = @cantidad1 + num
      elsif @posicion == 2; @cantidad2 = @cantidad2 + num
      end # if
    end # def

    # Dependiendo de la posicion colocar la guia
    if @posicion == 0
      @texto0 = "-> Peces: "
      @texto1 = "Tiburones: "
      @texto2 = "Reproduccion cada: "
    elsif @posicion == 1
      @texto0 = "Peces: "
      @texto1 = "-> Tiburones: "
      @texto2 = "Reproduccion cada: "
    elsif @posicion == 2
      @texto0 = "Peces: "
      @texto1 = "Tiburones: "
      @texto2 = "-> Reproduccion cada: "
    end # if

  end # def

  #
  #  Override:
  #  Esta funcion dibuja en el plano
  #
  def draw
    super
    @font.draw(@texto0 + @cantidad0.to_s, 100, 100, 0)
    @font.draw(@texto1 + @cantidad1.to_s, 100, 200, 0)
    @font.draw(@texto2 + @cantidad2.to_s + " seg", 100, 300, 0)
  end # def

  #
  #  Override:
  #  Esta funcion se ejecuta cuando se abandona el estado actual
  #
  def finalize
    print "Se sale de menu...\n"
  end # def

end #class
