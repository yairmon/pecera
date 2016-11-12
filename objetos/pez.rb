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
    @vida = 5
    @vida_inicio = Time.now
    @vida_desviacion = rand(5)

  end #def

  #
  # Mover:
  # Traza una ruta al azar en la ventana
  #
  def mover
    @direccion.mover
    @x = @direccion.get_x
    @y = @direccion.get_y
    #print "cords (" + @direccion.get_x.to_s + "," + @direccion.get_y.to_s + ")\n"
  end #def

  #
  # Definir Parametros:
  # Configura todas las opciones del pez
  # int genero: Es el genero que tendra el pez (1 = hembra, 2 = macho)
  # int vida_tiempo: Es el número de segundos que vive
  #
  def definir_parametros(genero, vida_tiempo)
    @genero = genero
    @vida = vida_tiempo
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

    # El pez muere luego de que pasa el tiempo de vida + desviacion
    if (Time.now - @vida_inicio) > @vida + @vida_desviacion
      print "Muere el pez '#{@nombre}', vivió #{Time.now - @vida_inicio} segundos...\n"
      self.destroy
    end # if

  end #def

  #
  # Colision_Pez
  # Se llama cuando el pez se encuentra con otro pez
  # El pez sólo colisiona con un pez diferente cada vez
  #
  def colision_pez(pez)
    if @ultimo != pez.get_nombre
      @ultimo = pez.get_nombre
      @color = Color::BLUE
      print rand(10).to_s + " Colision..." + @nombre + "\n"

    end # if
  end #def


end #class
